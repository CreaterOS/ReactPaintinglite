//
//  PaintingliteSecurity.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSecurity.h"
#import "PaintingliteFileManager.h"
#import "PaintingliteUUID.h"
#import "SSZipArchive.h"

#define ROOT_FILE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]
#define ZIP_NAME @"Encrypt"

@interface PaintingliteSecurity()
@property (nonatomic,strong)PaintingliteFileManager *fileManager; //文件管理者
@end

@implementation PaintingliteSecurity

#pragma mark - 懒加载
- (PaintingliteFileManager *)fileManager{
    if (!_fileManager) {
        _fileManager = [PaintingliteFileManager defaultManager];
    }
    
    return _fileManager;
}

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

#pragma mark - 加密数据库
- (Boolean)encryptDatabase:(NSString *)databasePath{
    //检验数据库是否存在
    if ([self.fileManager fileExistsAtPath:databasePath]) {
        //数据存在进行加密操作
        NSString *key = [PaintingliteUUID getPaintingliteUUID];
//        NSLog(@"key:%@",key);
        //保存用户偏好
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] init];
        [userDefaults setObject:key forKey:@"EncryptKey"];
        //加密字典
        NSString *targetPath = [ROOT_FILE_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",ZIP_NAME]];
//        NSLog(@"targetPath:%@",targetPath);
        
        NSString *sourcePath = databasePath;
        return [SSZipArchive createZipFileAtPath:targetPath withFilesAtPaths:@[sourcePath] withPassword:key];
    }
    
    return false;
}

#pragma mark - 解密数据库
- (Boolean)encodeDatabase{
    //查找当前目录下是否含有zip压缩包文件
    NSString *targetPath = [ROOT_FILE_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",ZIP_NAME]];
//    NSLog(@"targetPath:%@",targetPath);
    if ([self.fileManager fileExistsAtPath:targetPath] && [self.fileManager isReadableFileAtPath:targetPath]) {
        //解压
        NSString *destinationPath = [ROOT_FILE_PATH stringByAppendingPathComponent:ZIP_NAME];
//        NSLog(@"destinationPath:%@",destinationPath);
        NSError *error = nil;
        [self.fileManager createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:nil];
        return [SSZipArchive unzipFileAtPath:targetPath toDestination:destinationPath overwrite:YES password:[[[NSUserDefaults alloc] init] objectForKey:@"EncryptKey"] error:&error];
    }
    
    return false;
}

@end
