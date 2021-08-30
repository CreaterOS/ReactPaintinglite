//
//  PaintingliteDataBaseOptions.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteDataBaseOptions.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteExec.h"
#import "PaintingliteLog.h"
#import "PaintingliteWarningHelper.h"
#import "PaintingliteObjRuntimeProperty.h"

@interface PaintingliteDataBaseOptions()
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@end

@implementation PaintingliteDataBaseOptions

#pragma mark - 懒加载
- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

#pragma mark - 单例模式
static PaintingliteDataBaseOptions *_instance = nil;
+ (instancetype)sharePaintingliteDataBaseOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.crateManager = [PaintingliteCreateManager share];
        self.alterManager = [PaintingliteAlterManager share];
        self.dropManager = [PaintingliteDropManager share];
    }
    return self;
}


@end
