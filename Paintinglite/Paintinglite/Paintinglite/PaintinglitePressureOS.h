//
//  PaintinglitePressureOS.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/23.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintinglitePressureOS
 * sqlite数据库压力测试系统
 * 消耗时间 | 消耗内存
 * 插入读取时间
 * 查询时间测试 | 内存测试 | CPU测试
 * 更新时间测试 | 内存测试 | CPU测试
 * 删除时间测试 | 内存测试 | CPU测试
 * 生成测试报告
 */

#import <UIKit/UIKit.h>
#import "PaintingliteTableOptions.h"

typedef NS_ENUM(NSUInteger, PaintinglitePressureOSSaveType) {
    PaintinglitePressureOSSaveDefault,
    PaintinglitePressureOSSaveTXT
};

NS_ASSUME_NONNULL_BEGIN

@interface PaintinglitePressureOS : PaintingliteTableOptions

@property (nonatomic)PaintinglitePressureOSSaveType saveType; //保存类型

/* 单例模式 */
+ (instancetype)sharePaintinglitePressureOS;

/* 效率测试 */
- (float)paintingliteEfficiency:(void (^__nullable)(void))block;

/* 内存测试 */
- (int64_t)paintingliteMemoryUSE:(void (^__nullable)(void))block;

/* CPU测试 */
- (float)paintingliteCPUUSAGE:(void (^__nullable)(void))block;

/* 数据库压力测试 */
- (Boolean)paintingliteSqlitePressure;

@end

NS_ASSUME_NONNULL_END
