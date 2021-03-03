//
//  PaintingliteWarningHelper.h
//  Paintinglite
//
//  Created by CreaterOS on 2021/3/3.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteWarningHelper : NSObject

/// 警告
/// @param reason 原因
/// @param time 触发时间
/// @param solve 解决方案
/// @param args 其他参数
+ (void)warningReason:(NSString *)reason time:(NSDate *)time solve:(NSString *)solve args:(id __nullable)args;

/// 警告
/// @param reason 原因
/// @param session 会话
/// @param time 触发时间
/// @param solve 解决方案
/// @param args 其他参数
+ (void)warningReason:(NSString *)reason session:(NSString *)session time:(NSDate *)time solve:(NSString *)solve args:(id)args;

@end

NS_ASSUME_NONNULL_END
