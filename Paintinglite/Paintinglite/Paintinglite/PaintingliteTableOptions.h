//
//  PaintingliteTableOptions.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/29.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteTableOptions
 * 对表操作的封装
 * 增加数据
 * 更新数据
 * 删除数据
 * 查看数据
 */

#import <Foundation/Foundation.h>
#import "PaintingliteSessionError.h"
#import <Sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteTableOptions : NSObject

/* 单例模式 */
+ (instancetype)sharePaintingliteTableOptions;

/**
 * 查看数据
 * SQL语句
 * PQL语句
 * Obj查找
 */
- (NSMutableArray *)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql;
- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
- (id)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql obj:(id)obj;
- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

@end

NS_ASSUME_NONNULL_END
