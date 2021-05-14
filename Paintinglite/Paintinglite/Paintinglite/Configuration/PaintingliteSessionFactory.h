//
//  PaintingliteSessionFactory.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteSessionFactory
 @abstract PaintingliteSessionFactory 提供SDK框架中生成Session工厂类
 @author CreaterOS
 @version 1.00 2020/5/26 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import "PaintingliteLog.h"
#import <Sqlite3.h>

#define PaintingliteSessionFactoryLite sqlite3
#define PaintingliteSessionFactory_Sqlite_Queque dispatch_queue_create("PaintingliteSessionFactory_Sqlite_Queque", NULL)

/*!
 @abstract PaintingliteSessionFactoryStatus 工厂类型缓存状态
 @constant PaintingliteSessionFactoryTableCache 表缓存
 @constant PaintingliteSessionFactoryTableINFOCache 表信息缓存
 @discussion 标识缓存状态
*/
typedef NS_ENUM(NSUInteger, PaintingliteSessionFactoryStatus) {
    PaintingliteSessionFactoryTableCache,
    PaintingliteSessionFactoryTableINFOCache
};

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteSessionFactory
 @abstract PaintingliteSessionFactory 提供SDK框架中生成Session工厂类
 */
@interface PaintingliteSessionFactory : NSObject

/*!
 @method sharePaintingliteSessionFactory
 @abstract 单例模式生成PaintingliteSessionFactory对象
 @discussion 生成PaintingliteSessionFactory在项目工程全局中只生成一个实例对象
 @result PaintingliteSessionFactory
 */
+ (instancetype)sharePaintingliteSessionFactory;

/*!
 @method execQuery: tableName: sql: status:
 @abstract 执行查询
 @discussion 执行查询
 @param ppDb ppDb
 @param tableName 表名称
 @param sql sql语句
 @param status 工厂缓存状态
 @result NSMutableArray
 */
- (NSMutableArray *)execQuery:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName sql:(NSString *__nonnull)sql status:(PaintingliteSessionFactoryStatus)status;

/*!
 @method removeLogFileWithDatabaseName:
 @abstract 删除Sqlite3数据库操作日志
 @discussion 删除Sqlite3数据库操作日志
 @param fileName Sqlite3数据库名称
 */
- (void)removeLogFile:(NSString *)fileName;

/*!
 @method readLogFileWithDatabaseName:
 @abstract 读取Sqlite3数据库操作日志
 @discussion 读取Sqlite3数据库操作日志
 @param fileName Sqlite3数据库名称
 */
- (NSString *)readLogFile:(NSString *__nonnull)fileName;

/*!
 @method readLogFileWithDatabaseName: dateTime:
 @abstract 读取Sqlite3数据库操作日志
 @discussion 读取Sqlite3数据库操作日志,根据指定时间读取操作日志
 @param fileName Sqlite3数据库名称
 @param dateTime 日志指定时间
 */
- (NSString *)readLogFile:(NSString *)fileName dateTime:(NSDate *__nonnull)dateTime;

/*!
 @method readLogFileWithDatabaseName: logStatus:
 @abstract 读取Sqlite3数据库操作日志
 @discussion 读取Sqlite3数据库操作日志,根据操作日志状态读取操作日志
 @param fileName Sqlite3数据库名称
 @param logStatus 操作日志状态
 */
- (NSString *)readLogFile:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus;

@end

NS_ASSUME_NONNULL_END
