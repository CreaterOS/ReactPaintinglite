//
//  PaintingliteExec.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/28.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteExec.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteDataBaseOptions.h"
#import "PaintingliteSecurity.h"
#import "PaintingliteLog.h"
#import "PaintingliteException.h"
#import <objc/runtime.h>

@interface PaintingliteExec()
@property (nonatomic,strong)PaintingliteSessionFactory *factory; //工厂
@property (nonatomic,strong)PaintingliteLog *log; //日志
@property (nonatomic)sqlite3_stmt *stmt;
@end

@implementation PaintingliteExec

#pragma mark - 懒加载
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

#pragma mark - 执行SQL语句
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb sql:(NSString *)sql{
    NSAssert(sql != NULL, @"SQL Not IS Empty");
    
    
    Boolean flag = false;
    
    @synchronized (self) {
        flag = sqlite3_exec(ppDb, [sql UTF8String], 0, 0, 0) == SQLITE_OK;
        if (flag) {
            //保存快照
            NSString *masterSQL = @"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name";
            [self.factory execQuery:ppDb sql:masterSQL status:PaintingliteSessionFactoryTableJSON];
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
    
    //打印SQL语句
    NSLog(@"%@",sql);
    
    return flag;
}

/* 查询数据库 */
- (NSMutableArray *)sqlite3ExecQuery:(sqlite3 *)ppDb sql:(NSString *)sql{
    NSMutableArray<NSDictionary *> *tables = [NSMutableArray array];
    //将结果返回,保存为字典
    
    NSMutableArray *resArray = [self getObjName:sql ppDb:ppDb];
    
    @synchronized (self) {
        if (sqlite3_prepare_v2(ppDb, [sql UTF8String], -1, &_stmt, nil) == SQLITE_OK){
            //查询成功
            while (sqlite3_step(_stmt) == SQLITE_ROW) {
                NSMutableDictionary<id,id> *queryDict = [NSMutableDictionary dictionary];
                //resArray是一个含有表字段的数据，根据resArray获得值加入
                for (unsigned int i = 0; i < resArray.count; i++) {
                    //取出来的值，然后判断类型，进行类型分类
                    /**
                     SQLITE_INTEGER  1
                     SQLITE_FLOAT    2
                     SQLITE3_TEXT    3
                     SQLITE_BLOB     4
                     SQLITE_NULL     5
                     */
                    id value = nil;
                    value = [self caseTheType:sqlite3_column_type(_stmt, i) index:i value:value];
                    [queryDict setValue:value forKey:resArray[i]];
                }
                [tables addObject:queryDict];
            }
        }else{
            //写入日志文件
            [self.log writeLogFileOptions:sql status:PaintingliteLogError completeHandler:^(NSString * _Nonnull logFilePath) {
                ;
            }];
        }
    }
    
    if (tables.count != 0) {
        //写入日志文件
        [self.log writeLogFileOptions:sql status:PaintingliteLogSuccess completeHandler:^(NSString * _Nonnull logFilePath) {
            NSLog(@"%@",logFilePath);
        }];
    }
    
    return tables;
}

#pragma mark - 截取类名称
- (NSMutableArray *)getObjName:(NSString *__nonnull)sql ppDb:(sqlite3 *)ppDb{
    if (![[sql uppercaseString] containsString:@"WHERE"]) {
        //没有WHERE条件
        if ([[sql uppercaseString] containsString:@"LIMIT"]) {
            //有Limit
            return [self sqlite3Exec:ppDb objName:[[[[sql uppercaseString] componentsSeparatedByString:@"FROM "][1] componentsSeparatedByString:@" LIMIT"][0] lowercaseString]];
        }else if ([[sql uppercaseString] containsString:@"ORDER"]){
            //有ORDER
            return [self sqlite3Exec:ppDb objName:[[[[sql uppercaseString] componentsSeparatedByString:@"FROM "][1] componentsSeparatedByString:@" ORDER"][0] lowercaseString]];
        }else{
            //没有Limit
            return [self sqlite3Exec:ppDb objName:[[[sql uppercaseString] componentsSeparatedByString:@"FROM "][1] lowercaseString]];
        }
    }else{
        //用WHREE条件
        //取出FROM 和 WHERE之间的表名
        return [self sqlite3Exec:ppDb objName:[[[[sql uppercaseString] componentsSeparatedByString:@"FROM "][1] componentsSeparatedByString:@" WHERE"][0] lowercaseString]];
    }
}

#pragma mark - 类型转换
- (id)caseTheType:(int)type index:(int)i value:(id)value{
    switch (type) {
        case SQLITE_INTEGER:
            value = [NSNumber numberWithInt:sqlite3_column_int(_stmt, i)];
            break;
        case SQLITE_FLOAT:
            value = [NSNumber numberWithDouble:sqlite3_column_double(_stmt, i)];
            break;
        case SQLITE3_TEXT:
            value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(_stmt, i)];
            break;
        case SQLITE_BLOB:
            value = CFBridgingRelease(sqlite3_column_blob(_stmt, i));
            break;
        case SQLITE_NULL:
            value = @"";
            break;
        default:
            break;
    }
    
    return value;
}

- (NSMutableArray *)sqlite3Exec:(sqlite3 *)ppDb objName:(NSString *)objName{
    NSMutableArray<NSString *> *resArray = [NSMutableArray array];
    @synchronized (self) {
        //判断是否有这个表存在，存在则查询，否则报错
        if (![[self getCurrentTableNameWithJSON] containsObject:objName]) {
            [PaintingliteException PaintingliteException:@"无法执行操作" reason:@"表名不存在"];
        }
        
        //保存快照
        resArray = [self getTableInfo:ppDb objName:objName];
    }
    
    return resArray;
}

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content{
    NSAssert(tableName != NULL, @"TableName Not IS Empty");
    
    //根据表名来创建表语句
    //判断JSON文件中是否与这个表
    Boolean flag = true;
    
    @synchronized (self) {
        if ([[self getCurrentTableNameWithJSON] containsObject:tableName]) {
            //包含了就不能创建了
            flag = false;
            
            [PaintingliteException PaintingliteException:@"表名重复" reason:@"数据库中已经含有此表,请重新设置表的名称"];
        }else{
            //创建数据库
            if (flag) {
                NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(\n\t%@\n)",tableName,content];
                NSLog(@"%@",createSQL);
                [self sqlite3Exec:ppDb sql:createSQL];
            }
        }
    }
    
    return flag;
}

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName{
    NSAssert(tableName != NULL, @"TableName Not IS Empty");
    
    Boolean flag = true;
    
    @synchronized (self) {
        if ([[self getCurrentTableNameWithJSON] containsObject:tableName]) {
            //有表，则删除
            if (flag) {
                NSString *dropSQL = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
                NSLog(@"%@",dropSQL);
                [self sqlite3Exec:ppDb sql:dropSQL];
            }
        }else{
            //不能删除
            flag = false;
            
            [PaintingliteException PaintingliteException:@"表名不存在" reason:@"数据库中未找到表名"];
        }
    }
    
    return flag;
}

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb obj:(id)obj status:(PaintingliteExecStatus)status createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle{
    Boolean flag = true;
    
    @synchronized (self) {
        //获得obj的名称作为表的名称
        NSString *objName = [PaintingliteObjRuntimeProperty getObjName:obj];
        
        if (status == PaintingliteExecCreate) {
            [self getPaintingliteExecCreate:ppDb objName:objName obj:obj createSytle:createStyle];
        }else if(status == PaintingliteExecDrop){
            [self sqlite3Exec:ppDb tableName:[objName lowercaseString]];
        }else if (status == PaintingliteExecAlterRename){
            [self getPaintingliteExecAlterRename:ppDb obj:obj];
        }else if (status == PaintingliteExecAlterAddColumn){
            [self getPaintingliteExecAlterAddColumn:ppDb obj:obj];
        }else if (status == PaintingliteExecAlterObj){
            [self getPaintingliteExecAlterObj:ppDb objName:objName obj:obj];
        }
    }
    
    return flag;
}

#pragma mark - 基本操作
- (void)getPaintingliteExecCreate:(sqlite3 *)ppDb objName:(NSString *__nonnull)objName obj:(id)obj createSytle:(PaintingliteDataBaseOptionsCreateStyle)createStyle{
    
    //如果存在表则不能创建
    if ([[self getCurrentTableNameWithJSON] containsObject:[NSStringFromClass(obj) lowercaseString]]) {
        [PaintingliteException PaintingliteException:@"表名存在" reason:@"数据库中已经存在表名"];
    }
    
    //默认选择UUID作为主键
    //获得obj的成员变量作为表的字段
    NSMutableDictionary *propertyDict = [PaintingliteObjRuntimeProperty getObjPropertyName:obj];
    
    NSMutableString *content = [NSMutableString string];
    
    if (createStyle == PaintingliteDataBaseOptionsUUID) {
        content = [NSMutableString stringWithFormat:@"%@ NOT NULL PRIMARY KEY,",@"UUID"];
    }else if(createStyle == PaintingliteDataBaseOptionsID){
        content = [NSMutableString stringWithFormat:@"%@ NOT NULL PRIMARY KEY,",@"ID"];
    }
    
    for (NSString *ivarName in [propertyDict allKeys]) {
        NSString *ivarType = propertyDict[ivarName];
        [content appendFormat:@"%@ %@,",ivarName,ivarType];
    }
    
    content = (NSMutableString *)[content substringWithRange:NSMakeRange(0, content.length-1)];
    
    [self sqlite3Exec:ppDb tableName:[objName lowercaseString] content:content];
}

- (void)getPaintingliteExecAlterRename:(sqlite3 *)ppDb obj:(id)obj{
    //表存在才可以重命名表
    if ([[self getCurrentTableNameWithJSON] containsObject:(NSString *)obj[0]]) {
        NSString *alterSQL = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@",obj[0],obj[1]];
        [self sqlite3Exec:ppDb sql:alterSQL];
    }else{
        [PaintingliteException PaintingliteException:@"表名不存在" reason:@"数据库中未找到表名"];
    }
}

- (void)getPaintingliteExecAlterAddColumn:(sqlite3 *)ppDb obj:(id)obj{
    if ([[self getCurrentTableNameWithJSON] containsObject:(NSString *)obj[0]]){
        NSString *alterSQL = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",obj[0],obj[1],obj[2]];
        [self sqlite3Exec:ppDb sql:alterSQL];
    }else{
        [PaintingliteException PaintingliteException:@"表名不存在" reason:@"数据库中未找到表名"];
    }
}

- (void)getPaintingliteExecAlterObj:(sqlite3 *)ppDb objName:(NSString *)objName obj:(id)obj{
    if ([[self getCurrentTableNameWithJSON] containsObject:[objName lowercaseString]]) {
        NSArray *propertyNameArray = [[PaintingliteObjRuntimeProperty getObjPropertyName:obj] allKeys];
        //检查列表是否有更新
        //查看字段和当前表的字段进行对比操作，如果出现不一样则更新表
        [self sqlite3Exec:ppDb objName:objName];
        //读取JSON文件
        NSError *error = nil;
        
        NSArray *tableInfoArray = [NSJSONSerialization JSONObjectWithData:[PaintingliteSecurity SecurityDecodeBase64:[NSData dataWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"TablesInfo_Snap.json"]]] options:NSJSONReadingAllowFragments error:&error][@"TablesInfoSnap"];

        if ([propertyNameArray isEqualToArray:tableInfoArray]) {
            //完全相等，没必要更新操作
            return ;
        }else{
            //找出不一样的增加的那一个，进行更新操作
            //先删除原来那个表，然后重新根据这个表进行创建
            if ([self sqlite3Exec:ppDb obj:obj status:PaintingliteExecDrop createStyle:PaintingliteDataBaseOptionsDefault]) {
                [self sqlite3Exec:ppDb obj:obj status:PaintingliteExecCreate createStyle:PaintingliteDataBaseOptionsUUID];
            }
        }
    }else{
        [PaintingliteException PaintingliteException:@"表名不存在" reason:@"数据库中未找到表名"];
    }
    
}

#pragma mark - 读取JSON文件
#pragma mark - 获得数据库含有表名称
- (NSArray *)getCurrentTableNameWithJSON{
    NSError *error = nil;
    
    return [NSJSONSerialization JSONObjectWithData:[PaintingliteSecurity SecurityDecodeBase64:[NSData dataWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Tables_Snap.json"]]] options:NSJSONReadingAllowFragments error:&error][@"TablesSnap"];
}

/* 获得表字段 */
- (NSMutableArray *)getTableInfo:(sqlite3 *)ppDb objName:(NSString *__nonnull)objName{
    NSString *masterSQL = [NSString stringWithFormat:@"PRAGMA table_info(%@)",objName];
    return [self.factory execQuery:ppDb sql:masterSQL status:PaintingliteSessionFactoryTableINFOJSON];
}


@end
