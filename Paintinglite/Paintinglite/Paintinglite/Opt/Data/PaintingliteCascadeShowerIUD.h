//
//  PaintingliteCascadeShowerIUD.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/8.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteCascadeShowerIUD
 @abstract PaintingliteCascadeShowerIUD 实现多表插入,多表更新,多表删除的级联操作,对象用数组存储联动的另一个对象，从而达到级联操作
 @author CreaterOS
 @version 1.00 2020/6/8 Creation (此文档的版本信息)
 */

#import "PaintingliteCUDOptions.h"
#import "PaintingliteSessionError.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteCascadeShowerIUD
 @abstract PaintingliteCascadeShowerIUD 提供SDK框架中表的增删改
 */
@interface PaintingliteCascadeShowerIUD : PaintingliteCUDOptions

/*!
 @method sharePaintingliteCascadeShowerIUD
 @abstract 单例模式生成PaintingliteCascadeShowerIUD对象
 @discussion 生成PaintingliteCascadeShowerIUD在项目工程全局中只生成一个实例对象
 @result PaintingliteCascadeShowerIUD
 */
+ (instancetype)sharePaintingliteCascadeShowerIUD;

/*!
 @method cascadeInsert: obj: completeHandler:
 @abstract 级联插入
 @discussion 级联插入,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param obj 对象
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)cascadeInsert:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;

/*!
 @method cascadeUpdate: obj: condatation: completeHandler:
 @abstract 级联更改
 @discussion 级联更改,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param obj 对象
 @param condatation 更新条件
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)cascadeUpdate:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> * __nonnull)condatation completeHandler:(void (^__nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;

/*!
 @method cascadeDelete: obj: condatation: completeHandler:
 @abstract 级联删除
 @discussion 级联删除,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param obj 对象
 @param condatation 更新条件
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)cascadeDelete:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> * __nonnull)condatation completeHandler:(void (^__nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;

@end

NS_ASSUME_NONNULL_END
