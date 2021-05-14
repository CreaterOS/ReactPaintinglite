//
//  PaintingliteShortcutSQL.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/8/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//
/*!
 @header PaintingliteShortcutSQL
 @abstract PaintingliteShortcutSQL 提供SDK框架中部分操作宏定义
 @author CreaterOS
 @version 1.00 2020/8/27 Creation (此文档的版本信息)
 */

#ifndef PaintingliteShortcutSQL_h
#define PaintingliteShortcutSQL_h

/*!
 @method CREATE_TBALE(TABLE_NAME,TABLE_CONTENT)
 @abstract 创建表
 @discussion 创建表
 */
#define CREATE_TBALE(TABLE_NAME,TABLE_CONTENT) [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",TABLE_NAME,TABLE_CONTENT]
/*!
 @method ALTER_TABLE_NAME(OLD_TABLE_NAME,NEW_TABLE_NAME)
 @abstract 修改表
 @discussion 修改表[名称]
 */
#define ALTER_TABLE_NAME(OLD_TABLE_NAME,NEW_TABLE_NAME) [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@",OLD_TABLE_NAME,NEW_TABLE_NAME]
/*!
 @method ALTER_TABLE_ADD_COLUMN(NEW_TABLE_NAME,ADD_COLUMN)
 @abstract 修改表
 @discussion 修改表[列]
 */
#define ALTER_TABLE_ADD_COLUMN(NEW_TABLE_NAME,ADD_COLUMN) [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@",NEW_TABLE_NAME,ADD_COLUMN]
/*!
 @method DROP_TABLE(TABLE_NAME)
 @abstract 删除表
 @discussion 删除表
 */
#define DROP_TABLE(TABLE_NAME) [NSString stringWithFormat:@"DROP TABLE %@",TABLE_NAME]
/*!
 @method INSERT_TABLE(TABLE_NAME,TABLE_COLUMN,TABLE_INSERT_CONTENT)
 @abstract 插入操作
 @discussion 插入操作
 */
#define INSERT_TABLE(TABLE_NAME,TABLE_COLUMN,TABLE_INSERT_CONTENT) [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES %@",TABLE_NAME,TABLE_COLUMN,TABLE_INSERT_CONTENT]
/*!
 @method UPDATE_TABLE(TABLE_NAME,TABLE_UPDATE_SET,TABLE_UPDATE_WHERE)
 @abstract 更新操作
 @discussion 更新操作
 */
#define UPDATE_TABLE(TABLE_NAME,TABLE_UPDATE_SET,TABLE_UPDATE_WHERE) [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",TABLE_NAME,TABLE_UPDATE_SET,TABLE_UPDATE_WHERE]
/*!
 @method DELETE_TABLE(TABLE_NAME,TABLE_DELETE_WHERE)
 @abstract 删除操作
 @discussion 删除操作
 */
#define DELETE_TABLE(TABLE_NAME,TABLE_DELETE_WHERE) [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",TABLE_NAME,TABLE_DELETE_WHERE]

/*!
 @method TRANSACTION
 @abstract 开启事务
 @discussion 开启事务
 */
#define TRANSACTION @"BEGAIN"
/*!
 @method COMMIT
 @abstract 提交
 @discussion 提交
 */
#define COMMIT @"COMMIT"
/*!
 @method ROLLBACK
 @abstract 回滚
 @discussion 回滚
 */
#define ROLLBACK @"ROLLBACK"

#endif
