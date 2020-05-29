//
//  PaintingliteException.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/29.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteException.h"

@implementation PaintingliteException

#pragma mark - 抛出异常
+ (void)PaintingliteException:(NSString *)exceptionWithName reason:(NSString *)reason{
    NSException *exception = [NSException exceptionWithName:exceptionWithName reason:reason userInfo:nil];
    [exception raise];
}

@end
