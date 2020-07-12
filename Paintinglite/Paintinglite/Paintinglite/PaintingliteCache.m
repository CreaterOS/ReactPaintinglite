//
//  PaintingliteCache.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/11.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteCache.h"

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

#pragma mark - 添加表名称缓存
static int tableCount = 0;
- (void)addSnapTableNameCache:(NSString *__nonnull)tableName{
    [self setObject:tableName forKey:[NSString stringWithFormat:@"snap_tableName_%d",tableCount]];
    tableCount++;
    self.tableCount = tableCount;
}

#pragma mark - 获得表名称缓存
- (NSString *)getSnapTableNameCache:(NSString *__nonnull)cacheKey{
    return [self objectForKey:cacheKey];
}

@end
