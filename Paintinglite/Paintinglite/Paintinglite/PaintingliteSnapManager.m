//
//  PaintingliteSnapManager.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/4.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteSnapManager.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteExec.h"

@interface PaintingliteSnapManager()
@property (nonatomic,strong)PaintingliteSessionFactory *factory; //工厂
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
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

- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
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
    [self.factory execQuery:ppDb sql:[NSString stringWithFormat:@"PRAGMA table_info(%@)",objName] status:PaintingliteSessionFactoryTableINFOJSON];
}

#pragma mark - 表的数据快照
- (Boolean)saveTableValue:(sqlite3 *)ppDb tableName:(NSString *)tableName{
    NSMutableArray *queryArray = [self.exec sqlite3ExecQuery:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",[tableName lowercaseString]]];
    //写入JSON文件
    Boolean success = [queryArray writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_VALUE.json",tableName]]  atomically:YES];
    
    return success;
}

@end
