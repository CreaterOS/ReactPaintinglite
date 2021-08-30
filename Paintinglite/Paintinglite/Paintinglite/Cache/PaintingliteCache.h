//
//  PaintingliteCache.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/11.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteCache
 @abstract PaintingliteCache 提供SDK框架中Sqlite3数据库快照缓存,缓存数据库表名称和数据库表结构
 @author CreaterOS
 @version 1.00 2020/7/11 Creation (此文档的版本信息)
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class PaintingliteCache
 @abstract PaintingliteCache 提供SDK框架中Sqlite3数据库快照缓存,缓存数据库表名称和数据库表结构
 */
@interface PaintingliteCache : NSCache
/*!
 @property tableCount
 @abstract 当前数据库中存在表个数
 */
@property (nonatomic,assign)NSUInteger tableCount;
/*!
 @property optCount
 @abstract 当前数据库中进行操作的次数
 */
@property (nonatomic,assign)NSUInteger optCount;
/*!
 @property limitedCacheCount
 @abstract 支持缓存操作的最大条数
 */
@property (nonatomic,assign)NSUInteger limitedCacheCount;
/*!
 @property baseReleaseLine
 @abstract 支持缓存操作释放基准线
 */
@property (nonatomic,assign)NSUInteger baseReleaseLine;

/*!
 @method sharePaintingliteCache
 @abstract 单例模式生成sharePaintingliteCache对象
 @discussion 生成sharePaintingliteCache在项目工程全局中只生成一个实例对象
 @result PaintingliteCache
 */
+ (instancetype)sharePaintingliteCache;

/*!
 @method addSnapTableNameCache:
 @abstract 表名称缓存
 @discussion 表名称缓存
 @param tableName 表名称
 */
- (void)addSnapTableNameCache:(NSString *__nonnull)tableName;

/*!
 @method addSnapTableNameCache: tableName:
 @abstract 表结构缓存
 @discussion 表结构缓存
 @param infoArray 信息数组
 @param tableName 表名称
 */
- (void)addSnapTableInfoNameCache:(NSArray *__nonnull)infoArray tableName:(NSString *__nonnull)tableName;

/*!
 @method addDatabaseOptionsCache:
 @abstract 操作缓存
 @discussion 操作缓存
 @param optStr 操作字符串
 */
- (void)addDatabaseOptionsCache:(NSString *__nonnull)optStr;

/*!
 @method pushCacheToLogFile
 @abstract 写入缓存文件
 @discussion 写入缓存文件
 */
- (void)pushCacheToLogFile;

@end

NS_ASSUME_NONNULL_END
