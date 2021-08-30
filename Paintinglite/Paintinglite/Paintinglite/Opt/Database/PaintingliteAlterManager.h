//
//  PaintingliteAlterManager.h
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/8/30.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import <Sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteAlterManager : NSObject

+ (instancetype)share;

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

@end

NS_ASSUME_NONNULL_END
