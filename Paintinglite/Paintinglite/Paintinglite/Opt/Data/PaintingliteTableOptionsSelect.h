//
//  PaintingliteTableOptionsSelect.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/1.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteTableOptionsSelect
 @abstract PaintingliteTableOptionsSelect 提供SDK框架中表操作
 @author CreaterOS
 @version 1.00 2020/6/1 Creation (此文档的版本信息)
 */

#import <Foundation/Foundation.h>
#import "PaintingliteTableOptions.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteTableOptionsSelect
 @abstract PaintingliteTableOptionsSelect 提供SDK框架中表操作
 */
@interface PaintingliteTableOptionsSelect : PaintingliteTableOptions


/*!
 @method sharePaintingliteTableSelectOptions
 @abstract 单例模式生成PaintingliteTableOptionsSelect对象
 @discussion 生成PaintingliteTableOptionsSelect在项目工程全局中只生成一个实例对象
 @result PaintingliteTableOptionsSelect
 */
+ (instancetype)sharePaintingliteTableSelectOptions;


@end

NS_ASSUME_NONNULL_END
