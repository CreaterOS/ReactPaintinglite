//
//  PaintingliteCache.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/11.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteCache.h"
#import "PaintingliteLog.h"

@interface PaintingliteCache()
@property (nonatomic,strong)PaintingliteLog *log; //日志
@end

@implementation PaintingliteCache

#pragma mark - 懒加载
- (PaintingliteLog *)log{
    if (!_log) {
        _log = [PaintingliteLog sharePaintingliteLog];
    }
    
    return _log;
}

#pragma mark - 单例模式
static PaintingliteCache *_instance = nil;
+ (instancetype)sharePaintingliteCache{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册通知写日志
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(writeLogFile) name:@"PaintingliteWriteTableLogNotification" object:self];
    }
    return self;
}

#pragma mark - 添加表名称缓存
- (void)addSnapTableNameCache:(NSString *__nonnull)tableName{
    NSUInteger tableCount = self.tableCount;
    
    [self setObject:tableName forKey:[NSString stringWithFormat:@"snap_tableName_%zd",tableCount]];
    
    tableCount++;
    self.tableCount = tableCount;
}

#pragma mark - 添加表结构缓存
- (void)addSnapTableInfoNameCache:(NSArray *)infoArray tableName:(NSString *)tableName{
    [self setObject:infoArray forKey:[NSString stringWithFormat:@"snap_%@_info",tableName]];
}

#pragma mark - 添加数据库操作缓存
static int count = 0;
- (void)addDatabaseOptionsCache:(NSString *)optStr{
    /* count > 缓存基准线 */
    count++;
    self.optCount = count;
    
    /* 缓存池上限 */
    (self.limitedCacheCount < 30) ? self.limitedCacheCount = 30 : self.limitedCacheCount;
    (self.baseReleaseLine <= 0 || self.baseReleaseLine >= self.limitedCacheCount) ? self.baseReleaseLine = 10 : self.baseReleaseLine;

    [self setObject:optStr forKey:[NSString stringWithFormat:@"database_opt_%d",count]];
    
    if(count >= self.baseReleaseLine){
        /* 发送通知,写入缓存文件 */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaintingliteWriteTableLogNotification" object:self];
        count = 0;
    }
}
#pragma mark - 写入日志
- (void)writeLogFile{
    /* 写入文件 */
    @synchronized (self) {
        for (NSUInteger i = 1; i <= self.optCount; i++) {
            @autoreleasepool {
                /* 获得语句当前执行状态 */
                NSString *cacheKey = [NSString stringWithFormat:@"database_opt_%zd",i];
                NSString *optAndStatus = (NSString *)[self objectForKey:cacheKey];
                /* 分隔符 | */
                NSArray<NSString *> *strArray = [optAndStatus componentsSeparatedByString:@" | "];
                [self writeLogFileOptions:[strArray firstObject] status:([[strArray lastObject] isEqualToString:@"success"]) ? PaintingliteLogSuccess : PaintingliteLogError];
                /* 清除缓存 */
                [self removeObjectForKey:cacheKey];
            }
        }
    }
}

#pragma mark - 缓存写入日志文件
- (void)pushCacheToLogFile{
    [self writeLogFile];
}

#pragma mark - 写日志
- (void)writeLogFileOptions:(NSString *__nonnull)sql status:(PaintingliteLogStatus)status{
    [self.log writeLogFileOptions:sql status:status completeHandler:nil];
    self.log = nil;
}

@end
