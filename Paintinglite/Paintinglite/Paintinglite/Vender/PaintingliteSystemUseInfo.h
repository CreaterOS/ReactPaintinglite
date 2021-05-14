//
//  PaintingliteSystemUseInfo.h
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/5/13.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteSystemUseInfo
 @abstract PaintingliteSystemUseInfo 提供SDK框架中内存压力
 @author CreaterOS
 @version 1.00 2020/5/26 Creation (此文档的版本信息)
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class PaintingliteSystemUseInfo
 @abstract PaintingliteSystemUseInfo 提供SDK框架中内存压力
 */
@interface PaintingliteSystemUseInfo : NSObject

/*!
 @method sharePaintingliteSystemUseInfo
 @abstract 单例模式生成PaintingliteSystemUseInfo对象
 @discussion 生成PaintingliteSystemUseInfo在项目工程全局中只生成一个实例对象
 @result PaintingliteSystemUseInfo
 */
+ (instancetype)sharePaintingliteSystemUseInfo;

/*!
 @method applicationCPU
 @abstract 占用CPU
 @discussion 占用CPU
 @result double
 */
- (double)applicationCPU;

/*!
 @method applicationMemory
 @abstract 占用内存
 @discussion 占用内存
 @result double
 */
- (double)applicationMemory;

/*!
 @method systemCPU
 @abstract 系统CPU
 @discussion 系统CPU
 @result double
 */
- (double)systemCPU;

/*!
 @method systemMemory
 @abstract 系统内存
 @discussion 系统内存
 @result double
 */
- (double)systemMemory;

@end

NS_ASSUME_NONNULL_END
