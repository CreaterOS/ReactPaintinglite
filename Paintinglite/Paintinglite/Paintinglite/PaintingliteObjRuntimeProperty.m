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

        if ([ivarType isEqualToString:@"^q"] || [ivarType isEqualToString:@"^Q"]) {
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

#pragma mark - 属性方法动态赋值
+ (id)setObjPropertyValue:(id)obj value:(NSMutableDictionary *)value{
    unsigned int count = 0;
    obj = [[[obj class] alloc] init];
    Ivar *propertyIvar = class_copyIvarList([obj class], &count);

    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = propertyIvar[i];
        //给ivar赋值value
        NSLog(@"%@",[[value allValues][i] class]);
        
        object_setIvar(obj, ivar, [value allValues][i]);
    }

    return obj;
}

@end
