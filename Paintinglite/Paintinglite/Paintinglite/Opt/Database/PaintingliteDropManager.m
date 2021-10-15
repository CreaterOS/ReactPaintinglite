//
//  PaintingliteDropManager.m
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/8/30.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import "PaintingliteDropManager.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteExec.h"
#import "PaintingliteLog.h"
#import "PaintingliteWarningHelper.h"
#import "PaintingliteObjRuntimeProperty.h"

@interface PaintingliteDropManager()
@property (nonatomic, strong) PaintingliteExec *exec;
@end

@implementation PaintingliteDropManager

#pragma mark - lazyInit
- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

static PaintingliteDropManager *_instance = nil;
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 删除表
- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName{
    return [self dropTableForTableName:ppDb tableName:tableName completeHandler:nil];
}

- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (tableName == NULL || tableName == (id)[NSNull null] || tableName.length == 0) {
        [PaintingliteWarningHelper warningReason:@"TableName IS NULL OR TableName Len IS 0" time:[NSDate date] solve:@"Reset The TableName" args:nil];
        return NO;
    }

    Boolean success = [self.exec sqlite3Exec:ppDb tableName:tableName];
    
    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    
    return success;
}

#pragma mark - 删除表
- (Boolean)dropTableForObj:(sqlite3 *)ppDb obj:(id)obj{
    return [self dropTableForObj:ppDb obj:obj completeHandler:nil];
}

- (Boolean)dropTableForObj:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (obj == NULL || obj == (id)[NSNull null]) {
        [PaintingliteWarningHelper warningReason:@"Object IS NULL OR Object IS [NSNull null]" time:[NSDate date] solve:@"Reset The Object" args:nil];
        return NO;
    }
    
    Boolean success = [self.exec sqlite3Exec:ppDb obj:obj status:PaintingliteExecDrop createStyle:kDefault];

    if (completeHandler != nil) {
        completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
    }
    

    return success;
}

@end
