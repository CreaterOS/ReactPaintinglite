//
//  PaintingliteDataBaseOptions.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteDataBaseOptions
 @abstract PaintingliteDataBaseOptions 提供SDK框架中Sqlite3库操作
 @author CreaterOS
 @version 1.00 2020/5/27 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import "PaintingliteCreateManager.h"
#import "PaintingliteAlterManager.h"
#import "PaintingliteDropManager.h"
#import <Sqlite3.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteDataBaseOptions
 @abstract PaintingliteDataBaseOptions 提供SDK框架中Sqlite3库操作
 */
@interface PaintingliteDataBaseOptions : NSObject

@property (nonatomic, strong) PaintingliteCreateManager *crateManager; // 创建表管理者
@property (nonatomic, strong) PaintingliteAlterManager *alterManager; // 修改表管理者
@property (nonatomic, strong) PaintingliteDropManager *dropManager; /// 删除表管理者

/*!
 @method sharePaintingliteDataBaseOptions
 @abstract 单例模式生成PaintingliteDataBaseOptions对象
 @discussion 生成PaintingliteDataBaseOptions在项目工程全局中只生成一个实例对象
 @result PaintingliteDataBaseOptions
 */
+ (instancetype)sharePaintingliteDataBaseOptions;

/*!
 @method execTableOptForSQL: sql:
 @abstract 调用sql语句
 @discussion 原生调用sql语句
 @param ppDb ppDb
 @param sql SQL语句
 @result Boolean
 */
- (Boolean)execTableOptForSQL:(sqlite3 *)ppDb sql:(NSString *)sql;

/*!
 @method execTableOptForSQL: sql: completeHandler:
 @abstract 调用sql语句,支持回调操作
 @discussion 原生调用sql语句,支持回调操作
 @param ppDb ppDb
 @param sql SQL语句
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)execTableOptForSQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;

@end

NS_ASSUME_NONNULL_END
