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
@property (nonatomic,assign)NSTimeInterval lauchTime; /// 启动时间
@property (nonatomic,strong)CADisplayLink *displayLink;
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
//#if SD_UIKIT
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        /**
            v1.3.3 开启退出写入缓存
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
//#endif
    }
    return self;
}

#pragma mark - Life Cricle
- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    /// 记录登陆时间
    self.lauchTime = [[NSDate date] timeIntervalSince1970];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    /// 程序退出写入缓存
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakself pushCacheToLogFile];
    });
}

#pragma mark - 添加表名称缓存
- (void)addSnapTableNameCache:(NSString *__nonnull)tableName{
    
    if (tableName == NULL || tableName == (id)[NSNull null] || tableName.length == 0) {
        return ;
    }
    
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
    
    /**
        v1.3.3 添加程序运行超过10分钟写一次缓存
     */
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(sendTimeByPushCache)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink = displayLink;
    
    
    if(count >= self.baseReleaseLine){
        /* 发送通知,写入缓存文件 */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaintingliteWriteTableLogNotification" object:self];
        count = 0;
    }
}

- (void)sendTimeByPushCache {
     /// 获得当前时间
    long long int currentTime = (long long int)[[NSDate date] timeIntervalSince1970];
    
    /// 十分钟上传一次
    if (currentTime - (long long int)self.lauchTime >= 60 * 10) {
        /// 写入日志
        [self pushCacheToLogFile];
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
                @synchronized ([PaintingliteLog sharePaintingliteLog]) {
                    if ([strArray firstObject] == NULL) {
                        return ;
                    }
                    [[PaintingliteLog sharePaintingliteLog] writeLogFileOptions:[strArray firstObject] status:([[strArray lastObject] isEqualToString:@"success"]) ? PaintingliteLogSuccess : PaintingliteLogError completeHandler:nil];
                }
               
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
