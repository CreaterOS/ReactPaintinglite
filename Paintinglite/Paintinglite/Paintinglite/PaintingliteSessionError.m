//
//  PaintingliteSessionError.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSessionError.h"

@implementation PaintingliteSessionError

#pragma mark - 单例模式
static PaintingliteSessionError *_instance = nil;
+ (instancetype)sharePaintingliteSessionError{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"可能是数据库名称问题，无法打开数据库",NSLocalizedFailureReasonErrorKey:@"失败原因:文件打开失败",NSLocalizedRecoverySuggestionErrorKey:@"恢复建议:重新设置文件名称"};
        _instance = [[self alloc] initWithDomain:NSURLErrorDomain code:-1 userInfo:userInfo];
    });
    
    return _instance;
}

@end
