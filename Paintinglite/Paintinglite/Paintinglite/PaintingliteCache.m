//
//  PaintingliteCache.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/11.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteCache.h"
#import "PaintingliteLog.h"
#import <os/lock.h>

#define WEAK_SELF __weak typeof(self) weakSelf = self;
#define STRONG_SELF __strong typeof(weakSelf) self = weakSelf;
 
@interface PaintingliteCache()<UIApplicationDelegate>

@end

@implementation PaintingliteCache
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCacheToLogFile) name:@"PaintingliteWriteTableLogNotification" object:self];
#if SD_UIKIT
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
#endif
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

#pragma mark - 缓存写入日志文件
- (void)pushCacheToLogFile{
       for (NSUInteger i = 1; i <= self.optCount; i++) {
            @autoreleasepool {
                /* 获得语句当前执行状态 */
                NSString *cacheKey = [NSString stringWithFormat:@"database_opt_%zd",i];
                NSString *optAndStatus = (NSString *)[self objectForKey:cacheKey];
                /* 分隔符 | */
                NSArray<NSString *> *strArray = [optAndStatus componentsSeparatedByString:@" | "];
                
                //写入文件
                [[PaintingliteLog sharePaintingliteLog] writeLogFileOptions:[strArray firstObject]  status:([[strArray lastObject] isEqualToString:@"success"]) ? PaintingliteLogSuccess : PaintingliteLogError completeHandler:nil];
                /* 清除缓存 */
                [self removeObjectForKey:cacheKey];
            }
        }
}

#pragma mark - 释放内存
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
