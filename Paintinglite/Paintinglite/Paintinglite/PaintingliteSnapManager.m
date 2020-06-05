//
//  PaintingliteSnapManager.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/4.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSnapManager.h"
#import "PaintingliteSessionFactory.h"

@interface PaintingliteSnapManager()
@property (nonatomic,strong)PaintingliteSessionFactory *factory; //工厂
@end

#define HAVE_TABLE_SQL @"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"

@implementation PaintingliteSnapManager

#pragma mark - 懒加载
- (PaintingliteSessionFactory *)factory{
    if (!_factory) {
        _factory = [PaintingliteSessionFactory sharePaintingliteSessionFactory];
    }
    
    return _factory;
}

#pragma mark - 单例模式
static PaintingliteSnapManager *_instance = nil;
+ (instancetype)sharePaintingliteSnapManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 表名称的快照
- (void)saveSnap:(sqlite3 *)ppDb{
    [self.factory execQuery:ppDb sql:HAVE_TABLE_SQL status:PaintingliteSessionFactoryTableJSON];
}

#pragma mark - 表结构的快照
- (void)saveTableInfoSnap:(sqlite3 *)ppDb objName:(NSString *)objName{
    NSString *masterSQL = [NSString stringWithFormat:@"PRAGMA table_info(%@)",objName];
    [self.factory execQuery:ppDb sql:masterSQL status:PaintingliteSessionFactoryTableINFOJSON];
}

@end
