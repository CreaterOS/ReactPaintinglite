//
//  PaintingliteCreateManager.m
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/8/27.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import "PaintingliteCreateManager.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteExec.h"
#import "PaintingliteLog.h"
#import "PaintingliteWarningHelper.h"
#import "PaintingliteObjRuntimeProperty.h"

@interface PaintingliteCreateManager()
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@end

@implementation PaintingliteCreateManager

#pragma mark - lazyInit
- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

static PaintingliteCreateManager *_instance = nil;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 利用SQL操作
#pragma mark - 创建表
/* SQL创建 */
- (Boolean)execTableOptForSQL:(sqlite3 *)ppDb sql:(NSString *)sql{
    return [self execTableOptForSQL:ppDb sql:sql completeHandler:nil];
}

- (Boolean)execTableOptForSQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (sql == NULL || sql == (id)[NSNull null] || sql.length == 0) {
        return NO;
    }
    
    Boolean flag = [self.exec sqlite3Exec:ppDb sql:sql];

    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],flag);
    }
    
    return flag;
}

/* 表名创建 */
- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content{
    return [self createTableForName:ppDb tableName:tableName content:content completeHandler:nil];
}

- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    /// 表名称为空
    if (tableName == NULL || tableName == (id)[NSNull null] || tableName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"TableName IS NULL OR TableName Len IS 0" time:[NSDate date] solve:@"Reset The TableName" args:nil];
        return NO;
    }
    
    Boolean flag = [self.exec sqlite3Exec:ppDb tableName:tableName content:content];
    
    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],flag);
    }
    
    return flag;
    
}

/* Obj创建 */
- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj createStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)createStyle{
    return [self createTableForObj:ppDb obj:obj createStyle:createStyle completeHandler:nil];
}

- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj createStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)createStyle completeHandler:(void (^)(NSString *tableName,PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    /// 对象为空
    if (obj == NULL || obj == (id)[NSNull null]) {
        [PaintingliteWarningHelper warningReason:@"Object IS NULL OR Object IS [NSNull null]" time:[NSDate date] solve:@"Reset The Object" args:nil];
        return NO;
    }
    
    Boolean success = [self.exec sqlite3Exec:ppDb obj:obj status:PaintingliteExecCreate createStyle:createStyle];
    
    if (completeHandler != nil) {
        completeHandler([[PaintingliteObjRuntimeProperty getObjName:obj] lowercaseString],[PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    
    return success;
}

@end
