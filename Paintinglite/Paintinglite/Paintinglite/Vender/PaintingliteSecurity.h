//
//  PaintingliteSecurity.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 @abstract PaintingliteSecurityMode 安全模式
 @constant PaintingliteSecurityInsert 插入模式
 @constant PaintingliteSecurityUpdate 更新模式
 @discussion 标识Sqlite3安全操作模式
*/
typedef NS_ENUM(NSUInteger, PaintingliteSecurityMode) {
    PaintingliteSecurityInsert,
    PaintingliteSecurityUpdate
};

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

- (NSString *__nonnull)securitySqlCommand:(NSString *__nonnull)sql type:(PaintingliteSecurityMode)type;
- (NSObject *__nonnull)securityObj:(NSObject *__nonnull)obj;

@end

NS_ASSUME_NONNULL_END
