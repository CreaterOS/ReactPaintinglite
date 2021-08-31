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
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@end

#define HAVE_TABLE_SQL @"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
#define TABLE_INFO(objName) [NSString stringWithFormat:@"PRAGMA table_info(%@)",objName]
#define SELECT_QUERY_SQL(tableName) [NSString stringWithFormat:@"SELECT * FROM %@",[tableName lowercaseString]]
#define Paintinglite_SNAP_ROOT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
 
@implementation PaintingliteSnapManager

#pragma mark - 懒加载
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
    [[PaintingliteSessionFactory sharePaintingliteSessionFactory] execQuery:ppDb tableName:[NSString string] sql:HAVE_TABLE_SQL status:kSessionFactoryTableCache];
}

#pragma mark - 表结构的快照
- (void)saveTableInfoSnap:(sqlite3 *)ppDb tableName:(NSString *)tableName{
    [[PaintingliteSessionFactory sharePaintingliteSessionFactory] execQuery:ppDb tableName:tableName sql:TABLE_INFO(tableName) status:kSessionFactoryTableINFOCache];
}

@end
