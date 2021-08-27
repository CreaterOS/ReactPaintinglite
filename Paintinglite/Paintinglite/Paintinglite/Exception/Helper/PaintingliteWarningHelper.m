//
//  PaintingliteWarningHelper.m
//  Paintinglite
//
//  Created by CreaterOS on 2021/3/3.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import "PaintingliteWarningHelper.h"

#define STD_OUT(reason,time,solve,session) NSLog(@"Reson: %@",NSLocalizedString(reason, nil));\
                NSLog(@"Time: %@",time);\
                NSLog(@"Solve: %@",NSLocalizedString(solve, nil));\
                if (session != nil && session.length != 0) {\
                    NSLog(@"Session: %@",NSLocalizedString(session, nil));\
                }\
                if (args != NULL && args != (id)[NSNull null]) {\
                    NSError *error = nil;\
                    NSData *data = [NSJSONSerialization dataWithJSONObject:args options:NSJSONWritingSortedKeys error:&error];\
                    NSString *argStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];\
                    NSLog(@"Args: %@",argStr);\
                }\

@implementation PaintingliteWarningHelper

+ (void)warningReason:(NSString *)reason time:(NSDate *)time solve:(NSString *)solve args:(id)args {
#if DEBUG
    [PaintingliteWarningHelper warningReason:reason session:[NSString string] time:time solve:solve args:args];
#endif
}

+ (void)warningReason:(NSString *)reason session:(NSString *)session time:(NSDate *)time solve:(NSString *)solve args:(id)args {
#if DEBUG
    STD_OUT(reason,time,solve,session);
#endif
}

@end
