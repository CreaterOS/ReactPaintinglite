//
//  PaintingliteFileManager.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/11.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//
/*!
 @header PaintingliteFileManager
 @abstract PaintingliteFileManager 提供SDK框架中文件管理操作
 @author CreaterOS
 @version 1.00 2020/7/11 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteFileManager
 @abstract PaintingliteFileManager 提供SDK框架中文件管理操作
 */
@interface PaintingliteFileManager : NSFileManager

/*!
 @method defaultManager
 @abstract 单例模式生成PaintingliteFileManager对象
 @discussion 生成PaintingliteFileManager在项目工程全局中只生成一个实例对象
 @result PaintingliteFileManager
 */
+ (PaintingliteFileManager *)defaultManager;

/*!
 @method dictExistsFile:
 @abstract 文件存在性
 @discussion 判定文件是否存在
 @param filePath 文件绝对路径
 @result NSArray<NSString *>
 */
- (NSArray<NSString *> *)dictExistsFile:(NSString *__nonnull)filePath;

/*!
 @method databaseInfo:
 @abstract 数据库文件信息
 @discussion 数据库文件信息
 @param filePath 文件绝对路径
 @result NSDictionary<NSFileAttributeKey, id>
 */
- (NSDictionary<NSFileAttributeKey, id> *)databaseInfo:(NSString *__nonnull)filePath;

@end

NS_ASSUME_NONNULL_END
