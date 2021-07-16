//
//  PaintingliteSplitTable.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/15.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSplitTable.h"
#import "PaintingliteAggregateFunc.h"
#import "PaintingliteTransaction.h"
#import "PaintingliteThreadManager.h"

/* 最小表记录 */
#define MINTABLECOUNT 100000

/* 写入文件根目录 */
#define ROOTPATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@interface PaintingliteSplitTable()
@property (nonatomic,strong)PaintingliteAggregateFunc *aggregateFunc; //聚合函数
@property (nonatomic,strong)NSFileManager *fileM; //文件管理者
@end

@implementation PaintingliteSplitTable

#pragma mark - 懒加载
- (PaintingliteAggregateFunc *)aggregateFunc{
    if (!_aggregateFunc) {
        _aggregateFunc = [PaintingliteAggregateFunc sharePaintingliteAggregateFunc];
    }
    
    return _aggregateFunc;
}

- (NSFileManager *)fileM{
    if (!_fileM) {
        _fileM = [NSFileManager defaultManager];
    }
    
    return _fileM;
}

#pragma mark - 单例模式
static PaintingliteSplitTable *_instance = nil;
+ (instancetype)sharePaintingliteSplitTable{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

/**
* 切分表
* tableName : 表名
* basePoint : 基点切分文件个数
*/
#pragma mark -- 切分表
- (Boolean)splitTable:(sqlite3 *)ppDb tabelName:(NSString *)tableName basePoint:(NSUInteger)basePoint{
    __block Boolean success = false;
    
    /* 每个文件的基本数据量 */
    NSUInteger baseCount = 0;
    NSUInteger baseCountMod = 0;
    
    /* 查询数据量 / basePoint */
    __block NSUInteger queryTotalCount = 0;
    [self.aggregateFunc count:ppDb tableName:[tableName lowercaseString] condatation:@"" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, NSUInteger count) {
        if (success) {
            queryTotalCount = count;
        }
    }];

    /* 总数超过了最低值 */
    if (queryTotalCount >= MINTABLECOUNT) {
        /* 可以拆分 */
        /* 一个基本数据项 */
        baseCount = queryTotalCount / basePoint;
        baseCountMod = queryTotalCount % basePoint;
    }
    
    __block NSMutableArray<NSMutableArray<NSMutableDictionary *> *> *totalArray = [NSMutableArray arrayWithCapacity:basePoint];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (NSUInteger i = 0,j = 1; i <= basePoint-1 && j <= basePoint; i++,j++) {
            @autoreleasepool {
                NSUInteger start = baseCount * i;
                NSUInteger end = baseCount * j;
                
                //获得取出的数据
                NSMutableArray *baseArray = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %zd,%zd",[tableName lowercaseString],start,end]];
                
                //添加到总的集合中
                [totalArray addObject:baseArray];
            }
            
        }
        
        //获得剩下的数据
        if (baseCountMod != 0) {
            //有剩余数据
            NSUInteger start = baseCount * basePoint;
            NSInteger end = queryTotalCount - (baseCount * basePoint);
            
            //剩余数据
            NSMutableArray *otherArray = [self execLimitQuerySQL:ppDb tableName:[tableName lowercaseString] limitStart:start limitEnd:end];
            
            //添加剩余数据
            [totalArray addObject:otherArray];
        }
    });

    //写入文件目录
    NSUInteger count = totalArray.count;
    
    //将查询的所有数据的数组利用多线程分别写入不同文件
    for (NSUInteger threads = 0; threads < count; threads++) {
        @autoreleasepool {
            runAsynchronouslyOnExecQueue(^{
                [NSThread sleepForTimeInterval:0.01];
                
                //写入文件
                NSString *filePath = [ROOTPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_Info_Splite_%zd.txt",[tableName uppercaseString],threads]];
                
                if ([self.fileM fileExistsAtPath:filePath]) {
                    NSError *error = nil;
                    [self.fileM removeItemAtPath:filePath error:&error];
                }
                
                success = [totalArray[threads] writeToFile:filePath atomically:YES];
            });
        }
    }

    return success;
}

#pragma mark - 查询操作
- (NSMutableArray *)selectWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint{
    if (basePoint <= 0) {
        return [NSMutableArray array];
    }
    
    NSMutableArray<NSDictionary *> *selectResArray = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < basePoint; i++) {
        NSString *filePath = [ROOTPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_Info_Splite_%zd.txt",[tableName uppercaseString],i]];
        if ([self.fileM fileExistsAtPath:filePath]) {
            /* 从文件中读取数据,并返回字典数组 */
            @autoreleasepool {
                selectResArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
            }
        }
    }
    
    return selectResArray;
}

#pragma mark - 插入操作
- (Boolean)insertWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint insertSQL:(NSString *)insertSQL{
    Boolean success = false;

    /* 更新数据库 */
    if ([self insert:ppDb sql:insertSQL]){
        //插入成功
        /* 写入文件 */
        [self splitTable:ppDb tabelName:tableName basePoint:basePoint];
    }
    
    return success;
}

#pragma mark - 更新操作
- (Boolean)updateWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint updateSQL:(NSString *)updateSQL{
    Boolean success = false;
    
    /* 更新数据库 */
    if ([self update:ppDb sql:updateSQL]){
        //插入成功
        /* 写入文件 */
        [self splitTable:ppDb tabelName:tableName basePoint:basePoint];
    }
    
    return success;
}

#pragma mark - 删除操作
- (Boolean)deleteWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint deleteSQL:(NSString *)deleteSQL{
    Boolean success = false;
    
    /* 更新数据库 */
    if ([self del:ppDb sql:deleteSQL]){
  
        //插入成功
        /* 写入文件 */
        [self splitTable:ppDb tabelName:tableName basePoint:basePoint];
    }
    
    return success;
}

@end
