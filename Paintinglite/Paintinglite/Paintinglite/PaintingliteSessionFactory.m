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
- (NSMutableArray *)execQuery:(sqlite3 *)ppDb tableName:(NSString * _Nonnull)tableName sql:(NSString * _Nonnull)sql status:(PaintingliteSessionFactoryStatus)status{
    __block NSMutableArray<NSString *> *tables = [NSMutableArray array];

    __block NSString *optAndStatusStr = [sql stringByAppendingString:@" | "];
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
        [self.cache addDatabaseOptionsCache:optAndStatusStr];
        
        if (tables.count != 0) {
            if (status == PaintingliteSessionFactoryTableCache) {
                //表名缓存
                NSUInteger count = 0;
                self.cache.tableCount = 0;
                for (NSString *databaseName in tables) {
                    [self.cache removeObjectForKey:[NSString stringWithFormat:@"snap_tableName_%zd",count]];
                    [self.cache addSnapTableNameCache:databaseName];
                    count++;
                }
            }else{
                //表字段集合缓存
                [self.cache removeObjectForKey:[NSString stringWithFormat:@"snap_%@_info",tableName]];
                [self.cache addSnapTableInfoNameCache:tables tableName:tableName];
            }
        }
        
        dispatch_semaphore_signal(signal);
    });

    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    sqlite3_finalize(_stmt);
    
    return tables;
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
