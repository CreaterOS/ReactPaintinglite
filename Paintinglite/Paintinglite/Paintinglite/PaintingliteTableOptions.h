//
//  PaintingliteTableOptions.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/29.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteTableOptions
 * 对表操作的封装
 * 增加数据
 * 更新数据
 * 删除数据
 * 查看数据
 */

#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import <Sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteTableOptions : NSObject

/* 单例模式 */
+ (instancetype)sharePaintingliteTableOptions;

/**
 * 查看数据
 * SQL语句
 * PQL语句
 * Obj查找
 */

/* SQL查找 */
- (NSMutableArray *)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;
- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
/* sql查找 -- 封装对象 */
- (id)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql obj:(id)obj;
- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
/**
 * sql查找 -- 添加条件
 * 例: select * from user where id = ? and name = ?
 * 分别设置 id 和 name的值
 * prepareStatement setStatement  ---> 从0开始计数
 * 保存prepareStatementSql语句
 * 通过另一个方法进行传入?对应的值，然后进行查询工作
 */
- (void)execQuerySQLPrepareStatementSql:(NSString *__nonnull)prepareStatementSql;

/**
 * 调用这个方法进行对于问号进行处理
 * 传入参数两个
 * 1. 下标 index
 * 2. 参数值 paramter
 */
- (void)setPrepareStatementSqlParameter:(NSUInteger)index paramter:(NSString *__nonnull)paramter;

/**
 * 递归式的传递参数
 * 传入参数形式使用数组来进行设置
 */
- (void)setPrepareStatementSqlParameter:(NSMutableArray *__nonnull)paramter;

/**
 * 执行查询PrepareStatementSql
 */
- (NSMutableArray *)execPrepareStatementSql:(sqlite3 *)ppDb;
- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
/**
 * 执行查询PrepareStatementSql -- 封装对象
 */
- (id)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj;
- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

@end

NS_ASSUME_NONNULL_END
