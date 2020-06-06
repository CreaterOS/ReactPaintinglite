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
#import "PaintingliteSnapManager.h"
#import <objc/runtime.h>

#define Paintinglite_Sqlite3_CREATE @"CREATE"
#define Paintinglite_Sqlite3_DROP @"DROP"
#define Paintinglite_Sqlite3_ALTER @"ALTER"
#define Paintinglite_Sqlite3_ALTER_RENAME @"RENAME"
#define Paintinglite_Sqlite3_ALTER_SPACE_RENAME @" RENAME"
#define Paintinglite_Sqlite3_ALTER_ADD @"ADD"
#define Paintinglite_Sqlite3_ALTER_SPACE_ADD @" ADD"
#define Paintinglite_Sqlite3_ALTER_COLUMN @"COLUMN "
@interface PaintingliteExec()
@property (nonatomic,strong)PaintingliteSessionFactory *factory; //工厂
@property (nonatomic,strong)PaintingliteLog *log; //日志
@property (nonatomic)sqlite3_stmt *stmt;
@property (nonatomic,strong)PaintingliteSnapManager *snapManager; //快照管理者
@property (nonatomic)Boolean isCreateTable; //是否调用创建数据库
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

- (PaintingliteSnapManager *)snapManager{
    if (!_snapManager) {
        _snapManager = [PaintingliteSnapManager sharePaintingliteSnapManager];
    }
    
    return _snapManager;
}

#pragma mark - 执行SQL语句
#pragma mark - 创建 更新 删除数据库
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb sql:(NSString *)sql{
    NSAssert(sql != NULL, @"SQL Not IS Empty");
    
    Boolean flag = false;
    
    //判断是否有表,有表则不创建
    //更新数据库时候会出问题
    NSString *tableName = [self getOptTableName:ppDb sql:sql];
    
    //WHERE LIMIT ORDER BY
    if ([sql containsString:@"where"]) {
        [sql stringByReplacingOccurrencesOfString:@"where" withString:@"WHERE"];
    }else if ([sql containsString:@"limit"]){
        [sql stringByReplacingOccurrencesOfString:@"limit" withString:@"LIMIT"];
    }else if ([sql containsString:@"order by"]){
        [sql stringByReplacingOccurrencesOfString:@"order by" withString:@"ORDER BY"];
    }
    
    @synchronized (self) {
        flag = sqlite3_exec(ppDb, [sql UTF8String], 0, 0, 0) == SQLITE_OK;
        if (flag) {
            //保存快照
            if ([[sql uppercaseString] containsString:Paintinglite_Sqlite3_CREATE] || [[sql uppercaseString] containsString:Paintinglite_Sqlite3_DROP] || ([[sql uppercaseString] containsString:Paintinglite_Sqlite3_ALTER] && [[sql uppercaseString] containsString:Paintinglite_Sqlite3_ALTER_RENAME])) {
                //增加对表的快照的保存
                [self.snapManager saveSnap:ppDb];
            }else{
                //剩下的对表结构改变保存
                [self.snapManager saveTableInfoSnap:ppDb objName:tableName];
            }
            
            //写入日志
            [self writeLogFileOptions:sql status:PaintingliteLogSuccess];
        }else{
            [self writeLogFileOptions:sql status:PaintingliteLogError];
        }
    }
    
    //打印SQL语句
    NSLog(@"%@",sql);
    
    return flag;
}

#pragma mark - 获取执行的表名
- (NSString *__nonnull)getOptTableName:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql{
    NSString *tableName = [NSString string];
    if ([[sql uppercaseString] containsString:Paintinglite_Sqlite3_CREATE]) {
        tableName = [[[sql componentsSeparatedByString:@"("][0] componentsSeparatedByString:@" "]lastObject];
        
        if (self.isCreateTable) {
            if ([[self getCurrentTableNameWithJSON] containsObject:tableName]) {
                [PaintingliteException PaintingliteException:@"表名存在" reason:@"数据库中已经存在表名，无法建立新表"];
            }
        }else{
            self.isCreateTable = YES;
        }
    }else if ([[sql uppercaseString] containsString:Paintinglite_Sqlite3_ALTER] && [sql containsString:Paintinglite_Sqlite3_ALTER_RENAME]){
        tableName = [[[sql componentsSeparatedByString:Paintinglite_Sqlite3_ALTER_SPACE_RENAME][0] componentsSeparatedByString:@" "]lastObject];
        [self isNotExistsTable:tableName];
    }else if ([[sql uppercaseString] containsString:Paintinglite_Sqlite3_ALTER] && [sql containsString:Paintinglite_Sqlite3_ALTER_ADD]){
        tableName = [[[sql componentsSeparatedByString:Paintinglite_Sqlite3_ALTER_SPACE_ADD][0] componentsSeparatedByString:@" "]lastObject];
        
        //ALTER TABLE user ADD COLUMN IDCards TEXT
        NSString *column = [[[sql componentsSeparatedByString:Paintinglite_Sqlite3_ALTER_COLUMN][1] componentsSeparatedByString:@" "]firstObject];
        
        //执行时候，添加列的时候，已经有了列则不能添加
        for (NSString *info in [self getTableInfo:ppDb objName:tableName]) {
            if ([info isEqualToString:column]) {
                //相同的时候，则不更新
                [PaintingliteException PaintingliteException:@"列表存在" reason:[NSString stringWithFormat:@"列表存在无法修改[%@]",column]];
            }
        }
        [self isNotExistsTable:tableName];
    }else if ([[sql uppercaseString] containsString:Paintinglite_Sqlite3_DROP]){
        tableName = [[sql componentsSeparatedByString:@" "]lastObject];
       
        if (![[self getCurrentTableNameWithJSON] containsObject:tableName]) {
            [PaintingliteException PaintingliteException:@"表名不存在" reason:[NSString stringWithFormat:@"数据库中查找不到表名[%@]",tableName]];
        }
    }

    return tableName;
}

#pragma mark - 查询数据库 获得字段名称集合
- (NSMutableArray *)sqlite3ExecQuery:(sqlite3 *)ppDb sql:(NSString *)sql{
    NSMutableArray<NSDictionary *> *tables = [NSMutableArray array];
    //将结果返回,保存为字典
    
    NSMutableArray *resArray = [self getObjName:sql ppDb:ppDb];
    
    //替换SELECT * FROM user 中星号
    //SELECT * FROM user WHERE name = '...'
    NSString *tableInfoStr = [NSString string];
    
    if ([sql containsString:@"*"]) {
        if ([[sql uppercaseString] containsString:@"WHERE"]) {
            tableInfoStr = [NSString stringWithFormat:@"%@",[self getTableInfo:ppDb objName:[[[sql componentsSeparatedByString:@" WHERE"][0] componentsSeparatedByString:@" "]lastObject]]];
        }else if([[sql uppercaseString] containsString:@"ORDER"]){
            tableInfoStr = [NSString stringWithFormat:@"%@",[self getTableInfo:ppDb objName:[[[sql componentsSeparatedByString:@" ORDER"][0] componentsSeparatedByString:@" "]lastObject]]];
        }else if([[sql uppercaseString] containsString:@"LIMIT"]){
            tableInfoStr = [NSString stringWithFormat:@"%@",[self getTableInfo:ppDb objName:[[[sql componentsSeparatedByString:@" LIMIT"][0] componentsSeparatedByString:@" "]lastObject]]];
        }else{
            tableInfoStr = [NSString stringWithFormat:@"%@",[self getTableInfo:ppDb objName:[[sql componentsSeparatedByString:@" "]lastObject]]];
        }
        
        //去除换行和空格
        tableInfoStr = [[tableInfoStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
        tableInfoStr = [tableInfoStr substringWithRange:NSMakeRange(1, tableInfoStr.length - 2)];
        
        sql = [sql stringByReplacingOccurrencesOfString:@"*" withString:tableInfoStr];
    }

    NSLog(@"%@",sql);
    
    
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
            [self writeLogFileOptions:sql status:PaintingliteLogError];
        }
    }
    
    if (tables.count != 0) {
        //写入日志文件
        [self writeLogFileOptions:sql status:PaintingliteLogSuccess];
    }
    
    return tables;
}

- (NSMutableArray *)sqlite3Exec:(sqlite3 *)ppDb objName:(NSString *)objName{
    NSMutableArray<NSString *> *resArray = [NSMutableArray array];
    @synchronized (self) {
        objName = [objName lowercaseString];
        //判断是否有这个表存在，存在则查询，否则报错
        if (![[self getCurrentTableNameWithJSON] containsObject:objName]) {
            [PaintingliteException PaintingliteException:@"无法执行操作" reason:@"表名不存在"];
        }
        
        //保存表结构快照
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
            
            [PaintingliteException PaintingliteException:@"表名存在" reason:@"数据库中已经存在表名，无法建立新表"];
        }else{
            //创建数据库
            if (flag) {
                NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(\n\t%@\n)",tableName,content];
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

#pragma mark - 对象执行方法
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
    if ([[self getCurrentTableNameWithJSON] containsObject:[[PaintingliteObjRuntimeProperty getObjName:obj] lowercaseString]]) {
        [PaintingliteException PaintingliteException:@"表名存在" reason:@"数据库中已经存在表名，无法建立新表"];
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

#pragma mark - 查询截取类名称
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

#pragma mark - 写日志
- (void)writeLogFileOptions:(NSString *__nonnull)sql status:(PaintingliteLogStatus)status{
    [self.log writeLogFileOptions:sql status:status completeHandler:nil];
}

#pragma mark - 判断表是否存在
- (void)isNotExistsTable:(NSString *__nonnull)tableName{
    if (self.isCreateTable) {
        if (![[self getCurrentTableNameWithJSON] containsObject:tableName]) {
            [PaintingliteException PaintingliteException:@"表名不存在" reason:[NSString stringWithFormat:@"数据库中查找不到表名[%@]",tableName]];
        }
    }
}

@end
