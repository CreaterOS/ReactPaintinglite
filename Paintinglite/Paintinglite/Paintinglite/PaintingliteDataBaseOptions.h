//
//  PaintingliteDataBaseOptions.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteDataBaseOptions
 * 对数据库操作的封装
 * 创建表
 * 更新表
 * 删除表
 */

#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import <Sqlite3.h>

typedef NS_ENUM(NSUInteger, PaintingliteDataBaseOptionsPrimaryKeyStyle) {
    PaintingliteDataBaseOptionsDefault, //默认不带主键
    PaintingliteDataBaseOptionsUUID, //用UUID做主键
    PaintingliteDataBaseOptionsID //用ID做主键
};

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteDataBaseOptions : NSObject


/// 单例模式
+ (instancetype)sharePaintingliteDataBaseOptions;

/// 系统操作
/// @param ppDb ppDb
/// @param sql sql语句
- (Boolean)execTableOptForSQL:(sqlite3 *)ppDb sql:(NSString *)sql;
- (Boolean)execTableOptForSQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 创建表
/// @param ppDb ppDb
/// @param tableName 表名
/// @param content 创建表内容
- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content;

/// 创建表
/// @param tableName 表名
/// @param content 创建字段内容
/// @param completeHandler 回调操作
- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 创建表
/// @param obj 对象
/// @param createStyle 主键类型
- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj createStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)createStyle;

/// 创建表
/// @param obj 对象
/// @param createStyle 主键类型
/// @param completeHandler 回调操作
- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj createStyle:(PaintingliteDataBaseOptionsPrimaryKeyStyle)createStyle completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 修改表
/// @param oldName 原表名称
/// @param newName 新表名称
- (BOOL)alterTableForName:(sqlite3 *)ppDb oldName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName;

/// 修改表
/// @param oldName 原表名称
/// @param newName 新表名称
/// @param completeHandler 回调操作
- (BOOL)alterTableForName:(sqlite3 *)ppDb oldName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 修改表
/// @param tableName 表名
/// @param columnName 列表名称
/// @param columnType 列表类型
- (BOOL)alterTableAddColumn:(sqlite3 *)ppDb tableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType;

/// 修改表
/// @param tableName 表名
/// @param columnName 列表名称
/// @param columnType 列表类型
/// @param completeHandler 回调操作
- (BOOL)alterTableAddColumn:(sqlite3 *)ppDb tableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 修改表
/// @param obj 对象
- (BOOL)alterTableForObj:(sqlite3 *)ppDb obj:(id)obj;

/// 修改表
/// @param obj 对象
/// @param completeHandler 回调操作
- (BOOL)alterTableForObj:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 删除表
/// @param tableName 表名
- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName;

/// 删除表
/// @param tableName 表名
/// @param completeHandler 回调操作
- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

/// 删除表
/// @param obj 对象
- (Boolean)dropTableForObj:(sqlite3 *)ppDb obj:(id)obj;

/// 删除表
/// @param obj 对象
/// @param completeHandler 回调操作
- (Boolean)dropTableForObj:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

@end

NS_ASSUME_NONNULL_END
