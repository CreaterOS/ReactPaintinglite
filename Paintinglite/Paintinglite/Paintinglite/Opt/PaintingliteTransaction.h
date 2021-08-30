//
//  PaintingliteTransaction.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/31.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteTransaction
 @abstract PaintingliteTransaction 提供SDK框架中Sqlite3事务操作
 @author CreaterOS
 @version 1.00 2020/5/31 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import <Sqlite3.h>


NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteTransaction
 @abstract PaintingliteTransaction 提供SDK框架中Sqlite3事务操作
 */
@interface PaintingliteTransaction : NSObject

/*!
 @method begainPaintingliteTransaction: exec:
 @abstract 开启事务
 @discussion 开启事务
 @param ppDb Sqlite3 ppDb
 @param exec 执行操作
 @result Boolean
 */
+ (Boolean)begainPaintingliteTransaction:(sqlite3 *)ppDb exec:(Boolean (^)(void))exec;

/*!
 @method begainPaintingliteTransaction
 @abstract 开启事务
 @discussion 开启事务
 @param ppDb Sqlite3 ppDb
 */
+ (void)begainPaintingliteTransaction:(sqlite3 *)ppDb;

/*!
 @method commit:
 @abstract 提交事务
 @discussion 提交事务
 @param ppDb Sqlite3 ppDb
 */
+ (void)commit:(sqlite3 *)ppDb;

/*!
 @method rollback:
 @abstract 回滚事务
 @discussion 回滚事务
 @param ppDb Sqlite3 ppDb
 */
+ (void)rollback:(sqlite3 *)ppDb;

@end

NS_ASSUME_NONNULL_END
