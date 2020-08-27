//
//  PaintingliteShortcutSQL.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/8/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#ifndef PaintingliteShortcutSQL_h
#define PaintingliteShortcutSQL_h

/* 创建表 */
#define CREATE_TBALE(TABLE_NAME,TABLE_CONTENT) [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",TABLE_NAME,TABLE_CONTENT]
/* 修改表 -- 名称 */
#define ALTER_TABLE_NAME(OLD_TABLE_NAME,NEW_TABLE_NAME) [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@",OLD_TABLE_NAME,NEW_TABLE_NAME]
/* 修改表 -- 添加列 */
#define ALTER_TABLE_ADD_COLUMN(NEW_TABLE_NAME,ADD_COLUMN) [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@",NEW_TABLE_NAME,ADD_COLUMN]
/* 删除表 */
#define DROP_TABLE(TABLE_NAME) [NSString stringWithFormat:@"DROP TABLE %@",TABLE_NAME]
/* 插入语句 */
#define INSERT_TABLE(TABLE_NAME,TABLE_COLUMN,TABLE_INSERT_CONTENT) [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES %@",TABLE_NAME,TABLE_COLUMN,TABLE_INSERT_CONTENT]
/* 更新语句 */
#define UPDATE_TABLE(TABLE_NAME,TABLE_UPDATE_SET,TABLE_UPDATE_WHERE) [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",TABLE_NAME,TABLE_UPDATE_SET,TABLE_UPDATE_WHERE]
/* 删除语句 */
#define DELETE_TABLE(TABLE_NAME,TABLE_DELETE_WHERE) [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",TABLE_NAME,TABLE_DELETE_WHERE]
/* 开启事务 */
#define TRANSACTION @"BEGAIN"
/* 提交 */
#define COMMIT @"COMMIT"
/* 回滚 */
#define ROLLBACK @"ROLLBACK"

#endif /* PaintingliteShortcutSQL_h */
