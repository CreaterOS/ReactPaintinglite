//
//  PaintingliteSnapManager.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/4.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteSnapManager
 @abstract PaintingliteSnapManager 提供SDK框架中快照保存操作
 @author CreaterOS
 @version 1.00 2020/6/4 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import <Sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class PaintingliteSnapManager
 @abstract PaintingliteSnapManager 提供SDK框架中快照保存操作
 */
@interface PaintingliteSnapManager : NSObject

/*!
 @method PaintingliteSnapManager
 @abstract 单例模式生成PaintingliteSnapManager对象
 @discussion 生成PaintingliteSnapManager在项目工程全局中只生成一个实例对象
 @result PaintingliteSnapManager
 */
+ (instancetype)sharePaintingliteSnapManager;

/*!
 @method saveSnap:
 @abstract 保存表名称快照
 @discussion 保存表名称快照
 @param ppDb Sqlite3 ppDb
 */
- (void)saveSnap:(sqlite3 *)ppDb;

/*!
 @method saveTableInfoSnap: tableName:
 @abstract 保存表结构快照
 @discussion 保存表结构快照
 @param ppDb Sqlite3 ppDb
 @param tableName 数据库表名称
 */
- (void)saveTableInfoSnap:(sqlite3 *)ppDb tableName:(NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
