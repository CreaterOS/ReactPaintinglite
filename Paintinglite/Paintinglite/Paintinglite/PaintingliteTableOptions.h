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

/* 单例模式 */
+ (instancetype)sharePaintingliteTableOptions;

- (NSMutableArray *)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;
- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

- (id)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql obj:(id)obj;
- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

- (void)execQuerySQLPrepareStatementSql:(NSString *__nonnull)prepareStatementSql;


- (void)setPrepareStatementSqlParameter:(NSUInteger)index paramter:(NSString *__nonnull)paramter;


- (void)setPrepareStatementSqlParameter:(NSMutableArray *__nonnull)paramter;


- (NSMutableArray *)execPrepareStatementSql:(sqlite3 *)ppDb;
- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

- (id)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj;
- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

- (NSMutableArray *)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like;
- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

- (id)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj;
- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;


- (NSMutableArray *)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end;
- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

- (id)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj;
- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

- (NSMutableArray *)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle;
- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

- (id)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj;
- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

@end

NS_ASSUME_NONNULL_END
