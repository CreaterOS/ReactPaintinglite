//
//  PaintingliteIntellegenceSelect.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/3.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteIntellegenceSelect
 @abstract PaintingliteIntellegenceSelect 提供SDK框架中智能查询操作,针对多对象的查询分配操作[1.基本查询 2.分页查询 3.排序查询 4.万能查询]
 @author CreaterOS
 @version 1.00 2020/5/26 Creation (此文档的版本信息)
 */

#import "PaintingliteTableOptions.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteIntellegenceSelect
 @abstract PaintingliteIntellegenceSelect 提供SDK框架中智能查询操作,针对多对象的查询分配操作[1.基本查询 2.分页查询 3.排序查询 4.万能查询]
 */
@interface PaintingliteIntellegenceSelect : PaintingliteTableOptions

/*!
 @method sharePaintingliteIntellegenceSelect
 @abstract 单例模式生成PaintingliteIntellegenceSelect对象
 @discussion 生成PaintingliteIntellegenceSelect在项目工程全局中只生成一个实例对象
 @result PaintingliteIntellegenceSelect
 */
+ (instancetype)sharePaintingliteIntellegenceSelect;

#pragma mark - 智能查询操作

/*!
 @method load: completeHandler: objects:
 @abstract 基本查询
 @discussion 基本查询,支持回调操作
 @param ppDb Sqlite3 ppDb
 @param objects 可变参数,传入多个查询对象类型
 @param completeHandler 回调操作
 @result Boolean
 */
- (Boolean)load:(sqlite3 *)ppDb completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *loadArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

/* 分页查询 */

/// 分页查询
/// @param ppDb ppDb
/// @param start 开始位置,所有查询对象的起始位置数组
/// @param end 结束位置,所有查询对象的结束位置数组
/// @param completeHandler 回调操作
/// @param objects 可变参数,传入多个查询对象类型
- (Boolean)limit:(sqlite3 *)ppDb start:(NSUInteger)start end:(NSUInteger)end completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *limitArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

/// 分页查询高级方法
/// @param ppDb ppDb
/// @param startAndEnd 每个对象的开始和结束组成一个数组,二维数组
/// @param completeHandler 回调操作
/// @param objects 可变参数,传入多个查询对象类型
- (Boolean)limit:(sqlite3 *)ppDb startAndEnd:(NSArray<NSArray<NSNumber *> *> *)startAndEnd completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *limitArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

/// 排序查询
/// @param ppDb ppDb
/// @param orderStyle 排序方式
/// @param condation 每个对象排序字段数组
/// @param completeHandler 回调完成
/// @param objects 可变参数,传入多个查询对象类型
- (Boolean)orderBy:(sqlite3 *)ppDb orderStyle:(PaintingliteOrderByStyle)orderStyle condation:(NSArray<NSString *> *)condation completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *orderArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

/// 排序查询高级
/// @param ppDb ppDb
/// @param orderStyleArray 每个对象排序方式组成的排序数组
/// @param condation 每个对象的排序字段数组
/// @param completeHandler 回调操作
/// @param objects objects 可变参数,传入多个查询对象类型
- (Boolean)orderBy:(sqlite3 *)ppDb orderStyleArray:(NSArray<NSString *> *)orderStyleArray condation:(NSArray<NSString *> *)condation completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *orderArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

/// 万能查询
/// @param ppDb ppDb
/// @param sql sql语句数组
/// @param completeHandler 回调操作
/// @param objects objects 可变参数,传入多个查询对象类型
- (Boolean)query:(sqlite3 *)ppDb sql:(NSArray<NSString *> *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *orderArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
