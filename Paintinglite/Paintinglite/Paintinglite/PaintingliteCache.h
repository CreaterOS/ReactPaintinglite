//
//  PaintingliteCache.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/11.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteCache
 * 数据库快照一级缓存
 * 快照数据库表名
 * 快照数据库表的结构
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteCache : NSCache
@property (nonatomic,assign)NSUInteger tableCount; //表的个数

/* 单例模式 */
+ (instancetype)sharePaintingliteCache;

/* 添加表名称缓存 */
- (void)addSnapTableNameCache:(NSString *__nonnull)tableName;

/* 获得表名称缓存 */
- (NSString *)getSnapTableNameCache:(NSString *__nonnull)cacheKey;

@end

NS_ASSUME_NONNULL_END
