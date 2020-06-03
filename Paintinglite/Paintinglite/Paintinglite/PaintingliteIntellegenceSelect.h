//
//  PaintingliteIntellegenceSelect.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/3.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * 智能查询操作
 * 针对多对象的查询分配操作
 * 支持操作
 * 1.基本查询 2.分页查询 3.排序查询 4.万能查询
 */

#import "PaintingliteTableOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteIntellegenceSelect : PaintingliteTableOptions

/* 单例模式 */
+ (instancetype)sharePaintingliteIntellegenceSelect;

#pragma mark - 智能查询操作
/* 基本查询 */
- (Boolean)load:(sqlite3 *)ppDb completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *loadArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

/* 分页查询 */
- (Boolean)limit:(sqlite3 *)ppDb start:(NSUInteger)start end:(NSUInteger)end completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *limitArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

/* 分页查询高级 */
- (Boolean)limit:(sqlite3 *)ppDb startAndEnd:(NSArray<NSArray<NSNumber *> *> *)startAndEnd completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *limitArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

/* 排序查询 */
- (Boolean)orderBy:(sqlite3 *)ppDb orderStyle:(PaintingliteOrderByStyle)orderStyle condation:(NSArray<NSString *> *)condation completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *orderArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

/* 排序查询高级 */
- (Boolean)orderBy:(sqlite3 *)ppDb orderStyleArray:(NSArray<NSString *> *)orderStyleArray condation:(NSArray<NSString *> *)condation completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *orderArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

/* 万能查询 */
- (Boolean)query:(sqlite3 *)ppDb sql:(NSArray<NSString *> *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *orderArray))completeHandler objects:(id)objects,... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
