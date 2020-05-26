//
//  PaintingliteSessionManager.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSessionManager.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteConfiguration.h"

@interface PaintingliteSessionManager()
@property (nonatomic,readonly)PaintingliteSessionFactoryLite *ppDb; //数据库
@property (nonatomic,strong)PaintingliteSessionFactory *factory; //工厂类
@property (nonatomic,strong)PaintingliteSessionError *error; //错误
@property (nonatomic)Boolean closeFlag; //关闭标识符
@end

@implementation PaintingliteSessionManager

#pragma mark - 懒加载
- (PaintingliteSessionError *)error{
    if (!_error) {
        _error = [PaintingliteSessionError sharePaintingliteSessionError];
    }
    
    return _error;
}

- (PaintingliteSessionFactory *)factory{
    if (!_factory) {
        _factory = [PaintingliteSessionFactory sharePaintingliteSessionFactory];
    }
    
    return _factory;
}

#pragma mark - 单例模式
static PaintingliteSessionManager *_instance = nil;
+ (instancetype)sharePaintingliteSessionManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 连接数据库
- (Boolean)openSqlite:(NSString *)fileName{
    __block Boolean flag = false;
    
    [self openSqlite:fileName completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            flag = true;
        }
    }];

    return flag;
}

- (Boolean)openSqlite:(NSString *)fileName completeHandler:(void (^)(NSString * _Nonnull, PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    NSAssert(fileName != NULL, @"Please set the Sqlite DataBase Name");
    Boolean success = false;
    
    NSString *filePath = [PaintingliteConfiguration configurationFileName:fileName];
    @synchronized (self) {
        success = (sqlite3_open([filePath UTF8String], &_ppDb) == SQLITE_OK);
        if (completeHandler != nil) {
            completeHandler(filePath,self.error,success);
        }
    }
    
    //保存表快照到JSON文件
    dispatch_async(PaintingliteSessionFactory_Sqlite_Queque, ^{
        //查看打开的数据库，进行快照区保存
        [self.factory execQuery:self.ppDb sql:@"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"];
    });

    
    return success;
}

#pragma mark - 释放数据库
- (Boolean)releaseSqlite{
    __block Boolean flag = false;
    
    [self releaseSqliteCompleteHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            flag = success;
        }
    }];
    
    return flag;
}

- (Boolean)releaseSqliteCompleteHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    
    Boolean success = false;
    
    @synchronized (self) {
        if (!self.closeFlag) {
            success = (sqlite3_close(_ppDb) == SQLITE_OK);
            self.closeFlag = success;
            
            if (completeHandler != nil) {
                completeHandler(self.error,success);
            }
        }
    }

    return success;
}
@end
