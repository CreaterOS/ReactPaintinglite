//
//  PaintingliteTableOptionsSelectPQL.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/1.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteTableOptions.h"

/**
 * 使用PQL语句进行快速查询
 * PQL语句默认全部查询
 * PQL语句类比SQL语句
 * 例: FROM user (基本语法是FROM + 类的对象)
 * 统一大写
 * 支持
 * 1.基本查询 2.条件查询 3.分页查询 4.排序查询 5.模糊查询
 * 直接封装到对象中
 */
NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteTableOptionsSelectPQL : PaintingliteTableOptions

/* 单例模式 */
+ (instancetype)sharePaintingliteTableOptionsSelectPQL;

@end

NS_ASSUME_NONNULL_END
