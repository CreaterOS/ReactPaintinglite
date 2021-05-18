//
//  PaintingliteTableOptionsSelectPQL.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/1.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteTableOptionsSelectPQL
 @abstract PaintingliteTableOptionsSelectPQL 提供SDK框架中PQL语句进行快速查询,PQL语句默认全部查询[FROM user (基本语法是FROM + 类的对象)](统一大写)[1.基本查询 2.条件查询 3.分页查询 4.排序查询 5.模糊查询],结果集直接封装到对象中
 @author CreaterOS
 @version 1.00 2020/5/26 Creation (此文档的版本信息)
 */

#import "PaintingliteTableOptions.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteTableOptions
 @abstract PaintingliteTableOptions 提供SDK框架中PQL语句进行快速查询,PQL语句默认全部查询[FROM user (基本语法是FROM + 类的对象)](统一大写)[1.基本查询 2.条件查询 3.分页查询 4.排序查询 5.模糊查询],结果集直接封装到对象中
 */
@interface PaintingliteTableOptionsSelectPQL : PaintingliteTableOptions

/*!
 @method sharePaintingliteTableOptionsSelectPQL
 @abstract 单例模式生成PaintingliteTableOptionsSelectPQL对象
 @discussion 生成PaintingliteTableOptionsSelectPQL在项目工程全局中只生成一个实例对象
 @result PaintingliteTableOptionsSelectPQL
 */
+ (instancetype)sharePaintingliteTableOptionsSelectPQL;

@end

NS_ASSUME_NONNULL_END
