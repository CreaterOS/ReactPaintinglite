//
//  PaintingliteCascadeShowerIUD.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/8.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteCascadeShowerIUD
 * 实现多表插入,多表更新,多表删除的级联操作
 * 对象用数组存储联动的另一个对象，从而达到级联操作
 */

#import "PaintingliteCUDOptions.h"
#import "PaintingliteSessionError.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteCascadeShowerIUD : PaintingliteCUDOptions

/* 单例模式 */
+ (instancetype)sharePaintingliteCascadeShowerIUD;

/* 级联插入 */
- (Boolean)cascadeInsert:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;

/* 级联更改 */
- (Boolean)cascadeUpdate:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> * __nonnull)condatation completeHandler:(void (^__nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;

/* 级联删除 */
- (Boolean)cascadeDelete:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> * __nonnull)condatation completeHandler:(void (^__nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;

@end

NS_ASSUME_NONNULL_END
