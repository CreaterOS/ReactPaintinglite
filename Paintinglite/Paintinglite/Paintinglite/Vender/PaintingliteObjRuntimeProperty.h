//
//  PaintingliteObjRuntimeProperty.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/28.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//
/*!
 @header PaintingliteObjRuntimeProperty
 @abstract PaintingliteObjRuntimeProperty 提供SDK框架中Runtime操作
 @author CreaterOS
 @version 1.00 2020/5/28 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteObjRuntimeProperty
 @abstract PaintingliteObjRuntimeProperty 提供SDK框架中Runtime操作
 */
@interface PaintingliteObjRuntimeProperty : NSObject


/*!
 @method getObjName:
 @abstract 获得类的名称
 @discussion 获得类的名称
 @param obj 对象
 @result NSString
 */
+ (NSString *)getObjName:(id)obj;

/*!
 @method getObjPropertyName:
 @abstract 获得属性名称
 @discussion 获得属性名称
 @param obj 对象
 @result NSMutableDictionary
 */
+ (NSMutableDictionary *)getObjPropertyName:(id)obj;

/*!
 @method getObjPropertyType:
 @abstract 获得属性类型
 @discussion 获得属性类型
 @param obj 对象
 @result NSMutableDictionary
 */
+ (NSMutableDictionary *)getObjPropertyType:(id)obj;

/*!
 @method getObjPropertyValue:
 @abstract 获得属性值
 @discussion 获得属性值
 @param obj 对象
 @result NSMutableDictionary
 */
+ (NSMutableDictionary *)getObjPropertyValue:(id)obj;

/*!
 @method setObjPropertyValue: value:
 @abstract 属性方法动态赋值
 @discussion 属性方法动态赋值
 @param obj 对象
 @param value 赋值可变字典
 @result NSMutableDictionary
 */
+ (id)setObjPropertyValue:(id)obj value:(NSMutableDictionary *)value;

/*!
 @method ObjNameExists:
 @abstract 判断是否存在类
 @discussion 判断是否存在类
 @param objName 对象名称
 @result Boolean
 */
+ (Boolean)ObjNameExists:(NSString *)objName;

@end

NS_ASSUME_NONNULL_END
