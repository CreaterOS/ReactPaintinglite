//
//  PaintingliteUUID.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/10.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteUUID
 @abstract PaintingliteUUID 提供SDK框架中生成随机UUID
 @author CreaterOS
 @version 1.00 2020/6/10 Creation (此文档的版本信息)
 */

#import "PaintingliteCUDOptions.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteUUID
 @abstract PaintingliteUUID 提供SDK框架中生成随机UUID
 */
@interface PaintingliteUUID : PaintingliteCUDOptions

/*!
 @method getPaintingliteUUID
 @abstract 获得UUID
 @discussion 获得UUID
 @result NSString
 */
+ (NSString *__nonnull)getPaintingliteUUID;

@end

NS_ASSUME_NONNULL_END
