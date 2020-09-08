//
//  PaintingliteTableOptions.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/29.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteTableOptions
 * 对表操作的封装
 * 增加数据
 * 更新数据
 * 删除数据
 * 查看数据
 */

#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import <Sqlite3.h>

typedef NS_ENUM(NSUInteger, PaintingliteOrderByStyle) {
    PaintingliteOrderByASC,
    PaintingliteOrderByDESC,
};

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteTableOptions : NSObject

/// 单例模式
+ (instancetype)sharePaintingliteTableOptions;

#pragma mark - SQL查询

/// 查询SQL
/// @param sql sql语句
- (NSMutableArray *)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;

/// 查询SQL
/// @param sql sql语句
/// @param completeHandler 回调操作
- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

/// 查询SQL
/// @param sql sql语句
/// @param obj 对象
- (id)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql obj:(id)obj;

/// 查询SQL
/// @param sql sql语句
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

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
- (void)setPrepareStatementSqlParameter:(NSMutableArray *__nonnull)paramter;

/// 执行条件查询SQL
- (NSMutableArray *)execPrepareStatementSql:(sqlite3 *)ppDb;

/// 执行条件查询SQL
/// @param completeHandler 回调操作
- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

/// 执行条件查询对象
/// @param obj 对象
- (id)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj;

/// 执行条件查询对象
/// @param obj 对象
/// @param completeHandler 回调参数
- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/// 模糊匹配
/// @param tableName 表名
/// @param field 字段
/// @param like 模糊匹配条件
- (NSMutableArray *)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like;

/// 模糊匹配
/// @param tableName 表名
/// @param field 字段
/// @param like 模糊匹配条件
/// @param completeHandler 回调操作
- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

/// 模糊匹配
/// @param field 字段
/// @param like 模糊匹配条件
/// @param obj 对象
- (id)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj;

/// 模糊匹配
/// @param field 字段
/// @param like 模糊匹配条件
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/// 限制查询
/// @param tableName 表名
/// @param start 起始位置
/// @param end 结束位置
- (NSMutableArray *)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end;

/// 限制查询
/// @param tableName 表名
/// @param start 起始位置
/// @param end 结束位置
/// @param completeHandler 回调操作
- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

/// 限制查询
/// @param start 起始位置
/// @param end 结束位置
/// @param obj 对象
- (id)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj;

/// 限制查询
/// @param start 起始位置
/// @param end 结束位置
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/// 排序查询
/// @param tableName 表名
/// @param orderbyContext 排序内容字段
/// @param orderStyle 排序方式
- (NSMutableArray *)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle;

/// 排序查询
/// @param tableName 表名
/// @param orderbyContext  排序内容字段
/// @param orderStyle 排序方式
/// @param completeHandler 回调操作
- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

/// 排序查询
/// @param orderbyContext 排序内容字段
/// @param orderStyle 排序方式
/// @param obj 对象
- (id)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj;

/// 排序查询
/// @param orderbyContext 排序内容字段
/// @param orderStyle 排序方式
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;


#pragma mark - PQL查询

/// 执行PQL条件查询
- (id)execQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql;

/// 执行PQL条件查询
/// @param completeHandler 回调操作
- (Boolean)execQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/// 执行PQL条件查询
- (id)execPrepareStatementPQL:(sqlite3 *)ppDb;

/// 执行PQL条件查询
/// @param ppDb ppDb
/// @param completeHandler 回调操作
- (Boolean)execPrepareStatementPQL:(sqlite3 *)ppDb completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/// 执行PQL条件查询
/// @param prepareStatementPQL PQL条件查询
- (void)execQueryPQLPrepareStatementPQL:(NSString *__nonnull)prepareStatementPQL;

/// 执行PQL条件查询
/// @param index 下标
/// @param paramter 下标对应参数
- (void)setPrepareStatementPQLParameter:(NSUInteger)index paramter:(NSString *__nonnull)paramter;

/// 执行PQL条件查询
/// @param paramter 参数数组
- (void)setPrepareStatementPQLParameter:(NSMutableArray *__nonnull)paramter;

- (id)execLikeQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql;
- (Boolean)execLikeQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

- (id)execLimitQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql;
- (Boolean)execLimitQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

- (id)execOrderQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql;
- (Boolean)execOrderQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/* 万能PQL查询 */
- (id)execPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql;
- (Boolean)execPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

#pragma mark - CUD
/// 插入
/// @param sql 插入sql语句
- (Boolean)insert:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;

/// 插入
/// @param sql 插入sql语句
/// @param completeHandler 回调操作
- (Boolean)insert:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 插入
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)insert:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 更新
/// @param sql 更新sql语句
- (Boolean)update:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;

/// 更新
/// @param sql 更新sql语句
/// @param completeHandler 回调操作
- (Boolean)update:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 更新
/// @param obj 对象
/// @param condition 更新条件字段
/// @param completeHandler 回调操作
- (Boolean)update:(sqlite3 *)ppDb obj:(id)obj condition:(NSString *__nonnull)condition completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 删除
/// @param sql 删除sql语句
- (Boolean)del:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;

/// 删除
/// @param sql 删除sql语句
/// @param completeHandler 回调操作
- (Boolean)del:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

@end

NS_ASSUME_NONNULL_END
