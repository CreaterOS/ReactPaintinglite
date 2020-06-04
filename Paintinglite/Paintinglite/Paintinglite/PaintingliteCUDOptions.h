//
//  PaintingliteCUDOptions.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/4.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteCUDOptions
 * 表的增删改
 * 增加: 基本SQL执行增加 对象封装增加
 * 删除: 基本SQL执行删除 对象封装删除
 * 更新: 基本SQL执行更新 对象封装更新
 */

#import "PaintingliteTableOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteCUDOptions : PaintingliteTableOptions

/* 单例模式 */
+ (instancetype)sharePaintingliteCUDOptions;

@end

NS_ASSUME_NONNULL_END
