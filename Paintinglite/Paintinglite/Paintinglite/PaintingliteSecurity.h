//
//  PaintingliteSecurity.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteSecurity : NSObject

/* 加密 */
+ (NSData *)SecurityBase64:(NSData *)data;
+ (NSString *)StringWithSecurityBase64:(NSString *)str;

/* 解密 */
+ (NSData *)SecurityDecodeBase64:(NSData *)data;
+ (NSString *)StringWithDecodeSecurityBase64:(NSString *)baseStr;

@end

NS_ASSUME_NONNULL_END
