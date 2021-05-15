//
//  PaintingliteCUDOptions.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/4.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteCUDOptions
 @abstract PaintingliteCUDOptions 提供SDK框架中表的增删改
 @author CreaterOS
 @version 1.00 2020/6/4 Creation (此文档的版本信息)
 */

#import "PaintingliteTableOptions.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteCUDOptions
 @abstract PaintingliteCUDOptions 提供SDK框架中表的增删改
 */
@interface PaintingliteCUDOptions : PaintingliteTableOptions

/*!
 @method sharePaintingliteCUDOptions
 @abstract 单例模式生成PaintingliteCUDOptions对象
 @discussion 生成PaintingliteCUDOptions在项目工程全局中只生成一个实例对象
 @result PaintingliteCUDOptions
 */
+ (instancetype)sharePaintingliteCUDOptions;

/*!
 @method baseCUD: sql: CUDHandler:  completeHandler:
 @abstract 增改删[CUD]操作
 @discussion 增改删[CUD]操作,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param sql 增改删[CUD] sql语句
 @param CUDHandler 增改删[CUD] 回调操作
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)baseCUD:(sqlite3 *)ppDb sql:(NSString *)sql CUDHandler:(NSString *(^)(void))CUDHandler completeHandler:(void (^)(PaintingliteSessionError *sessionerror, Boolean success))completeHandler;

@end

NS_ASSUME_NONNULL_END
