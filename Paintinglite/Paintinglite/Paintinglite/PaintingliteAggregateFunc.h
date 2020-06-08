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

/* 单例模式 */
+ (instancetype)sharePaintingliteAggregateFunc;

#pragma mark - 统计聚合函数
/* 统计聚合函数 */
- (Boolean)count:(sqlite3 *)ppDb tableName:(NSString *)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, NSUInteger count))completeHandler;
/* 统计聚合函数 -- 带条件 */
- (Boolean)count:(sqlite3 *)ppDb tableName:(NSString *)tableName condatation:(NSString *__nonnull)condatation  completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, NSUInteger count))completeHandler;

#pragma mark - 总和聚合函数
/* 总和聚合函数 */
- (Boolean)sum:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double sum))completeHandler;

/* 总和聚合函数 -- 带条件 */
- (Boolean)sum:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double sum))completeHandler;

#pragma mark - 最大值聚合函数
- (Boolean)max:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double max))completeHandler;

- (Boolean)max:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double max))completeHandler;

#pragma mark - 最小值聚合函数
- (Boolean)min:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double min))completeHandler;

- (Boolean)min:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double min))completeHandler;

#pragma mark - 平均值聚合函数
- (Boolean)avg:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double avg))completeHandler;

- (Boolean)avg:(sqlite3 *)ppDb field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionerror, Boolean success, double avg))completeHandler;


@end

NS_ASSUME_NONNULL_END
