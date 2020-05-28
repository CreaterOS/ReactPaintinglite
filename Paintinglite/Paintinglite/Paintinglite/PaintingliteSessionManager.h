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
 * SQL语句创建
 */
- (Boolean)createTableForSQL:(NSString *)sql;
- (Boolean)createTableForSQL:(NSString *)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content;
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForObj:(id)obj;
- (Boolean)createTableForObj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/**
 * 删除表
 * SQL语句删除
 */
- (Boolean)dropTableForSQL:(NSString *)sql;
- (Boolean)dropTableForSQL:(NSString *)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)dropTableForTableName:(NSString *)tableName;
- (Boolean)dropTableForTableName:(NSString *)tableName completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

@end

NS_ASSUME_NONNULL_END
