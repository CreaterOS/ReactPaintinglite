//
//  PaintingliteSecurityDecodeTool.m
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/8/30.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSecurityDecodeTool.h"

@implementation PaintingliteSecurityDecodeTool

#pragma mark - Base64解密
+ (NSData *)SecurityDecodeBase64:(NSData *)data{
    return [[NSData alloc] initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

+ (NSString *)StringWithDecodeSecurityBase64:(NSString *)baseStr{
    return [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:baseStr options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
}

@end
