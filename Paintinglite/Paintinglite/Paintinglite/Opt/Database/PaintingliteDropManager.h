//
//  PaintingliteDropManager.h
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/8/30.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import <Sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteDropManager : NSObject

+ (instancetype)share;

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
