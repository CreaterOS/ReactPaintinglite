//
//  PaintingliteSecurity.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSecurity.h"
#import "SSZipArchive/SSZipArchive.h"

@implementation PaintingliteSecurity

#pragma mark - Base64加密
+ (NSData *)SecurityBase64:(NSData *)data{
    return [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (NSString *)StringWithSecurityBase64:(NSString *)str{
    return [[str dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

#pragma mark - Base64解密
+ (NSData *)SecurityDecodeBase64:(NSData *)data{
    return [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

+ (NSString *)StringWithDecodeSecurityBase64:(NSString *)baseStr{
    return [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:baseStr options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
}

#warning 拆分二进制
//#pragma mark - 拆分NSData
//+ (void)dataSplite:(NSString *)filePath{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error = nil;
//
//#pragma mark - 压缩文件
//    // 对文件进行压缩
//    NSArray *pathArr = @[filePath];
//    NSString *zipRootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *zipPath = [zipRootPath stringByAppendingPathComponent:@"DB.zip"];
//
//    //压缩
//    [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:pathArr];
//#pragma mark - 删除文件
//    //删除DB.bd
//    if ([fileManager fileExistsAtPath:filePath]) {
//        [fileManager removeItemAtPath:filePath error:&error];
//    }
//
//#pragma mark - 转换二进制
//    NSMutableData *data = [NSMutableData dataWithContentsOfFile:zipPath];
//
//    //获得字符串长度
//    NSUInteger len = data.length;
//    NSMutableArray<NSMutableData *> *dataStrSplit = [NSMutableArray array];
//
//    //产生随机数,将len切分若干
//    int randomLen = arc4random() % len + 1;
//    [dataStrSplit addObject:[NSMutableData dataWithData:[self SecurityBase64:[data subdataWithRange:NSMakeRange(0, randomLen)]]]];
//    [dataStrSplit addObject:[NSMutableData dataWithData:[self SecurityBase64:[data subdataWithRange:NSMakeRange(randomLen, len-randomLen)]]]];
//
//
//#pragma mark - 删除拆分zip文件
//    if ([fileManager fileExistsAtPath:[zipRootPath stringByAppendingPathComponent:@"DataBase1.zip"]]) {
//        NSError *error = nil;
//        [fileManager removeItemAtPath:[zipRootPath stringByAppendingPathComponent:@"DataBase1.zip"] error:&error];
//    }
//
//    [[dataStrSplit firstObject] writeToFile:[zipRootPath stringByAppendingPathComponent:@"DataBase1.zip"] atomically:YES];
//
//    if ([fileManager fileExistsAtPath:[zipRootPath stringByAppendingPathComponent:@"DataBase2.zip"]]) {
//        NSError *error = nil;
//        [fileManager removeItemAtPath:[zipRootPath stringByAppendingPathComponent:@"DataBase2.zip"] error:&error];
//    }
//
//    [[dataStrSplit lastObject] writeToFile:[zipRootPath stringByAppendingPathComponent:@"DataBase2.zip"] atomically:YES];
//
//#pragma mark - 删除压缩包
//    //删除压缩包
//    if ([fileManager fileExistsAtPath:zipPath]) {
//        [fileManager removeItemAtPath:zipPath error:&error];
//    }
//}

@end
