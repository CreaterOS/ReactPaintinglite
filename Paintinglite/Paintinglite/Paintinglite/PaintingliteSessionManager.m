//
//  PaintingliteSessionManager.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSessionManager.h"
#import "PaintingliteFileManager.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteSecurity.h"
#import "PaintingliteConfiguration.h"
#import "PaintingliteSnapManager.h"
#import "PaintingliteExec.h"
#import "PaintingliteCache.h"
#import "PaintingliteWarningHelper.h"

#define WEAKSELF(SELF) __weak typeof(SELF) weakself = SELF
#define STRONGSELF(WEAKSELF) __strong typeof(WEAKSELF) self = WEAKSELF
#define ROOT_FILE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]
#define ZIP_NAME @"Encrypt"

/// 数据库打开方式
typedef NS_ENUM(NSUInteger, PaintingliteOpenType) {
    PaintingliteOpenByFileName,
    PaintingliteOpenByFilePath
};

@interface PaintingliteSessionManager()
@property (nonatomic,readwrite)PaintingliteSessionFactoryLite *ppDb; //数据库
@property (nonatomic,copy)NSString *databaseName; //数据库名称
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@property (nonatomic)Boolean closeFlag; //关闭标识符

@property (nonatomic,copy)NSString *basePath; /// 基本路径
@property (nonatomic,copy)NSString *session; /// 会话Session
@end

@implementation PaintingliteSessionManager

#pragma mark - 懒加载
- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

- (NSString *)basePath {
    if (!_basePath) {
        _basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    }
    
    return _basePath;
}

- (NSString *)session {
    if (!_session) {
        _session = [NSUUID UUID].UUIDString;
    }
    
    return _session;
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        //加载缓存
        [PaintingliteCache sharePaintingliteCache];
    }
    return self;
}

/* =====================================数据库打开/关闭======================================== */
#pragma mark - 数据库打开/关闭
#pragma mark - 连接数据库
/// v1.3.3优化策略
- (NSString *__nonnull)createDefineDataBaseName:(NSString *)str type:(PaintingliteOpenType)type {
    /**
        v1.3.3优化策略
        针对文件名为空,自动生成文件名称
     */
    NSString *name = @"paintingliteDB.db";
    if (str == NULL || str == (id)[NSNull null] || str.length == 0) {
        switch (type) {
            case PaintingliteOpenByFileName:
                str = name;
                break;
            case PaintingliteOpenByFilePath:
                str = [self.basePath stringByAppendingPathComponent:name];
                break;
        }
        
    }
    
    return str;
}

- (Boolean)openSqlite:(NSString *)fileName{
    return [self openSqlite:fileName completeHandler:nil];
}

- (Boolean)openSqlite:(NSString *)fileName completeHandler:(void (^)(NSString * _Nonnull, PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    fileName = [self createDefineDataBaseName:fileName type:PaintingliteOpenByFileName];
    
    //创建信号量
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    __block Boolean success = false;
    
    /* 打开数据库先判断是否打开数据库,打开了先释放数据库,在打开数据库 */
    if (self.isOpen) [self releaseSqlite];
    
    //数据库名称名称
    NSString *filePath = [[PaintingliteConfiguration sharePaintingliteConfiguration] configurationFileName:fileName];
    
    WEAKSELF(self);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF(weakself);
        if ([self isExistsDatabase:filePath]){
            success = (sqlite3_open_v2([filePath UTF8String], &(self->_ppDb), SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX, NULL) == SQLITE_OK);
        }else{
            success = (sqlite3_open([filePath UTF8String], &(self->_ppDb)) == SQLITE_OK);
        }
        
        if (completeHandler != nil) {
            completeHandler(filePath,[PaintingliteSessionError sharePaintingliteSessionError],success);
        }

        /* 数据库打开成功 */
        self.isOpen = success;
        /* 数据库文件路径 */
        self.databasePath = filePath;
        
        //保存表快照到一级缓存 -- 当数据库中含有的表的时候保存到快照
        //查看打开的数据库，进行快照区保存
        [[PaintingliteSnapManager sharePaintingliteSnapManager] saveSnap:self.ppDb];
        
        //信号量+1
        dispatch_semaphore_signal(signal);
    });
    
    //信号量等待
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    return success;
}

- (Boolean)openSqliteWithFilePath:(NSString *)filePath{
    return [self openSqliteFilePath:filePath completeHandler:nil];
}

- (Boolean)openSqliteFilePath:(NSString *)filePath completeHandler:(void (^)(NSString * _Nonnull, Boolean))completeHandler{
//    NSAssert(filePath != NULL, @"Please set the Sqlite DataBase FilePath");
    filePath = [self createDefineDataBaseName:filePath type:PaintingliteOpenByFilePath];
    
    //创建信号量
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    __block Boolean success = false;
    WEAKSELF(self);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF(weakself);
        if([[PaintingliteFileManager defaultManager] fileExistsAtPath:filePath]){
            success = (sqlite3_open_v2([filePath UTF8String], &(self->_ppDb), SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX, NULL) == SQLITE_OK);
        }else{
            success = (sqlite3_open([filePath UTF8String], &(self->_ppDb)) == SQLITE_OK);
        }
        
        /* 数据库打开成功 */
        self.isOpen = success;
        /* 数据库文件路径 */
        self.databasePath = filePath;
        
        //保存表快照到一级缓存 -- 当数据库中含有的表的时候保存到快照
        //查看打开的数据库，进行快照区保存
        [[PaintingliteSnapManager sharePaintingliteSnapManager] saveSnap:self.ppDb];
        
        //信号量+1
        dispatch_semaphore_signal(signal);
    });
    
    //信号量等待
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    completeHandler(filePath,success);
    
    return success;
}

#pragma mark - 获得当前Session
- (NSString *)getCurrentSession {
    return ([self getSqlite3] == NULL) ? [NSString string] : self.session;
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
    /* 释放数据库,先判断是否打开数据库,只有打开数据库才可以释放 */
    Boolean success = false;
    
    if (self.isOpen) {
        @synchronized (self) {
            if (!self.closeFlag) {
                success = (sqlite3_close(_ppDb) == SQLITE_OK);
                self.closeFlag = success;
                
                if (completeHandler != nil) {
                    completeHandler([PaintingliteSessionError sharePaintingliteSessionError],success);
                }
            }
        }
    }else{
        [self warningOpenDatabase];
    }

    return success;
}

/* =====================================数据库基本信息======================================== */
#pragma mark - 数据库基本信息
#pragma mark - 获得数据库
- (sqlite3 *)getSqlite3{
    if (self.ppDb == NULL || self.ppDb == CFBridgingRetain([NSNull null])) {
        /// WARNING-INFO
        [PaintingliteWarningHelper warningReason:@"Not Found The Database By This Session" time:[NSDate date] solve:@"Use [openSqlite: ] [openSqlite: completeHandler:] etc Create The Sqlite3 Database" args:nil];
        return nil;
    }
    
    return self.ppDb;
}

#pragma mark - 获得数据库版本
- (NSString *)getSqlite3Version{
    return [@"Paintinglite use sqlite3 version:" stringByAppendingString:[NSString stringWithUTF8String:sqlite3_version]];
}

#pragma mark - 返回数据库列表
- (NSArray<NSString *> *)dictExistsDatabaseList:(NSString *__nonnull)fileDict{
    NSMutableArray<NSString *> *databaseArray = [NSMutableArray array];
    
    if (fileDict == NULL || fileDict == (id)[NSNull null] || fileDict.length == 0) {
        return databaseArray;
    }
    
    NSArray<NSString *> *filePathArray = [[PaintingliteFileManager defaultManager] dictExistsFile:fileDict];
    for (NSString *fileName in filePathArray) {
        if ([fileName hasSuffix:@"db"]){
            [databaseArray addObject:fileName];
        }
    }
    return (NSArray *)databaseArray;
}

#pragma mark - 数据库文件存在
- (Boolean)isExistsDatabase:(NSString *)filePath{
    if (filePath == NULL || filePath == (id)[NSNull null] || filePath.length == 0) {
        return NO;
    }
    return [[PaintingliteFileManager defaultManager] fileExistsAtPath:filePath];
}

#pragma mark - 数据库文件详细信息
- (NSDictionary<NSFileAttributeKey,id> *)databaseInfoDict:(NSString *)filePath{
    if (filePath != NULL && filePath != (id)[NSNull null] && filePath.length != 0 && [filePath hasSuffix:@"db"]) {
        return [[PaintingliteFileManager defaultManager] databaseInfo:filePath];
    }
    
    return [NSDictionary dictionary];
}

#pragma mark - 数据库大小
- (double)totalSize{
    if (self.databasePath == NULL || self.databasePath == (id)[NSNull null] || self.databasePath.length == 0) {
        return 0.0f;
    }
    
    NSUInteger fileSize = [(NSNumber *)[self databaseInfoDict:self.databasePath][NSFileSize] integerValue];
    return fileSize/1024.0/1024.0;
}

/* =====================================数据库操作======================================== */
#pragma mark - SQL操作
- (void)warningOpenDatabase {
    /// 显示当前含有的数据库
    NSArray<NSString *> *args = [self dictExistsDatabaseList:self.basePath];
    
    /// WARNING-INFO
    [PaintingliteWarningHelper warningReason:@"Can't Open The Database" session:self.session time:[NSDate date] solve:@"Use [openSqlite: ] [openSqlite: completeHandler:] etc Create The Sqlite3 Database" args:args];
}

#pragma mark - 创建表
- (Boolean)execTableOptForSQL:(NSString *)sql{
    return [self execTableOptForSQL:sql completeHandler:nil];
}

- (Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [[PaintingliteDataBaseOptions sharePaintingliteDataBaseOptions] execTableOptForSQL:self.ppDb sql:sql completeHandler:completeHandler];
}

- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content{
    return [self createTableForName:tableName content:content completeHandler:nil];
}

- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    /* 首先判断数据库是否打开 */
    if (!self.isOpen) {
        [self warningOpenDatabase];
        
        return false;
    }
    
    return [[PaintingliteDataBaseOptions sharePaintingliteDataBaseOptions] createTableForName:self.ppDb tableName:tableName content:content completeHandler:completeHandler];
}

- (Boolean)createTableForObj:(id)obj primaryKeyStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)primaryKeyStyle{
    return [self createTableForObj:obj primaryKeyStyle:primaryKeyStyle completeHandler:nil];
}

- (Boolean)createTableForObj:(id)obj primaryKeyStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)primaryKeyStyle completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
        
    return [[PaintingliteDataBaseOptions sharePaintingliteDataBaseOptions] createTableForObj:self.ppDb obj:obj createStyle:primaryKeyStyle completeHandler:completeHandler];
}

#pragma mark - 更新表
- (BOOL)alterTableForName:(NSString *)oldName newName:(NSString *)newName{
    return [self alterTableForName:oldName newName:newName completeHandler:nil];
}

- (BOOL)alterTableForName:(NSString *)oldName newName:(NSString *)newName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    
    return [[PaintingliteDataBaseOptions sharePaintingliteDataBaseOptions] alterTableForName:self.ppDb oldName:oldName newName:newName completeHandler:completeHandler];
}

- (BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *)columnName columnType:(NSString *)columnType{
    return [self alterTableAddColumnWithTableName:tableName columnName:columnName columnType:columnType completeHandler:nil];
}

- (BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *)columnName columnType:(NSString *)columnType completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    
    return [[PaintingliteDataBaseOptions sharePaintingliteDataBaseOptions] alterTableAddColumn:self.ppDb tableName:tableName columnName:columnName columnType:columnType completeHandler:completeHandler];
}

- (BOOL)alterTableForObj:(id)obj{
    return [self alterTableForObj:obj completeHandler:nil];
}

- (BOOL)alterTableForObj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
        
    return [[PaintingliteDataBaseOptions sharePaintingliteDataBaseOptions] alterTableForObj:self.ppDb obj:obj completeHandler:completeHandler];
}

#pragma mark - 删除表
- (Boolean)dropTableForTableName:(NSString *)tableName{
    return [self dropTableForTableName:tableName completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)dropTableForTableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
    }
    
    return [[PaintingliteDataBaseOptions sharePaintingliteDataBaseOptions] dropTableForTableName:self.ppDb tableName:tableName completeHandler:completeHandler];
}

- (Boolean)dropTableForObj:(id)obj{
    return [self dropTableForObj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)dropTableForObj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    
    return [[PaintingliteDataBaseOptions sharePaintingliteDataBaseOptions] dropTableForObj:self.ppDb obj:obj completeHandler:completeHandler];
}

/* =====================================数据库日志操作======================================== */
#pragma mark - 日志文件操作
#pragma mark - 删除日志文件
- (void)removeLogFileWithDatabaseName:(NSString *)fileName{
    [[PaintingliteSessionFactory sharePaintingliteSessionFactory] removeLogFile:fileName];
}

#pragma mark - 读取日志文件
- (void)readLogFileWithDatabaseName:(NSString *)fileName{
    NSLog(@"%@",[[PaintingliteSessionFactory sharePaintingliteSessionFactory] readLogFile:fileName]);
}

- (void)readLogFileWithDatabaseName:(NSString *)fileName dateTime:(NSDate *)dateTime{
    NSLog(@"%@",[[[PaintingliteSessionFactory sharePaintingliteSessionFactory] readLogFile:fileName dateTime:dateTime] length] != 0 ? [[PaintingliteSessionFactory sharePaintingliteSessionFactory] readLogFile:fileName dateTime:dateTime] : @"无操作日志");
}

- (void)readLogFileWithDatabaseName:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus{
    NSLog(@"%@",[[[PaintingliteSessionFactory sharePaintingliteSessionFactory] readLogFile:fileName logStatus:logStatus] length] != 0 ? [[PaintingliteSessionFactory sharePaintingliteSessionFactory] readLogFile:fileName logStatus:logStatus] : @"无对应日志");
}

/* =====================================表的操作SQL======================================== */
#pragma mark - 系统查询方式
- (NSMutableArray<NSMutableDictionary<NSString *,NSString *> *> *)systemExec:(NSString *)sql{
    return [self.exec systemExec:self.ppDb sql:sql];
}

#pragma mark - 查询数据
- (NSMutableArray<NSDictionary *> *)execQuerySQL:(NSString *)sql{
    __block NSMutableArray *execQueryArray = [NSMutableArray array];
    [self execQuerySQL:sql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
            if (success) {
                execQueryArray = resArray;
            }
    }];
    
    return execQueryArray;
}

- (Boolean)execQuerySQL:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<NSDictionary *> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execQuerySQL:self.ppDb sql:sql completeHandler:completeHandler];
}

- (NSMutableArray<id> *)execQuerySQL:(NSString *)sql obj:(id)obj{
    __block NSMutableArray<id> *execQueryObj = [NSMutableArray array];
    
    [self execQuerySQL:sql obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> *  _Nonnull resObjList) {
        if (success) {
            execQueryObj = resObjList;
        }
    }];
    
    return execQueryObj;
}

- (Boolean)execQuerySQL:(NSString *)sql obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<NSDictionary *> * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execQuerySQL:self.ppDb sql:sql obj:obj completeHandler:completeHandler];
}

- (void)execQuerySQLPrepareStatementSql:(NSString *)prepareStatementSql{
    [[PaintingliteTableOptions sharePaintingliteTableOptions] execQuerySQLPrepareStatementSql:prepareStatementSql];
}

- (void)setPrepareStatementSqlParameter:(NSUInteger)index paramter:(NSString *)paramter{
    [[PaintingliteTableOptions sharePaintingliteTableOptions] setPrepareStatementSqlParameter:index paramter:paramter];
}

- (void)setPrepareStatementSqlParameter:(NSArray *)paramter{
    NSMutableArray *paramterMutableArray = [NSMutableArray arrayWithArray:paramter];
    [[PaintingliteTableOptions sharePaintingliteTableOptions] setPrepareStatementSqlParameter:paramterMutableArray];
}

- (NSMutableArray *)execPrepareStatementSql{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return [NSMutableArray array];
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execPrepareStatementSql:self.ppDb];
}

- (Boolean)execPrepareStatementSqlCompleteHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<NSDictionary *> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execPrepareStatementSql:self.ppDb completeHandler:completeHandler];
}

- (id)execPrepareStatementSqlWithObj:(id)obj{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return [NSObject new];
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execPrepareStatementSql:self.ppDb obj:obj];
}

- (Boolean)execPrepareStatementSqlWithObj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<NSDictionary *> * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execPrepareStatementSql:self.ppDb obj:obj completeHandler:completeHandler];
}

- (NSMutableArray<NSDictionary *> *)execQueryLikeSQLWithTableName:(NSString *)tableName field:(NSString *)field like:(NSString *)like{
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execLikeQuerySQL:self.ppDb tableName:tableName field:field like:like];
}

- (Boolean)execQueryLikeSQLWithTableName:(NSString *)tableName field:(NSString *)field like:(NSString *)like completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<NSDictionary *> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execLikeQuerySQL:self.ppDb tableName:tableName field:field like:like completeHandler:completeHandler];
}

- (NSMutableArray<id> *)execQueryLikeSQLWithField:(NSString *)field like:(NSString *)like obj:(id)obj{
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execLikeQuerySQL:self.ppDb field:field like:like obj:obj];
}

- (Boolean)execQueryLikeSQLWithField:(NSString *)field like:(NSString *)like obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<NSDictionary *> * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execLikeQuerySQL:self.ppDb field:field like:like obj:obj completeHandler:completeHandler];
}

- (NSMutableArray *)execQueryLimitSQLWithTableName:(NSString *)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end{
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execLimitQuerySQL:self.ppDb tableName:tableName limitStart:start limitEnd:end];
}

- (Boolean)execQueryLimitSQLWithTableName:(NSString *)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<NSDictionary *> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execLimitQuerySQL:self.ppDb tableName:tableName limitStart:start limitEnd:end completeHandler:completeHandler];
}

- (NSMutableArray<id> *)execQueryLimitSQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj{
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execLimitQuerySQL:self.ppDb limitStart:start limitEnd:end obj:obj];
}

- (Boolean)execQueryLimitSQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<NSDictionary *> * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execLimitQuerySQL:self.ppDb limitStart:start limitEnd:end obj:obj completeHandler:completeHandler];
}

- (NSMutableArray *)execQueryOrderBySQLWithTableName:(NSString *)tableName orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle{
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execOrderByQuerySQL:self.ppDb tableName:tableName orderbyContext:orderbyContext orderStyle:orderStyle];
}

- (Boolean)execQueryOrderBySQLWithTableName:(NSString *)tableName orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<NSDictionary *> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execOrderByQuerySQL:self.ppDb tableName:tableName orderbyContext:orderbyContext orderStyle:orderStyle completeHandler:completeHandler];
}

- (NSMutableArray<id> *)execQueryOrderBySQLWithOrderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj{
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execOrderByQuerySQL:self.ppDb orderbyContext:orderbyContext orderStyle:orderStyle obj:obj];
}

- (Boolean)execQueryOrderBySQLWithOrderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<NSDictionary *> * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execOrderByQuerySQL:self.ppDb orderbyContext:orderbyContext orderStyle:orderStyle obj:obj completeHandler:completeHandler];
}

/* =====================================表的操作PQL======================================== */
#pragma mark - PQL查询
- (NSArray<id> *)execPrepareStatementPQL{
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execPrepareStatementPQL:self.ppDb];
}

- (Boolean)execPrepareStatementPQLWithCompleteHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execPrepareStatementPQL:self.ppDb completeHandler:completeHandler];
}

- (void)execQueryPQLPrepareStatementPQL:(NSString *)prepareStatementPQL{
    [[PaintingliteTableOptions sharePaintingliteTableOptions] execQueryPQLPrepareStatementPQL:prepareStatementPQL];
}

- (void)setPrepareStatementPQLParameter:(NSUInteger)index paramter:(NSString *)paramter{
    [[PaintingliteTableOptions sharePaintingliteTableOptions] setPrepareStatementPQLParameter:index paramter:paramter];
}

- (void)setPrepareStatementPQLParameter:(NSArray *)paramter{
    NSMutableArray *tempParamterArray = [[NSMutableArray alloc] initWithArray:paramter];
    [[PaintingliteTableOptions sharePaintingliteTableOptions] setPrepareStatementPQLParameter:tempParamterArray];
}

- (NSMutableArray<id> *)execPQL:(NSString *)pql{
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execPQL:self.ppDb pql:pql];
}

- (Boolean)execPQL:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] execPQL:self.ppDb pql:pql completeHandler:completeHandler];
}

/* =====================================表的操作CUD======================================== */
#pragma mark - CUD
#pragma mark - 增加数据
- (Boolean)insert:(NSString *)sql{
    return [self insert:sql completeHandler:nil];
}

- (Boolean)insert:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    
    if (self.openSecurityMode) {
        sql = [[[PaintingliteSecurity alloc] init] securitySqlCommand:sql type:PaintingliteSecurityInsert];
    }
    
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] insert:self.ppDb sql:sql completeHandler:completeHandler];
}

- (Boolean)insertWithObj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }

    if (self.openSecurityMode) {
        obj = [[[PaintingliteSecurity alloc] init] securityObj:obj];
    }
    
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] insert:self.ppDb obj:obj completeHandler:completeHandler];
}

#pragma mark - 更新数据
- (Boolean)update:(NSString *)sql{
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] update:self.ppDb sql:sql];
}

- (Boolean)update:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (self.openSecurityMode) {
        sql = [[[PaintingliteSecurity alloc] init] securitySqlCommand:sql type:PaintingliteSecurityUpdate];
    }
    
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] update:self.ppDb sql:sql completeHandler:completeHandler];
}

- (Boolean)updateWithObj:(id)obj condition:(NSString * _Nonnull)condition completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    
    if (self.openSecurityMode) {
        obj = [[[PaintingliteSecurity alloc] init] securityObj:obj];
    }
    
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] update:self.ppDb obj:obj condition:condition completeHandler:completeHandler];
}

#pragma mark - 删除数据
- (Boolean)del:(NSString *)sql{
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] del:self.ppDb sql:sql];
}

- (Boolean)del:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    if (!self.isOpen) {
        [self warningOpenDatabase];
        return false;
    }
    return [[PaintingliteTableOptions sharePaintingliteTableOptions] del:self.ppDb sql:sql completeHandler:completeHandler];
}

#pragma mark - 表结构查询
- (NSMutableArray<NSDictionary *> *)tableInfoWithTableName:(NSString *)tableName{
    return [self.exec execQueryTableInfo:_ppDb tableName:tableName];
}

- (void)setOpenSecurityMode:(Boolean)openSecurityMode {
    [PaintingliteTableOptions sharePaintingliteTableOptions].openSecurityMode = openSecurityMode;
    _openSecurityMode = openSecurityMode;
}

@end
