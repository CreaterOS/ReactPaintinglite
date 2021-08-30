//
//  PaintinglitePressureOS.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/23.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintinglitePressureOS
 @abstract PaintinglitePressureOS 提供SDK框架中数据库压力测试,支持内存测试和CPU测试[查询时间测试｜更新时间测试｜删除测试],生成测试报告
 @author CreaterOS
 @version 1.00 2020/6/23 Creation (此文档的版本信息)
 */

#import <UIKit/UIKit.h>
#import "PaintingliteTableOptions.h"

/*!
 @abstract kPressureSaveType 测试报告保存类型
 @constant kPressureSaveDefault 默认方式 @constant kPressureSaveTXT 文本方式
 @discussion 测试报告保存类型
*/
typedef NS_ENUM(NSUInteger, KPressureSaveType) {
    KPressureSaveDefault,
    KPressureSaveTxt
};

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintinglitePressureOS
 @abstract PaintinglitePressureOS 提供SDK框架中数据库压力测试,支持内存测试和CPU测试[查询时间测试｜更新时间测试｜删除测试],生成测试报告
 */
@interface PaintinglitePressureOS : PaintingliteTableOptions
/*!
 @property saveType
 @abstract 测试报告保存类型
 */
@property (nonatomic)KPressureSaveType saveType;

/*!
 @method sharePaintinglitePressureOS
 @abstract 单例模式生成sharePaintinglitePressureOS对象
 @discussion 生成sharePaintinglitePressureOS在项目工程全局中只生成一个实例对象
 @result sharePaintinglitePressureOS
 */
+ (instancetype)sharePaintinglitePressureOS;

/*!
 @method paintingliteEfficiency:
 @abstract 效率测试
 @discussion 效率测试
 @param block 数据库具体操作
 @result float
 */
- (float)paintingliteEfficiency:(void (^__nullable)(void))block;

/*!
 @method paintingliteMemoryUSE:
 @abstract 内存测试
 @discussion 内存测试
 @param block 数据库具体操作
 @result int64_t
 */
- (int64_t)paintingliteMemoryUSE:(void (^__nullable)(void))block;

/*!
 @method paintingliteCPUUSAGE:
 @abstract CPU测试
 @discussion CPU测试
 @param block 数据库具体操作
 @result float
 */
- (float)paintingliteCPUUSAGE:(void (^__nullable)(void))block;

/*!
 @method paintingliteSqlitePressure:
 @abstract 数据库压力测试
 @discussion 数据库压力测试
 @param firstPressureStr 可变参数[字符串]
 @result Boolean
 */
- (Boolean)paintingliteSqlitePressure:(NSString *)firstPressureStr,... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
