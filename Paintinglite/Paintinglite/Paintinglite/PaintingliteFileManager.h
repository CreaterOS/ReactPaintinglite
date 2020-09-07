//
//  PaintingliteFileManager.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/11.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteFileManager : NSFileManager


/// 单例模式
+ (PaintingliteFileManager *)defaultManager;


/// 文件存在性
/// @param filePath 文件地址
- (NSArray<NSString *> *)dictExistsFile:(NSString *__nonnull)filePath;


/// 数据库文件信息
/// @param filePath 文件地址
- (NSDictionary<NSFileAttributeKey, id> *)databaseInfo:(NSString *__nonnull)filePath;

@end

NS_ASSUME_NONNULL_END
