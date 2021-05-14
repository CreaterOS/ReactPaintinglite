//
//  PaintingliteWarningHelper.h
//  Paintinglite
//
//  Created by CreaterOS on 2021/3/3.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//
/*!
 @header PaintingliteWarningHelper
 @abstract PaintingliteWarningHelper 提供SDK框架中警告异常处理
 @author CreaterOS
 @version 1.00 2021/3/3 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteWarningHelper
 @abstract PaintingliteWarningHelper 提供SDK框架中警告异常处理
 */
@interface PaintingliteWarningHelper : NSObject
/*!
 @method warningReason: time: solve: args:
 @abstract 警告原因,触发时间以及解决方案
 @discussion 警告原因,触发时间以及解决方案
 @param reason 原因
 @param time 触发时间
 @param solve 解决方案
 @param args 其他参数
 */
+ (void)warningReason:(NSString *)reason time:(NSDate *)time solve:(NSString *)solve args:(id __nullable)args;
/*!
 @method warningReason: time: solve: args:
 @abstract 警告原因,触发时间以及解决方案
 @discussion 警告原因,触发时间以及解决方案
 @param reason 原因
 @param session 会话
 @param time 触发时间
 @param solve 解决方案
 @param args 其他参数
 */
+ (void)warningReason:(NSString *)reason session:(NSString *)session time:(NSDate *)time solve:(NSString *)solve args:(id)args;

@end

NS_ASSUME_NONNULL_END
