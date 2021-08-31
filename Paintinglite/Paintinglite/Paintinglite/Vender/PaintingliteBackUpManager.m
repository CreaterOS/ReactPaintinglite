//
//  PaintingliteBackUpManager.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/6.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteBackUpManager.h"
#import "PaintingliteSessionManager.h"
#import "PaintingliteFileManager.h"
#import "PaintingliteExec.h"
#import "PaintingliteThreadManager.h"

#define Paintinglite_MAX_TEXT @"1012"
#define ROOTPATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@interface PaintingliteBackUpManager()
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@property (nonatomic,strong)NSString *saveFilePath; //保存文件路径
@end

@implementation PaintingliteBackUpManager

#pragma mark - 懒加载
- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
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
- (Boolean)backupDataBaseWithName:(sqlite3 *)ppDb sqliteName:(NSString *)sqliteName type:(kBackUpType)type completeHandler:(void (^)(NSString * _Nonnull))completeHandler{
    Boolean success = false;
    
    //创建数据库文件完成
    if([self writeCreateDataBaseWithName:sqliteName type:type fileExists:[self isFileExists:sqliteName]]){
        if ([self backupCreateTable:ppDb type:(kBackUpType)type]) {
                //写入数据插入数据文件
            success = true;
            }
        }
    
    return success;
}

#pragma mark -  备份表数据
- (Boolean)backupTableRowWithTableName:(NSMutableArray<NSString *> *__nonnull)tableNameArray ppDb:(sqlite3 *)ppDb{
    Boolean success = false;
    
    for (NSString *tableName in tableNameArray) {
        NSString *contentStr = [NSString stringWithFormat:@"INSERT INTO %@",tableName];
        NSMutableArray<NSString *> *fieldArray = [NSMutableArray array];
        contentStr = [self execTableInfo:ppDb tableName:tableName contentStr:contentStr fieldArray:fieldArray];
        success = [self execTableRowValue:ppDb tableName:tableName contentStr:contentStr fieldArray:fieldArray];
    }
    
    return success;
}

#pragma mark - 查找表字段
- (NSString *__nonnull)execTableInfo:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName contentStr:(NSString *__nonnull)contentStr fieldArray:(NSMutableArray<NSString *> *)fieldArray{
    /* 添加表字段 */
    __block NSMutableArray *tableInfoArray = [self.exec execQueryTableInfo:ppDb tableName:tableName];
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    runAsynchronouslyOnExecQueue(^{
        for (NSUInteger i = 0; i < tableInfoArray.count; i++) {
            [fieldArray addObject:tableInfoArray[i][TABLEINFO_NAME]];
        }
        dispatch_semaphore_signal(signal);
    });

    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    return [contentStr stringByAppendingString:[NSString stringWithFormat:@"(%@) VALUES ",[fieldArray componentsJoinedByString:@","]]];
}

#pragma mark - 查找表中数据
- (Boolean)execTableRowValue:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName contentStr:(NSString *__nonnull)contentStr fieldArray:(NSMutableArray<NSString *> *)fieldArray{
    __block Boolean success = false;
    //查询表中所有的数据
    __block NSMutableArray<NSDictionary *> *queryArray = [self.exec sqlite3ExecQuery:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",tableName]];
    
    __block NSMutableArray<NSString *> *tableRowStrArray = [NSMutableArray array];
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    runAsynchronouslyOnExecQueue(^{
        NSUInteger totalCount = queryArray.count;
        for (NSUInteger i = 0; i < totalCount; i++) {
            @autoreleasepool {
                NSArray<NSString *> *tableRowArray = [queryArray[i] objectsForKeys:fieldArray notFoundMarker:[NSNull class]];
                NSString *tableRowStr = [tableRowArray componentsJoinedByString:@","];
                [tableRowStrArray addObject:[NSString stringWithFormat:@"(%@)",tableRowStr]];
            }
        }
        
        /* 写入文件 */
        /* 数据量过大 -- 不能一次写入 -- 分批写入 */
        /* 数组划分为500个为一个数组 */
        [self appendContent:@""];
        [self appendContent:contentStr];
        
        NSUInteger tableRowStrArrayTotal = tableRowStrArray.count;
        //分成组数
        NSUInteger tableRowArrayGroup = tableRowStrArrayTotal / 2500;
        //剩余个数
        NSUInteger lastCount = tableRowStrArrayTotal % 2500;
        
        //分批写入
        for (NSUInteger i = 0; i < tableRowArrayGroup; ++i) {
            NSArray<NSString *> *subArray = [tableRowStrArray subarrayWithRange:NSMakeRange(i * 2500, 2500)];
            
            NSString *subStr = [subArray componentsJoinedByString:@","];
            if (i != 0) {
                //前置一个,符号
                subStr = [@"," stringByAppendingString:subStr];
            }
            
            [self appendContent:subStr];
        }
        
        
        if (lastCount != 0) {
            /* 还有剩余 */
            NSArray<NSString *> *subArray = [tableRowStrArray subarrayWithRange:NSMakeRange(tableRowArrayGroup * 2500, lastCount)];
            NSString *subStr = [subArray componentsJoinedByString:@","];
            [self appendContent:subStr];
        }
        
        success = true;
        
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    return success;
}

#pragma mark - 创建表备份文件
- (Boolean)backupCreateTable:(sqlite3 *)ppDb type:(kBackUpType)type{
    __block Boolean success = false;
    //获得每个表的名称和表的字段
    //分别写入不同的sql文件，文件命名通过表名完成
    __block NSMutableArray *tableNameArray = (NSMutableArray *)[self.exec getCurrentTableNameWithCache];
    
    //根据表名进行查询
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    runAsynchronouslyOnExecQueue(^{
        for (NSString *tableName in tableNameArray) {
            @autoreleasepool {
                //保存表结构字典数组
                NSMutableArray *tableInfoArray = [self.exec execQueryTableInfo:ppDb tableName:tableName];
                //根据字典数据进行创建表语句书写
                //CREATE TABLE IF NOT EXISTS user (name TEXT not null primary key,age INTEGER)
                NSString *contentStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName] ;
                
                for (NSUInteger i = 0; i < tableInfoArray.count; i++) {
                    @autoreleasepool {
                        NSDictionary *dict = tableInfoArray[i];
                        //取出每一个字段名称和类型
                        NSString *name = dict[TABLEINFO_NAME];
                        NSString *typeContent = dict[TABLEINFO_TYPE];
                        
                        if (type == kTypeMySql || type == kTypeSqlServer || type == kTypeORCALE) {
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
                        
                        contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"`%@` %@",name,typeContent]];
                        
                        if (![notnull isEqualToString:@"0"]) {
                            //不允许空
                            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@" NOT NULL"]];
                        }else if(![pk isEqualToString:@"0"]) {
                            //主键
                            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@" PRIMARY KEY"]];
                        }else if(![dflt_value isEqualToString:@"(null)"]){
                            //有默认值
                            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@" DEFAULT(%@)",dflt_value]];
                        }
                        
                        contentStr = (i == tableInfoArray.count - 1) ? [contentStr stringByAppendingString:@""] : [contentStr stringByAppendingString:@","];
                    }
                }
                
                contentStr = [contentStr stringByAppendingString:@")"];
                
                //写入文件
                success = [self appendContent:contentStr];
            }
        }
        
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    return success;
}

#pragma mark - 判断文件存在
- (Boolean)isFileExists:(NSString *__nonnull)sqliteName{
    //根据文件名判断文件是否存在
    //数据库路径
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent: [sqliteName containsString:@".db"] ? sqliteName : [sqliteName stringByAppendingString:@".db"]];

    if ([[PaintingliteFileManager defaultManager]  fileExistsAtPath:filePath]) {
        //文件存在
        return true;
    }else{
        //文件不存在
        NSLog(@"未找到数据库文件...");
        return false;
    }
}

#pragma mark - 写创建数据库文件
- (Boolean)writeCreateDataBaseWithName:(NSString *__nonnull)sqliteName type:(kBackUpType)type fileExists:(Boolean)fileExists{
    //文件存在
    //先写创建数据库的文件
    __block Boolean success = false;
    
    if ([sqliteName containsString:@".db"]) {
        sqliteName = [sqliteName componentsSeparatedByString:@"."][0];
    }
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    runAsynchronouslyOnExecQueue(^{
        if (type != kTypeORCALE) {
            NSString *savePath = [ROOTPATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_BACKUP.sql",[sqliteName uppercaseString]]];
            
            NSString *createSQLContentStr = [@"CREATE DATABASE IF NOT EXISTS " stringByAppendingString:sqliteName];
            success = [self writeContent:createSQLContentStr saveFilePath:savePath];
        }
        
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    return success;
}

#pragma mark - 写数据内容
- (Boolean)writeContent:(NSString *__nonnull)sqlContent saveFilePath:(NSString *__nonnull)saveFilePath{
    
    /* 存在则删除 */
    if ([[PaintingliteFileManager defaultManager]  fileExistsAtPath:saveFilePath]) {
        NSError *error = nil;
        [[PaintingliteFileManager defaultManager]  removeItemAtPath:saveFilePath error:&error];
    }
    
    /* 保存文件路径 */
    self.saveFilePath = saveFilePath;
    
    return [[[sqlContent stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding] writeToFile:saveFilePath atomically:YES];
}

#pragma mark - 追加文件内容
- (Boolean)appendContent:(NSString *__nonnull)sqlContent{
    if (self.saveFilePath.length != 0) {
        /* 说明有文件了 */
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.saveFilePath];
        [fileHandle seekToEndOfFile];

        //sqlContent追加换行
        [fileHandle writeData:[[sqlContent stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [fileHandle closeFile];
        
        return true;
    }
    
    return false;
}

#pragma mark - 回退一次表数据
- (Boolean)backupTableValueForBeforeOpt:(sqlite3 *)ppDb tableName:(NSString *)tableName completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<NSDictionary *> * _Nonnull))completeHandler{
    Boolean success = false;
    
    //读取保存的上一次版本的数据文件
    NSMutableArray *oldValueArray = [[NSMutableArray alloc] initWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_VALUE.json",tableName]]];
    NSString *oldValueArrayStr = [NSString stringWithFormat:@"%@",oldValueArray];
    oldValueArrayStr = [[[[[[oldValueArrayStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@";" withString:@","]  stringByReplacingOccurrencesOfString:@"{" withString:@"("] stringByReplacingOccurrencesOfString:@"}" withString:@")"] stringByReplacingOccurrencesOfString:@",)" withString:@")"];
    
    oldValueArrayStr = [[[oldValueArrayStr stringByReplacingOccurrencesOfString:@"=" withString:@"='"] stringByReplacingOccurrencesOfString:@"," withString:@"',"]stringByReplacingOccurrencesOfString:@")'," withString:@"),"];
    oldValueArrayStr = [oldValueArrayStr stringByReplacingOccurrencesOfString:@")" withString:@"')"];
    oldValueArrayStr = [oldValueArrayStr substringWithRange:NSMakeRange(1, oldValueArrayStr.length - 3)];
    
    NSLog(@"%@",oldValueArrayStr);
    
    //获得原来表的字段
    NSMutableDictionary *dict = [oldValueArray firstObject];
    NSString *tableFieldsArrayStr = [NSString stringWithFormat:@"%@",dict.allKeys];
    tableFieldsArrayStr = [[tableFieldsArrayStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    for (NSString *str in dict.allKeys) {
        if ([oldValueArrayStr containsString:str]) {
            oldValueArrayStr = [oldValueArrayStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@=",str] withString:@""];
        }
    }
    
    //删除表数据然后写入数据
    if ([[PaintingliteSessionManager sharePaintingliteSessionManager] del:[NSString stringWithFormat:@"DELETE FROM %@",tableName]]){
        //重写写入数据
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@%@ VALUES %@",tableName,tableFieldsArrayStr,oldValueArrayStr];

        success = [[PaintingliteSessionManager sharePaintingliteSessionManager] insert:insertSQL completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
            if (success) {
                if (completeHandler != nil) {
                    NSMutableArray<NSDictionary *> *newList = [[PaintingliteSessionManager sharePaintingliteSessionManager] execQuerySQL:[NSString stringWithFormat:@"SELECT * FROM %@",tableName]];
                    completeHandler(error,success,newList);
                }
            }
        }];
    }
    return success;
}

@end
