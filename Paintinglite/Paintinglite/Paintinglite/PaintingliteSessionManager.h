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
#import "PaintingliteDataBaseOptions.h"
#import "PaintingliteTableOptions.h"
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
 */
- (Boolean)createTableForSQL:(NSString *)sql;
- (Boolean)createTableForSQL:(NSString *)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content;
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle;
- (Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/**
 * 更新表
 */
- (BOOL)alterTableForSQL:(NSString *)sql;
- (BOOL)alterTableForSQL:(NSString *)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName;
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableAddColumn:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType;
- (BOOL)alterTableAddColumn:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableForObj:(id)obj;
- (BOOL)alterTableForObj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/**
 * 删除表
 */
- (Boolean)dropTableForSQL:(NSString *)sql;
- (Boolean)dropTableForSQL:(NSString *)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)dropTableForTableName:(NSString *)tableName;
- (Boolean)dropTableForTableName:(NSString *)tableName completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)dropTableForObj:(id)obj;
- (Boolean)dropTableForObj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;

/**
 * 查看数据
 */
- (NSMutableArray *)execQuerySQL:(NSString *__nonnull)sql;
- (Boolean)execQuerySQL:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
- (id)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj;
- (Boolean)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id> *resObjList))completeHandler;
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
- (void)setPrepareStatementSqlParameter:(NSArray *__nonnull)paramter;
/**
 * 执行查询PrepareStatementSql
 */
- (NSMutableArray *)execPrepareStatementSql;
- (Boolean)execPrepareStatementSqlCompleteHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
/**
 * 执行查询PrepareStatementSql -- 封装对象
 */
- (id)execPrepareStatementSqlWithObj:(id)obj;
- (Boolean)execPrepareStatementSqlWithObj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
/**
 * sql查询 -- 模态查询
 * 例: select * from user where name like '%d';
 */
- (NSMutableArray *)execLikeQuerySQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like;
- (Boolean)execLikeQuerySQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
/**
 * sql查询 -- 模态查询 -- 封装对象
 */
- (id)execLikeQuerySQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj;
- (Boolean)execLikeQuerySQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
/**
 * sql查询 -- 分页查询
 * 例: select * from user limit 0,2
 */
- (NSMutableArray *)execLimitQuerySQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end;
- (Boolean)execLimitQuerySQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
/**
 * sql查询 -- 分页查询 -- 封装对象
 * 例: select * from user limit 0,2
 */
- (id)execLimitQuerySQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj;
- (Boolean)execLimitQuerySQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

/**
 * sql查询 -- 排序
 * 例: select * from user order by name ASC
 */
- (NSMutableArray *)execOrderByQuerySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle;
- (Boolean)execOrderByQuerySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
/**
 * sql查询 -- 排序 -- 封装对象
 */
- (id)execOrderByQuerySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj;
- (Boolean)execOrderByQuerySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

@end

NS_ASSUME_NONNULL_END
