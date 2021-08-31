//
//  PaintingliteCreateManager.h
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/8/27.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import <Sqlite3.h>

/*!
 @abstract kPrimaryKeyStyle 主键类型
 @constant kDefault 默认不带主键
 @constant kUUID UUID做主键
 @constant kID ID做主键
 @discussion 主键类型
*/
typedef NS_ENUM(NSUInteger, kPrimaryKeyStyle) {
    kDefault = 0,
    kUUID    = 1 << 0,
    kID      = 1 << 1
};

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteCreateManager : NSObject

+ (instancetype)share;

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
- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj createStyle:(kPrimaryKeyStyle)createStyle;

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
- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj createStyle:(kPrimaryKeyStyle)createStyle completeHandler:(void(^ __nullable)(NSString *tableName,PaintingliteSessionError *error,Boolean success))completeHandler;

@end

NS_ASSUME_NONNULL_END
