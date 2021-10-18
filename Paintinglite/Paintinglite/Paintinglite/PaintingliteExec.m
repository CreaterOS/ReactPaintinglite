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
#import "PaintingliteException.h"
#import "PaintingliteSnapManager.h"
#import "PaintingliteCache.h"
#import "PaintingliteSystemUseInfo.h"
#import "PaintingliteThreadManager.h"
#import <objc/runtime.h>

#define WEAKSELF(SELF) __weak typeof(SELF) weakself = SELF
#define STRONGSELF(WEAKSELF) __strong typeof(WEAKSELF) self = WEAKSELF

#define Paintinglite_Sqlite3_WHERE @"WHERE"
#define Paintinglite_Sqlite3_LIMIT @"LIMIT"
#define Paintinglite_Sqlite3_ORDER_BY @"ORDER BY"
#define Paintinglite_Sqlite3_ORDER @"ORDER"

#define Paintinglite_Sqlite3_INSERT @"INSERT"
#define Paintinglite_Sqlite3_DELETE @"DELETE"

#define Paintinglite_Sqlite3_CREATE @"CREATE"
#define Paintinglite_Sqlite3_DROP @"DROP"
#define Paintinglite_Sqlite3_ALTER @"ALTER"
#define Paintinglite_Sqlite3_ALTER_RENAME @"RENAME"
#define Paintinglite_Sqlite3_ALTER_SPACE_RENAME @" RENAME"
#define Paintinglite_Sqlite3_ALTER_ADD @"ADD"
#define Paintinglite_Sqlite3_ALTER_SPACE_ADD @" ADD"
#define Paintinglite_Sqlite3_ALTER_COLUMN @"COLUMN "

#define Paintinglite_Sqlite3_FROM @"FROM "

#define Paintinglite_Sqlite3_SPACE @" "

/* SQL语句 */
#define Paintinglite_Sqlite3_CREATE_SQL(tableName,content) [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(\n\t%@\n)",tableName,content]
#define Paintinglite_Sqlite3_DROP_SQL(tableName) [NSString stringWithFormat:@"DROP TABLE %@",tableName]
#define Paintinglite_Sqlite3_PRIMARY_KEY(primaryKey) [NSMutableString stringWithFormat:@"%@ TEXT NOT NULL PRIMARY KEY,",primaryKey]
#define Paintinglite_Sqlite3_ALTER_RENAME_SQL(tableName,newName) [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@",tableName,newName]
#define Paintinglite_Sqlite3_ALTER_ADD_COLUMN_SQL(tableName,columnName,content) [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",tableName,columnName,content]
#define TABLE_INFO(tableName) [NSString stringWithFormat:@"PRAGMA table_info(%@)",tableName]
#define SHOW_TABLES @"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"

/* 获得SQL语句首单词 */
#define SQL_FIRST_WORDS(sql) [[[sql uppercaseString] componentsSeparatedByString:@" "] firstObject]

@interface PaintingliteExec()
@property (nonatomic)sqlite3_stmt *stmt;
@property (nonatomic)Boolean isCreateTable; //是否调用创建数据库
@property (nonatomic)Boolean isSnap; //是否保存过
@end

@implementation PaintingliteExec
#pragma mark - 执行SQL语句
#pragma mark - 创建 更新 删除数据库
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb sql:(NSString *)sql{
    NSAssert(sql != NULL, @"SQL Not IS Empty");
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    NSString *firstWords = SQL_FIRST_WORDS(sql); /** 获得SQL语句第一个词*/
    
    __block Boolean flag = false;
    __block Boolean sqlFlag = [firstWords containsString:Paintinglite_Sqlite3_CREATE] || [firstWords containsString:Paintinglite_Sqlite3_DROP] || [firstWords containsString:Paintinglite_Sqlite3_ALTER] || [firstWords containsString:Paintinglite_Sqlite3_ALTER_RENAME];
    /* 获得表名 */
    __block NSString *tableName = [self getOptTableName:ppDb sql:sql];
    
    __block NSString *upperSql = [self lowerToUpper:sql];
    runAsynchronouslyOnExecQueue(^{
        //判断是否有表,有表则不创建
        /*
         执行sqlite3_exec(),成功在保存快照
         成功失败都会进行日志记录
         */
        [self CPUShare];
        
        /* 拼接缓存操作 */
        flag = sqlite3_exec(ppDb, [upperSql UTF8String], 0, 0, 0) == SQLITE_OK;
        
        NSString *optAndStatusStr = [upperSql stringByAppendingString:@" | "];
        if (flag && sqlFlag) {
            //增加对表的快照保存
            [[PaintingliteSnapManager sharePaintingliteSnapManager] saveSnap:ppDb];
            //对表结构的快照保存
            [[PaintingliteSnapManager sharePaintingliteSnapManager] saveTableInfoSnap:ppDb tableName:tableName];
        }
        
        //写入缓存
        [[PaintingliteCache sharePaintingliteCache] addDatabaseOptionsCache:[optAndStatusStr stringByAppendingString:flag ? @"success" : @"error"]];
        
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    //释放
    sqlite3_finalize(_stmt);
    tableName = nil;
    
    return flag;
}

#pragma mark - 大小写转换
- (NSString *)lowerToUpper:(NSString *__nonnull)sql {
    //WHERE LIMIT ORDER BY
    if ([sql containsString:[Paintinglite_Sqlite3_WHERE lowercaseString]]) {
        return [sql stringByReplacingOccurrencesOfString:[Paintinglite_Sqlite3_WHERE lowercaseString] withString:Paintinglite_Sqlite3_WHERE];
    }else if ([sql containsString:[Paintinglite_Sqlite3_LIMIT lowercaseString]]){
        return [sql stringByReplacingOccurrencesOfString:[Paintinglite_Sqlite3_LIMIT lowercaseString] withString:Paintinglite_Sqlite3_LIMIT];
    }else if ([sql containsString:[Paintinglite_Sqlite3_ORDER_BY lowercaseString]]){
        return [sql stringByReplacingOccurrencesOfString:[Paintinglite_Sqlite3_ORDER_BY lowercaseString] withString:Paintinglite_Sqlite3_ORDER_BY];
    }
    
    return sql;
}

#pragma mark - 获取执行的表名
- (NSString *__nonnull)getOptTableName:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql { /** 根据SQL语句提取表名*/
    NSString *tableName = [NSString string];
    
    /* 获得SQL语句第一个词 */
    NSString *firstSQLWords = SQL_FIRST_WORDS(sql);
    
    if ([firstSQLWords isEqualToString:Paintinglite_Sqlite3_CREATE] || [firstSQLWords isEqualToString:Paintinglite_Sqlite3_INSERT]) {
        tableName = [[[sql componentsSeparatedByString:@"("][0] componentsSeparatedByString:Paintinglite_Sqlite3_SPACE] lastObject];
        
        if (self.isCreateTable && ![firstSQLWords isEqualToString:Paintinglite_Sqlite3_INSERT]) {
            if ([[self getCurrentTableNameWithCache] containsObject:[tableName lowercaseString]]) {
                [PaintingliteException paintingliteException:@"表名存在" reason:@"数据库中已经存在表名，无法建立新表"];
            }
        } else {
            self.isCreateTable = YES; /** 创建表标识符*/
        }
        
    } else if ([firstSQLWords isEqualToString:Paintinglite_Sqlite3_ALTER] && [sql isEqualToString:Paintinglite_Sqlite3_ALTER_RENAME]) {
        tableName = [[[sql componentsSeparatedByString:Paintinglite_Sqlite3_ALTER_SPACE_RENAME][0] componentsSeparatedByString:Paintinglite_Sqlite3_SPACE] lastObject];
        [self isNotExistsTable:tableName];
    } else if ([firstSQLWords isEqualToString:Paintinglite_Sqlite3_ALTER] && [sql isEqualToString:Paintinglite_Sqlite3_ALTER_ADD]) {
        tableName = [[[sql componentsSeparatedByString:Paintinglite_Sqlite3_ALTER_SPACE_ADD][0] componentsSeparatedByString:Paintinglite_Sqlite3_SPACE] lastObject];
        
        //ALTER TABLE user ADD COLUMN IDCards TEXT
        NSString *column = [[[sql componentsSeparatedByString:Paintinglite_Sqlite3_ALTER_COLUMN][1] componentsSeparatedByString:Paintinglite_Sqlite3_SPACE] firstObject];
        
        //执行时候，添加列的时候，已经有了列则不能添加
        for (NSString *info in [self getTableInfo:ppDb tableName:tableName]) {
            if ([info isEqualToString:column]) {
                //相同的时候，则不更新
                [PaintingliteException paintingliteException:@"列表存在" reason:[NSString stringWithFormat:@"列表存在无法修改[%@]",column]];
            }
        }
        [self isNotExistsTable:tableName];
    } else if ([firstSQLWords isEqualToString:Paintinglite_Sqlite3_DROP]) {
        tableName = [[sql componentsSeparatedByString:Paintinglite_Sqlite3_SPACE] lastObject];
        
        if (![[self getCurrentTableNameWithCache] containsObject:[tableName lowercaseString]]) {
            [PaintingliteException paintingliteException:@"表名不存在" reason:[NSString stringWithFormat:@"数据库中查找不到表名[%@]",tableName]];
        }
    }else if ([firstSQLWords isEqualToString:Paintinglite_Sqlite3_DELETE]) {
        if ([[sql uppercaseString] containsString:Paintinglite_Sqlite3_WHERE]) {
            tableName = [[[[[sql uppercaseString] componentsSeparatedByString:[NSString stringWithFormat:@" %@",Paintinglite_Sqlite3_WHERE]][0] componentsSeparatedByString:Paintinglite_Sqlite3_FROM]lastObject] lowercaseString];
        } else {
            tableName = [[[[sql uppercaseString] componentsSeparatedByString:Paintinglite_Sqlite3_FROM]lastObject] lowercaseString];
        }
    }
    
    return tableName;
}

#pragma mark - 系统查询方法
- (NSMutableArray<NSMutableDictionary<NSString *,NSString *> *> *)systemExec:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql{
    NSMutableArray<NSMutableDictionary<NSString *,NSString *> *> *resArray = [NSMutableArray array];
    
    __block NSString *optAndStatusStr = [sql stringByAppendingString:@" | "];
    
    runSynchronouslyOnExecQueue(self, ^{
        if (sqlite3_prepare_v2(ppDb, [sql UTF8String], -1, &self->_stmt, nil) == SQLITE_OK) {
            //查询成功
            while (sqlite3_step(self->_stmt) == SQLITE_ROW) {
                /* 获得字段个数 */
                unsigned int count = sqlite3_column_count(self->_stmt);
                NSMutableDictionary<NSString *,NSString *> *dict = [NSMutableDictionary dictionary];
                
                for (unsigned i = 0; i < count; i++) {
                    @autoreleasepool {
                        /* 取出字段 */
                        /* 根据tableName,name组合唯一的字段名 */
                        char *name = (char *)sqlite3_column_name(self->_stmt, i);
                        char *tableName = (char *)sqlite3_column_table_name(self->_stmt, i);
                        
                        NSString *filedsName = [[NSString stringWithUTF8String:tableName] stringByAppendingString:[NSString stringWithFormat:@".%@",[NSString stringWithUTF8String:name]]];
                        /* 内容 */
                        char *text = (char *)sqlite3_column_text(self->_stmt, i);
                        NSString *textStr = text != nil ? [NSString stringWithUTF8String:text] : @"(null)";
                        [dict setObject:textStr forKey:filedsName];
                        
                    }
                }
                [resArray addObject:dict];
            }
            
            optAndStatusStr = [optAndStatusStr stringByAppendingString:@"success"];
        } else {
            //执行失败
            optAndStatusStr = [optAndStatusStr stringByAppendingString:@"error"];
        }
    });
    
    //写入缓存
    [[PaintingliteCache sharePaintingliteCache] addDatabaseOptionsCache:optAndStatusStr];
    
    sqlite3_finalize(_stmt);
    
    return resArray;
}

#pragma mark - 查询数据库 获得字段名称集合
- (NSMutableArray *)sqlite3ExecQuery:(sqlite3 *)ppDb sql:(NSString *)sql{
    
    /* 对多表连接进行查询 */
    if ([[sql uppercaseString] containsString:@"JOIN"]) {
        //交给系统操作
        return [self systemExec:ppDb sql:sql];
    }
    
    __block NSMutableArray<NSDictionary *> *tables = [NSMutableArray array];
    //将结果返回,保存为字典
    __block NSMutableArray *resArray = [self getObjName:sql ppDb:ppDb];
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    runAsynchronouslyOnExecQueue(^{
        NSString *optAndStatusStr = [sql stringByAppendingString:@" | "];
        
        if (sqlite3_prepare_v2(ppDb, [sql UTF8String], -1, &(self->_stmt), nil) == SQLITE_OK) {
            //查询成功
            NSUInteger resArrayCount = resArray.count;
            while (sqlite3_step(self->_stmt) == SQLITE_ROW) {
                @autoreleasepool {
                    NSMutableDictionary<id,id> *queryDict = [NSMutableDictionary dictionary];
                    //resArray是一个含有表字段的数据，根据resArray获得值加入
                    for (unsigned int i = 0; i < resArrayCount; ++i) {
                        //取出来的值，然后判断类型，进行类型分类
                        @autoreleasepool {
                            id value = nil;
                            [queryDict setValue:[self caseTheType:sqlite3_column_type(self->_stmt, i) index:i value:value] forKey:resArray[i]];
                        }
                    }
                    
                    [tables addObject:queryDict];
                }
            }
            optAndStatusStr = [optAndStatusStr stringByAppendingString:@"success"];
        } else {
            //执行失败
            optAndStatusStr = [optAndStatusStr stringByAppendingString:@"error"];
        }
        
        //写入缓存
        [[PaintingliteCache sharePaintingliteCache] addDatabaseOptionsCache:optAndStatusStr];
        
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_semaphore_wait(signal,DISPATCH_TIME_FOREVER);
    
    sqlite3_finalize(_stmt);
    
    return tables;
}

#pragma mark - 替代*操作
- (NSString *__nonnull)replaceStar:(sqlite3 *)ppDb resArray:(NSMutableArray *)resArray sql:(NSString *__nonnull)sql{
    __block NSString *tableInfoStr = NULL;
    __block NSString *tableName = NULL;
    __block NSString *tempSql = [sql uppercaseString];
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    runAsynchronouslyOnExecQueue(^{
        if ([tempSql containsString:@"*"]) {
            if ([tempSql containsString:Paintinglite_Sqlite3_WHERE]) {
                tableName = [[[sql componentsSeparatedByString:[NSString stringWithFormat:@" %@",Paintinglite_Sqlite3_WHERE]][0] componentsSeparatedByString:Paintinglite_Sqlite3_SPACE]lastObject];
                tableInfoStr = [NSString stringWithFormat:@"%@",[self getTableInfo:ppDb tableName:tableName]];
            }else if([tempSql containsString:Paintinglite_Sqlite3_ORDER]){
                tableName = [[[sql componentsSeparatedByString:[NSString stringWithFormat:@" %@",Paintinglite_Sqlite3_ORDER]][0] componentsSeparatedByString:Paintinglite_Sqlite3_SPACE]lastObject];
                tableInfoStr = [NSString stringWithFormat:@"%@",[self getTableInfo:ppDb tableName:tableName]];
            }else if([tempSql containsString:Paintinglite_Sqlite3_LIMIT]){
                tableName = [[[sql componentsSeparatedByString:[NSString stringWithFormat:@" %@",Paintinglite_Sqlite3_LIMIT]][0] componentsSeparatedByString:Paintinglite_Sqlite3_SPACE]lastObject];
                tableInfoStr = [NSString stringWithFormat:@"%@",[self getTableInfo:ppDb tableName:tableName]];
            }else{
                tableName = [[sql componentsSeparatedByString:Paintinglite_Sqlite3_SPACE]lastObject];
                tableInfoStr = [NSString stringWithFormat:@"%@",[self getTableInfo:ppDb tableName:tableName]];
            }
            
            //去除换行和空格
            tableInfoStr = [[tableInfoStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:Paintinglite_Sqlite3_SPACE withString:@""];
            tableInfoStr = [tableInfoStr substringWithRange:NSMakeRange(1, tableInfoStr.length - 2)];
            
            //SELECT name,age FROM user
            //每一个数组增加user.
            NSString *str = [NSString stringWithFormat:@"%@.",tableName];
            NSString *resStr = [NSString string];
            
            NSUInteger i = 0;
            NSArray<NSString*> *tableInfoArray = [tableInfoStr componentsSeparatedByString:@","];
            for (NSString *field in tableInfoArray) {
                resStr = (i == tableInfoArray.count - 1) ? [resStr stringByAppendingString:[NSString stringWithFormat:@"%@ as %@",[str stringByAppendingString:field],[NSString stringWithFormat:@"painting_%@",field]]] : [resStr stringByAppendingString:[NSString stringWithFormat:@"%@ as %@,",[str stringByAppendingString:field],[NSString stringWithFormat:@"painting_%@",field]]];
                i++;
            }
            
            tempSql = [sql stringByReplacingOccurrencesOfString:@"*" withString:resStr];
        }
        
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
   
    sql = tempSql;
    return sql;
}

#pragma mark - 类名执行
- (NSMutableArray *)sqlite3Exec:(sqlite3 *)ppDb objName:(NSString *)objName{
    __block NSMutableArray<NSString *> *resArray = NULL;
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    runAsynchronouslyOnExecQueue(^{
        NSString *objLowName = [objName lowercaseString];
        //判断是否有这个表存在，存在则查询，否则报错
        if (![[self getCurrentTableNameWithCache] containsObject:objLowName]) {
            [PaintingliteException paintingliteException:@"无法执行操作" reason:@"表名不存在"];
        }
        //保存表结构快照
        resArray = [self getTableInfo:ppDb tableName:objLowName];
        
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    return resArray;
}

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content{
    NSAssert(tableName != NULL, @"TableName Not IS Empty");
    
    //根据表名来创建表语句
    //判断JSON文件中是否与这个表
    __block Boolean flag = true;
    
    runSynchronouslyOnExecQueue(self, ^{
        NSArray *tables = [self getCurrentTableNameWithCache];
        if (tables.count != 0 && [tables containsObject:[tableName lowercaseString]]) {
            //包含了就不能创建了
            flag = false;
        }else{
            //创建数据库
            if (flag) {
                [self sqlite3Exec:ppDb sql:Paintinglite_Sqlite3_CREATE_SQL(tableName, content)];
            }
        }
    });
    
    return flag;
}

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName{
    NSAssert(tableName != NULL, @"TableName Not IS Empty");
    
    Boolean flag = true;
    
    if ([[self getCurrentTableNameWithCache] containsObject:[tableName lowercaseString]]) {
        //有表，则删除
        if (flag) {
            NSString *dropSQL = Paintinglite_Sqlite3_DROP_SQL(tableName);
            
            flag = [self sqlite3Exec:ppDb sql:dropSQL];
        }
    }else{
        //不能删除
        flag = false;
        
        [PaintingliteException paintingliteException:@"表名不存在" reason:@"数据库中未找到表名"];
    }
    
    return flag;
}

#pragma mark - 对象执行方法
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb obj:(id)obj status:(PaintingliteExecStatus)status createStyle:(kPrimaryKeyStyle)createStyle{
    Boolean flag = true;
    
    runSynchronouslyOnExecQueue(self, ^{
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
    });
    
    return flag;
}

#pragma mark - 基本操作
- (void)getPaintingliteExecCreate:(sqlite3 *)ppDb objName:(NSString *__nonnull)objName obj:(id)obj createSytle:(kPrimaryKeyStyle)createStyle{
    
    //如果存在表则不能创建
    if ([[self getCurrentTableNameWithCache] containsObject:[[PaintingliteObjRuntimeProperty getObjName:obj] lowercaseString]]) {
        //        [PaintingliteException PaintingliteException:@"表名存在" reason:@"数据库中已经存在表名，无法建立新表"];
        
    }
    
    //默认选择UUID作为主键
    //获得obj的成员变量作为表的字段
    NSMutableDictionary *propertyDict = [PaintingliteObjRuntimeProperty getObjPropertyName:obj];
    
    NSMutableString *content = [NSMutableString string];
    
    /* 设置主键 */
    if (createStyle == kUUID) {
        content = Paintinglite_Sqlite3_PRIMARY_KEY(@"UUID");
    }else if(createStyle == kID){
        content = [NSMutableString stringWithFormat:@"%@ INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,",@"ID"];
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
    if ([[self getCurrentTableNameWithCache] containsObject:(NSString *)obj[0]]) {
        [self sqlite3Exec:ppDb sql:Paintinglite_Sqlite3_ALTER_RENAME_SQL(obj[0],obj[1])];
    }else{
        [PaintingliteException paintingliteException:@"表名不存在" reason:@"数据库中未找到表名"];
    }
}

- (void)getPaintingliteExecAlterAddColumn:(sqlite3 *)ppDb obj:(id)obj{
    //表存在才可以添加表的字段
    if ([[self getCurrentTableNameWithCache] containsObject:[(NSString *)obj[0] lowercaseString]]){
        [self sqlite3Exec:ppDb sql:Paintinglite_Sqlite3_ALTER_ADD_COLUMN_SQL(obj[0],obj[1],obj[2])];
    }else{
        [PaintingliteException paintingliteException:@"表名不存在" reason:@"数据库中未找到表名"];
    }
}

- (void)getPaintingliteExecAlterObj:(sqlite3 *)ppDb objName:(NSString *)objName obj:(id)obj{
    if ([[self getCurrentTableNameWithCache] containsObject:[objName lowercaseString]]) {
        NSArray *propertyNameArray = [[PaintingliteObjRuntimeProperty getObjPropertyName:obj] allKeys];
        //检查列表是否有更新
        //查看字段和当前表的字段进行对比操作，如果出现不一样则更新表
        
        /* 获得表信息的缓存 */
        NSArray *tableInfoArray = (NSArray *)[[PaintingliteCache sharePaintingliteCache] objectForKey:[NSString stringWithFormat:@"snap_%@_info",[objName lowercaseString]]];
        
        if ([propertyNameArray isEqualToArray:tableInfoArray]) {
            //完全相等，没必要更新操作
            return ;
        }else{
            //找出不一样的增加的那一个，进行更新操作
            //先删除原来那个表，然后重新根据这个表进行创建
            if ([self sqlite3Exec:ppDb obj:obj status:PaintingliteExecDrop createStyle:kDefault]) {
                [self sqlite3Exec:ppDb obj:obj status:PaintingliteExecCreate createStyle:kUUID];
            }
        }
    }else{
        [PaintingliteException paintingliteException:@"表名不存在" reason:@"数据库中未找到表名"];
    }
}

#pragma mark - 读取缓存
#pragma mark - 获得数据库含有表名称
- (NSArray *)getCurrentTableNameWithCache{
    NSMutableArray<NSString *> *tableNameArray = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < [PaintingliteCache sharePaintingliteCache].tableCount; i++) {
        NSString *tableName = (NSString*)[[PaintingliteCache sharePaintingliteCache] objectForKey:[NSString stringWithFormat:@"snap_tableName_%zd",i]];
        if (![tableNameArray containsObject:tableName]) {
            [tableNameArray addObject:tableName];
        }
    }
    
    return tableNameArray;
}

/* 获得表字段 */
- (NSMutableArray *)getTableInfo:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName{
    return [[PaintingliteSessionFactory sharePaintingliteSessionFactory] execQuery:ppDb tableName:tableName sql:TABLE_INFO(tableName) status:kSessionFactoryTableINFOCache];
}

#pragma mark - 获得表的名称
- (NSMutableArray<NSString *> *)execQueryTable:(sqlite3 *)ppDb{
    __block NSMutableArray<NSString *> *tables = [NSMutableArray array];
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    runAsynchronouslyOnExecQueue(^{
        if (sqlite3_prepare_v2(ppDb, [SHOW_TABLES UTF8String], -1, &(self->_stmt), nil) == SQLITE_OK){
            //查询成功
            while (sqlite3_step(self->_stmt) == SQLITE_ROW) {
                //获得数据库中含有的表名
                char *name = (char *)sqlite3_column_text(self->_stmt, 0);
                [tables addObject:[NSString stringWithFormat:@"%s",name]];
            }
        }
        
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    return tables;
}

#pragma mark - 获得表的结构字典数组
- (NSMutableArray *)execQueryTableInfo:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName{
    __block NSMutableArray<NSMutableDictionary *> *tables = [NSMutableArray array];
    
    __block NSString *tableInfoSql = TABLE_INFO(tableName);
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    runAsynchronouslyOnExecQueue(^{
        if (sqlite3_prepare_v2(ppDb, [tableInfoSql UTF8String], -1, &(self->_stmt), nil) == SQLITE_OK){
            //查询成功
            while (sqlite3_step(self->_stmt) == SQLITE_ROW) {
                NSMutableDictionary<NSString *,NSString *> *tablesInfoDict = [NSMutableDictionary dictionary];
                
                //保存数据库中的字段名
                char *cid  = (char *)sqlite3_column_text(self->_stmt, 0);
                char *name = (char *)sqlite3_column_text(self->_stmt, 1);
                char *type = (char *)sqlite3_column_text(self->_stmt, 2);
                char *notnull = (char *)sqlite3_column_text(self->_stmt, 3);
                char *dflt_value = (char *)sqlite3_column_text(self->_stmt, 4);
                char *pk = (char *)sqlite3_column_text(self->_stmt, 5);
                
                [tablesInfoDict setValue:[NSString stringWithFormat:@"%s",cid] forKey:TABLEINFO_CID];
                [tablesInfoDict setValue:[NSString stringWithFormat:@"%s",name] forKey:TABLEINFO_NAME];
                [tablesInfoDict setValue:[NSString stringWithFormat:@"%s",type] forKey:TABLEINFO_TYPE];
                [tablesInfoDict setValue:[NSString stringWithFormat:@"%s",notnull] forKey:TABLEINFO_NOTNULL];
                [tablesInfoDict setValue:[NSString stringWithFormat:@"%s",dflt_value] forKey:TABLEINFO_DEFAULT_VALUE];
                [tablesInfoDict setValue:[NSString stringWithFormat:@"%s",pk] forKey:TABLEINFO_PK];
                
                [tables addObject:tablesInfoDict];
            }
        }
        
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    return tables;
}

#pragma mark - 查询截取类名称
- (NSMutableArray *)getObjName:(NSString *__nonnull)sql ppDb:(sqlite3 *)ppDb{
    sql = [sql uppercaseString];
    
    return [self sqlite3Exec:ppDb objName:[[[[[sql componentsSeparatedByString:@"FROM "] lastObject] componentsSeparatedByString:@" "] firstObject] lowercaseString]];
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
        case SQLITE3_TEXT:{
            char *text = (char *)sqlite3_column_text(_stmt, i);
            if (self.openSecurityMode) {
                value = text != nil ? [PaintingliteSecurityDecodeTool StringWithDecodeSecurityBase64:[NSString stringWithUTF8String:text]] : @"(null)";
            } else {
                value = text != nil ? [NSString stringWithUTF8String:text] : @"(null)";
            }
            
            break;
        }
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

#pragma mark - 判断表是否存在
- (Boolean)isNotExistsTable:(NSString *__nonnull)tableName{
    //    if (self.isCreateTable) {
    for (NSString *name in [self getCurrentTableNameWithCache]) {
        if ([name isEqualToString:tableName]) {
            return true;
        }
    }
    
    [PaintingliteException paintingliteException:@"表名不存在" reason:[NSString stringWithFormat:@"数据库中查找不到表名[%@]",tableName]];
    //    }
    
    return false;
}

#pragma mark - 资源占用
- (void)CPUShare {
    PaintingliteSystemUseInfo *systemUseInfo = [PaintingliteSystemUseInfo sharePaintingliteSystemUseInfo];
    double usedCPU = [systemUseInfo applicationCPU];
    /// 限定CPU占有率为55%
    if (usedCPU >= 35.0) {
        /// 暂停exec操作
        [NSThread sleepForTimeInterval:0.03];
    }
}

#pragma mark - dealloc
- (void)dealloc{
    sqlite3_finalize(self.stmt);
}

@end
