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
+ (void)paintingliteException:(NSString *)exceptionWithName reason:(NSString *)reason{
    NSLog(@"Exception: %@ Reason: %@",exceptionWithName,reason);
}

+ (void)paintingliteDictException:(NSDictionary *)info{
    NSLog(@"%@",info);
}

+ (void)paintingliteXMLException:(NSString *)exceptionWithName reason:(NSString *)reason{
     NSLog(@"Exception: %@ Reason: %@",exceptionWithName,reason);
}

@end
