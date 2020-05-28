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

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteDataBaseOptions : NSObject

/* 单例模式 */
+ (instancetype)sharePaintingliteDataBaseOptions;

/* 创建表 */
- (Boolean)createTableForSQL:(sqlite3 *)ppDb sql:(NSString *)sql;
- (Boolean)createTableForSQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content;
- (Boolean)createTableForName:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj;
- (Boolean)createTableForObj:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/* 更新表 */

/* 删除表 */
- (Boolean)dropTableForSQL:(sqlite3 *)ppDb sql:(NSString *)sql;
- (Boolean)dropTableForSQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName;
- (Boolean)dropTableForTableName:(sqlite3 *)ppDb tableName:(NSString *)tableName completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

@end

NS_ASSUME_NONNULL_END
