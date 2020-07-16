//
//  PaintingliteSnapManager.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/4.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteSnapManager
 * 管理快照区
 * 写入JSON文件
 */

#import <Foundation/Foundation.h>
#import <Sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteSnapManager : NSObject

/* 单例模式 */
+ (instancetype)sharePaintingliteSnapManager;

/* 保存表名快照 */
- (void)saveSnap:(sqlite3 *)ppDb;

/* 保存表结构快照 */
- (void)saveTableInfoSnap:(sqlite3 *)ppDb tableName:(NSString *)tableName;

/* 保存表数据 */
- (Boolean)saveTableValue:(sqlite3 *)ppDb tableName:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
