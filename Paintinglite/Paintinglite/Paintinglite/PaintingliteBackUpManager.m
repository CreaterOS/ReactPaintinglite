//
//  PaintingliteBackUpManager.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/6.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteBackUpManager.h"
#import "PaintingliteExec.h"

#define Paintinglite_MAX_TEXT @"1012"

@interface PaintingliteBackUpManager()
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@property (nonatomic,strong)NSString *saveFilePath; //保存文件路径
@property (nonatomic,strong)NSFileManager *fileManager; //文件管理者
@property (nonatomic,weak)NSString *tableName; //表名
@property (nonatomic,strong)NSMutableArray *tableInfoArray; //表结构字典数组
@end

@implementation PaintingliteBackUpManager

#pragma mark - 懒加载
- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

- (NSString *)saveFilePath{
    if (!_saveFilePath) {
        _saveFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
    
    return _saveFilePath;
}

- (NSFileManager *)fileManager{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    
    return _fileManager;
}

#pragma mark - 单例模式
static PaintingliteBackUpManager *_instance = nil;
+ (instancetype)sharePaintingliteBackUpManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 备份数据库
- (Boolean)backupDataBaseWithName:(sqlite3 *)ppDb sqliteName:(NSString *)sqliteName type:(PaintingliteBackUpManagerDBType)type completeHandler:(void (^)(NSString * _Nonnull))completeHandler{
    Boolean success = false;
    
    //创建数据库文件完成
    if([self writeCreateDataBaseWithName:sqliteName type:type fileExists:[self isFileExists:sqliteName]]){
        if ([self backupCreateTable:ppDb type:(PaintingliteBackUpManagerDBType)type]) {
            //写入数据插入数据文件
            NSMutableArray *tableNameArray = [self.exec execQueryTable:ppDb];
            
            for (NSString *tableName in tableNameArray) {
                NSString *contentStr = [NSString stringWithFormat:@"INSERT INTO %@(",tableName];
                _tableName = tableName;
                
                NSMutableArray *tableInfoArray = [self.exec execQueryTableInfo:ppDb tableName:tableName];
                //查询表中所有的数据
                NSMutableArray *queryArray = [self.exec sqlite3ExecQuery:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",tableName]];
                
                NSMutableArray<NSString *> *fieldArray = [NSMutableArray array];
                
                for (NSUInteger i = 0; i < tableInfoArray.count; i++) {
                    NSDictionary *dict = tableInfoArray[i];
                    
                    NSString *name = dict[TABLEINFO_NAME];
                    [fieldArray addObject:name];
                    
                    contentStr = (i == tableInfoArray.count - 1) ? [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@) VALUES (",name]] : [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@,",name]];
                }

                Boolean flag = false;
                for (NSUInteger i = 0; i < queryArray.count; i++) {
                    flag = true;
                    NSDictionary *dict = queryArray[i];
      
                    NSUInteger count = 0;
                    for (NSString *str in fieldArray) {
                        id tableContent = dict[str];
                        tableContent =  [tableContent isEqual: @""] ? [NSString stringWithFormat:@"%@",@"''"] : tableContent;
                        
                        contentStr = (count == fieldArray.count - 1) ? [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@),(",tableContent]] : [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@,",tableContent]];
                    
                        count++;
                    }
                }
                
                contentStr = [contentStr substringWithRange:NSMakeRange(0, contentStr.length - 2)];
                
                //写入保存插入文件
                if (flag) {
                       [self writeContent:contentStr saveFilePath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"INSERT_TABLEINFO_%@_SQL.sql",[_tableName uppercaseString]]]];
                }
            }
        }
    }
    
    return success;
}

#pragma mark - 创建表备份文件
- (Boolean)backupCreateTable:(sqlite3 *)ppDb type:(PaintingliteBackUpManagerDBType)type{
    Boolean success = false;
    //获得每个表的名称和表的字段
    //分别写入不同的sql文件，文件命名通过表名完成
    NSMutableArray *tableNameArray = [self.exec execQueryTable:ppDb];
    
    //根据表名进行查询
    for (NSString *tableName in tableNameArray) {
        _tableName = tableName;
        
        NSMutableArray *tableInfoArray = [self.exec execQueryTableInfo:ppDb tableName:tableName];
        
        //保存表结构字典数组
        self.tableInfoArray = tableInfoArray;
        
        //根据字典数据进行创建表语句书写
        //CREATE TABLE IF NOT EXISTS user (name TEXT not null primary key,age INTEGER)
        NSString *contentStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName] ;
        
        for (NSUInteger i = 0; i < tableInfoArray.count; i++) {
            NSDictionary *dict = tableInfoArray[i];
            //取出每一个字段名称和类型
            NSString *name = dict[TABLEINFO_NAME];
            NSString *typeContent = dict[TABLEINFO_TYPE];
            
            if (type == PaintingliteBackUpMySql || type == PaintingliteBackUpSqlServer || type == PaintingliteBackUpORCALE) {
                //处理类型字段
                if ([typeContent isEqualToString:@"INTEGER"]) {
                    typeContent = @"INT";
                }else if ([typeContent isEqualToString:@"TEXT"]){
                    typeContent = [NSString stringWithFormat:@"VARCHAR(%@)",Paintinglite_MAX_TEXT];
                }
            }
            
            //取出每一个字段的notnull和默认值
            NSString *notnull = dict[TABLEINFO_NOTNULL];
            NSString *dflt_value = dict[TABLEINFO_DEFAULT_VALUE];
            //取出每一个字段的主键值
            NSString *pk = dict[TABLEINFO_PK];
            
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@ %@",name,typeContent]];
            
            if (![notnull isEqualToString:@"0"]) {
                //不允许空
                contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@" NOT NULL"]];
            }
            
            if (![pk isEqualToString:@"0"]) {
                //主键
                contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@" PRIMARY KEY"]];
            }
            
            if(![dflt_value isEqualToString:@"(null)"]){
                //有默认值
                contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@" DEFAULT(%@)",dflt_value]];
            }
            
            contentStr = (i == tableInfoArray.count - 1) ? [contentStr stringByAppendingString:@""] : [contentStr stringByAppendingString:@","];
            
        }
        
        contentStr = [contentStr stringByAppendingString:@")"];
        
        //写入文件
        success = [self writeContent:contentStr saveFilePath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"CREATE_TABLE_%@_SQL.sql",[_tableName uppercaseString]]]];
    }
    
    return success;
}

#pragma mark - 判断文件存在
- (Boolean)isFileExists:(NSString *__nonnull)sqliteName{
    //根据文件名判断文件是否存在
    //数据库路径
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: [sqliteName containsString:@".db"] ? sqliteName : [sqliteName stringByAppendingString:@".db"]];

    if ([self.fileManager fileExistsAtPath:filePath]) {
        //文件存在
        return true;
    }else{
        //文件不存在
        NSLog(@"未找到数据库文件...");
        return false;
    }
}

#pragma mark - 写创建数据库文件
- (Boolean)writeCreateDataBaseWithName:(NSString *__nonnull)sqliteName type:(PaintingliteBackUpManagerDBType)type fileExists:(Boolean)fileExists{
    //文件存在
    //先写创建数据库的文件
    if ([sqliteName containsString:@".db"]) {
        sqliteName = [sqliteName componentsSeparatedByString:@"."][0];
    }
    
    if (type != PaintingliteBackUpORCALE) {
        NSString *savePath = [self.saveFilePath stringByAppendingPathComponent:@"CREATE_DATABASE.sql"];
        if([self.fileManager fileExistsAtPath:savePath]){
            //存在删除
            NSError *error = nil;
            [self.fileManager removeItemAtPath:savePath error:&error];
        }
        
        NSString *createSQLContentStr = [@"CREATE DATABASE IF NOT EXISTS " stringByAppendingString:sqliteName];
        return [self writeContent:createSQLContentStr saveFilePath:savePath];
    }
    
    return false;
}

#pragma mark - 写数据内容
- (Boolean)writeContent:(NSString *__nonnull)sqlContent saveFilePath:(NSString *__nonnull)saveFilePath{
    
    if ([self.fileManager fileExistsAtPath:saveFilePath]) {
        NSError *error = nil;
        [self.fileManager removeItemAtPath:saveFilePath error:&error];
    }
    
    return [[sqlContent dataUsingEncoding:NSUTF8StringEncoding] writeToFile:saveFilePath atomically:YES];
}


@end
