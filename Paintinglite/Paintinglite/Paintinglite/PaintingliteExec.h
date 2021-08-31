//
//  PaintingliteExec.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/28.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//
/*!
 @header PaintingliteExec
 @abstract PaintingliteExec 提供SDK框架中所有的基本操作,通过Exec执行对Sqlite3数据库和表的操作
 @author CreaterOS
 @version 1.00 2020/5/28 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import "PaintingliteDataBaseOptions.h"
#import <Sqlite3.h>

#define TABLEINFO_CID @"cid"
#define TABLEINFO_NAME @"name"
#define TABLEINFO_TYPE @"type"
#define TABLEINFO_NOTNULL @"notnull"
#define TABLEINFO_DEFAULT_VALUE @"dflt_value"
#define TABLEINFO_PK @"pk"

/*!
 @abstract PaintingliteExecStatus 执行状态
 @constant PaintingliteExecCreate 创建表
 @constant PaintingliteExecDrop 删除表
 @constant PaintingliteExecAlterRename 修改表名称
 @constant PaintingliteExecAlterAddColumn 修改表结构[增加列]
 @constant PaintingliteExecAlterObj 对象修改表结构
 @discussion 标识Sqlite3操作的执行状态
*/
typedef NS_ENUM(NSInteger,PaintingliteExecStatus){
    PaintingliteExecCreate,
    PaintingliteExecDrop,
    PaintingliteExecAlterRename,
    PaintingliteExecAlterAddColumn,
    PaintingliteExecAlterObj
};

NS_ASSUME_NONNULL_BEGIN

/*!
 @class PaintingliteExec
 @abstract PaintingliteExec 提供SDK框架中所有的基本操作,通过Exec执行对Sqlite3数据库和表的操作
 */
@interface PaintingliteExec : NSObject
/*!
 @property openSecurityMode
 @abstract 开启数据库安全模式
 */
@property (nonatomic)Boolean openSecurityMode;

/*!
 @method systemExec: sql:
 @abstract 原生执行方式
 @discussion 原生执行方式
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @result NSMutableArray<NSMutableDictionary<NSString *,NSString *> *>
 */
- (NSMutableArray<NSMutableDictionary<NSString *,NSString *> *> *)systemExec:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;

/*!
 @method sqlite3Exec: sql:
 @abstract 执行SQL语句
 @discussion 执行SQL语句
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @result Boolean
 */
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb sql:(NSString *)sql;

/*!
 @method sqlite3ExecQuery: sql:
 @abstract 执行SQL查询语句
 @discussion 执行SQL查询语句
 @param ppDb Sqlite3 ppDb
 @param sql sql语句
 @result NSMutableArray
 */
- (NSMutableArray *)sqlite3ExecQuery:(sqlite3 *)ppDb sql:(NSString *)sql;

/*!
 @method sqlite3Exec: tableName: content:
 @abstract 执行SQL操作
 @discussion 根据表名执行SQL操作
 @param ppDb Sqlite3 ppDb
 @param tableName 表名称
 @param content 表名称
 @result Boolean
 */
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content;

/*!
 @method sqlite3Exec: tableName:
 @abstract 执行SQL操作
 @discussion 根据表名执行SQL操作
 @param ppDb Sqlite3 ppDb
 @param tableName 表名称
 @result Boolean
 */
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName;

/*!
 @method sqlite3Exec: obj: status: createStyle:
 @abstract 执行SQL操作
 @discussion 根据表名执行SQL操作
 @param ppDb Sqlite3 ppDb
 @param obj 对象
 @param status Sqlite3执行状态
 @param createStyle 主键类型
 @result Boolean
 */
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb obj:(id)obj status:(PaintingliteExecStatus)status createStyle:(kPrimaryKeyStyle)createStyle;

/*!
 @method sqlite3Exec: objName:
 @abstract 执行SQL操作
 @discussion 根据对象名称执行SQL操作
 @param ppDb Sqlite3 ppDb
 @param objName 对象名称
 @result NSMutableArray
 */
- (NSMutableArray *)sqlite3Exec:(sqlite3 *)ppDb objName:(NSString *)objName;

/*!
 @method execQueryTable:
 @abstract 表所有的名称
 @discussion 获得表所有的名称
 @param ppDb Sqlite3 ppDb
 @result NSMutableArray<NSString *>
 */
- (NSMutableArray<NSString *> *)execQueryTable:(sqlite3 *)ppDb;

/*!
 @method execQueryTableInfo: tableName:
 @abstract 表结构字典数组
 @discussion 获得表结构字典数组
 @param ppDb Sqlite3 ppDb
 @param tableName 表名称
 @result NSMutableArray
 */
- (NSMutableArray *)execQueryTableInfo:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName;

/*!
 @method getTableInfo: tableName:
 @abstract 表字段
 @discussion 获得表字段
 @param ppDb Sqlite3 ppDb
 @param tableName 表名称
 @result NSMutableArray
 */
- (NSMutableArray *)getTableInfo:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName;

/*!
 @method getCurrentTableNameWithCache
 @abstract 表缓存JSON文件
 @discussion 获得表缓存JSON文件
 @result NSArray
 */
- (NSArray *)getCurrentTableNameWithCache;

/*!
 @method isNotExistsTable:
 @abstract 表名是否存在
 @discussion 判断表名是否存在
 @param tableName 表名称
 @result Boolean
 */
- (Boolean)isNotExistsTable:(NSString *__nonnull)tableName;

@end

NS_ASSUME_NONNULL_END
