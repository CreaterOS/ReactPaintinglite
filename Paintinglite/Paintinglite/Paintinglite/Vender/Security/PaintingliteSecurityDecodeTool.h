//
//  PaintingliteSecurityDecodeTool.h
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/8/30.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteSecurityDecodeTool : NSObject

/*!
 @method SecurityDecodeBase64:
 @abstract 解密
 @discussion base64解密算法解密二进制数据
 @param data 二进制数据
 @result NSData
 */
+ (NSData *)SecurityDecodeBase64:(NSData *)data;

/*!
 @method StringWithDecodeSecurityBase64:
 @abstract 解密
 @discussion base64解密算法解密字符串数据
 @param baseStr 字符串
 @result NSString
 */
+ (NSString *)StringWithDecodeSecurityBase64:(NSString *)baseStr;

@end

NS_ASSUME_NONNULL_END
