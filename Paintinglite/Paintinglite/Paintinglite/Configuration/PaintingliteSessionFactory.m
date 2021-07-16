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
#import "PaintingliteWarningHelper.h"
#import "PaintingliteThreadManager.h"

@interface PaintingliteSessionFactory()
@property (nonatomic)sqlite3_stmt *stmt;
@end

@implementation PaintingliteSessionFactory
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
- (NSMutableArray *)execQuery:(sqlite3 *)ppDb tableName:(NSString * _Nonnull)tableName sql:(NSString * _Nonnull)sql status:(PaintingliteSessionFactoryStatus)status{
    __block NSMutableArray<NSString *> *tables = [NSMutableArray array];

    __block NSString *optAndStatusStr = [sql stringByAppendingString:@" | "];
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    runAsynchronouslyOnExecQueue(^{
        if (sqlite3_prepare_v2(ppDb, [sql UTF8String], -1, &(self->_stmt), nil) == SQLITE_OK){
            //查询成功
            while (sqlite3_step(self->_stmt) == SQLITE_ROW) {
                //获得数据库中含有的表名
                if (status == PaintingliteSessionFactoryTableCache) {
                    char *name = (char *)sqlite3_column_text(self->_stmt, 0);
                    [tables addObject:[NSString stringWithFormat:@"%s",name]];
                }else if (status == PaintingliteSessionFactoryTableINFOCache){
                    //保存数据库中的字段名
                    char *name = (char *)sqlite3_column_text(self->_stmt, 1);
                    [tables addObject:[NSString stringWithFormat:@"%s",name]];
                }
            }
            
            //写入日志缓存
            optAndStatusStr = [optAndStatusStr stringByAppendingString:@"success"];
        }else{
            //写入日志缓存
            optAndStatusStr = [optAndStatusStr stringByAppendingString:@"error"];
        }
        
        //添加缓存
        [[PaintingliteCache sharePaintingliteCache] addDatabaseOptionsCache:optAndStatusStr];
        
        if (tables.count != 0) {
            if (status == PaintingliteSessionFactoryTableCache) {
                //表名缓存
                NSUInteger count = 0;
                [PaintingliteCache sharePaintingliteCache].tableCount = 0;
                for (NSString *databaseName in tables) {
                    @autoreleasepool {
                        [[PaintingliteCache sharePaintingliteCache] removeObjectForKey:[NSString stringWithFormat:@"snap_tableName_%zd",count]];
                        [[PaintingliteCache sharePaintingliteCache] addSnapTableNameCache:databaseName];
                        count++;
                    }
                }
            }else{
                //表字段集合缓存
                [[PaintingliteCache sharePaintingliteCache] removeObjectForKey:[NSString stringWithFormat:@"snap_%@_info",tableName]];
                [[PaintingliteCache sharePaintingliteCache] addSnapTableInfoNameCache:tables tableName:tableName];
            }
        }
        
        dispatch_semaphore_signal(signal);
    });

    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    sqlite3_finalize(_stmt);
    
    return tables;
}

/* =====================================日志操作======================================== */
#pragma mark - 日志操作
#pragma mark - 删除日志文件
- (void)removeLogFile:(NSString *)fileName{
    if (fileName == NULL || fileName == (id)[NSNull null] || fileName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"FileName IS NULL OR FileName Len IS 0" time:[NSDate date] solve:@"Reset The FileName" args:nil];
        return ;
    }
    
    [[PaintingliteLog sharePaintingliteLog] removeLogFile:fileName];
}

#pragma mark - 读取日志文件
- (NSString *)readLogFile:(NSString *)fileName{
    if (fileName == NULL || fileName == (id)[NSNull null] || fileName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"FileName IS NULL OR FileName Len IS 0" time:[NSDate date] solve:@"Reset The FileName" args:nil];
        return [NSString string];
    }
    
    return [[PaintingliteLog sharePaintingliteLog] readLogFile:fileName];
}

- (NSString *)readLogFile:(NSString *)fileName dateTime:(NSDate *)dateTime{
    if (fileName == NULL || fileName == (id)[NSNull null] || fileName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"FileName IS NULL OR FileName Len IS 0" time:[NSDate date] solve:@"Reset The FileName" args:nil];
        return [NSString string];
    }
    
    return [[PaintingliteLog sharePaintingliteLog] readLogFile:fileName dateTime:dateTime];
}

- (NSString *)readLogFile:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus{
    if (fileName == NULL || fileName == (id)[NSNull null] || fileName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"FileName IS NULL OR FileName Len IS 0" time:[NSDate date] solve:@"Reset The FileName" args:nil];
        return [NSString string];
    }
    
    return [[PaintingliteLog sharePaintingliteLog] readLogFile:fileName logStatus:logStatus]; 
}

@end
