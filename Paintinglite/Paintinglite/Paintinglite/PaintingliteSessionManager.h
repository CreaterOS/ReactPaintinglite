//
//  PaintingliteSessionManager.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteSessionManager
 @abstract PaintingliteSessionManager 提供SDK框架中所有的基本操作，开发这可以通过SessionManager获得数据库管理者，提供了大量的数据库操作方式
 @author CreaterOS
 @version 1.00 2020/5/26 Creation (此文档的版本信息)
 */

#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import "PaintingliteDataBaseOptions.h"
#import "PaintingliteTableOptions.h"
#import "PaintingliteLog.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 @class PaintingliteSessionManager
 @abstract PaintingliteSessionManager 提供SDK框架中所有的基本操作，开发这可以通过SessionManager获得数据库管理者，提供了大量的数据库操作方式
 */
@interface PaintingliteSessionManager : NSObject
/*!
 @property isOpen
 @abstract 判读是否打开Sqlite3数据库,YES/true表示打开数据库,NO/false表示未打开数据库
 */
@property (nonatomic)Boolean isOpen;
/*!
 @property databasePath
 @abstract 数据库路径
 */
@property (nonatomic,copy)NSString *databasePath;
/*!
 @property totalSize
 @abstract 记录Sqlite3数据库文件大小(MB)
 */
@property (nonatomic,assign)double totalSize;

/*!
 @method sharePaintingliteSessionManager
 @abstract 单例模式生成PaintingliteSessionManager对象
 @discussion 生成PaintingliteSessionManager在项目工程全局中只生成一个实例对象
 @result PaintingliteSessionManager
 */
+ (instancetype)sharePaintingliteSessionManager;

#pragma mark - 数据库打开/关闭
/*!
 @method openSqlite:
 @abstract 打开数据库
 @discussion 传入数据库的名称,例如"sqlite","db_Paintinglite"等名称
 @param fileName 数据库名称
 @result Boolean
 */
- (Boolean)openSqlite:(NSString *)fileName;

/*!
 @method openSqlite: completeHandler:
 @abstract 打开数据库,支持回调操作
 @discussion 传入数据库的名称,例如"sqlite","db_Paintinglite"等名称
 @param fileName 数据库名称
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)openSqlite:(NSString *)fileName completeHandler:(void(^ __nullable)(NSString *filePath,PaintingliteSessionError *error,Boolean success))completeHandler;


- (Boolean)openEncryptSqlite:(NSString *)fileName completeHandler:(void (^ __nullable)(NSString * _Nonnull, PaintingliteSessionError * _Nonnull, Boolean))completeHandler;

/*!
 @method openSqliteWithFilePath:
 @abstract 打开数据库
 @discussion 传入数据库的绝对路径
 @param filePath 数据库绝对路径
 @result Boolean
 */
- (Boolean)openSqliteWithFilePath:(NSString *)filePath;

/*!
 @method openSqliteFilePath: completeHandler:
 @abstract 打开数据库,支持回调操作
 @discussion 传入数据库的绝对路径
 @param filePath 数据库绝对路径
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)openSqliteFilePath:(NSString *)filePath completeHandler:(void (^__nullable)(NSString *filePath,Boolean success))completeHandler;


- (Boolean)openEncryptSqliteFilePath:(NSString *)filePath completeHandler:(void (^ __nullable)(NSString * _Nonnull, PaintingliteSessionError * _Nonnull, Boolean))completeHandler;

- (Boolean)resume;

- (Boolean)delEncryptDict;

/*!
 @method getCurrentSession
 @abstract Sqlite3数据库会语信息
 @discussion 获得当前Sqlite3数据库会语信息
 @result 当前Session信息
 */
- (NSString *)getCurrentSession;

/*!
 @method releaseSqlite
 @abstract 释放数据库
 @discussion 程序运行结束时,调用此方法释放Sqlite3数据库资源
 @result Boolean
 */
- (Boolean)releaseSqlite;

/*!
 @method releaseSqliteCompleteHandler:
 @abstract 释放数据库,支持回调操作
 @discussion 程序运行结束时,调用此方法释放Sqlite3数据库资源,并支持回调操作
 @result Boolean
 */
- (Boolean)releaseSqliteCompleteHandler:(void(^__nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;


#pragma mark - 数据库基本信息
/*!
 @method getSqlite3
 @abstract 当前连接Sqlite3数据库
 @discussion 获得当前连接Sqlite3数据库
 @result sqlite3
 */
- (sqlite3 *)getSqlite3;

/*!
 @method getSqlite3Version
 @abstract 当前连接Sqlite3数据库版本
 @discussion 获得当前连接Sqlite3数据库版本
 @result NSString
 */
- (NSString *)getSqlite3Version;

/*!
 @method dictExistsDatabaseList:
 @abstract 指定目录下Sqlite3数据库文件列表
 @discussion 列出当前文件列表下的所有Sqlite3数据库文件
 @param fileDict 文件目录绝对路径
 @result NSArray<NSString *>
 */
- (NSArray<NSString *> *)dictExistsDatabaseList:(NSString *__nonnull)fileDict;

/*!
 @method isExistsDatabase:
 @abstract 判定Sqlite3数据库是否存在
 @discussion 指定Sqlite3数据库绝对路径判断数据库文件是否存在
 @param filePath Sqlite3数据库绝对路径
 @result Boolean
 */
- (Boolean)isExistsDatabase:(NSString *__nonnull)filePath;

/*!
 @method databaseInfoDict:
 @abstract Sqlite3数据库文件夹详细信息
 @discussion 获得指定Sqlite3数据库文件夹详细信息
 @param filePath Sqlite3数据库绝对路径
 @result NSDictionary<NSFileAttributeKey,id>
 */
- (NSDictionary<NSFileAttributeKey,id> *)databaseInfoDict:(NSString *__nonnull)filePath;


#pragma mark - 数据库日志操作
/*!
 @method removeLogFileWithDatabaseName:
 @abstract 删除Sqlite3数据库操作日志
 @discussion 删除Sqlite3数据库操作日志
 @param fileName Sqlite3数据库名称
 */
- (void)removeLogFileWithDatabaseName:(NSString *__nonnull)fileName;

/*!
 @method readLogFileWithDatabaseName:
 @abstract 读取Sqlite3数据库操作日志
 @discussion 读取Sqlite3数据库操作日志
 @param fileName Sqlite3数据库名称
 */
- (void)readLogFileWithDatabaseName:(NSString *__nonnull)fileName;

/*!
 @method readLogFileWithDatabaseName: dateTime:
 @abstract 读取Sqlite3数据库操作日志
 @discussion 读取Sqlite3数据库操作日志,根据指定时间读取操作日志
 @param fileName Sqlite3数据库名称
 @param dateTime 日志指定时间
 */
- (void)readLogFileWithDatabaseName:(NSString *__nonnull)fileName dateTime:(NSDate *__nonnull)dateTime;

/*!
 @method readLogFileWithDatabaseName: logStatus:
 @abstract 读取Sqlite3数据库操作日志
 @discussion 读取Sqlite3数据库操作日志,根据操作日志状态读取操作日志
 @param fileName Sqlite3数据库名称
 @param logStatus 操作日志状态
 */
- (void)readLogFileWithDatabaseName:(NSString *__nonnull)fileName logStatus:(PaintingliteLogStatus)logStatus;

#pragma mark - SQL语句执行

/*!
 @method execTableOptForSQL:
 @abstract 调用sql语句
 @discussion 原生调用sql语句
 @param sql SQL语句
 @result Boolean
 */
- (Boolean)execTableOptForSQL:(NSString *)sql;

/*!
 @method execTableOptForSQL: completeHandler:
 @abstract 调用sql语句,支持回调操作
 @discussion 原生调用sql语句,支持回调操作
 @param sql SQL语句
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

#pragma mark - 数据库操作
/*!
 @method createTableForName: content:
 @abstract 创建表
 @discussion 通过表名称创建表
 @param tableName 表名
 @param content 创建字段内容
 @result Boolean
 */
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content;

/*!
 @method createTableForName: content: completeHandler:
 @abstract 创建表
 @discussion 通过表名称创建表,支持回调操作
 @param tableName 表名
 @param content 创建字段内容
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method createTableForObj: primaryKeyStyle:
 @abstract 创建表
 @discussion 通过对象创建表
 @param obj 对象
 @param primaryKeyStyle 主键类型
 @result Boolean
 */
- (Boolean)createTableForObj:(id)obj primaryKeyStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)primaryKeyStyle;

/*!
 @method createTableForObj: primaryKeyStyle: completeHandler:
 @abstract 创建表
 @discussion 通过对象创建表,支持回调操作
 @param obj 对象
 @param primaryKeyStyle 主键类型
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)createTableForObj:(id)obj primaryKeyStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)primaryKeyStyle completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method alterTableForName: newName:
 @abstract 修改表名称
 @discussion 修改表名称
 @param oldName 原表名称
 @param newName 新表名称
 @result BOOL
 */
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName;

/*!
 @method alterTableForName: newName: completeHandler:
 @abstract 修改表名称
 @discussion 修改表名称,支持回调操作
 @param oldName 原表名称
 @param newName 新表名称
 @param completeHandler 回调操作
 @result BOOL
 */
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method alterTableAddColumnWithTableName: columnName: columnType:
 @abstract 修改表结构
 @discussion 修改表结构,添加表列
 @param tableName 表名
 @param columnName 列表名称
 @param columnType 列表类型
 @result BOOL
 */
- (BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType;

/*!
 @method alterTableAddColumnWithTableName: columnName: columnType: completeHandler:
 @abstract 修改表结构
 @discussion 修改表结构,添加表列,支持回调操作
 @param tableName 表名
 @param columnName 列表名称
 @param columnType 列表类型
 @param completeHandler 回调操作
 @result BOOL
 */
- (BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method alterTableForObj:
 @abstract 修改表
 @discussion 修改表,依据对象成员变量修订表结构
 @param obj 对象
 @result BOOL
 */
- (BOOL)alterTableForObj:(id)obj;

/*!
 @method alterTableForObj: completeHandler:
 @abstract 修改表
 @discussion 修改表,依据对象成员变量修订表结构,支持回调操作
 @param obj 对象
 @param completeHandler 回调操作
 @result BOOL
 */
- (BOOL)alterTableForObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method dropTableForTableName:
 @abstract 删除表
 @discussion 通过表名称删除表
 @param tableName 表名
 @result BOOL
 */
- (Boolean)dropTableForTableName:(NSString *)tableName;

/*!
 @method dropTableForTableName: completeHandler:
 @abstract 删除表
 @discussion 通过表名称删除表
 @param tableName 表名
 @param completeHandler 回调操作
 @result BOOL
 */
- (Boolean)dropTableForTableName:(NSString *)tableName completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method dropTableForObj:
 @abstract 删除表
 @discussion 通过对象删除表
 @param obj 对象
 @result BOOL
 */
- (Boolean)dropTableForObj:(id)obj;

/*!
 @method dropTableForObj: completeHandler:
 @abstract 删除表
 @discussion 通过对象删除表,支持回调操作
 @param obj 对象
 @param completeHandler 回调操作
 @result BOOL
 */
- (Boolean)dropTableForObj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

#pragma mark - 表的操作SQL
/*!
 @method systemExec:
 @abstract 原生查询方式
 @discussion 原生查询方式
 @param sql sql语句
 @result NSMutableArray<NSMutableArray<NSString *> *>
 */
- (NSMutableArray<NSMutableArray<NSString *> *> *)systemExec:(NSString *__nonnull)sql;

/*!
 @method execQuerySQL:
 @abstract 查询SQL
 @discussion 查询SQL
 @param sql sql语句
 @result NSMutableArray<NSDictionary *>
 */
- (NSMutableArray<NSDictionary *> *)execQuerySQL:(NSString *__nonnull)sql;

/*!
 @method execQuerySQL: completeHandler:
 @abstract 查询SQL
 @discussion 查询SQL,支持回调操作
 @param sql sql语句
 @param completeHandler 回调操作
 @result NSMutableArray<NSDictionary *>
 */
- (Boolean)execQuerySQL:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;

/*!
 @method execQuerySQL: obj:
 @abstract 查询SQL
 @discussion 查询SQL,返回值通过对象进行封装
 @param sql sql语句
 @param obj 对象
 @result NSMutableArray<id>
 */
- (NSMutableArray<id> *)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj;

/*!
 @method execQuerySQL: obj: completeHandler:
 @abstract 查询SQL
 @discussion 查询SQL,返回值通过对象进行封装,支持回调操作
 @param sql sql语句
 @param obj 对象
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray,NSMutableArray<id> *resObjList))completeHandler;

/*!
 @method execQuerySQLPrepareStatementSql:
 @abstract 查询SQL
 @discussion 查询SQL,通过限定条件查询结果
 @param prepareStatementSql 条件语句 SELECT * FROM user WHERE name = ? and age = ?
 */
- (void)execQuerySQLPrepareStatementSql:(NSString *__nonnull)prepareStatementSql;

/*!
 @method setPrepareStatementSqlParameter: paramter:
 @abstract 查询SQL
 @discussion 查询SQL,配置限定条件查询结果
 @param index 对应下标
 @param paramter 对应下标参数[字符串]
 */
- (void)setPrepareStatementSqlParameter:(NSUInteger)index paramter:(NSString *__nonnull)paramter;

/*!
 @method setPrepareStatementSqlParameter:
 @abstract 查询SQL
 @discussion 查询SQL,配置限定条件查询结果
 @param paramter 对应下标参数[数组]
 */
- (void)setPrepareStatementSqlParameter:(NSArray *__nonnull)paramter;

/*!
 @method execPrepareStatementSql
 @abstract 执行条件查询SQL
 @discussion 执行条件查询SQL
 @result NSMutableArray<NSDictionary *>
 */
- (NSMutableArray<NSDictionary *> *)execPrepareStatementSql;

/*!
 @method execPrepareStatementSqlCompleteHandler:
 @abstract 执行条件查询SQL
 @discussion 执行条件查询SQL,支持回调操作
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execPrepareStatementSqlCompleteHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;

/*!
 @method execPrepareStatementSqlWithObj:
 @abstract 执行条件查询对象
 @discussion 执行条件查询对象,结果集封装成对象
 @param obj 对象
 @result id
 */
- (id)execPrepareStatementSqlWithObj:(id)obj;

/*!
 @method execPrepareStatementSqlWithObj: completeHandler:
 @abstract 执行条件查询对象
 @discussion 执行条件查询对象,结果集封装成对象,支持回调操作
 @param obj 对象
 @param completeHandler 回调参数
 @result Boolean
 */
- (Boolean)execPrepareStatementSqlWithObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray,NSMutableArray<id>* resObjList))completeHandler;

/*!
 @method execQueryLikeSQLWithTableName: field: like:
 @abstract 模糊匹配
 @discussion 模糊匹配
 @param tableName 表名
 @param field 表字段
 @param like 模糊匹配条件
 @result NSMutableArray<NSDictionary *>
 */
- (NSMutableArray<NSDictionary *> *)execQueryLikeSQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like;

/*!
 @method execQueryLikeSQLWithTableName: field: like: completeHandler:
 @abstract 模糊匹配
 @discussion 模糊匹配
 @param tableName 表名
 @param field 表字段
 @param like 模糊匹配条件
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execQueryLikeSQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;

/*!
 @method execQueryLikeSQLWithField: like: obj:
 @abstract 模糊匹配
 @discussion 模糊匹配,结果集封装成对象
 @param field 表字段
 @param like 模糊匹配条件
 @param obj 对象
 @result NSMutableArray<id>
 */
- (NSMutableArray<id> *)execQueryLikeSQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj;

/*!
 @method execQueryLikeSQLWithField: like: obj: completeHandler:
 @abstract 模糊匹配
 @discussion 模糊匹配,结果集封装成对象,支持回调操作
 @param field 表字段
 @param like 模糊匹配条件
 @param obj 对象
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execQueryLikeSQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray,NSMutableArray<id>* resObjList))completeHandler;

/*!
 @method execQueryLimitSQLWithTableName: limitStart: limitEnd:
 @abstract 限制匹配
 @discussion 限制匹配
 @param tableName 表名
 @param start 起始位置
 @param end 结束位置
 @result NSMutableArray<NSDictionary *>
 */
- (NSMutableArray<NSDictionary *> *)execQueryLimitSQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end;

/*!
 @method execQueryLimitSQLWithTableName: limitStart: limitEnd: completeHandler:
 @abstract 限制匹配
 @discussion 限制匹配,支持回调操作
 @param tableName 表名
 @param start 起始位置
 @param end 结束位置
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execQueryLimitSQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;

/*!
 @method execQueryLimitSQLWithLimitStart: limitEnd: obj:
 @abstract 限制匹配
 @discussion 限制匹配,结果集封装成对象
 @param start 起始位置
 @param end 结束位置
 @param obj 对象
 @result NSMutableArray<id>
 */
- (NSMutableArray<id> *)execQueryLimitSQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj;

/*!
 @method execQueryLimitSQLWithLimitStart: limitEnd: obj: completeHandler:
 @abstract 限制匹配
 @discussion 限制匹配,结果集封装成对象
 @param start 起始位置
 @param end 结束位置
 @param obj 对象
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execQueryLimitSQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray,NSMutableArray<id>* resObjList))completeHandler;

/*!
 @method execQueryOrderBySQLWithTableName: orderbyContext: orderStyle:
 @abstract 排序查询
 @discussion 排序查询
 @param tableName 表名
 @param orderbyContext 排序内容表字段
 @param orderStyle 排序方式 [升序/降序]
 @result NSMutableArray<NSDictionary *>
 */
- (NSMutableArray<NSDictionary *> *)execQueryOrderBySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle;

/*!
 @method execQueryOrderBySQLWithTableName: orderbyContext: orderStyle: completeHandler:
 @abstract 排序查询
 @discussion 排序查询,支持回调操作
 @param tableName 表名
 @param orderbyContext 排序内容表字段
 @param orderStyle 排序方式 [升序/降序]
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execQueryOrderBySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;

/*!
 @method execQueryOrderBySQLWithOrderbyContext: orderStyle: obj:
 @abstract 排序查询
 @discussion 排序查询,结果集封装成对象
 @param orderbyContext 排序内容表字段
 @param orderStyle 排序方式 [升序/降序]
 @param obj 对象
 @result NSMutableArray<id>
 */
- (NSMutableArray<id> *)execQueryOrderBySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj;

/*!
 @method execQueryOrderBySQLWithOrderbyContext: orderStyle: obj: completeHandler:
 @abstract 排序查询
 @discussion 排序查询,结果集封装成对象,支持回调操作
 @param orderbyContext 排序内容表字段
 @param orderStyle 排序方式 [升序/降序]
 @param obj 对象
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execQueryOrderBySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray,NSMutableArray<id>* resObjList))completeHandler;

#pragma mark - PQL查询
/*!
 @method execPrepareStatementPQL
 @abstract PQL条件查询
 @discussion PQL条件查询
 @result id
 */
- (id)execPrepareStatementPQL;

/*!
 @method execPrepareStatementPQLWithCompleteHandler:
 @abstract PQL条件查询
 @discussion PQL条件查询,支持回调操作
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execPrepareStatementPQLWithCompleteHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/*!
 @method execQueryPQLPrepareStatementPQL:
 @abstract PQL条件查询
 @discussion PQL条件查询
 @param prepareStatementPQL PQL条件语句
 */
- (void)execQueryPQLPrepareStatementPQL:(NSString *__nonnull)prepareStatementPQL;

/*!
 @method setPrepareStatementPQLParameter: paramter:
 @abstract PQL条件查询
 @discussion 配置PQL条件查询
 @param index 下标
 @param paramter 下标对应参数[字符串]
 */
- (void)setPrepareStatementPQLParameter:(NSUInteger)index paramter:(NSString *__nonnull)paramter;

/*!
 @method setPrepareStatementPQLParameter:
 @abstract PQL条件查询
 @discussion 配置PQL条件查询
 @param paramter 下标对应参数[数组]
 */
- (void)setPrepareStatementPQLParameter:(NSArray *__nonnull)paramter;

/*!
 @method execPQL:
 @abstract PQL查询
 @discussion PQL查询 FROM + 类名 + [条件]
 @param pql pql需要遵从PQL语法规则
 @result NSMutableArray<id>
 */
- (NSMutableArray<id> *)execPQL:(NSString *__nonnull)pql;

/*!
 @method execPQL: completeHandler:
 @abstract PQL查询
 @discussion PQL查询 FROM + 类名 + [条件],支持回调操作
 @param pql pql需要遵从PQL语法规则
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execPQL:(NSString *__nonnull)pql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

#pragma mark - CUD
/*!
 @method insert:
 @abstract 插入操作
 @discussion 插入操作
 @param sql sql语句
 @result Boolean
 */
- (Boolean)insert:(NSString *__nonnull)sql;

/*!
 @method insert: completeHandler:
 @abstract 插入操作
 @discussion 插入操作,支持回调操作
 @param sql sql语句
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)insert:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method insertWithObj: completeHandler:
 @abstract 插入操作
 @discussion 通过对象进行插入操作,支持回调操作
 @param obj 对象
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)insertWithObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method update:
 @abstract 更新操作
 @discussion 更新操作
 @param sql sql语句
 @result Boolean
 */
- (Boolean)update:(NSString *__nonnull)sql;

/*!
 @method update: completeHandler:
 @abstract 更新操作
 @discussion 更新操作,支持回调操作
 @param sql sql语句
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)update:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method updateWithObj: condition: completeHandler:
 @abstract 更新操作
 @discussion 通过对象进行更新操作,支持回调操作
 @param obj 对象
 @param condition 更新条件字段
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)updateWithObj:(id)obj condition:(NSString *__nonnull)condition completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method del:
 @abstract 删除操作
 @discussion 删除操作
 @param sql sql语句
 @result Boolean
 */
- (Boolean)del:(NSString *__nonnull)sql;

/*!
 @method del: completeHandler:
 @abstract 更新操作
 @discussion 更新操作,支持回调操作
 @param sql sql语句
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)del:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method tableInfoWithTableName:
 @abstract 表结构查询操作
 @discussion 表结构查询操作
 @param tableName 表名称
 @result NSMutableArray<NSDictionary *>
 */
- (NSMutableArray<NSDictionary *> *)tableInfoWithTableName:(NSString *__nonnull)tableName;

@end

NS_ASSUME_NONNULL_END
