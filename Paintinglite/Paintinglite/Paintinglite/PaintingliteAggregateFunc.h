//
//  PaintingliteAggregateFunc.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/8.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteAggregateFunc
 * 聚合函数
 * 1.COUNT 2.MAX 3.MIN 4.SUM 5.AVG
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

@interface PaintingliteAggregateFunc : PaintingliteTableOptions

/// 单例模式
+ (instancetype)sharePaintingliteAggregateFunc;

#pragma mark - 统计聚合函数

/// 统计聚合函数
/// @param ppDb ppDb
/// @param tableName 表名
/// @param completeHandler 回调操作
- (Boolean)count:(sqlite3 *)ppDb tableName:(NSString *)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, NSUInteger count))completeHandler;

/// 条件统计聚合函数
/// @param ppDb ppDb
/// @param tableName 表名
/// @param condatation 条件
/// @param completeHandler 回调操作
- (Boolean)count:(sqlite3 *)ppDb tableName:(NSString *)tableName condatation:(NSString *__nonnull)condatation  completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, NSUInteger count))completeHandler;

#pragma mark - 总和聚合函数

/// 总和聚合函数
/// @param ppDb ppDb
/// @param field 字段
/// @param tableName 表名
/// @param completeHandler 回调操作
- (Boolean)sum:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double sum))completeHandler;

/// 条件总和聚合函数
/// @param ppDb ppDb
/// @param field 字段
/// @param tableName 表名
/// @param condatation 条件
/// @param completeHandler 回调操作
- (Boolean)sum:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double sum))completeHandler;

#pragma mark - 最大值聚合函数

/// 最大值聚合函数
/// @param ppDb ppDb
/// @param field 字段
/// @param tableName 表名
/// @param completeHandler 回调操作
- (Boolean)max:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double max))completeHandler;

/// 条件最大值聚合函数
/// @param ppDb ppDb
/// @param field 字段
/// @param tableName 表名
/// @param condatation 条件
/// @param completeHandler 回调操作
- (Boolean)max:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double max))completeHandler;

#pragma mark - 最小值聚合函数

/// 最小值聚合函数
/// @param ppDb ppDb
/// @param field 字段
/// @param tableName 表名
/// @param completeHandler 回调操作
- (Boolean)min:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double min))completeHandler;

/// 条件最小值聚合函数
/// @param ppDb ppDb
/// @param field 字段
/// @param tableName 表名
/// @param condatation 条件
/// @param completeHandler 回调操作
- (Boolean)min:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double min))completeHandler;

#pragma mark - 平均值聚合函数

/// 平均值聚合函数
/// @param ppDb ppDb
/// @param field 字段
/// @param tableName 表名
/// @param completeHandler 回调操作
- (Boolean)avg:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double avg))completeHandler;

/// 条件平均值聚合函数
/// @param ppDb ppDb
/// @param field 字段
/// @param tableName 表名
/// @param condatation 条件
/// @param completeHandler 回调操作
- (Boolean)avg:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double avg))completeHandler;


@end

NS_ASSUME_NONNULL_END
