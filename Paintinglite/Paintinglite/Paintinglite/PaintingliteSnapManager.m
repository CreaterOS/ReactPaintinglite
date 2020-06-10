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
#define TABLE_INFO(objName) [NSString stringWithFormat:@"PRAGMA table_info(%@)",objName]
#define SELECT_QUERY_SQL(tableName) [NSString stringWithFormat:@"SELECT * FROM %@",[tableName lowercaseString]]
#define Paintinglite_SNAP_ROOT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
 
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
    [self.factory execQuery:ppDb sql:TABLE_INFO(objName) status:PaintingliteSessionFactoryTableINFOJSON];
}

#pragma mark - 表的数据快照
- (Boolean)saveTableValue:(sqlite3 *)ppDb tableName:(NSString *)tableName{
    NSMutableArray *queryArray = [self.exec sqlite3ExecQuery:ppDb sql:SELECT_QUERY_SQL(tableName)];
    //写入JSON文件
    return [queryArray writeToFile:[Paintinglite_SNAP_ROOT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_VALUE.json",tableName]] atomically:YES];
}

#pragma mark - 删除所有快照
- (Boolean)removeSnap:(NSString *__nonnull)tableName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileValuePath = [Paintinglite_SNAP_ROOT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_VALUE.json",tableName]];
    NSString *fileInfoSnapPath = [Paintinglite_SNAP_ROOT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"TablesInfo_Snap.json"]];
    NSString *fileSnapPath = [Paintinglite_SNAP_ROOT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"Tables_Snap.json"]];
    
    Boolean success = false;
    NSError *error = nil;
    
    if ([fileManager fileExistsAtPath:fileValuePath]) {
        success = [fileManager removeItemAtPath:fileValuePath error:&error];
    }
    
    if ([fileManager fileExistsAtPath:fileInfoSnapPath]) {
        success = [fileManager removeItemAtPath:fileInfoSnapPath error:&error];
    }
    
    if ([fileManager fileExistsAtPath:fileSnapPath]) {
        success = [fileManager removeItemAtPath:fileSnapPath error:&error];
    }
    
    return success;
}

@end