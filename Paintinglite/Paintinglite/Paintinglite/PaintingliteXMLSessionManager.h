//
//  PaintingliteXMLSessionManager.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/25.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteXMLSessionManager
 * 配置XML文件
 * 实现增删改查基本操作
 * XML格式使用DTD约束
 */

#import "PaintingliteSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteXMLSessionManager : PaintingliteSessionManager

/**
 * 建立SessionManager
 * xmlFileName: 每个类对应一个XML文件,传入XML文件名称
 */
+ (instancetype)buildSesssionManger:(NSString *__nonnull)xmlFileName;

/**
 * 查询一个
 * methodID: XML绑定的Select ID
 * condition: 查询条件
 */
- (NSDictionary *)selectOne:(NSString *__nonnull)methodID condition:(id)condition,... NS_REQUIRES_NIL_TERMINATION;

/* 查询多个 */
- (NSArray<id> *)select:(NSString *__nonnull)methodID condition:(id)condition,... NS_REQUIRES_NIL_TERMINATION;

- (NSArray<id> *)select:(NSString *)methodID obj:(id)obj;

/**
 * 插入
 * methodID: XML绑定的INSERT ID
 * obj: 插入的对象
 */
- (Boolean)insert:(NSString *)methodID obj:(id)obj;

/**
 * 插入返回主键ID
 * methodID: XML绑定的INSERT ID
 * obj: 插入的对象
 */
- (sqlite3_int64)insertReturnPrimaryKeyID:(NSString *)methodID obj:(id)obj;

/**
 * 更新
 * methodID: XML绑定的INSERT ID
 * obj: 插入的对象
 */
- (Boolean)update:(NSString *)methodID obj:(id)obj;

/**
 * 删除
 * methodID: XML绑定的INSERT ID
 * obj: 插入的对象
 */
- (Boolean)del:(NSString *)methodID obj:(id)obj;

@end

NS_ASSUME_NONNULL_END
