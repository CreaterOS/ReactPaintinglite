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


/// 加密数据库
/// @param databasePath 数据库路径
/// 自动产生加密KEY
- (Boolean)encryptDatabase:(NSString *__nonnull)databasePath;

/// 解密数据库
- (Boolean)encodeDatabase;

- (NSString *__nonnull)securitySqlCommand:(NSString *__nonnull)sql;
- (NSObject *__nonnull)securityObj:(NSObject *__nonnull)obj;

@end

NS_ASSUME_NONNULL_END
