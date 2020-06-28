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

@end
