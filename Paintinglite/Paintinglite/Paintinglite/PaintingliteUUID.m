//
//  PaintingliteUUID.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/10.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteUUID.h"

@implementation PaintingliteUUID

#pragma mark - 获得UUID
+ (NSString *)getPaintingliteUUID{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    return [NSString stringWithString:(__bridge NSString * _Nonnull)(uuid_string_ref)];
}

@end
