//
//  PaintingliteSessionFactory.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSessionFactory.h"
#import "PaintingliteCache.h"
#import "PaintingliteSecurity.h"
#import "PaintingliteLog.h"

@interface PaintingliteSessionFactory()
@property (nonatomic)sqlite3_stmt *stmt;
@property (nonatomic,strong)PaintingliteLog *log; //日志
@property (nonatomic,strong)PaintingliteCache *cache; //快照缓存
@end

@implementation PaintingliteSessionFactory

#pragma mark - 懒加载
- (PaintingliteLog *)log{
    if (!_log) {
        _log = [PaintingliteLog sharePaintingliteLog];
    }
    
    return _log;
}

- (PaintingliteCache *)cache{
    if (!_cache) {
        _cache = [PaintingliteCache sharePaintingliteCache];
    }
    
    return _cache;
}

#pragma mark - 单例模式
static PaintingliteSessionFactory *_instance = nil;
+ (instancetype)sharePaintingliteSessionFactory{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 执行查询
- (NSMutableArray *)execQuery:(sqlite3 *)ppDb sql:(NSString *)sql status:(PaintingliteSessionFactoryStatus)status{
    NSMutableArray<NSString *> *tables = [NSMutableArray array];

    @synchronized (self) {
        if (sqlite3_prepare_v2(ppDb, [sql UTF8String], -1, &_stmt, nil) == SQLITE_OK){
            //查询成功
            while (sqlite3_step(_stmt) == SQLITE_ROW) {
                //获得数据库中含有的表名
                if (status == PaintingliteSessionFactoryTableJSON) {
                    char *name = (char *)sqlite3_column_text(_stmt, 0);
                    [tables addObject:[NSString stringWithFormat:@"%s",name]];
                }else if (status == PaintingliteSessionFactoryTableINFOJSON){
                    //保存数据库中的字段名
                    char *name = (char *)sqlite3_column_text(_stmt, 1);
                    [tables addObject:[NSString stringWithFormat:@"%s",name]];
                }
            }
        }else{
            //写入日志文件
            [self.log writeLogFileOptions:sql status:PaintingliteLogError completeHandler:^(NSString * _Nonnull logFilePath) {
                ;
            }];
        }
        
        sqlite3_finalize(_stmt);
    }
    
    if (tables.count != 0) {
        //写入缓存
        if (status == PaintingliteSessionFactoryTableJSON) {
            /* 添加之前先清除之前缓存 */
            for (NSString *databaseName in tables) {
                [self.cache addSnapTableNameCache:databaseName];
            }
        }else{
            [self writeTablesSnapJSON:tables status:PaintingliteSessionFactoryTableINFOJSON];
        }
    }
    
    return tables;
}

#pragma mark - 写入JSON快照
- (void)writeTablesSnapJSON:(NSMutableArray *)tables status:(PaintingliteSessionFactoryStatus)status{
    NSDictionary *tablesSnapDict = @{((status == PaintingliteSessionFactoryTableJSON) ? @"TablesSnap" : @"TablesInfoSnap"):tables};
    
    //写入JSON文件
    @synchronized (self) {
        if ([NSJSONSerialization isValidJSONObject:tablesSnapDict]) {
            NSError *error = nil;
           
            NSData *data =  [PaintingliteSecurity SecurityBase64:[NSJSONSerialization dataWithJSONObject:tablesSnapDict options:NSJSONWritingPrettyPrinted error:&error]];
      
            NSString *TablesSnapJsonPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:(status == PaintingliteSessionFactoryTableJSON ? @"Tables_Snap.json" : @"TablesInfo_Snap.json")];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if ([fileManager fileExistsAtPath:TablesSnapJsonPath]) {
                [fileManager removeItemAtPath:TablesSnapJsonPath error:&error];
            }
            
            //判断是否存则这个文件
            [data writeToFile:TablesSnapJsonPath atomically:YES];
            
            data = nil;
        }
        
        tablesSnapDict = nil;
    }
}

#pragma mark - 删除日志文件
- (void)removeLogFile:(NSString *)fileName{
    [self.log removeLogFile:fileName];
}

#pragma mark - 读取日志文件
- (NSString *)readLogFile:(NSString *)fileName{
    return [self.log readLogFile:fileName];
}

- (NSString *)readLogFile:(NSString *)fileName dateTime:(NSDate *)dateTime{
    return [self.log readLogFile:fileName dateTime:dateTime];
}

- (NSString *)readLogFile:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus{
    return [self.log readLogFile:fileName logStatus:logStatus]; 
}

@end
