//
//  PaintingliteAggregateFunc.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/8.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteAggregateFunc
 @abstract PaintingliteAggregateFunc 提供SDK框架中聚合函数操作[COUNT MAX MIN SUM AVG]
 @author CreaterOS
 @version 1.00 2020/6/8 Creation (此文档的版本信息)
 */

#import "PaintingliteTableOptions.h"
#import "PaintingliteSessionError.h"

typedef NS_ENUM(NSUInteger, PaintingliteAggregateType) {
    PaintingliteAggregateMax,
    PaintingliteAggregateMIN,
    PaintingliteAggregateSUM,
    PaintingliteAggregateAVG
};

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteAggregateFunc
 @abstract PaintingliteAggregateFunc 提供SDK框架中PQL语句进行聚合函数操作[COUNT MAX MIN SUM AVG]
 */
@interface PaintingliteAggregateFunc : PaintingliteTableOptions

/*!
 @method sharePaintingliteAggregateFunc
 @abstract 单例模式生成PaintingliteAggregateFunc对象
 @discussion 生成PaintingliteAggregateFunc在项目工程全局中只生成一个实例对象
 @result PaintingliteAggregateFunc
 */
+ (instancetype)sharePaintingliteAggregateFunc;

#pragma mark - 统计聚合函数

/*!
 @method count: tableName:  completeHandler:
 @abstract 统计聚合函数
 @discussion 统计聚合函数,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param tableName 表名称
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)count:(sqlite3 *)ppDb tableName:(NSString *)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, NSUInteger count))completeHandler;

/*!
 @method count: tableName:  condatation: completeHandler:
 @abstract 条件统计聚合函数
 @discussion 统计聚合函数,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param tableName 表名称
 @param condatation 条件
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)count:(sqlite3 *)ppDb tableName:(NSString *)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, NSUInteger count))completeHandler;

#pragma mark - 总和聚合函数

/*!
 @method sum:  field: tableName:  completeHandler:
 @abstract 总和聚合函数
 @discussion 总和聚合函数,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param field 字段
 @param tableName 表名称
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)sum:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double sum))completeHandler;

/*!
 @method sum:  field: tableName: condatation: completeHandler:
 @abstract 总和聚合函数
 @discussion 总和聚合函数,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param field 字段
 @param tableName 表名称
 @param condatation 条件
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)sum:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double sum))completeHandler;

#pragma mark - 最大值聚合函数
/*!
 @method max:  field: tableName: completeHandler:
 @abstract 最大值聚合函数
 @discussion 最大值聚合函数,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param field 字段
 @param tableName 表名称
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)max:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double max))completeHandler;

/*!
 @method max:  field: tableName: condatation: completeHandler:
 @abstract 条件最大值聚合函数
 @discussion 条件最大值聚合函数,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param field 字段
 @param tableName 表名称
 @param condatation 条件
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)max:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double max))completeHandler;

#pragma mark - 最小值聚合函数
/*!
 @method min:  field: tableName: completeHandler:
 @abstract 最小值聚合函数
 @discussion 条件最小值聚合函数,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param field 字段
 @param tableName 表名称
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)min:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double min))completeHandler;

/*!
 @method min:  field: tableName: condatation: completeHandler:
 @abstract 条件最小值聚合函数
 @discussion 条件最小值聚合函数,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param field 字段
 @param tableName 表名称
 @param condatation 条件
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)min:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double min))completeHandler;

#pragma mark - 平均值聚合函数
/*!
 @method avg:  field: tableName: completeHandler:
 @abstract 平均值聚合函数
 @discussion 平均值聚合函数,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param field 字段
 @param tableName 表名称
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)avg:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double avg))completeHandler;

/*!
 @method avg:  field: tableName: condatation: completeHandler:
 @abstract 条件平均值聚合函数
 @discussion 条件平均值聚合函数,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param field 字段
 @param tableName 表名称
 @param condatation 条件
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)avg:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double avg))completeHandler;


@end

NS_ASSUME_NONNULL_END
