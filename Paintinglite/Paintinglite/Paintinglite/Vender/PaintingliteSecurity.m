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
#import "PaintingliteObjRuntimeProperty.h"

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

#pragma mark - Sql数据加密
- (NSString *)securitySqlCommand:(NSString *)sql type:(PaintingliteSecurityMode)type{
    Boolean semicolonFlag = [sql containsString:@";"];
    
    __block NSString *tempSql = sql;
    if (semicolonFlag) {
        tempSql = [tempSql substringWithRange:NSMakeRange(0, tempSql.length-1)];
    }
    
    if (type == PaintingliteSecurityInsert) {
        NSArray<NSString *> *elements = [tempSql componentsSeparatedByString:@" "];
        tempSql = elements.lastObject;
        
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([tempSql containsString:@"),"]) {
                NSArray<NSString *> *sqlSubs = [tempSql componentsSeparatedByString:@"),"];
                
                tempSql = [NSString string];
                for (NSUInteger i = 0; i < sqlSubs.count; i++) {
                    @autoreleasepool {
                        NSString *sqlSub = [NSString string];
                        if (i < sqlSubs.count-1) {
                            sqlSub = [sqlSubs[i] stringByAppendingString:@")"];
                        } else {
                            sqlSub = sqlSubs[i];
                        }
                       
                        /// 处理数据
                        sqlSub = [self securityField:sqlSub];
                        
                        if (i < sqlSubs.count-1) {
                            tempSql = [tempSql stringByAppendingString:[sqlSub stringByAppendingString:@","]];
                        } else {
                            tempSql = [tempSql stringByAppendingString:sqlSub];
                        }
                    }
                }
            } else {
                /// 处理数据
                tempSql = [self securityField:tempSql];
            }
            dispatch_semaphore_signal(signal);
        });
        
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
        
        
        sql = [[[sql componentsSeparatedByString:@" ("].firstObject stringByAppendingString:@" "] stringByAppendingString:tempSql];
    }
    else if (type == PaintingliteSecurityUpdate){
        /// set 位置
        NSRange setRange = [[tempSql uppercaseString] rangeOfString:@"SET"];
        NSRange whereRange = [[tempSql uppercaseString] rangeOfString:@"WHERE"];
        /// set语句
        __block NSString *setSql = [tempSql substringWithRange:NSMakeRange(setRange.location+setRange.length+1, whereRange.location-setRange.location-setRange.length-2)];
        /// where语句
        __block NSString *whereSql = [tempSql substringFromIndex:whereRange.location+whereRange.length];
        
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            setSql = [self securityCondition:setSql];
            whereSql = [self securityCondition:whereSql];
            dispatch_semaphore_signal(signal);
        });
        
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
        
        /// 拼接
        sql = [[[[[sql componentsSeparatedByString:[sql substringWithRange:setRange]].firstObject stringByAppendingString:@"set "] stringByAppendingString:setSql] stringByAppendingString:@" where"] stringByAppendingString:whereSql];
    }
    
    if (semicolonFlag) {
        sql = [sql stringByAppendingString:@";"];
    }

    return sql;
}

- (NSObject *)securityObj:(NSObject *)obj {
    NSMutableDictionary *dict = [PaintingliteObjRuntimeProperty getObjPropertyValue:obj];
    
    for (NSString *key in dict.allKeys) {
        @autoreleasepool {
            if ([dict[key] isKindOfClass:[NSString class]]) {
                NSString *value = dict[key];
                value = [[value dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [obj setValue:value forKey:key];
            }
        }
    }

    return obj;
}

- (NSString *__nonnull)securityField:(NSString *__nonnull)field {
    NSString *resultStr = [NSString string];
    
    if ([field containsString:@"("] && [field containsString:@")"]) {
        /// 取出括号中的内容
        field = [field substringWithRange:NSMakeRange(1, field.length-2)];
        if ([field containsString:@","]) {
            NSArray<NSString *> *fieldStrs = [field componentsSeparatedByString:@","];
            
            NSUInteger index = 0;
            for (NSString *field in fieldStrs) {
                @autoreleasepool {
                    NSString *str = [NSString string];
                    if ([field characterAtIndex:0] == '\'' && [field characterAtIndex:field.length-1] == '\'') {
                        str = [field substringWithRange:NSMakeRange(1, field.length-2)];
                        str = [[str dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                        str = [[@"'" stringByAppendingString:str] stringByAppendingString:@"'"];
                    } else {
                        str = field;
                        [[str dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    }
                    
                    if (index < fieldStrs.count-1) {
                        resultStr = [resultStr stringByAppendingString:[str stringByAppendingString:@","]];
                    } else {
                        resultStr = [resultStr stringByAppendingString:str];
                    }
                    
                    index++;
                }
            }
        }
        
        /// 复原括号
        resultStr = [[@"(" stringByAppendingString:resultStr] stringByAppendingString:@")"];
    }
    
    return resultStr;
}

- (NSString *__nonnull)securityCondition:(NSString *__nonnull)condition {
    NSUInteger index = 0;
    NSString *setResultStr = [NSString string];
    if ([condition containsString:@","]) {
        NSArray<NSString *> *sets = [condition componentsSeparatedByString:@","];
        for (NSString *set in sets) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if ([set containsString:@"="]) {
                [dict setValue:[set componentsSeparatedByString:@"="].lastObject forKey:[set componentsSeparatedByString:@"="].firstObject];
            } else if ([set containsString:@" = "]) {
                [dict setValue:[set componentsSeparatedByString:@" = "].lastObject forKey:[set componentsSeparatedByString:@" = "].firstObject];
            }
            
            NSString *value = dict.allValues.firstObject;
            
            if ([value characterAtIndex:0] == '\'' && [value characterAtIndex:value.length-1] == '\'') {
                value = [value substringWithRange:NSMakeRange(1, value.length-2)];
                value = [[value dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                value = [[@"'" stringByAppendingString:value] stringByAppendingString:@"'"];
            } else {
                [[value dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            
            /// 复原语句
            NSString *setRes = [[dict.allKeys.firstObject stringByAppendingString:@"="] stringByAppendingString:value];
            
            if (index < sets.count-1) {
                setResultStr = [setResultStr stringByAppendingString:[setRes stringByAppendingString:@","]];
            } else {
                setResultStr = [setResultStr stringByAppendingString:setRes];
            }
            
            index++;
        }
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if ([condition containsString:@"="]) {
            [dict setValue:[condition componentsSeparatedByString:@"="].lastObject forKey:[condition componentsSeparatedByString:@"="].firstObject];
        } else if ([condition containsString:@" = "]) {
            [dict setValue:[condition componentsSeparatedByString:@" = "].lastObject forKey:[condition componentsSeparatedByString:@" = "].firstObject];
        }
        
        NSString *value = dict.allValues.firstObject;
        
        if ([value characterAtIndex:0] == '\'' && [value characterAtIndex:value.length-1] == '\'') {
            value = [value substringWithRange:NSMakeRange(1, value.length-2)];
            value = [[value dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            value = [[@"'" stringByAppendingString:value] stringByAppendingString:@"'"];
        } else {
            [[value dataUsingEncoding:NSUTF8StringEncoding] base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
        }
        
        /// 复原语句
        setResultStr = [[dict.allKeys.firstObject stringByAppendingString:@"="] stringByAppendingString:value];
    }
    
    return setResultStr;
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

@end
