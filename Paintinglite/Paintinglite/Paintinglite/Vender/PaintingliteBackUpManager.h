//
//  PaintingliteBackUpManager.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/6.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteBackUpManager
 @abstract PaintingliteBackUpManager 提供SDK框架中备份sql文件,支持备份类型MySql ORCAL Sqlite SqlServer
 @author CreaterOS
 @version 1.00 2020/6/6 Creation (此文档的版本信息)
 */

#import <Foundation/Foundation.h>
#import <Sqlite3.h>
#import "PaintingliteSessionError.h"

/*!
 @abstract PaintingliteBackUpManagerDBType 备份类型
 @constant PaintingliteBackUpSqlite3 Sqlite3
 @constant PaintingliteBackUpMySql 删除表
 @constant PaintingliteBackUpSqlServer SqlServer
 @constant PaintingliteBackUpORCALE ORCALE
 @discussion 备份类型
*/
typedef NS_ENUM(NSUInteger, PaintingliteBackUpManagerDBType) {
    PaintingliteBackUpSqlite3,
    PaintingliteBackUpMySql,
    PaintingliteBackUpSqlServer,
    PaintingliteBackUpORCALE
};

NS_ASSUME_NONNULL_BEGIN

/*!
 @class PaintingliteBackUpManager
 @abstract PaintingliteBackUpManager 提供SDK框架中备份sql文件,支持备份类型MySql ORCAL Sqlite SqlServer
 */
@interface PaintingliteBackUpManager : NSObject

/*!
 @method sharePaintingliteBackUpManager
 @abstract 单例模式生成PaintingliteBackUpManager对象
 @discussion 生成PaintingliteBackUpManager在项目工程全局中只生成一个实例对象
 @result PaintingliteBackUpManager
 */
+ (instancetype)sharePaintingliteBackUpManager;

/*!
 @method backupDataBaseWithName: sqliteName: type: completeHandler:
 @abstract 备份数据库
 @discussion 备份数据库,支持回调操作
 @param sqliteName 数据库名称
 @param type 数据库类型
 @param completeHandler 返回路径
 @result Boolean
 */
- (Boolean)backupDataBaseWithName:(sqlite3 *)ppDb sqliteName:(NSString *)sqliteName type:(PaintingliteBackUpManagerDBType)type completeHandler:(void(^ __nullable)(NSString *saveFilePath))completeHandler;

/*!
 @method backupTableRowWithTableName: sqliteName: type: completeHandler:
 @abstract 根据表名称数组备份
 @discussion 根据表名称数组备份
 @param tableNameArray 表名称数组
 @param ppDb Sqlite3 ppDb
 @result Boolean
 */
- (Boolean)backupTableRowWithTableName:(NSMutableArray<NSString *> *__nonnull)tableNameArray ppDb:(sqlite3 *)ppDb;

/*!
 @method backupTableValueForBeforeOpt:  tableName: completeHandler:
 @abstract 回退一次表数据
 @discussion 回退一次表数据,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param tableName 表名称
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)backupTableValueForBeforeOpt:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName completeHandler:(void(^ __nullable)(PaintingliteSessionError *sessionerror,Boolean success, NSMutableArray<NSDictionary *> *newList))completeHandler;

@end

NS_ASSUME_NONNULL_END
