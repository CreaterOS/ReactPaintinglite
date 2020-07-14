//
//  PaintingliteFileManager.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/11.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteFileManager.h"

@implementation PaintingliteFileManager

#pragma mark - 单例模式
static PaintingliteFileManager *_instance = nil;
+ (PaintingliteFileManager *)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 文件目录
- (NSArray<NSString *> *)dictExistsFile:(NSString *__nonnull)filePath{
    /* 根据传入的文件目录,返回当前文件目录下的所有含有.db后缀的文件名称 */
    NSError *error = nil;
    NSArray<NSString *> *filePathArray = [self contentsOfDirectoryAtPath:filePath error:&error];
    return (NSArray *)filePathArray;
}

#pragma mark - 数据库文件基本信息
- (NSDictionary<NSFileAttributeKey, id> *)databaseInfo:(NSString *__nonnull)filePath{
    if ([self fileExistsAtPath:filePath]) {
        /* 存在则返回信息 */
        NSError *error = nil;
        return [self attributesOfItemAtPath:filePath error:&error];
    }
    
    return NULL;
}

@end
