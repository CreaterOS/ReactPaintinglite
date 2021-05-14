//
//  PaintingliteTableOptions.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/29.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteTableOptions
 @abstract PaintingliteTableOptions 提供SDK框架中表操作
 @author CreaterOS
 @version 1.00 2020/5/29 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import <Sqlite3.h>

/*!
 @abstract PaintingliteOrderByStyle 排序类型
 @constant PaintingliteOrderByASC 升序
 @constant PaintingliteOrderByDESC 降序
 @discussion 排序类型
*/
typedef NS_ENUM(NSUInteger, PaintingliteOrderByStyle) {
    PaintingliteOrderByASC,
    PaintingliteOrderByDESC,
};

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteTableOptions
 @abstract PaintingliteTableOptions 提供SDK框架中表操作
 */
@interface PaintingliteTableOptions : NSObject

/*!
 @method sharePaintingliteTableOptions
 @abstract 单例模式生成PaintingliteTableOptions对象
 @discussion 生成PaintingliteTableOptions在项目工程全局中只生成一个实例对象
 @result PaintingliteTableOptions
 */
+ (instancetype)sharePaintingliteTableOptions;

#pragma mark - SQL查询
/*!
 @method execQuerySQL: sql:
 @abstract 查询SQL
 @discussion 查询SQL
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @result NSMutableArray<NSDictionary *>
 */
- (NSMutableArray *)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;

/*!
 @method execQuerySQL: sql: completeHandler:
 @abstract 查询SQL
 @discussion 查询SQL,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @param completeHandler 回调操作
 @result NSMutableArray<NSDictionary *>
 */
- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

/*!
 @method execQuerySQL: sql: obj:
 @abstract 查询SQL
 @discussion 查询SQL,返回值通过对象进行封装
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @param obj 对象
 @result NSMutableArray<id>
 */
- (id)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql obj:(id)obj;

/*!
 @method execQuerySQL: sql: obj: completeHandler:
 @abstract 查询SQL
 @discussion 查询SQL,返回值通过对象进行封装,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @param obj 对象
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

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
- (void)setPrepareStatementSqlParameter:(NSMutableArray *__nonnull)paramter;

/*!
 @method execPrepareStatementSql:
 @abstract 执行条件查询SQL
 @discussion 执行条件查询SQL
 @param ppDb Sqlite3 ppDb
 @result NSMutableArray<NSDictionary *>
 */
- (NSMutableArray *)execPrepareStatementSql:(sqlite3 *)ppDb;

/*!
 @method execPrepareStatementSql: completeHandler:
 @abstract 执行条件查询SQL
 @discussion 执行条件查询SQL,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

/*!
 @method execPrepareStatementSql: obj:
 @abstract 执行条件查询对象
 @discussion 执行条件查询对象,结果集封装成对象
 @param ppDb Sqlite3 ppDb
 @param obj 对象
 @result id
 */
- (id)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj;

/*!
 @method execPrepareStatementSql: obj: completeHandler:
 @abstract 执行条件查询对象
 @discussion 执行条件查询对象,结果集封装成对象,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param obj 对象
 @param completeHandler 回调参数
 @result Boolean
 */
- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/*!
 @method execLikeQuerySQL: tableName: field: like:
 @abstract 模糊匹配
 @discussion 模糊匹配
 @param ppDb Sqlite3 ppDb
 @param tableName 表名
 @param field 表字段
 @param like 模糊匹配条件
 @result NSMutableArray<NSDictionary *>
 */
- (NSMutableArray *)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like;

/*!
 @method execQueryLikeSQLWithTableName: field: like: completeHandler:
 @abstract 模糊匹配
 @discussion 模糊匹配
 @param ppDb Sqlite3 ppDb
 @param tableName 表名
 @param field 表字段
 @param like 模糊匹配条件
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

/*!
 @method execLikeQuerySQL: field: like: obj:
 @abstract 模糊匹配
 @discussion 模糊匹配,结果集封装成对象
 @param ppDb Sqlite3 ppDb
 @param field 表字段
 @param like 模糊匹配条件
 @param obj 对象
 @result id
 */
- (id)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj;

/*!
 @method execLikeQuerySQL: field: like: obj: completeHandler:
 @abstract 模糊匹配
 @discussion 模糊匹配,结果集封装成对象,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param field 表字段
 @param like 模糊匹配条件
 @param obj 对象
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/*!
 @method execLimitQuerySQL: tableName: limitStart: limitEnd:
 @abstract 限制匹配
 @discussion 限制匹配
 @param ppDb Sqlite3 ppDb
 @param tableName 表名
 @param start 起始位置
 @param end 结束位置
 @result NSMutableArray<NSDictionary *>
 */
- (NSMutableArray *)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end;

/*!
 @method execLimitQuerySQL: tableName: limitStart: limitEnd: completeHandler:
 @abstract 限制匹配
 @discussion 限制匹配,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param tableName 表名
 @param start 起始位置
 @param end 结束位置
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

/*!
 @method execLimitQuerySQL: limitStart: limitEnd: obj:
 @abstract 限制匹配
 @discussion 限制匹配,结果集封装成对象
 @param ppDb Sqlite3 ppDb
 @param start 起始位置
 @param end 结束位置
 @param obj 对象
 @result NSMutableArray<id>
 */
- (id)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj;

/*!
 @method execLimitQuerySQL: limitStart: limitEnd: obj: completeHandler:
 @abstract 限制匹配
 @discussion 限制匹配,结果集封装成对象
 @param ppDb Sqlite3 ppDb
 @param start 起始位置
 @param end 结束位置
 @param obj 对象
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/*!
 @method execOrderByQuerySQL: tableName: orderbyContext: orderStyle:
 @abstract 排序查询
 @discussion 排序查询
 @param ppDb Sqlite3 ppDb
 @param tableName 表名
 @param orderbyContext 排序内容表字段
 @param orderStyle 排序方式 [升序/降序]
 @result NSMutableArray<NSDictionary *>
 */
- (NSMutableArray *)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle;

/*!
 @method execOrderByQuerySQL: tableName: orderbyContext: orderStyle: completeHandler:
 @abstract 排序查询
 @discussion 排序查询,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param tableName 表名
 @param orderbyContext 排序内容表字段
 @param orderStyle 排序方式 [升序/降序]
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

/*!
 @method execOrderByQuerySQL: orderbyContext: orderStyle: obj:
 @abstract 排序查询
 @discussion 排序查询,结果集封装成对象
 @param ppDb Sqlite3 ppDb
 @param orderbyContext 排序内容表字段
 @param orderStyle 排序方式 [升序/降序]
 @param obj 对象
 @result NSMutableArray<id>
 */
- (id)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj;

/*!
 @method execOrderByQuerySQL: orderbyContext: orderStyle: obj: completeHandler:
 @abstract 排序查询
 @discussion 排序查询,结果集封装成对象,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param orderbyContext 排序内容表字段
 @param orderStyle 排序方式 [升序/降序]
 @param obj 对象
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;


#pragma mark - PQL查询

/*!
 @method execPQL: pql:
 @abstract PQL查询
 @discussion PQL查询 FROM + 类名 + [条件]
 @param ppDb Sqlite3 ppDb
 @param pql pql需要遵从PQL语法规则
 @result NSMutableArray<id>
 */
- (id)execQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql;

/*!
 @method execPQL: pql: completeHandler:
 @abstract PQL查询
 @discussion PQL查询 FROM + 类名 + [条件],支持回调操作
 @param ppDb Sqlite3 ppDb
 @param pql pql需要遵从PQL语法规则
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/*!
 @method execPrepareStatementPQL:
 @abstract PQL条件查询
 @discussion PQL条件查询
 @param ppDb Sqlite3 ppDb
 @result id
 */
- (id)execPrepareStatementPQL:(sqlite3 *)ppDb;

/*!
 @method execPrepareStatementPQL: completeHandler:
 @abstract PQL条件查询
 @discussion PQL条件查询,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execPrepareStatementPQL:(sqlite3 *)ppDb completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

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
- (void)setPrepareStatementPQLParameter:(NSMutableArray *__nonnull)paramter;

/*!
 @method execLikeQueryPQL: pql:
 @abstract PQL模糊查询
 @discussion PQL模糊查询
 @param ppDb Sqlite3 ppDb
 @param pql FROM + 类名 + [条件]
 @result id
 */
- (id)execLikeQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql;

/*!
 @method execLikeQueryPQL: pql: completeHandler:
 @abstract PQL模糊查询
 @discussion PQL模糊查询,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param pql FROM + 类名 + [条件]
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execLikeQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/*!
 @method execLimitQueryPQL: pql:
 @abstract PQL限定查询
 @discussion PQL限定查询
 @param ppDb Sqlite3 ppDb
 @param pql FROM + 类名 + [条件]
 @result id
 */
- (id)execLimitQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql;

/*!
 @method execLimitQueryPQL: pql: completeHandler:
 @abstract PQL限定查询
 @discussion PQL限定查询,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param pql FROM + 类名 + [条件]
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execLimitQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/*!
 @method execOrderQueryPQL: pql:
 @abstract PQL排序查询
 @discussion PQL排序查询
 @param ppDb Sqlite3 ppDb
 @param pql FROM + 类名 + [条件]
 @result id
 */
- (id)execOrderQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql;

/*!
 @method execOrderQueryPQL: pql: completeHandler:
 @abstract PQL排序查询
 @discussion PQL排序查询,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param pql FROM + 类名 + [条件]
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execOrderQueryPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/*!
 @method execPQL: pql:
 @abstract PQL万能查询
 @discussion PQL万能查询
 @param ppDb Sqlite3 ppDb
 @param pql FROM + 类名 + [条件]
 @result id
 */
- (id)execPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql;

/*!
 @method execPQL: pql: completeHandler:
 @abstract PQL万能查询
 @discussion PQL万能查询,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param pql FROM + 类名 + [条件]
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execPQL:(sqlite3 *)ppDb pql:(NSString *__nonnull)pql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

#pragma mark - CUD
/*!
 @method insert: sql:
 @abstract 插入操作
 @discussion 插入操作
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @result Boolean
 */
- (Boolean)insert:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;

/*!
 @method insert: sql: completeHandler:
 @abstract 插入操作
 @discussion 插入操作,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)insert:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method insert: obj: completeHandler:
 @abstract 插入操作
 @discussion 通过对象进行插入操作,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param obj 对象
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)insert:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method update: sql:
 @abstract 更新操作
 @discussion 更新操作
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @result Boolean
 */
- (Boolean)update:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;

/*!
 @method update: sql: completeHandler:
 @abstract 更新操作
 @discussion 更新操作,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)update:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method update: obj: condition: completeHandler:
 @abstract 更新操作
 @discussion 通过对象进行更新操作,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param obj 对象
 @param condition 更新条件字段
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)update:(sqlite3 *)ppDb obj:(id)obj condition:(NSString *__nonnull)condition completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method del: sql:
 @abstract 删除操作
 @discussion 删除操作
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @result Boolean
 */
- (Boolean)del:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;

/*!
 @method del: sql: completeHandler:
 @abstract 更新操作
 @discussion 更新操作,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)del:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

@end

NS_ASSUME_NONNULL_END
