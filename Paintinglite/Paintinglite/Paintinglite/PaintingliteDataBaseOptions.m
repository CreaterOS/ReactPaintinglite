//
//  PaintingliteDataBaseOptions.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteDataBaseOptions.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteExec.h"
#import "PaintingliteLog.h"

@interface PaintingliteDataBaseOptions()
@property (nonatomic,strong)PaintingliteSessionError *sessionError;
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@end

@implementation PaintingliteDataBaseOptions

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
static PaintingliteDataBaseOptions *_instance = nil;
+ (instancetype)sharePaintingliteDataBaseOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 利用SQL操作
#pragma mark - 创建表
- (Boolean)createTableForSQL:(sqlite3 *)ppDb sql:(NSString *)sql{
    return [self createTableForSQL:ppDb sql:sql
        completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
            ;
    }];
}

- (Boolean)createTableForSQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    Boolean flag = [self.exec sqlite3Exec:ppDb sql:sql];

    if (completeHandler != nil) {
        completeHandler(self.sessionError,flag);
    }
    
    return flag;
}

#pragma mark - 删除表
- (Boolean)dropTableForSQL:(sqlite3 *)ppDb sql:(NSString *)sql{
    return [self dropTableForSQL:ppDb sql:sql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)dropTableForSQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(nonnull void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    
    Boolean success = [self.exec sqlite3Exec:ppDb sql:sql];
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success);
    }
    
    return success;
}

#pragma mark - 利用表名操作
#pragma mark - 创建表
- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content{
    return [self createTableForName:ppDb tableName:tableName content:content completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    NSAssert(tableName != NULL, @"Table Name IS Not Empty");
    
    Boolean flag = [self.exec sqlite3Exec:ppDb tableName:tableName content:content];
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,flag);
    }
    
    return flag;
    
}


#pragma mark - 删除表
- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName{
    return [self dropTableForTableName:ppDb tableName:tableName completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    NSAssert(tableName != NULL, @"Table Name IS Not Empty");

    Boolean success = [self.exec sqlite3Exec:ppDb tableName:tableName];
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success);
    }
    
    return success;
}

#pragma mark - 利用类操作
#pragma mark - 创建表
- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj{
    return [self createTableForObj:ppDb obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    
    Boolean success = [self.exec sqlite3Exec:ppDb obj:obj];
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success);
    }
    
    return success;
}

@end
