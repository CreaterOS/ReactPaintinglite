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
@end

NS_ASSUME_NONNULL_END
