//
//  PaintingliteDataBaseOptions.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteDataBaseOptions
 @abstract PaintingliteDataBaseOptions 提供SDK框架中Sqlite3库操作
 @author CreaterOS
 @version 1.00 2020/5/27 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import <Sqlite3.h>

/*!
 @abstract PaintingliteDataBaseOptionsPrimaryKeyStyle 主键类型
 @constant PaintingliteDataBaseOptionsDefault 默认不带主键
 @constant PaintingliteDataBaseOptionsUUID UUID做主键
 @constant PaintingliteDataBaseOptionsID ID做主键
 @discussion 主键类型
*/
typedef NS_ENUM(NSUInteger, PaintingliteDataBaseOptionsPrimaryKeyStyle) {
    PaintingliteDataBaseOptionsDefault,
    PaintingliteDataBaseOptionsUUID,
    PaintingliteDataBaseOptionsID
};

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteDataBaseOptions
 @abstract PaintingliteDataBaseOptions 提供SDK框架中Sqlite3库操作
 */
@interface PaintingliteDataBaseOptions : NSObject


/*!
 @method sharePaintingliteDataBaseOptions
 @abstract 单例模式生成PaintingliteDataBaseOptions对象
 @discussion 生成PaintingliteDataBaseOptions在项目工程全局中只生成一个实例对象
 @result PaintingliteDataBaseOptions
 */
+ (instancetype)sharePaintingliteDataBaseOptions;

/*!
 @method execTableOptForSQL: sql:
 @abstract 调用sql语句
 @discussion 原生调用sql语句
 @param ppDb ppDb
 @param sql SQL语句
 @result Boolean
 */
- (Boolean)execTableOptForSQL:(sqlite3 *)ppDb sql:(NSString *)sql;

/*!
 @method execTableOptForSQL: sql: completeHandler:
 @abstract 调用sql语句,支持回调操作
 @discussion 原生调用sql语句,支持回调操作
 @param ppDb ppDb
 @param sql SQL语句
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execTableOptForSQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method createTableForName: tableName: content:
 @abstract 创建表
 @discussion 通过表名称创建表
 @param ppDb ppDb
 @param tableName 表名
 @param content 创建字段内容
 @result Boolean
 */
- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content;

/*!
 @method createTableForName: tableName: content: completeHandler:
 @abstract 创建表
 @discussion 通过表名称创建表,支持回调操作
 @param ppDb ppDb
 @param tableName 表名
 @param content 创建字段内容
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method createTableForObj: obj: createStyle:
 @abstract 创建表
 @discussion 通过对象创建表
 @param ppDb ppDb
 @param obj 对象
 @param createStyle 主键类型
 @result Boolean
 */
- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj createStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)createStyle;

/*!
 @method createTableForObj: obj: createStyle: completeHandler:
 @abstract 创建表
 @discussion 通过对象创建表,支持回调操作
 @param ppDb ppDb
 @param obj 对象
 @param createStyle 主键类型
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj createStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)createStyle completeHandler:(void(^ __nullable)(NSString *tableName,PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method alterTableForName: oldName: newName:
 @abstract 修改表名称
 @discussion 修改表名称
 @param ppDb ppDb
 @param oldName 原表名称
 @param newName 新表名称
 @result BOOL
 */
- (BOOL)alterTableForName:(sqlite3 *)ppDb oldName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName;

/*!
 @method alterTableForName: oldName: newName: completeHandler:
 @abstract 修改表名称
 @discussion 修改表名称,支持回调操作
 @param ppDb ppDb
 @param oldName 原表名称
 @param newName 新表名称
 @param completeHandler 回调操作
 @result BOOL
 */
- (BOOL)alterTableForName:(sqlite3 *)ppDb oldName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method alterTableAddColumn: tableName: columnName: columnType:
 @abstract 修改表结构
 @discussion 修改表结构,添加表列
 @param ppDb ppDb
 @param tableName 表名
 @param columnName 列表名称
 @param columnType 列表类型
 @result BOOL
 */
- (BOOL)alterTableAddColumn:(sqlite3 *)ppDb tableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType;

/*!
 @method alterTableAddColumn: tableName: columnName: columnType: completeHandler:
 @abstract 修改表结构
 @discussion 修改表结构,添加表列,支持回调操作
 @param ppDb ppDb
 @param tableName 表名
 @param columnName 列表名称
 @param columnType 列表类型
 @param completeHandler 回调操作
 @result BOOL
 */
- (BOOL)alterTableAddColumn:(sqlite3 *)ppDb tableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method alterTableForObj: obj:
 @abstract 修改表
 @discussion 修改表,依据对象成员变量修订表结构
 @param ppDb ppDb
 @param obj 对象
 @result BOOL
 */
- (BOOL)alterTableForObj:(sqlite3 *)ppDb obj:(id)obj;

/*!
 @method alterTableForObj: obj: completeHandler:
 @abstract 修改表
 @discussion 修改表,依据对象成员变量修订表结构,支持回调操作
 @param ppDb ppDb
 @param obj 对象
 @param completeHandler 回调操作
 @result BOOL
 */
- (BOOL)alterTableForObj:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method dropTableForTableName: tableName:
 @abstract 删除表
 @discussion 通过表名称删除表
 @param ppDb ppDb
 @param tableName 表名称
 @result BOOL
 */
- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName;

/*!
 @method dropTableForTableName: tableName: completeHandler:
 @abstract 删除表
 @discussion 通过表名称删除表
 @param ppDb ppDb
 @param tableName 表名称
 @param completeHandler 回调操作
 @result BOOL
 */
- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/*!
 @method dropTableForObj:
 @abstract 删除表
 @discussion 通过对象删除表
 @param ppDb ppDb
 @param obj 对象
 @result BOOL
 */
- (Boolean)dropTableForObj:(sqlite3 *)ppDb obj:(id)obj;

/*!
 @method dropTableForObj: completeHandler:
 @abstract 删除表
 @discussion 通过对象删除表,支持回调操作
 @param ppDb ppDb
 @param obj 对象
 @param completeHandler 回调操作
 @result BOOL
 */
- (Boolean)dropTableForObj:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

@end

NS_ASSUME_NONNULL_END
