//
//  PaintingliteBackUpManager.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/6.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteBackUpManager
 * 用来备份,生成sql文件
 * 支持MySql ORCAL Sqlite SqlServer
 * 建库文件
 * 建表操作文件
 * 插入数据文件
 */

#import <Foundation/Foundation.h>
#import <Sqlite3.h>

typedef NS_ENUM(NSUInteger, PaintingliteBackUpManagerDBType) {
    PaintingliteBackUpSqlite3,
    PaintingliteBackUpMySql,
    PaintingliteBackUpSqlServer,
    PaintingliteBackUpORCALE
};

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteBackUpManager : NSObject

/* 单例模式 */
+ (instancetype)sharePaintingliteBackUpManager;

/**
 * 备份数据库
 * sqliteName -- 数据库名称
 * type -- 数据库类型
 * completeHandler -- 返回路径
 */
- (Boolean)backupDataBaseWithName:(sqlite3 *)ppDb sqliteName:(NSString *)sqliteName type:(PaintingliteBackUpManagerDBType)type completeHandler:(void(^ __nullable)(NSString *saveFilePath))completeHandler;

@end

NS_ASSUME_NONNULL_END
