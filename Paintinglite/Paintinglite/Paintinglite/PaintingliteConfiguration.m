//
//  PaintingliteConfiguration.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteConfiguration.h"


#define SYNCHRONOUSMODE(MODE) [NSString stringWithFormat:@"PRAGMA synchronous = %@;",MODE]
#define DATABASEENCODING(ENCODING) [NSString stringWithFormat:@"PRAGMA encoding = \"%@\";",ENCODING]
#define AutoVacuum(MODE) [NSString stringWithFormat:@"PRAGMA auto_vacuum = %@;",MODE]

@interface PaintingliteConfiguration()
@property (nonatomic)sqlite3_stmt *stmt;
@end

@implementation PaintingliteConfiguration

#pragma mark - 单例模式
static PaintingliteConfiguration *_instance = nil;
+ (instancetype)sharePaintingliteConfiguration{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 修改Synchronous模式
+ (Boolean)setSynchronous:(sqlite3 *)ppDb mode:(PaintingliteSynchronousMode)mode{
    NSString *synchronousSQL = [NSString string];
    switch (mode) {
        case 0:
            synchronousSQL = SYNCHRONOUSMODE(@"OFF");
            break;
        case 1:
            synchronousSQL = SYNCHRONOUSMODE(@"NORMAL");
            break;
        case 2:
            synchronousSQL = SYNCHRONOUSMODE(@"FULL");
            break;
        default:
            synchronousSQL = SYNCHRONOUSMODE(@"FULL");
            break;
    }
    
    return sqlite3_exec(ppDb, [synchronousSQL UTF8String], 0, 0, NULL) == SQLITE_OK;
}

#pragma mark - 查看Synchronous状态
+ (NSString *)getSynchronous:(sqlite3 *)ppDb{
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(ppDb, [@"PRAGMA synchronous" UTF8String], -1, &stmt, nil) == SQLITE_OK){
        //查询成功
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获得数据库中含有的表名
            int synchronous = (int)sqlite3_column_int(stmt, 0);
            switch (synchronous) {
                case 0:
                    return @"OFF";
                case 1:
                    return @"NORMAL";
                case 2:
                    return @"FULL";
            }
        }
    }
    
    return @"FULL";
}

#pragma mark - 配置数据库编码格式
+ (Boolean)setEncoding:(sqlite3 *)ppDb encoding:(PaintingliteEncoding)encoding{
    NSString *encode = [NSString string];
    
    switch (encoding) {
        case 0:
            encode = @"UTF-8";
            break;
        case 1:
            encode = @"UTF-16";
            break;
        case 2:
            encode = @"UTF-16le";
            break;
        case 3:
            encode = @"UTF-16be";
            break;
        default:
            encode = @"UTF-8";
            break;
    }

    return sqlite3_exec(ppDb, [DATABASEENCODING(encode) UTF8String], 0, 0, NULL) == SQLITE_OK;
}

#pragma mark - 查看数据库编码格式
+ (NSString *)getEncoding:(sqlite3 *)ppDb{
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(ppDb, [@"PRAGMA synchronous" UTF8String], -1, &stmt, nil) == SQLITE_OK){
        //查询成功
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获得数据库中含有的表名
            char *encoding = (char *)sqlite3_column_text(stmt, 0);
            return [NSString stringWithCString:encoding encoding:NSUTF8StringEncoding];
        }
    }
    
    return @"UTF-8";
}

#pragma mark - 修改数据库Auto_Vacuum模式
+ (Boolean)setAutoVacuum:(sqlite3 *)ppDb mode:(PaintingliteAutoVacuumMode)mode{
    NSString *AutoVacuum = [NSString string];
    switch (mode) {
        case 0:
            AutoVacuum = @"NONE";
            break;
        case 1:
            AutoVacuum = @"FULL";
            break;
        case 2:
            AutoVacuum = @"INCREMENTAL";
            break;
        default:
            AutoVacuum = @"NONE";
            break;
    }
    
    return sqlite3_exec(ppDb, [AutoVacuum(AutoVacuum) UTF8String], 0, 0, NULL) == SQLITE_OK;
}

#pragma mark - 查看数据库Auto_Vacuum模式
+ (NSString *)getAutoVacuum:(sqlite3 *)ppDb{
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(ppDb, [@"PRAGMA auto_vacuum" UTF8String], -1, &stmt, nil) == SQLITE_OK){
        //查询成功
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获得数据库中含有的表名
            char *AutoVacuum = (char *)sqlite3_column_text(stmt, 0);
            return [NSString stringWithCString:AutoVacuum encoding:NSUTF8StringEncoding];
        }
    }
    
    return @"NONE";
}


#pragma mark - 配置数据库名称
- (NSString *)configurationFileName:(NSString *)fileName{
    //传入fileName只有文件名称没有路径时候，自动拼接路径
    //传入fileName如果是绝对路径，直接返回，不做处理
    
    if (![fileName containsString:@"."]) {
        fileName = [fileName stringByAppendingString:@".db"];
    }else{
        //判断.后边是不是sqlite3后缀，不是则替换成db
        fileName = [[fileName componentsSeparatedByString:@"."][1] isEqualToString:@"db"] ? fileName : [[fileName componentsSeparatedByString:@"."][0] stringByAppendingString:@".db"]  ;
    }
   
    if (!fileName.isAbsolutePath) {
        //当前路径下生成fileName
        fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:fileName];
    }

    self.fileName = fileName;
    return fileName;
}

@end
