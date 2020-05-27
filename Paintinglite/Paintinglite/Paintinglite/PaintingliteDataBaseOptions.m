//
//  PaintingliteDataBaseOptions.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteDataBaseOptions.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteLog.h"

@interface PaintingliteDataBaseOptions()
@property (nonatomic,strong)PaintingliteSessionError *sessionError;
@property (nonatomic,strong)PaintingliteSessionFactory *factory; //工厂
@property (nonatomic,strong)PaintingliteLog *log; //日志
@end

@implementation PaintingliteDataBaseOptions

#pragma mark - 懒加载
- (PaintingliteSessionError *)sessionError{
    if (!_sessionError) {
        _sessionError = [PaintingliteSessionError sharePaintingliteSessionError];
    }
    
    return _sessionError;
}

- (PaintingliteSessionFactory *)factory{
    if (!_factory) {
        _factory = [PaintingliteSessionFactory sharePaintingliteSessionFactory];
    }
    
    return _factory;
}

- (PaintingliteLog *)log{
    if (!_log) {
        _log = [PaintingliteLog sharePaintingliteLog];
    }
    
    return _log;
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

#pragma mark - 利用SQL语句创建
#pragma mark - 创建表
- (Boolean)createTableForSQL:(sqlite3 *)ppDb sql:(NSString *)sql{
    __block Boolean flag = false;
    return [self createTableForSQL:ppDb sql:sql
                   completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
                       flag = success;
                   }];
    
    return flag;
}

- (Boolean)createTableForSQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    Boolean flag = [self sqlite3Exec:ppDb sql:sql];

    @synchronized (self) {
        if (flag) {
            //保存快照
            NSString *sql = @"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name";
            [self.factory execQuery:ppDb sql:sql];
            //写入日志
            [self.log writeLogFileOptions:sql status:PaintingliteLogSuccess completeHandler:^(NSString * _Nonnull logFilePath) {
                ;
            }];
        }else{
            [self.log writeLogFileOptions:sql status:PaintingliteLogError completeHandler:^(NSString * _Nonnull logFilePath) {
                ;
            }];
        }
    }
    if (completeHandler != nil) {
        completeHandler(self.sessionError,flag);
    }
    
    return flag;
}


- (Boolean)sqlite3Exec:(sqlite3 *)ppDb sql:(NSString *)sql{
    NSAssert(sql != NULL, @"SQL Not IS Empty");
    
    return sqlite3_exec(ppDb, [sql UTF8String], 0, 0, 0) == SQLITE_OK;
}

@end
