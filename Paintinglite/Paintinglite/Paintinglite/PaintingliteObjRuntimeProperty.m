//
//  PaintingliteObjRuntimeProperty.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/28.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteObjRuntimeProperty.h"

@implementation PaintingliteObjRuntimeProperty

#pragma mark - 获得类名称
+ (NSString *)getObjName:(id)obj{
    return  NSStringFromClass([obj class]);
}

#pragma mark - 获得属性名称
+ (NSMutableDictionary *)getObjPropertyName:(id)obj{
    NSMutableDictionary *propertyNameDict = [NSMutableDictionary dictionary];
    
    unsigned int count = 0;
    
    Ivar *propertyIvar = class_copyIvarList([obj class], &count);
    
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = propertyIvar[i];
        
        const char *propertyType = ivar_getTypeEncoding(ivar);
        const char *propertyName = ivar_getName(ivar);
        
        NSString *ivarType = [NSString stringWithFormat:@"%s",propertyType];
        NSString *ivarName = [NSString stringWithFormat:@"%s", propertyName];
        
        //属性名称需要处理_
        ivarName = [ivarName substringFromIndex:1];

        if ([ivarType isEqualToString:@"q"] || [ivarType isEqualToString:@"Q"] || [ivarType isEqualToString:[NSString stringWithFormat:@"@\"NSNumber\""]] ) {
            ivarType = @"INTEGER";
        }else if ([ivarType isEqualToString:[NSString stringWithFormat:@"@\"NSString\""]] || [ivarType isEqualToString:[NSString stringWithFormat:@"@"]]) {
            ivarType = @"TEXT";
        }else{
            ivarType = @"BLOB";
        }
        
        [propertyNameDict setObject:ivarType forKey:ivarName];
        
    }
    
    free(propertyIvar);
    
    return propertyNameDict;
}

#pragma mark - 获得属性类型
+ (NSMutableDictionary *)getObjPropertyType:(id)obj{
    NSMutableDictionary *propertyTypeDict = [NSMutableDictionary dictionary];
    
    unsigned int count = 0;
    
    Ivar *propertyIvar = class_copyIvarList([obj class], &count);
    
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = propertyIvar[i];
        
        const char *propertyType = ivar_getTypeEncoding(ivar);
        const char *propertyName = ivar_getName(ivar);
        
        NSString *ivarType = [NSString stringWithFormat:@"%s",propertyType];
        NSString *ivarName = [NSString stringWithFormat:@"%s", propertyName];
        
        //属性名称需要处理_
        ivarName = [ivarName substringFromIndex:1];
        
        [propertyTypeDict setObject:ivarType forKey:ivarName];
    }
    
    free(propertyIvar);
    
    return propertyTypeDict;
}

#pragma mark - 属性方法动态赋值
/**
 * value: 包含表的结构
 */
+ (id)setObjPropertyValue:(id)obj value:(NSMutableDictionary *)value{
    unsigned int count = 0;
    obj = [[[obj class] alloc] init];
    
    /* obj属性Ivar */
    Ivar *propertyIvar = class_copyIvarList([obj class], &count);

    for (unsigned int i = 0; i < [value allKeys].count; i++) {
        @autoreleasepool {
            //给ivar赋值value
            Ivar ivar = propertyIvar[i];
            
            if (count != [value allKeys].count) {
                if (i == count) {
                    break;
                }
                
                Ivar ivar = propertyIvar[i];
                //说明数据库返回的个数和ivar的个数不相同
                //寻找匹配的字段，进行赋值，没有的字段采用默认值
                if ([[value allKeys] containsObject:[[NSString stringWithUTF8String:ivar_getName(ivar)] substringFromIndex:1]]) {
                     object_setIvar(obj, ivar, [value allValues][[[value allKeys] indexOfObject:[[NSString stringWithUTF8String:ivar_getName(ivar)] substringFromIndex:1]]]);
                }
            }else{
                object_setIvar(obj, ivar, [value allValues][[[value allKeys] indexOfObject:[[NSString stringWithUTF8String:ivar_getName(ivar)] substringFromIndex:1]]]);
            }
        }
    }
    
    return obj;
}

#pragma mark - 获得属性值
+ (NSMutableDictionary *)getObjPropertyValue:(id)obj{
    NSMutableDictionary<NSString *,id> *propertyValueDict = [NSMutableDictionary dictionary];
    
    unsigned int count = 0;
    
    Ivar *propertyIvar = class_copyIvarList([obj class], &count);
    
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = propertyIvar[i];
        
        const char *propertyName = ivar_getName(ivar);

        NSString *ivarName = [NSString stringWithFormat:@"%s", propertyName];
        [propertyValueDict setValue:object_getIvar(obj, ivar) forKey:[ivarName substringFromIndex:1]];
    }
    
    free(propertyIvar);
    
    return propertyValueDict;
}

#pragma mark - 判断是否存在类
+ (Boolean)ObjNameExists:(NSString *)objName{
    return NSClassFromString(objName) != nil;
}

@end
