//
//  PaintingliteSessionManager.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteSessionManager
 * 创建一个Session管理者
 * 连接数据库
 */

#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import "PaintingliteDataBaseOptions.h"
#import "PaintingliteTableOptions.h"
#import "PaintingliteLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteSessionManager : NSObject

/* 单例模式 */
+ (instancetype)sharePaintingliteSessionManager;

/**
 * 连接数据库
 * 数据库的名称
 */
- (Boolean)openSqlite:(NSString *)fileName;

/**
 * 连接数据库
 * 数据库的名称
 * 连接完成的Block操作
 */

- (Boolean)openSqlite:(NSString *)fileName completeHandler:(void(^)(NSString *filePath,PaintingliteSessionError *error,Boolean success))completeHandler;

/**
 * 释放数据库
 */
- (Boolean)releaseSqlite;

- (Boolean)releaseSqliteCompleteHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/**
 * 删除日志文件
 */
- (void)removeLogFile:(NSString *)fileName;

/**
 * 读取日志文件
 */
- (NSString *)readLogFile:(NSString *__nonnull)fileName;

- (NSString *)readLogFile:(NSString *)fileName dateTime:(NSDate *__nonnull)dateTime;

- (NSString *)readLogFile:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus;

/**
 * 创建表
 */
- (Boolean)createTableForSQL:(NSString *)sql;
- (Boolean)createTableForSQL:(NSString *)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content;
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle;
- (Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/**
 * 更新表
 */
- (BOOL)alterTableForSQL:(NSString *)sql;
- (BOOL)alterTableForSQL:(NSString *)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName;
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableAddColumn:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType;
- (BOOL)alterTableAddColumn:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableForObj:(id)obj;
- (BOOL)alterTableForObj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/**
 * 删除表
 */
- (Boolean)dropTableForSQL:(NSString *)sql;
- (Boolean)dropTableForSQL:(NSString *)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)dropTableForTableName:(NSString *)tableName;
- (Boolean)dropTableForTableName:(NSString *)tableName completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)dropTableForObj:(id)obj;
- (Boolean)dropTableForObj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/**
 * 查看数据
 */
- (NSMutableArray *)execQuerySQL:(NSString *__nonnull)sql;
- (Boolean)execQuerySQL:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
- (id)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj;
- (Boolean)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id> *resObjList))completeHandler;

@end

NS_ASSUME_NONNULL_END
