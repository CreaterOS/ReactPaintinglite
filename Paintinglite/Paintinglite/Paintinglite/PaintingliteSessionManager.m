//
//  PaintingliteSessionManager.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSessionManager.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteDataBaseOptions.h"
#import "PaintingliteConfiguration.h"

@interface PaintingliteSessionManager()
@property (nonatomic,readonly)PaintingliteSessionFactoryLite *ppDb; //数据库
@property (nonatomic,strong)PaintingliteSessionFactory *factory; //工厂类
@property (nonatomic,strong)PaintingliteSessionError *error; //错误
@property (nonatomic,strong)PaintingliteConfiguration *configuration; //配置文件
@property (nonatomic,strong)PaintingliteDataBaseOptions *dataBaseOptions; //数据库操作
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

- (PaintingliteDataBaseOptions *)dataBaseOptions{
    if (!_dataBaseOptions) {
        _dataBaseOptions = [PaintingliteDataBaseOptions sharePaintingliteDataBaseOptions];
    }
    
    return _dataBaseOptions;
}


- (PaintingliteConfiguration *)configuration{
    if (!_configuration) {
        _configuration = [PaintingliteConfiguration sharePaintingliteConfiguration];
    }
    
    return _configuration;
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
    
    NSString *filePath = [self.configuration configurationFileName:fileName];
    @synchronized (self) {
        success = (sqlite3_open_v2([filePath UTF8String], &_ppDb, SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX, NULL) == SQLITE_OK);
        if (completeHandler != nil) {
            completeHandler(filePath,self.error,success);
        }
    }
    
    //保存表快照到JSON文件
    dispatch_async(PaintingliteSessionFactory_Sqlite_Queque, ^{
        //查看打开的数据库，进行快照区保存
        [self saveSnip];
    });

    
    return success;
}

#pragma mark - 快照区保存
- (void)saveSnip{
    [self.factory execQuery:self.ppDb sql:@"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"];
}

#pragma mark - SQL操作
#pragma mark - 创建表
- (Boolean)createTableForSQL:(NSString *)sql{
    return [self createTableForSQL:sql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)createTableForSQL:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions createTableForSQL:self.ppDb sql:sql completeHandler:completeHandler];
}

- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content{
    return [self createTableForName:tableName content:content completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions createTableForName:self.ppDb tableName:tableName content:content completeHandler:completeHandler];
}

#pragma mark - 删除表
- (Boolean)dropTableForSQL:(NSString *)sql{
    return [self dropTableForSQL:sql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)dropTableForSQL:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions createTableForSQL:self.ppDb sql:sql completeHandler:completeHandler];
}

- (Boolean)dropTableForTableName:(NSString *)tableName{
    return [self dropTableForTableName:tableName completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)dropTableForTableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions dropTableForTableName:self.ppDb tableName:tableName completeHandler:completeHandler];
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

#pragma mark - 删除日志文件
- (void)removeLogFile:(NSString *)fileName{
    [self.factory removeLogFile:fileName];
}

#pragma mark - 读取日志文件
- (NSString *)readLogFile:(NSString *)fileName{
    return [self.factory readLogFile:fileName];
}

- (NSString *)readLogFile:(NSString *)fileName dateTime:(NSDate *)dateTime{
    return [[self.factory readLogFile:fileName dateTime:dateTime] length] != 0 ? [self.factory readLogFile:fileName dateTime:dateTime] : @"无操作日志";
}

- (NSString *)readLogFile:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus{
    return [[self.factory readLogFile:fileName logStatus:logStatus] length] != 0 ? [self.factory readLogFile:fileName logStatus:logStatus] : @"无对应日志";
}
@end
