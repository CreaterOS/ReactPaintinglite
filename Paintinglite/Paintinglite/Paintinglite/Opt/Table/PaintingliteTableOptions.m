//
//  PaintingliteTableOptions.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/29.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteTableOptions.h"
#import "PaintingliteTableOptionsSelect.h"
#import "PaintingliteTableOptionsSelectPQL.h"
#import "PaintingliteCUDOptions.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteExec.h"
#import "PaintingliteTransaction.h"

@interface PaintingliteTableOptions()
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@property (nonatomic,strong,readwrite,nonnull)NSString *prepareStatementSql;
@property (nonatomic,assign)NSUInteger paramterIndex; //下标
@property (nonatomic,strong)PaintingliteCUDOptions *cudOpt; //增删改
@end

@implementation PaintingliteTableOptions
#pragma mark - 懒加载
- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

- (PaintingliteCUDOptions *)cudOpt{
    if (!_cudOpt) {
        _cudOpt = [PaintingliteCUDOptions sharePaintingliteCUDOptions];
    }
    
    return _cudOpt;
}

#pragma mark - 单例模式
static PaintingliteTableOptions *_instance = nil;
+ (instancetype)sharePaintingliteTableOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 利用SQL语句操作
#pragma mark - 基本查询
- (NSMutableArray *)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execQuerySQL:ppDb sql:sql];
}

- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execQuerySQL:ppDb sql:sql completeHandler:completeHandler];
}

#pragma mark - 基本查询封装对象查询
- (id)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql obj:(id)obj{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execQuerySQL:ppDb sql:sql obj:obj];
}

- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execQuerySQL:ppDb sql:sql obj:obj completeHandler:completeHandler];
}

#pragma mark - 条件查询
- (void)execQuerySQLPrepareStatementSql:(NSString *)prepareStatementSql{
    [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execQuerySQLPrepareStatementSql:prepareStatementSql];
}

- (void)setPrepareStatementSqlParameter:(NSUInteger)index paramter:(NSString *)paramter{
    [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] setPrepareStatementSqlParameter:index paramter:paramter];
}


- (void)setPrepareStatementSqlParameter:(NSMutableArray *)paramter{
    [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] setPrepareStatementSqlParameter:paramter];
}


- (NSInteger)getParamterCount:(NSString *__nonnull)tempPrepareStatementSql{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] getParamterCount:tempPrepareStatementSql];
}


- (NSMutableArray *)execPrepareStatementSql:(sqlite3 *)ppDb{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execPrepareStatementSql:ppDb];
}
            
- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execPrepareStatementSql:ppDb completeHandler:completeHandler];
}

#pragma mark - 条件查询封装对象查询
- (id)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execPrepareStatementSql:ppDb obj:obj];
}

- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execPrepareStatementSql:ppDb obj:obj completeHandler:completeHandler];
}

#pragma mark - 模糊查询
- (NSMutableArray *)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString * _Nonnull)tableName field:(NSString * _Nonnull)field like:(NSString * _Nonnull)like{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execLikeQuerySQL:ppDb tableName:tableName field:field like:like];
}

- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString * _Nonnull)tableName field:(NSString * _Nonnull)field like:(NSString * _Nonnull)like completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execLikeQuerySQL:ppDb tableName:tableName field:field like:like completeHandler:completeHandler];
}

#pragma mark - 模糊查询封装对象查询
- (id)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *)field like:(NSString *)like obj:(id)obj{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execLikeQuerySQL:ppDb field:field like:like obj:obj];
}

- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *)field like:(NSString *)like obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execLikeQuerySQL:ppDb field:field
                                    like:like obj:obj completeHandler:completeHandler];
}

#pragma mark - 分页查询
- (NSMutableArray *)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execLimitQuerySQL:ppDb tableName:tableName limitStart:start limitEnd:end];
}

- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execLimitQuerySQL:ppDb tableName:tableName limitStart:start limitEnd:end completeHandler:completeHandler];
}

#pragma mark - 分页查询封装对象查询
- (NSMutableArray *)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(nonnull id)obj{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execLimitQuerySQL:ppDb limitStart:start limitEnd:end obj:obj];
}

- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execLimitQuerySQL:ppDb limitStart:start limitEnd:end obj:obj completeHandler:completeHandler];
}

#pragma mark - 排序查询
- (NSMutableArray *)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execOrderByQuerySQL:ppDb tableName:tableName orderbyContext:orderbyContext orderStyle:orderStyle];
}

- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execOrderByQuerySQL:ppDb tableName:tableName orderbyContext:orderbyContext orderStyle:orderStyle completeHandler:completeHandler];
}

#pragma mark - 排序查询封装对象查询
- (id)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execOrderByQuerySQL:ppDb orderbyContext:orderbyContext orderStyle:orderStyle obj:obj];
}

- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions] execOrderByQuerySQL:ppDb orderbyContext:orderbyContext orderStyle:orderStyle obj:obj completeHandler:completeHandler];
}

#pragma mark - PQL查询
#pragma mark - 基本查询
- (NSMutableArray *)execQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql{
    return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execQueryPQL:ppDb pql:pql];
}

- (Boolean)execQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
        return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execQueryPQL:ppDb pql:pql completeHandler:completeHandler];
}

#pragma mark - 条件查询
- (id)execPrepareStatementPQL:(sqlite3 *)ppDb{
    return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execPrepareStatementPQL:ppDb];
}

- (Boolean)execPrepareStatementPQL:(sqlite3 *)ppDb completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execPrepareStatementPQL:ppDb completeHandler:completeHandler];
}

- (void)execQueryPQLPrepareStatementPQL:(NSString *)prepareStatementPQL{
    [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execQueryPQLPrepareStatementPQL:prepareStatementPQL];
}

- (void)setPrepareStatementPQLParameter:(NSUInteger)index paramter:(NSString *)paramter{
    [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] setPrepareStatementPQLParameter:index paramter:paramter];
}

- (void)setPrepareStatementPQLParameter:(NSMutableArray *)paramter{
    [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] setPrepareStatementPQLParameter:paramter];
}

#pragma mark - 模糊查询
- (id)execLikeQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql{
    return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execLikeQueryPQL:ppDb pql:pql];
}

- (Boolean)execLikeQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execLikeQueryPQL:ppDb pql:pql completeHandler:completeHandler];
}

#pragma mark - 分页查询
- (id)execLimitQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql{
    return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execLimitQueryPQL:ppDb pql:pql];
}

- (Boolean)execLimitQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execLimitQueryPQL:ppDb pql:pql completeHandler:completeHandler];
}

#pragma mark - 排序查询
- (id)execOrderQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql{
    return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execOrderQueryPQL:ppDb pql:pql];
}

- (Boolean)execOrderQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execOrderQueryPQL:ppDb pql:pql completeHandler:completeHandler];
}

#pragma mark - 万能查询
- (id)execPQL:(sqlite3 *)ppDb pql:(NSString *)pql{
    return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execPQL:ppDb pql:pql];
}

- (Boolean)execPQL:(sqlite3 *)ppDb pql:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [[PaintingliteTableOptionsSelectPQL sharePaintingliteTableOptionsSelectPQL] execPQL:ppDb pql:pql completeHandler:completeHandler];
}

#pragma mark - CUD
/* 增加数据 */
- (Boolean)insert:(sqlite3 *)ppDb sql:(NSString *)sql{
    return [self insert:ppDb sql:sql completeHandler:nil];
}

- (Boolean)insert:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^ __nullable)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.cudOpt insert:ppDb sql:sql completeHandler:completeHandler];
}

- (Boolean)insert:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.cudOpt insert:ppDb obj:obj completeHandler:completeHandler];
}

/* 更新数据 */
- (Boolean)update:(sqlite3 *)ppDb sql:(NSString *)sql{
    return [self.cudOpt update:ppDb sql:sql];
}

- (Boolean)update:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.cudOpt update:ppDb sql:sql
               completeHandler:completeHandler];
}

- (Boolean)update:(sqlite3 *)ppDb obj:(id)obj condition:(NSString *__nonnull)condition completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.cudOpt update:ppDb obj:obj condition:condition completeHandler:completeHandler];
}

/* 删除数据 */
- (Boolean)del:(sqlite3 *)ppDb sql:(NSString *)sql{
    return [self del:ppDb sql:sql completeHandler:nil];
}

- (Boolean)del:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^ __nullable)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.cudOpt del:ppDb sql:sql completeHandler:completeHandler];
}

@end

