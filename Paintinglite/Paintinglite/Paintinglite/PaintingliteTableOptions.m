//
//  PaintingliteTableOptions.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/29.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteTableOptions.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteExec.h"

@interface PaintingliteTableOptions()
@property (nonatomic,strong)PaintingliteSessionError *sessionError;
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
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
    __block NSMutableArray *execQueryArray = [NSMutableArray array];
    [self execQuerySQL:ppDb sql:sql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        if (success) {
            execQueryArray = resArray;
        }
    }];
    
    return execQueryArray;
}

- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    Boolean success = ([self.exec sqlite3ExecQuery:ppDb sql:sql].count != 0);
    NSMutableArray *resArray = [NSMutableArray array];
    
    if (success) {
       resArray = [self.exec sqlite3ExecQuery:ppDb sql:sql];
    }
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,resArray);
    }
    
    return success;
}

#pragma mark - 封装查询
- (id)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql obj:(id)obj{
    __block id paintingObj = NULL;
    [self execQuerySQL:ppDb sql:sql obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> *  _Nonnull resObjList) {
        paintingObj = resObjList;
    }];
    
    return paintingObj;
}

- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    //执行普通查询，然后进行封装
    __block NSMutableArray *execQueryArray = [NSMutableArray array];
    Boolean success = [self execQuerySQL:ppDb sql:sql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        if (success) {
            execQueryArray = resArray;
        }
    }];
    
    NSMutableArray<id> *resObjList = [NSMutableArray array];
    
    @synchronized (self) {
        //开始封装
        for (NSUInteger i = 0; i < execQueryArray.count; i++) {
            id tempObj = nil;
            
            tempObj = [PaintingliteObjRuntimeProperty setObjPropertyValue:obj value: execQueryArray[i]];
            
            [resObjList addObject:tempObj];
        }

    }
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,execQueryArray,resObjList);
    }
    
    return success;
}

@end
