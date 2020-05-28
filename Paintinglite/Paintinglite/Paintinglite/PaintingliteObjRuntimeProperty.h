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

/* 获得属性名称 */
+ (NSMutableDictionary *)getObjPropertyName:(id)obj;

@end

NS_ASSUME_NONNULL_END
