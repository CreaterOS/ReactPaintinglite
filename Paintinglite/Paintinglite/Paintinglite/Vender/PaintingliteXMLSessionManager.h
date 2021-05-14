//
//  PaintingliteXMLSessionManager.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/25.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteXMLSessionManager
 @abstract PaintingliteSessionManager提供SDK框架中XML配置数据库操作管理者，提供了大量的数据库操作方式
 @author CreaterOS
 @version 1.00 2020/7/25 Creation (此文档的版本信息)
 */

#import "PaintingliteSessionManager.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteXMLSessionManager
 @abstract PaintingliteXMLSessionManager PaintingliteSessionManager提供SDK框架中XML配置数据库操作管理者，提供了大量的数据库操作方式
 */
@interface PaintingliteXMLSessionManager : PaintingliteSessionManager

/*!
 @method buildSesssionManger:
 @abstract 构建XML SessionManager
 @discussion 构建XML SessionManager
 @param xmlFileName 每个类对应一个XML文件,传入XML文件名称
 @result PaintingliteSessionManager
 */
+ (instancetype)buildSesssionManger:(NSString *__nonnull)xmlFileName;

/*!
 @method selectOne: condition:
 @abstract 查询一个
 @discussion 查询一个
 @param methodID XML绑定的Select ID
 @param condition 查询条件
 @result NSDictionary
 */
- (NSDictionary *)selectOne:(NSString *__nonnull)methodID condition:(id)condition,... NS_REQUIRES_NIL_TERMINATION;

/*!
 @method select: condition:
 @abstract 查询多个
 @discussion 查询多个
 @param methodID XML绑定的Select ID
 @param condition 查询条件
 @result NSArray<id>
 */
- (NSArray<id> *)select:(NSString *__nonnull)methodID condition:(id)condition,... NS_REQUIRES_NIL_TERMINATION;

/*!
 @method select: obj:
 @abstract 查询多个
 @discussion 查询多个
 @param methodID XML绑定的Select ID
 @param obj 对象
 @result NSArray<id>
 */
- (NSArray<id> *)select:(NSString *)methodID obj:(id)obj;

/*!
 @method insert: obj:
 @abstract 插入
 @discussion 插入
 @param methodID XML绑定的INSERT ID
 @param obj 对象
 @result Boolean
 */
- (Boolean)insert:(NSString *)methodID obj:(id)obj;

/*!
 @method insertReturnPrimaryKeyID: obj:
 @abstract 插入返回主键ID
 @discussion 插入返回主键ID
 @param methodID XML绑定的INSERT ID
 @param obj 对象
 @result sqlite3_int64
 */
- (sqlite3_int64)insertReturnPrimaryKeyID:(NSString *)methodID obj:(id)obj;

/*!
 @method update: obj:
 @abstract 更新
 @discussion 更新
 @param methodID XML绑定的INSERT ID
 @param obj 对象
 @result Boolean
 */
- (Boolean)update:(NSString *)methodID obj:(id)obj;

/*!
 @method del: obj:
 @abstract 删除
 @discussion 删除
 @param methodID XML绑定的INSERT ID
 @param obj 对象
 @result Boolean
 */
- (Boolean)del:(NSString *)methodID obj:(id)obj;

@end

NS_ASSUME_NONNULL_END
