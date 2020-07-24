//
//  PaintingliteAggregateFunc.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/8.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteAggregateFunc.h"
#import "PaintingliteException.h"
#import "PaintingliteExec.h"

@interface PaintingliteAggregateFunc()
@property (nonatomic,strong)PaintingliteSessionError *sessionError;
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@property (nonatomic)sqlite3_stmt *stmt;
@end

@implementation PaintingliteAggregateFunc

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

#pragma mark - 单例模式
static PaintingliteAggregateFunc *_instance = nil;
+ (instancetype)sharePaintingliteAggregateFunc{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 基本聚合
- (double)Aggregate:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql{
    //查询总个数
    //SELECT count(*) FROM user
    __block double number = 0;
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (sqlite3_prepare_v2(ppDb, [sql UTF8String], -1, &(self->_stmt), nil) == SQLITE_OK){
            //查询成功
            while (sqlite3_step(self->_stmt) == SQLITE_ROW) {
                number = sqlite3_column_double(self->_stmt, 0);
            }
        }
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    sqlite3_finalize(_stmt);
    
    return number;
}

#pragma mark - SQL
- (NSString *__nonnull)aggregateSQL:(PaintingliteAggregateType)type field:(NSString *__nonnull)field tableName:(NSString *__nonnull)tableName condatation:(NSString *__nonnull)condatation{
    
    //判断表是否存在
    if (![[self.exec getCurrentTableNameWithCache] containsObject:[tableName lowercaseString]]) {
        //抛出异常
        [PaintingliteException PaintingliteException:@"表名不存在" reason:@"数据库中找不到表名,无法查询"];
    }

    
    if (type == PaintingliteAggregateSUM) {
        return [NSString stringWithFormat:@"SELECT SUM(%@) FROM %@ %@",field,[tableName lowercaseString],condatation];
    }else if (type == PaintingliteAggregateMax){
        return [NSString stringWithFormat:@"SELECT MAX(%@) FROM %@ %@",field,[tableName lowercaseString],condatation];
    }else if (type == PaintingliteAggregateMIN){
        return [NSString stringWithFormat:@"SELECT MIN(%@) FROM %@ %@",field,[tableName lowercaseString],condatation];
    }else if(type == PaintingliteAggregateAVG){
        return [NSString stringWithFormat:@"SELECT AVG(%@) FROM %@ %@",field,[tableName lowercaseString],condatation];
    }
    
    return [NSString string];
}

#pragma mark - 统计个数
- (Boolean)count:(sqlite3 *)ppDb tableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSUInteger))completeHandler{
    return [self count:ppDb tableName:tableName condatation:@"" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, NSUInteger count) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(self.sessionError,success,count);
            }
        }
    }];
}

- (Boolean)count:(sqlite3 *)ppDb tableName:(NSString *)tableName condatation:(NSString *)condatation completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSUInteger))completeHandler{
    Boolean success = false;
    
    //查询总个数
    NSUInteger number = [self Aggregate:ppDb sql:[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ %@",[tableName lowercaseString],condatation]];
    success = number != -1;
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,number);
    }
    
    return success;
}

#pragma mark - 总和聚合函数
- (Boolean)sum:(sqlite3 *)ppDb field:(NSString *)field tableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, double))completeHandler{
    return [self sum:ppDb field:field tableName:tableName condatation:@"" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double sum) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(sessionerror,success,sum);
            }
        }
    }];
}

- (Boolean)sum:(sqlite3 *)ppDb field:(NSString *)field tableName:(NSString *)tableName condatation:(NSString *)condatation completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, double))completeHandler{
    Boolean success = false;
    
    //总和
    NSUInteger number = [self Aggregate:ppDb sql:[self aggregateSQL:PaintingliteAggregateSUM field:field tableName:tableName condatation:condatation]];
    success = number != -1;
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,number);
    }
    
    return success;
}

#pragma mark - 最大值聚合函数
- (Boolean)max:(sqlite3 *)ppDb field:(NSString *)field tableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, double))completeHandler{
    return [self max:ppDb field:field tableName:tableName condatation:@"" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double max) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(sessionerror,success,max);
            }
        }
    }];
}

- (Boolean)max:(sqlite3 *)ppDb field:(NSString *)field tableName:(NSString *)tableName condatation:(NSString *)condatation completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, double))completeHandler{
    Boolean success = false;
    
    //总和
    NSUInteger number = [self Aggregate:ppDb sql:[self aggregateSQL:PaintingliteAggregateMax field:field tableName:tableName condatation:condatation]];
    success = number != -1;
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,number);
    }
    
    return success;
}

#pragma mark - 最小值聚合函数
- (Boolean)min:(sqlite3 *)ppDb field:(NSString *)field tableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, double))completeHandler{
    return [self min:ppDb field:field tableName:tableName condatation:@"" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double min) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(sessionerror,success,min);
            }
        }
    }];
}

- (Boolean)min:(sqlite3 *)ppDb field:(NSString *)field tableName:(NSString *)tableName condatation:(NSString *)condatation completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, double))completeHandler{
    Boolean success = false;
    
    //总和
    double number = [self Aggregate:ppDb sql:[self aggregateSQL:PaintingliteAggregateMIN field:field tableName:tableName condatation:condatation]];
    success = number != -1;
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,number);
    }
    
    return success;
}

#pragma mark - 平均值聚合函数
- (Boolean)avg:(sqlite3 *)ppDb field:(NSString *)field tableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, double))completeHandler{
    return [self avg:ppDb field:field tableName:tableName condatation:@"" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double avg) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(sessionerror,success,avg);
            }
        }
    }];
}

- (Boolean)avg:(sqlite3 *)ppDb field:(NSString *)field tableName:(NSString *)tableName condatation:(NSString *)condatation completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, double))completeHandler{
    Boolean success = false;
    
    //总和
    double number = [self Aggregate:ppDb sql:[self aggregateSQL:PaintingliteAggregateAVG field:field tableName:tableName condatation:condatation]];
    success = number != -1;
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,number);
    }
    
    return success;
}

@end
