//
//  PaintingliteSplitTable.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/15.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteSplitTable
 * 拆分数据库的表信息
 * 单一独立的表拆分
 * 基点值设置为10
 * 拆分的文件隐藏
 */

#import "PaintingliteTableOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteSplitTable : PaintingliteTableOptions

/* 单例模式 */
+ (instancetype)sharePaintingliteSplitTable;

/**
 * 切分表
 * tableName : 表名
 * basePoint : 基点切分文件个数
 */
- (Boolean)splitTable:(sqlite3 *)ppDb tabelName:(NSString *__nonnull)tableName basePoint:(NSUInteger)basePoint;

/**
 * 查询操作
 */
- (NSMutableArray *)selectWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName basePoint:(NSUInteger)basePoint;

/**
 * 插入操作
 */
- (Boolean)insertWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint insertSQL:(NSString *)insertSQL;

/**
 * 更新操作
 */
- (Boolean)updateWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint updateSQL:(NSString *)updateSQL;

/**
 * 删除操作
 */
- (Boolean)deleteWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint deleteSQL:(NSString *)deleteSQL;

@end

NS_ASSUME_NONNULL_END
