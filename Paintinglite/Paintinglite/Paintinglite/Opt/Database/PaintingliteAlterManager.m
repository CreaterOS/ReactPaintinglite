//
//  PaintingliteAlterManager.m
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/8/30.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import "PaintingliteAlterManager.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteExec.h"
#import "PaintingliteLog.h"
#import "PaintingliteWarningHelper.h"
#import "PaintingliteObjRuntimeProperty.h"

@interface PaintingliteAlterManager()
@property (nonatomic, strong) PaintingliteExec *exec;
@end

@implementation PaintingliteAlterManager

#pragma mark - lazyInit
- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

static PaintingliteAlterManager *_instance = nil;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (BOOL)alterTableForName:(sqlite3 *)ppDb oldName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName{
    return [self alterTableForName:ppDb oldName:oldName newName:newName completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (BOOL)alterTableForName:(sqlite3 *)ppDb oldName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    /// 旧表名称
    if (oldName == NULL || oldName == (id)[NSNull null] || oldName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"TableName IS NULL OR TableName Len IS 0" time:[NSDate date] solve:@"Reset The TableName" args:nil];
        return NO;
    }
    
    /// 新表名称
    if (newName == NULL || newName == (id)[NSNull null] || newName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"New TableName IS NULL OR New TableName Len IS 0" time:[NSDate date] solve:@"Reset The New TableName" args:nil];
        return NO;
    }
    
    Boolean success = [self.exec sqlite3Exec:ppDb obj:@[oldName,newName] status:PaintingliteExecAlterRename createStyle:PaintingliteDataBaseOptionsDefault];
    
    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    
    return success;
}

- (BOOL)alterTableAddColumn:(sqlite3 *)ppDb tableName:(NSString *)tableName columnName:(NSString *)columnName columnType:(NSString *)columnType{
    return [self alterTableAddColumn:ppDb tableName:tableName columnName:columnName columnType:columnType completeHandler:nil];
}

- (BOOL)alterTableAddColumn:(sqlite3 *)ppDb tableName:(NSString *)tableName columnName:(NSString *)columnName columnType:(NSString *)columnType completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    
    if (tableName == NULL || tableName == (id)[NSNull null] || tableName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"TableName IS NULL OR TableName Len IS 0" time:[NSDate date] solve:@"Reset The TableName" args:nil];
        return NO;
    }
    
    if (columnName == NULL || columnName == (id)[NSNull null] || columnName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"ColumnName IS NULL OR ColumnName Len IS 0" time:[NSDate date] solve:@"Reset The ColumnName" args:nil];
        return NO;
    }
    
    Boolean success = [self.exec sqlite3Exec:ppDb obj:@[tableName,columnName,columnType] status:PaintingliteExecAlterAddColumn createStyle:PaintingliteDataBaseOptionsDefault];
    
    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    
    return success;
}

- (BOOL)alterTableForObj:(sqlite3 *)ppDb obj:(id)obj columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType{
    return [self alterTableForObj:ppDb obj:obj completeHandler:nil];
}

- (BOOL)alterTableForObj:(sqlite3 *)ppDb obj:(id)obj{
    return [self alterTableForObj:ppDb obj:obj completeHandler:nil];
}

- (BOOL)alterTableForObj:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (obj == NULL || obj == (id)[NSNull null]) {
        [PaintingliteWarningHelper warningReason:@"Object IS NULL OR Object IS [NSNull null]" time:[NSDate date] solve:@"Reset The Object" args:nil];
        return NO;
    }
    
    Boolean success = [self.exec sqlite3Exec:ppDb obj:obj status:PaintingliteExecAlterObj createStyle:PaintingliteDataBaseOptionsDefault];
    
    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    
    return success;
}

@end
