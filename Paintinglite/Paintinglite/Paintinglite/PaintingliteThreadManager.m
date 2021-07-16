//
//  PaintingliteThreadManager.m
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/7/16.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import "PaintingliteThreadManager.h"

void runAsynchronouslyOnExecQueue(void (^block)(void)) {
    if (block == nil) {
        return;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_block_t execBlock = dispatch_block_create(0, ^{
        block();
    });
    dispatch_async(queue, ^{
        execBlock();
    });
}

void runSynchronouslyOnExecQueue(id token,void (^block)(void)) {
    if (block == nil) {
        return;
    }
    
    @synchronized (token) {
        block();
    }

}

@implementation PaintingliteThreadManager

static PaintingliteThreadManager *_instance = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PaintingliteThreadManager alloc] init];
    });

    return _instance;
}

@end
