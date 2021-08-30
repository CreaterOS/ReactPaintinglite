//
//  PaintingliteSessionError.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//
/*!
 @header PaintingliteSessionError
 @abstract PaintingliteSessionError 提供SDK框架中会语异常处理
 @author CreaterOS
 @version 1.00 2020/5/26 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteSessionError
 @abstract PaintingliteSessionError 提供SDK框架中会语异常处理
 */
@interface PaintingliteSessionError : NSError

/*!
 @method sharePaintingliteSessionError
 @abstract 单例模式生成sharePaintingliteSessionError对象
 @discussion 生成sharePaintingliteSessionError在项目工程全局中只生成一个实例对象
 @result PaintingliteSessionError
 */
+ (instancetype)sharePaintingliteSessionError;

@end

NS_ASSUME_NONNULL_END
