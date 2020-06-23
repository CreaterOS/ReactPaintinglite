//
//  PaintingliteTableOptionsSelect.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/1.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteTableOptionsSelect.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteExec.h"
#import "PaintingliteTransaction.h"

@interface PaintingliteTableOptionsSelect()
@property (nonatomic,strong)PaintingliteSessionError *sessionError;
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@property (nonatomic,strong,readwrite,nonnull)NSString *prepareStatementSql;
@property (nonatomic,assign)NSUInteger paramterIndex; //下标
@end

@implementation PaintingliteTableOptionsSelect

#pragma mark - 懒加载
- (PaintingliteSessionError *)sessionError{
    if (!_sessionError) {
        _sessionError = [PaintingliteSessionError sharePaintingliteSessionError];
    }
    
    return _sessionError;
}

- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

#pragma mark - 单例模式
static PaintingliteTableOptionsSelect *_instance = nil;
+ (instancetype)sharePaintingliteTableSelectOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 利用SQL语句操作
#pragma mark - 基本查询
- (NSMutableArray *)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql{
    __block NSMutableArray *execQueryArray = [NSMutableArray array];
    [self execQuerySQL:ppDb sql:sql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        if (success) {
            execQueryArray = resArray;
        }
    }];
    
    return execQueryArray;
}

- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    
    NSMutableArray *array = [self.exec sqlite3ExecQuery:ppDb sql:sql];
    Boolean success = (array.count != -1);
    NSMutableArray *resArray = [NSMutableArray array];
    
    @autoreleasepool {
        if (success) {
            resArray = array;
        }
        
        if (completeHandler != nil) {
            completeHandler(self.sessionError,success,resArray);
        }
    }

    return success;
}

#pragma mark - 基本查询封装对象查询
- (id)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql obj:(id)obj{
    __block id paintingObj = NULL;
    [self execQuerySQL:ppDb sql:sql obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> *  _Nonnull resObjList) {
        paintingObj = resObjList;
    }];
    
    return paintingObj;
}

- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    
    //执行普通查询，然后进行封装
    __block NSMutableArray *execQueryArray = [NSMutableArray array];

    return [PaintingliteTransaction begainPaintingliteTransaction:ppDb exec:^Boolean{
        Boolean success = [self execQuerySQL:ppDb sql:sql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
            if (success) {
                execQueryArray = resArray;
            }
        }];
        
        NSMutableArray<id> *resObjList = [NSMutableArray array];
        
        @synchronized (self) {
            //开始封装
            for (NSUInteger i = 0; i < execQueryArray.count; i++) {
                id tempObj = nil;
                
                tempObj = [PaintingliteObjRuntimeProperty setObjPropertyValue:obj value: execQueryArray[i]];
                
                [resObjList addObject:tempObj];
            }
            
        }
        
        if (completeHandler != nil) {
            completeHandler(self.sessionError,success,execQueryArray,resObjList);
        }
        
        return success;
    }];
}

/**
 * sql查找 -- 添加条件
 * 例: select * from user where id = ? and name = ?
 * 分别设置 id 和 name的值
 * prepareStatement setStatement  ---> 从1开始计数
 * 保存prepareStatementSql语句
 * 通过另一个方法进行传入?对应的值，然后进行查询工作
 */
#pragma mark - 条件查询
- (void)execQuerySQLPrepareStatementSql:(NSString *)prepareStatementSql{
    NSAssert(prepareStatementSql != NULL, @"PrepareStatementSql Not Is Empty");
    
    self.prepareStatementSql = prepareStatementSql;
}

/**
 * 执行查询PrepareStatementSql -- 封装对象
 */
#pragma mark - 条件查询封装对象查询
- (id)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj{
    __block NSMutableArray *prepareStatementArray = [NSMutableArray array];
    [self execPrepareStatementSql:ppDb obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        prepareStatementArray = resObjList;
    }];
    
    return prepareStatementArray;
}

- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    
    return [PaintingliteTransaction begainPaintingliteTransaction:ppDb exec:^Boolean{
        return [self execQuerySQL:ppDb sql:self.prepareStatementSql obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
            if (success) {
                if (completeHandler != nil) {
                    completeHandler(error,success,resArray,resObjList);
                }
            }
        }];
    }];
}

/**
 * 调用这个方法进行对于问号进行处理
 * 传入参数两个
 * 1. 下标 index
 * 2. 参数值 paramter
 */
- (void)setPrepareStatementSqlParameter:(NSUInteger)index paramter:(NSString *)paramter{
    //获取prepareStatementSql
    NSString *tempPrepareStatementSql = [NSString string];
    
    if (self.prepareStatementSql.length != 0) {
        tempPrepareStatementSql = self.prepareStatementSql;
    }
    
    NSInteger count = 0;
    
    count = [self getParamterCount:tempPrepareStatementSql];
    
    //对比index传入的下标
    if ((index - self.paramterIndex) < count) {
        if (index == self.paramterIndex) {
            /**
             * 查看是否含有'?'
             */
            if ([tempPrepareStatementSql containsString:@"?"]) {
                NSRange range = [tempPrepareStatementSql rangeOfString:@"?"];
                tempPrepareStatementSql = [tempPrepareStatementSql stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"\'%@\'",paramter]];
                self.prepareStatementSql = tempPrepareStatementSql;
                NSLog(@"%@",tempPrepareStatementSql);
                //更新下标
                self.paramterIndex++;
            }
        }
    }else{
        self.paramterIndex = 0;
    }
}

/**
 * 递归式的传递参数
 * 传入参数形式使用数组来进行设置
 */
- (void)setPrepareStatementSqlParameter:(NSMutableArray *)paramter{
    NSString *tempPrepareStatementSql = [NSString string];
    if (self.prepareStatementSql.length != 0) {
        tempPrepareStatementSql = self.prepareStatementSql;
    }
    
    if ([tempPrepareStatementSql containsString:@"?"]) {
        NSRange range = [tempPrepareStatementSql rangeOfString:@"?"];
        tempPrepareStatementSql = [tempPrepareStatementSql stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"\'%@\'",[paramter firstObject]]];
        self.prepareStatementSql = tempPrepareStatementSql;
        //删除第一个下标
        [paramter removeObject:[paramter firstObject]];
        //递归调用
        [self setPrepareStatementSqlParameter:paramter];
        
        NSLog(@"%@",tempPrepareStatementSql);
        //更新下标
        self.paramterIndex++;
    }
}

/* 获得'?'的个数 */
- (NSInteger)getParamterCount:(NSString *__nonnull)tempPrepareStatementSql{
    NSInteger count = 0;
    const char *chars = [tempPrepareStatementSql UTF8String];
    
    for (int i = 0; i < tempPrepareStatementSql.length; i++) {
        char ch = chars[i];
        if (ch == '?') {
            count++;
        }
    }
    
    return count;
}

/**
 * 执行查询PrepareStatementSql
 */
- (NSMutableArray *)execPrepareStatementSql:(sqlite3 *)ppDb{
    __block NSMutableArray *prepareStatementResArray = [NSMutableArray array];
    
    [self execPrepareStatementSql:ppDb completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        prepareStatementResArray = resArray;
    }];
    
    return prepareStatementResArray;
}

- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    
    return [PaintingliteTransaction begainPaintingliteTransaction:ppDb exec:^Boolean{
        return [self execQuerySQL:ppDb sql:self.prepareStatementSql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
            if (success) {
                if (completeHandler != nil) {
                    completeHandler(error,success,resArray);
                }
            }
        }];
    }];
}

/**
 * sql查询 -- 模态查询
 */
#pragma mark - 模态查询
- (NSMutableArray *)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString * _Nonnull)tableName field:(NSString * _Nonnull)field like:(NSString * _Nonnull)like{
    __block NSMutableArray *likeQuerySqlArray = [NSMutableArray array];
    
    [self execLikeQuerySQL:ppDb tableName:tableName field:field like:like  completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        if (success) {
            likeQuerySqlArray = resArray;
        }
    }];
    
    return likeQuerySqlArray;
}

- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString * _Nonnull)tableName field:(NSString * _Nonnull)field like:(NSString * _Nonnull)like completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    
    NSString *likeSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ like '%@'",tableName,field,like];
    //执行模态查询
    return [self execQuerySQL:ppDb sql:likeSql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(error,success,resArray);
            }
        }
    }];
}

#pragma mark - 模态查询封装对象查询
- (id)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *)field like:(NSString *)like obj:(id)obj{
    __block NSMutableArray<id> *likeQuerySQLArray = [NSMutableArray array];
    
    [self execLikeQuerySQL:ppDb field:field like:like obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            likeQuerySQLArray = resObjList;
        }
    }];
    
    return likeQuerySQLArray;
}

- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *)field like:(NSString *)like obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    
    NSString *likeSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ like '%@'",[[PaintingliteObjRuntimeProperty getObjName:obj] lowercaseString],field,like];
    
    return [self execQuerySQL:ppDb sql:likeSql obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        completeHandler(error,success,resArray,resObjList);
    }];
}

/**
 * sql查询 -- 分页查询
 * 例: select * from user limit 0,2
 */
#pragma mark - 分页查询
- (NSMutableArray *)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end{
    __block NSMutableArray *limitQuerySQLArray = [NSMutableArray array];
    
    [self execLimitQuerySQL:ppDb tableName:tableName limitStart:start limitEnd:end completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        if (success) {
            limitQuerySQLArray = resArray;
        }
    }];
    
    return limitQuerySQLArray;
}

- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    start = (start > 0) ? start : 0;
    
    //判断传入的end的长度
    NSString *limitSql = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %zd,%zd",tableName,start,end];
//    NSLog(@"%@",limitSql);
    return [self execQuerySQL:ppDb sql:limitSql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(error,success,resArray);
            }
        }
    }];
}

#pragma mark - 分页查询封装对象查询
- (NSMutableArray *)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(nonnull id)obj{
    __block NSMutableArray<id> *limitQuerySQLArray = [NSMutableArray array];
    
    [self execLimitQuerySQL:ppDb limitStart:start limitEnd:end obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        limitQuerySQLArray = resObjList;
    }];
    
    return limitQuerySQLArray;
}

- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    //判断传入的end的长度
    start = (start > 0) ? start : 0;
    
    NSString *limitSql = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %zd,%zd",[[PaintingliteObjRuntimeProperty getObjName:obj] lowercaseString],start,end];
    
    return [self execQuerySQL:ppDb sql:limitSql obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        completeHandler(error,success,resArray,resObjList);
    }];
}

/**
 * sql查询 -- 排序
 * 例: select * from user order by name ASC
 */
#pragma mark - 排序查询
- (NSMutableArray *)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle{
    __block NSMutableArray *orderByQueryArray = [NSMutableArray array];
    
    [self execOrderByQuerySQL:ppDb tableName:tableName orderbyContext:orderbyContext orderStyle:orderStyle completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        if (success) {
            orderByQueryArray = resArray;
        }
    }];
    
    return orderByQueryArray;
}

- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    
    
    NSString *orderBySql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ %@",tableName,orderbyContext,(orderStyle == PaintingliteOrderByASC) ? @"ASC" : @"DESC"];
    NSLog(@"%@",orderBySql);
    return [self execQuerySQL:ppDb sql:orderBySql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(error,success,resArray);
            }
        }
    }];
    
}

#pragma mark - 排序查询封装对象查询
- (id)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj{
    __block NSMutableArray<id> *orderByQuerySQLArray = [NSMutableArray array];
    
    [self execOrderByQuerySQL:ppDb orderbyContext:orderbyContext orderStyle:orderStyle obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        orderByQuerySQLArray = resObjList;
    }];
    
    return orderByQuerySQLArray;
}

- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    
    NSString *orderBySql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ %@",[[PaintingliteObjRuntimeProperty getObjName:obj] lowercaseString],orderbyContext,(orderStyle == PaintingliteOrderByASC) ? @"ASC" : @"DESC"];
    NSLog(@"%@",orderBySql);
    
    return [self execQuerySQL:ppDb sql:orderBySql obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        completeHandler(error,success,resArray,resObjList);
    }];
}

@end
