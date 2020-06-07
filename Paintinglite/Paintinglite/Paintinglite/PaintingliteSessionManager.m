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
#import "PaintingliteSnapManager.h"

@interface PaintingliteSessionManager()
@property (nonatomic,readonly)PaintingliteSessionFactoryLite *ppDb; //数据库
@property (nonatomic,strong)PaintingliteSessionFactory *factory; //工厂类
@property (nonatomic,strong)PaintingliteSessionError *error; //错误
@property (nonatomic,strong)PaintingliteConfiguration *configuration; //配置文件
@property (nonatomic,strong)PaintingliteDataBaseOptions *dataBaseOptions; //数据库操作
@property (nonatomic,strong)PaintingliteTableOptions *tableOptions; //表操作
@property (nonatomic)Boolean closeFlag; //关闭标识符
@property (nonatomic,strong)PaintingliteSnapManager *snapManager; //快照管理者
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

- (PaintingliteTableOptions *)tableOptions{
    if (!_tableOptions) {
        _tableOptions = [PaintingliteTableOptions sharePaintingliteTableOptions];
    }
    
    return _tableOptions;
}

- (PaintingliteConfiguration *)configuration{
    if (!_configuration) {
        _configuration = [PaintingliteConfiguration sharePaintingliteConfiguration];
    }
    
    return _configuration;
}

- (PaintingliteSnapManager *)snapManager{
    if (!_snapManager) {
        _snapManager = [PaintingliteSnapManager sharePaintingliteSnapManager];
    }
    
    return _snapManager;
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
    
    //数据库名称名称
    NSString *filePath = [self.configuration configurationFileName:fileName];
    @synchronized (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if([fileManager fileExistsAtPath:filePath]){
            success = (sqlite3_open_v2([filePath UTF8String], &_ppDb, SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX, NULL) == SQLITE_OK);
        }else{
            success = (sqlite3_open([filePath UTF8String], &_ppDb) == SQLITE_OK);
        }
        
        if (completeHandler != nil) {
            completeHandler(filePath,self.error,success);
        }
    }
    
    //保存表快照到JSON文件 -- 当数据库中含有的表的时候保存到快照
    //查看打开的数据库，进行快照区保存
    [self.snapManager saveSnap:self.ppDb];
    
    return success;
}

#pragma mark - 获得数据库
- (sqlite3 *)getSqlite3{
    return self.ppDb;
}

#pragma mark - 获得数据库版本
- (NSString *)getSqlite3Version{
    return [@"Paintinglite use sqlite3 version:" stringByAppendingString:[NSString stringWithUTF8String:sqlite3_version]];
}

#pragma mark - SQL操作
#pragma mark - 创建表
- (Boolean)execTableOptForSQL:(NSString *)sql{
    return [self execTableOptForSQL:sql completeHandler:nil];
}

- (Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions execTableOptForSQL:self.ppDb sql:sql completeHandler:completeHandler];
}

- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content{
    return [self createTableForName:tableName content:content completeHandler:nil];
}

- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions createTableForName:self.ppDb tableName:tableName content:content completeHandler:completeHandler];
}

- (Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle{
    return [self createTableForObj:obj createStyle:createStyle completeHandler:nil];
}

- (Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions createTableForObj:self.ppDb obj:obj createStyle:createStyle completeHandler:completeHandler];
}

#pragma mark - 更新表
- (BOOL)alterTableForName:(NSString *)oldName newName:(NSString *)newName{
    return [self alterTableForName:oldName newName:newName completeHandler:nil];
}

- (BOOL)alterTableForName:(NSString *)oldName newName:(NSString *)newName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions alterTableForName:self.ppDb oldName:oldName newName:newName completeHandler:completeHandler];
}

- (BOOL)alterTableAddColumn:(NSString *)tableName columnName:(NSString *)columnName columnType:(NSString *)columnType{
    return [self alterTableAddColumn:tableName columnName:columnName columnType:columnType completeHandler:nil];
}

- (BOOL)alterTableAddColumn:(NSString *)tableName columnName:(NSString *)columnName columnType:(NSString *)columnType completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions alterTableAddColumn:self.ppDb tableName:tableName columnName:columnName columnType:columnType completeHandler:completeHandler];
}

- (BOOL)alterTableForObj:(id)obj{
    return [self alterTableForObj:obj completeHandler:nil];
}

- (BOOL)alterTableForObj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions alterTableForObj:self.ppDb obj:obj completeHandler:completeHandler];
}

#pragma mark - 删除表
- (Boolean)dropTableForTableName:(NSString *)tableName{
    return [self dropTableForTableName:tableName completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)dropTableForTableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions dropTableForTableName:self.ppDb tableName:tableName completeHandler:completeHandler];
}

- (Boolean)dropTableForObj:(id)obj{
    return [self dropTableForObj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        ;
    }];
}

- (Boolean)dropTableForObj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean))completeHandler{
    return [self.dataBaseOptions dropTableForObj:self.ppDb obj:obj completeHandler:completeHandler];
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

#pragma mark - 查询数据
- (NSMutableArray *)execQuerySQL:(NSString *)sql{
    __block NSMutableArray *execQueryArray = [NSMutableArray array];
    
    [self execQuerySQL:sql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        execQueryArray = resArray;
    }];
    
    return execQueryArray;
}

- (Boolean)execQuerySQL:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [self.tableOptions execQuerySQL:self.ppDb sql:sql completeHandler:completeHandler];
}

- (id)execQuerySQL:(NSString *)sql obj:(id)obj{
    __block id execQueryObj = NULL;
    
    [self execQuerySQL:sql obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> *  _Nonnull resObjList) {
        if (success) {
            execQueryObj = resObjList;
        }
    }];
    
    return execQueryObj;
}

- (Boolean)execQuerySQL:(NSString *)sql obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
        return [self.tableOptions execQuerySQL:self.ppDb sql:sql obj:obj completeHandler:completeHandler];
}

- (void)execQuerySQLPrepareStatementSql:(NSString *)prepareStatementSql{
    [self.tableOptions execQuerySQLPrepareStatementSql:prepareStatementSql];
}

- (void)setPrepareStatementSqlParameter:(NSUInteger)index paramter:(NSString *)paramter{
    [self.tableOptions setPrepareStatementSqlParameter:index paramter:paramter];
}

- (void)setPrepareStatementSqlParameter:(NSArray *)paramter{
    NSMutableArray *paramterMutableArray = [NSMutableArray arrayWithArray:paramter];
    [self.tableOptions setPrepareStatementSqlParameter:paramterMutableArray];
}

- (NSMutableArray *)execPrepareStatementSql{
    return [self.tableOptions execPrepareStatementSql:self.ppDb];
}

- (Boolean)execPrepareStatementSqlCompleteHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [self.tableOptions execPrepareStatementSql:self.ppDb completeHandler:completeHandler];
}

- (id)execPrepareStatementSqlWithObj:(id)obj{
    return [self.tableOptions execPrepareStatementSql:self.ppDb obj:obj];
}

- (Boolean)execPrepareStatementSqlWithObj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.tableOptions execPrepareStatementSql:self.ppDb obj:obj completeHandler:completeHandler];
}

- (NSMutableArray *)execLikeQuerySQLWithTableName:(NSString *)tableName field:(NSString *)field like:(NSString *)like{
    return [self.tableOptions execLikeQuerySQL:self.ppDb tableName:tableName field:field like:like];
}

- (Boolean)execLikeQuerySQLWithTableName:(NSString *)tableName field:(NSString *)field like:(NSString *)like completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [self.tableOptions execLikeQuerySQL:self.ppDb tableName:tableName field:field like:like completeHandler:completeHandler];
}

- (id)execLikeQuerySQLWithField:(NSString *)field like:(NSString *)like obj:(id)obj{
    return [self.tableOptions execLikeQuerySQL:self.ppDb field:field like:like obj:obj];
}

- (Boolean)execLikeQuerySQLWithField:(NSString *)field like:(NSString *)like obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.tableOptions execLikeQuerySQL:self.ppDb field:field like:like obj:obj completeHandler:completeHandler];
}

- (NSMutableArray *)execLimitQuerySQLWithTableName:(NSString *)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end{
    return [self.tableOptions execLimitQuerySQL:self.ppDb tableName:tableName limitStart:start limitEnd:end];
}

- (Boolean)execLimitQuerySQLWithTableName:(NSString *)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [self.tableOptions execLimitQuerySQL:self.ppDb tableName:tableName limitStart:start limitEnd:end completeHandler:completeHandler];
}

- (id)execLimitQuerySQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj{
    return [self.tableOptions execLimitQuerySQL:self.ppDb limitStart:start limitEnd:end obj:obj];
}

- (Boolean)execLimitQuerySQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.tableOptions execLimitQuerySQL:self.ppDb limitStart:start limitEnd:end obj:obj completeHandler:completeHandler];
}

- (NSMutableArray *)execOrderByQuerySQLWithTableName:(NSString *)tableName orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle{
    return [self.tableOptions execOrderByQuerySQL:self.ppDb tableName:tableName orderbyContext:orderbyContext orderStyle:orderStyle];
}

- (Boolean)execOrderByQuerySQLWithTableName:(NSString *)tableName orderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    return [self.tableOptions execOrderByQuerySQL:self.ppDb tableName:tableName orderbyContext:orderbyContext orderStyle:orderStyle completeHandler:completeHandler];
}

- (id)execOrderByQuerySQLWithOrderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj{
    return [self.tableOptions execOrderByQuerySQL:self.ppDb orderbyContext:orderbyContext orderStyle:orderStyle obj:obj];
}

- (Boolean)execOrderByQuerySQLWithOrderbyContext:(NSString *)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.tableOptions execOrderByQuerySQL:self.ppDb orderbyContext:orderbyContext orderStyle:orderStyle obj:obj completeHandler:completeHandler];
}

#pragma mark - PQL查询
- (id)execPrepareStatementPQL{
    return [self.tableOptions execPrepareStatementPQL:self.ppDb];
}

- (Boolean)execPrepareStatementPQLWithCompleteHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.tableOptions execPrepareStatementPQL:self.ppDb completeHandler:completeHandler];
}

- (void)execQueryPQLPrepareStatementPQL:(NSString *)prepareStatementPQL{
    [self.tableOptions execQueryPQLPrepareStatementPQL:prepareStatementPQL];
}

- (void)setPrepareStatementPQLParameter:(NSUInteger)index paramter:(NSString *)paramter{
    [self.tableOptions setPrepareStatementPQLParameter:index paramter:paramter];
}

- (void)setPrepareStatementPQLParameter:(NSArray *)paramter{
    NSMutableArray *tempParamterArray = [[NSMutableArray alloc] initWithArray:paramter];
    [self.tableOptions setPrepareStatementPQLParameter:tempParamterArray];
}

- (id)execPQL:(NSString *)pql{
    return [self.tableOptions execPQL:self.ppDb pql:pql];
}

- (Boolean)execPQL:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.tableOptions execPQL:self.ppDb pql:pql completeHandler:completeHandler];
}

#pragma mark - CUD
#pragma mark - 增加数据
- (Boolean)insert:(NSString *)sql{
    return [self insert:sql completeHandler:nil];
}

- (Boolean)insert:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.tableOptions insert:self.ppDb sql:sql completeHandler:completeHandler];
}

- (Boolean)insertWithObj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.tableOptions insert:self.ppDb obj:obj completeHandler:completeHandler];
}

#pragma mark - 更新数据
- (Boolean)update:(NSString *)sql{
    return [self.tableOptions update:self.ppDb sql:sql];
}

- (Boolean)update:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.tableOptions update:self.ppDb sql:sql completeHandler:completeHandler];
}

- (Boolean)updateWithObj:(id)obj condition:(NSString * _Nonnull)condition completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.tableOptions update:self.ppDb obj:obj condition:condition completeHandler:completeHandler];
}

#pragma mark - 删除数据
- (Boolean)del:(NSString *)sql{
    return [self.tableOptions del:self.ppDb sql:sql];
}

- (Boolean)del:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self.tableOptions del:self.ppDb sql:sql completeHandler:completeHandler];
}

@end
