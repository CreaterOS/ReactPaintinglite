//
//  PaintingliteThreadManager.h
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/7/16.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//
/*!
 @header PaintingliteThreadManager
 @abstract PaintingliteThreadManager 提供SDK框架中多线程管理和维护
 @author CreaterOS
 @version 1.00 2020/5/28 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

void runAsynchronouslyOnExecQueue(void (^block)(void));
void runSynchronouslyOnExecQueue(id token,void (^block)(void));

@interface PaintingliteThreadManager : NSObject

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
