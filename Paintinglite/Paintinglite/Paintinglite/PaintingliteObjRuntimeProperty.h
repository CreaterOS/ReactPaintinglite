//
//  PaintingliteObjRuntimeProperty.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/28.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteObjRuntimeProperty : NSObject

/* 获得类的名称 */
+ (NSString *)getObjName:(id)obj;

/* 获得属性名称 */
+ (NSMutableDictionary *)getObjPropertyName:(id)obj;

/* 获得属性值 */
+ (NSMutableDictionary *)getObjPropertyValue:(id)obj;

/* 属性方法动态赋值 */
+ (id)setObjPropertyValue:(id)obj value:(NSMutableDictionary *)value;

/* 判断是否存在类 */
+ (Boolean)ObjNameExists:(NSString *)objName;

@end

NS_ASSUME_NONNULL_END
