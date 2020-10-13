//
//  PaintingliteSessionManager.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteSessionManager
 * 创建一个Session管理者
 * 连接数据库
 */

#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import "PaintingliteDataBaseOptions.h"
#import "PaintingliteTableOptions.h"
#import "PaintingliteLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteSessionManager : NSObject
/* 判读是否打开数据库 */
@property (nonatomic)Boolean isOpen;
/* 数据库路径 */
@property (nonatomic,copy)NSString *databasePath;
/* 数据库大小 */
@property (nonatomic,assign)double totalSize;

/* 单例模式 */
+ (instancetype)sharePaintingliteSessionManager;


/// 打开数据库
/// @param fileName 数据库名称
- (Boolean)openSqlite:(NSString *)fileName;

/// 打开数据库
/// @param fileName 数据库名称
/// @param completeHandler 回调操作
- (Boolean)openSqlite:(NSString *)fileName completeHandler:(void(^ __nullable)(NSString *filePath,PaintingliteSessionError *error,Boolean success))completeHandler;


/// 打开数据库
/// @param fileName 数据库名称
/// @param completeHandler 回调操作
- (Boolean)openEncryptSqlite:(NSString *)fileName completeHandler:(void (^ __nullable)(NSString * _Nonnull, PaintingliteSessionError * _Nonnull, Boolean))completeHandler;

/// 打开数据库
/// @param filePath 数据库路径
- (Boolean)openSqliteWithFilePath:(NSString *)filePath;


/// 打开数据库
/// @param filePath 数据库路径
/// @param completeHandler 回调操作
- (Boolean)openSqliteFilePath:(NSString *)filePath completeHandler:(void (^__nullable)(NSString *filePath,PaintingliteSessionError *error,Boolean success))completeHandler;


/// 打开数据库 -- 加密
/// @param filePath 数据库路径
/// @param completeHandler 回调操作
- (Boolean)openEncryptSqliteFilePath:(NSString *)filePath completeHandler:(void (^ __nullable)(NSString * _Nonnull, PaintingliteSessionError * _Nonnull, Boolean))completeHandler;

/// 加密数据库
- (Boolean)resume;

/// 删除加密文件夹
- (Boolean)delEncryptDict;

/// 获得数据库
- (sqlite3 *)getSqlite3;

/// 获得数据库版本
- (NSString *)getSqlite3Version;

/// 数据库文件列表
/// @param fileDict 文件目录
- (NSArray<NSString *> *)dictExistsDatabaseList:(NSString *__nonnull)fileDict;

/// 数据库文件存在
/// @param filePath 文件路径
- (Boolean)isExistsDatabase:(NSString *__nonnull)filePath;


/// 数据库文件详细信息
/// @param filePath 文件路径
- (NSDictionary<NSFileAttributeKey,id> *)databaseInfoDict:(NSString *__nonnull)filePath;

/// 释放数据库
- (Boolean)releaseSqlite;


/// 释放数据库
/// @param completeHandler 回调操作
- (Boolean)releaseSqliteCompleteHandler:(void(^__nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 删除日志
/// @param fileName 文件名称
- (void)removeLogFileWithDatabaseName:(NSString *__nonnull)fileName;


/// 读取日志
/// @param fileName 文件名称
- (void)readLogFileWithDatabaseName:(NSString *__nonnull)fileName;


/// 读取日志
/// @param fileName 文件名称
/// @param dateTime 日期
- (void)readLogFileWithDatabaseName:(NSString *__nonnull)fileName dateTime:(NSDate *__nonnull)dateTime;


/// 读取日志
/// @param fileName 文件名称
/// @param logStatus 日志状态
- (void)readLogFileWithDatabaseName:(NSString *__nonnull)fileName logStatus:(PaintingliteLogStatus)logStatus;

#pragma mark - SQL语句执行

/// 系统操作
/// @param sql sql语句
- (Boolean)execTableOptForSQL:(NSString *)sql;

/// 系统查询
/// @param sql  sql语句
/// @param completeHandler 回调操作
- (Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/* =====================================数据库操作======================================== */

/// 创建表
/// @param tableName 表名
/// @param content 创建字段内容
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content;

/// 创建表
/// @param tableName 表名
/// @param content 创建字段内容
/// @param completeHandler 回调操作
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 创建表
/// @param obj 对象
/// @param primaryKeyStyle 主键类型
- (Boolean)createTableForObj:(id)obj primaryKeyStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)primaryKeyStyle;


/// 创建表
/// @param obj 对象
/// @param primaryKeyStyle 主键类型
/// @param completeHandler 回调操作
- (Boolean)createTableForObj:(id)obj primaryKeyStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)primaryKeyStyle completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;


/// 修改表
/// @param oldName 原表名称
/// @param newName 新表名称
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName;


/// 修改表
/// @param oldName 原表名称
/// @param newName 新表名称
/// @param completeHandler 回调操作
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;


/// 修改表
/// @param tableName 表名
/// @param columnName 列表名称
/// @param columnType 列表类型
- (BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType;


/// 修改表
/// @param tableName 表名
/// @param columnName 列表名称
/// @param columnType 列表类型
/// @param completeHandler 回调操作
- (BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 修改表
/// @param obj 对象
- (BOOL)alterTableForObj:(id)obj;


/// 修改表
/// @param obj 对象
/// @param completeHandler 回调操作
- (BOOL)alterTableForObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;


/// 删除表
/// @param tableName 表名
- (Boolean)dropTableForTableName:(NSString *)tableName;


/// 删除表
/// @param tableName 表名
/// @param completeHandler 回调操作
- (Boolean)dropTableForTableName:(NSString *)tableName completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;


/// 删除表
/// @param obj 对象
- (Boolean)dropTableForObj:(id)obj;

/// 删除表
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)dropTableForObj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/* =====================================表的操作SQL======================================== */


/// 系统查询方式
/// @param sql sql语句
- (NSMutableArray<NSMutableArray<NSString *> *> *)systemExec:(NSString *__nonnull)sql;


/// 查询SQL
/// @param sql sql语句
- (NSMutableArray<NSDictionary *> *)execQuerySQL:(NSString *__nonnull)sql;


/// 查询SQL
/// @param sql sql语句
/// @param completeHandler 回调操作
- (Boolean)execQuerySQL:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;


/// 查询SQL
/// @param sql sql语句
/// @param obj 对象
- (NSMutableArray<id> *)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj;


/// 查询SQL
/// @param sql sql语句
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray,NSMutableArray<id> *resObjList))completeHandler;


/// 条件查询SQL
/// @param prepareStatementSql 条件语句
/// 例:  SELECT * FROM user WHERE name = ? and age = ?
- (void)execQuerySQLPrepareStatementSql:(NSString *__nonnull)prepareStatementSql;


/// 设置条件查询参数
/// @param index 对应下标
/// @param paramter 对应下标参数
- (void)setPrepareStatementSqlParameter:(NSUInteger)index paramter:(NSString *__nonnull)paramter;


/// 设置条件查询参数
/// @param paramter 参数用数组形式传入
- (void)setPrepareStatementSqlParameter:(NSArray *__nonnull)paramter;


/// 执行条件查询SQL
- (NSMutableArray<NSDictionary *> *)execPrepareStatementSql;


/// 执行条件查询SQL
/// @param completeHandler 回调操作
- (Boolean)execPrepareStatementSqlCompleteHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;


/// 执行条件查询对象
/// @param obj 对象
- (id)execPrepareStatementSqlWithObj:(id)obj;


/// 执行条件查询对象
/// @param obj 对象
/// @param completeHandler 回调参数
- (Boolean)execPrepareStatementSqlWithObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray,NSMutableArray<id>* resObjList))completeHandler;


/// 模糊匹配
/// @param tableName 表名
/// @param field 字段
/// @param like 模糊匹配条件
- (NSMutableArray<NSDictionary *> *)execQueryLikeSQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like;


/// 模糊匹配
/// @param tableName 表名
/// @param field 字段
/// @param like 模糊匹配条件
/// @param completeHandler 回调操作
- (Boolean)execQueryLikeSQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;


/// 模糊匹配
/// @param field 字段
/// @param like 模糊匹配条件
/// @param obj 对象
- (NSMutableArray<id> *)execQueryLikeSQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj;


/// 模糊匹配
/// @param field 字段
/// @param like 模糊匹配条件
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)execQueryLikeSQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray,NSMutableArray<id>* resObjList))completeHandler;


/// 限制查询
/// @param tableName 表名
/// @param start 起始位置
/// @param end 结束位置
- (NSMutableArray<NSDictionary *> *)execQueryLimitSQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end;

/// 限制查询
/// @param tableName 表名
/// @param start 起始位置
/// @param end 结束位置
/// @param completeHandler 回调操作
- (Boolean)execQueryLimitSQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;


/// 限制查询
/// @param start 起始位置
/// @param end 结束位置
/// @param obj 对象
- (NSMutableArray<id> *)execQueryLimitSQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj;


/// 限制查询
/// @param start 起始位置
/// @param end 结束位置
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)execQueryLimitSQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray,NSMutableArray<id>* resObjList))completeHandler;


/// 排序查询
/// @param tableName 表名
/// @param orderbyContext 排序内容字段
/// @param orderStyle 排序方式
- (NSMutableArray<NSDictionary *> *)execQueryOrderBySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle;

/// 排序查询
/// @param tableName 表名
/// @param orderbyContext  排序内容字段
/// @param orderStyle 排序方式
/// @param completeHandler 回调操作
- (Boolean)execQueryOrderBySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;

/// 排序查询
/// @param orderbyContext 排序内容字段
/// @param orderStyle 排序方式
/// @param obj 对象
- (NSMutableArray<id> *)execQueryOrderBySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj;

/// 排序查询
/// @param orderbyContext 排序内容字段
/// @param orderStyle 排序方式
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)execQueryOrderBySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray,NSMutableArray<id>* resObjList))completeHandler;

/* =====================================表的操作PQL======================================== */

#pragma mark - PQL查询

/// 执行PQL条件查询
- (id)execPrepareStatementPQL;

/// 执行PQL条件查询
/// @param completeHandler 回调操作
- (Boolean)execPrepareStatementPQLWithCompleteHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;


/// 执行PQL条件查询
/// @param prepareStatementPQL PQL条件查询
- (void)execQueryPQLPrepareStatementPQL:(NSString *__nonnull)prepareStatementPQL;

/// 执行PQL条件查询
/// @param index 下标
/// @param paramter 下标对应参数
- (void)setPrepareStatementPQLParameter:(NSUInteger)index paramter:(NSString *__nonnull)paramter;


/// 执行PQL条件查询
/// @param paramter 参数数组
- (void)setPrepareStatementPQLParameter:(NSArray *__nonnull)paramter;

/// 执行PQL查询
/// @param pql PQL语法规则
/// FROM + 类名 + [条件]
- (NSMutableArray<id> *)execPQL:(NSString *__nonnull)pql;

/// 执行PQL查询
/// @param pql PQL语句
/// @param completeHandler 回调操作
- (Boolean)execPQL:(NSString *__nonnull)pql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/* =====================================表的操作CUD======================================== */

#pragma mark - CUD

/// 插入
/// @param sql 插入sql语句
- (Boolean)insert:(NSString *__nonnull)sql;

/// 插入
/// @param sql 插入sql语句
/// @param completeHandler 回调操作
- (Boolean)insert:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;


/// 插入
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)insertWithObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;


/// 更新
/// @param sql 更新sql语句
- (Boolean)update:(NSString *__nonnull)sql;

/// 更新
/// @param sql 更新sql语句
/// @param completeHandler 回调操作
- (Boolean)update:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 更新
/// @param obj 对象
/// @param condition 更新条件字段
/// @param completeHandler 回调操作
- (Boolean)updateWithObj:(id)obj condition:(NSString *__nonnull)condition completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 删除
/// @param sql 删除sql语句
- (Boolean)del:(NSString *__nonnull)sql;

/// 删除
/// @param sql 删除sql语句
/// @param completeHandler 回调操作
- (Boolean)del:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 表结构查询
/// @param tableName 表名称
- (NSMutableArray<NSDictionary *> *)tableInfoWithTableName:(NSString *__nonnull)tableName;

@end

NS_ASSUME_NONNULL_END
