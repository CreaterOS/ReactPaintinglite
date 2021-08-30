//
//  PaintingliteSecurityCodeTool.h
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/8/30.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
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

@interface PaintingliteSecurityCodeTool : NSObject

/*!
 @method SecurityBase64:
 @abstract 加密
 @discussion base64加密算法加密二进制数据
 @param data 二进制数据
 @result NSData
 */
+ (NSData *)SecurityBase64:(NSData *)data;

/*!
 @method StringWithSecurityBase64:
 @abstract 加密
 @discussion base64加密算法加密字符串数据
 @param str 字符串
 @result NSString
 */
+ (NSString *)StringWithSecurityBase64:(NSString *)str;

/*!
 @method securitySqlCommand: type:
 @abstract 加密
 @discussion base64加密算法加密sql语句
 @param sql sql语句
 @param type 安全模式
 @result NSString
 */
- (NSString *__nonnull)securitySqlCommand:(NSString *__nonnull)sql type:(PaintingliteSecurityMode)type;

/*!
 @method securityObj:
 @abstract 加密
 @discussion base64加密算法加密obj对象
 @param obj 对象
 @result NSObject
 */
- (NSObject *__nonnull)securityObj:(NSObject *__nonnull)obj;

@end

NS_ASSUME_NONNULL_END
