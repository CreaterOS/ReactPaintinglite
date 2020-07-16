//
//  PaintingliteExec.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/28.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintingliteDataBaseOptions.h"
#import <Sqlite3.h>

#define TABLEINFO_CID @"cid"
#define TABLEINFO_NAME @"name"
#define TABLEINFO_TYPE @"type"
#define TABLEINFO_NOTNULL @"notnull"
#define TABLEINFO_DEFAULT_VALUE @"dflt_value"
#define TABLEINFO_PK @"pk"

typedef NS_ENUM(NSInteger,PaintingliteExecStatus){
    PaintingliteExecCreate,
    PaintingliteExecDrop,
    PaintingliteExecAlterRename,
    PaintingliteExecAlterAddColumn,
    PaintingliteExecAlterObj
};

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteExec : NSObject

/* 系统执行方式 */
- (NSMutableArray<NSMutableArray<NSString *> *> *)systemExec:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;

/* 执行SQL语句 */
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb sql:(NSString *)sql;

/* 执行SQL查询语句 */
- (NSMutableArray *)sqlite3ExecQuery:(sqlite3 *)ppDb sql:(NSString *)sql;

/* 根据表名执行SQL */
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content;

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName;

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb obj:(id)obj status:(PaintingliteExecStatus)status createStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)createStyle;

/* 根据类名执行SQL */
- (NSMutableArray *)sqlite3Exec:(sqlite3 *)ppDb objName:(NSString *)objName;

/* 获得表所有的名称 */
- (NSMutableArray<NSString *> *)execQueryTable:(sqlite3 *)ppDb;

/* 获得表结构字典数组 */
- (NSMutableArray *)execQueryTableInfo:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName;

/* 获得表字段 */
- (NSMutableArray *)getTableInfo:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName;

/* 获得表名当前JSON文件 */
- (NSArray *)getCurrentTableNameWithCache;

/* 判断表名是否存在 */
- (void)isNotExistsTable:(NSString *__nonnull)tableName;

@end

NS_ASSUME_NONNULL_END
