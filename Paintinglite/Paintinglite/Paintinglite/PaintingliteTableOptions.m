//
//  PaintingliteTableOptions.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/29.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteTableOptions.h"
#import "PaintingliteTableOptionsSelect.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteExec.h"
#import "PaintingliteTransaction.h"

@interface PaintingliteTableOptions()
@property (nonatomic,strong)PaintingliteSessionError *sessionError;
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@property (nonatomic,strong,readwrite,nonnull)NSString *prepareStatementSql;
@property (nonatomic,assign)NSUInteger paramterIndex; //下标
@property (nonatomic,strong)PaintingliteTableOptionsSelect *select; //查询
@end

@implementation PaintingliteTableOptions

#pragma mark - 懒加载
- (PaintingliteSessionError *)sessionError{
    if (!_sessionError) {
        _sessionError = [PaintingliteSessionError sharePaintingliteSessionError];
    }
    
    return _sessionError;
}

- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

- (PaintingliteTableOptionsSelect *)select{
    if (!_select) {
        _select = [PaintingliteTableOptionsSelect sharePaintingliteTableSelectOptions];
    }
    
    return _select;
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
    return [self.select execQuerySQL:ppDb sql:sql];
}

- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [self.select execQuerySQL:ppDb sql:sql completeHandler:completeHandler];
}

#pragma mark - 基本查询封装对象查询
- (id)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql obj:(id)obj{
    return [self.select execQuerySQL:ppDb sql:sql obj:obj];
}

- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.select execQuerySQL:ppDb sql:sql obj:obj completeHandler:completeHandler];
}

#pragma mark - 条件查询
- (void)execQuerySQLPrepareStatementSql:(NSString *)prepareStatementSql{
    [self.select execQuerySQLPrepareStatementSql:prepareStatementSql];
}

- (void)setPrepareStatementSqlParameter:(NSUInteger)index paramter:(NSString *)paramter{
    [self.select setPrepareStatementSqlParameter:index paramter:paramter];
}


- (void)setPrepareStatementSqlParameter:(NSMutableArray *)paramter{
    [self.select setPrepareStatementSqlParameter:paramter];
}


- (NSInteger)getParamterCount:(NSString *__nonnull)tempPrepareStatementSql{
    return [self.select getParamterCount:tempPrepareStatementSql];
}


- (NSMutableArray *)execPrepareStatementSql:(sqlite3 *)ppDb{
    return [self.select execPrepareStatementSql:ppDb];
}
            
- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [self.select execPrepareStatementSql:ppDb completeHandler:completeHandler];
}

#pragma mark - 条件查询封装对象查询
- (id)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj{
    return [self.select execPrepareStatementSql:ppDb obj:obj];
}

- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.select execPrepareStatementSql:ppDb obj:obj completeHandler:completeHandler];
}

#pragma mark - 模糊查询
- (NSMutableArray *)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString * _Nonnull)tableName field:(NSString * _Nonnull)field like:(NSString * _Nonnull)like{
    return [self.select execLikeQuerySQL:ppDb tableName:tableName field:field like:like];
}

- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb tableName:(NSString * _Nonnull)tableName field:(NSString * _Nonnull)field like:(NSString * _Nonnull)like completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [self.select execLikeQuerySQL:ppDb tableName:tableName field:field like:like completeHandler:completeHandler];
}

#pragma mark - 模糊查询封装对象查询
- (id)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *)field like:(NSString *)like obj:(id)obj{
    return [self.select execLikeQuerySQL:ppDb field:field like:like obj:obj];
}

- (Boolean)execLikeQuerySQL:(sqlite3 *)ppDb field:(NSString *)field like:(NSString *)like obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.select execLikeQuerySQL:ppDb field:field
                                    like:like obj:obj completeHandler:completeHandler];
}

#pragma mark - 分页查询
- (NSMutableArray *)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end{
    return [self.select execLimitQuerySQL:ppDb tableName:tableName limitStart:start limitEnd:end];
}

- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [self.select execLimitQuerySQL:ppDb tableName:tableName limitStart:start limitEnd:end completeHandler:completeHandler];
}

#pragma mark - 分页查询封装对象查询
- (NSMutableArray *)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(nonnull id)obj{
    return [self.select execLimitQuerySQL:ppDb limitStart:start limitEnd:end obj:obj];
}

- (Boolean)execLimitQuerySQL:(sqlite3 *)ppDb limitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.select execLimitQuerySQL:ppDb limitStart:start limitEnd:end obj:obj completeHandler:completeHandler];
}

#pragma mark - 排序查询
- (NSMutableArray *)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle{
    return [self.select execOrderByQuerySQL:ppDb tableName:tableName orderbyContext:orderbyContext orderStyle:orderStyle];
}

- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb tableName:(NSString *)tableName orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [self.select execOrderByQuerySQL:ppDb tableName:tableName orderbyContext:orderbyContext orderStyle:orderStyle completeHandler:completeHandler];
}

#pragma mark - 排序查询封装对象查询
- (id)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj{
    return [self.select execOrderByQuerySQL:ppDb orderbyContext:orderbyContext orderStyle:orderStyle obj:obj];
}

- (Boolean)execOrderByQuerySQL:(sqlite3 *)ppDb orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.select execOrderByQuerySQL:ppDb orderbyContext:orderbyContext orderStyle:orderStyle obj:obj completeHandler:completeHandler];
}

@end
