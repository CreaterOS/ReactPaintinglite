//
//  ViewController.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * 测试SQL操作数据库
 * 表: 创建,删除,修改
 * 表数据: 增加 删除 修改 查询
 */

#import "ViewController.h"
#import "Paintinglite/PaintingliteSessionManager.h"

@interface ViewController ()
@property (nonatomic,strong)PaintingliteSessionManager *sessionM; //会语管理者
@end

@implementation ViewController

#pragma mark - 懒加载
- (PaintingliteSessionManager *)sessionM{
    if (!_sessionM) {
        _sessionM = [PaintingliteSessionManager sharePaintingliteSessionManager];
    }
    
    return _sessionM;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //创建数据库
    [self.sessionM openSqlite:@"sqlite" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"%@",filePath);
        }
    }];
    
    //获得数据库版本信息
    [self sqliteVersion];
    
    //创建表
//    [self execTableForOpt];
    //修改表
    [self alterTable];
    //删除表
//    [self execTableForOptDropTable];
}

#pragma mark - 打开数据库 (运行正常)
#pragma mark - 方法一
- (void)openDB{
    [self.sessionM openSqlite:@"sqlite"];
    [self.sessionM openSqlite:@"sqlite02.db"];
    [self.sessionM openSqlite:@"sqlite03.image"];
    [self.sessionM openSqlite:@"sqlite04.text"];
    [self.sessionM openSqlite:@"sqlite05.."];
}

#pragma mark - 方法二
- (void)openDBCH{
    [self.sessionM openSqlite:@"sqlite06" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"%@",filePath);
        }
    }];
    [self.sessionM openSqlite:@"sqlite07.db" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"%@",filePath);
        }
    }];
    [self.sessionM openSqlite:@"sqlite08.image" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"%@",filePath);
        }
    }];
    [self.sessionM openSqlite:@"sqlite09.text" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"%@",filePath);
        }
    }];
    [self.sessionM openSqlite:@"sqlite10.." completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"%@",filePath);
        }
    }];
}

#pragma mark - 获得数据库版本
- (void)sqliteVersion{
    NSLog(@"%@",[self.sessionM getSqlite3Version]);;
}

#pragma mark - 创建表 (对输入不合法数据类型进行判错 | success判断不准确,需要修改)
#pragma mark - 方法一
- (void)createTable{
//    [self.sessionM createTableForName:@"user" content:@"ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,name TEXT,age INTEGER"];
//    [self.sessionM createTableForName:@"person" content:@"ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,name TEXT,age INT"];
    [self.sessionM createTableForName:@"ele" content:@"ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,name TEXT,age RE"];
}

#pragma mark - 方法二
- (void)createTableCH{
//    [self.sessionM createTableForName:@"teacher" content:@"UUID TEXT NOT NULL PRIMARY KEY,name TEXT,age INTEGER" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"创建表成功...");
//        }
//    }];
    [self.sessionM createTableForName:@"boss" content:@"UUID TEXT NOT NULL PRIMARY KEY,name TEXT,age INTEGER" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"创建表成功...");
        }
    }];
}

#pragma mark - 方法三
- (void)execTableForOptCreate{
//    [self.sessionM execTableOptForSQL:@"CREATE TABLE IF NOT EXISTS shopping(UUID VARCHAR(20) NOT NULL PRIMARY KEY,shoppingName TEXT,shoppingID INT(11))"];
    [self.sessionM execTableOptForSQL:@"CREATE TABLE IF NOT EXISTS cart(UUID VARCHAR(20) NOT NULL PRIMARY KEY,shoppingName TEXT,shoppingID INT(11))" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"创建表成功...");
        }
    }];
}

#pragma mark - 修改表名 (DEBUG: [logging] near ")": syntax error)
#pragma mark - 方法一
- (void)alterTable{
    [self.sessionM alterTableForName:@"cart" newName:@"carts"];
}

#pragma mark - 方法二
- (void)alterTableCH{
    [self.sessionM alterTableForName:@"boss" newName:@"bosses" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"修改表名成功...");
        }
    }];
}

#pragma mark - 方法三
- (void)execTableForOptAlter{
    [self.sessionM execTableOptForSQL:@"ALTER TABLE bosses RENAME TO boss" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"修改表名成功...");
        }
    }];
}

#pragma mark - 修改表字段
#pragma mark - 方法一
- (void)alterTableAdd{
    [self.sessionM alterTableAddColumnWithTableName:@"user" columnName:@"birthday" columnType:@"DATE"];
}

#pragma mark - 方法二
- (void)alterTableAddCH{
    [self.sessionM alterTableAddColumnWithTableName:@"teacher" columnName:@"money" columnType:@"DOUBLE" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"添加字段成功...");
        }
    }];
}

#pragma mark - 方法三
- (void)execTableForOptAlterAddColumn{
    [self.sessionM execTableOptForSQL:@"ALTER TABLE user ADD COLUMN hobby TEXT" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"添加字段成功...");
        }
    }];
}

#pragma mark - 删除表
#pragma mark - 方法一
- (void)dropTable{
    [self.sessionM dropTableForTableName:@"shopping"];
}

#pragma mark - 方法二
- (void)dropTableCH{
    [self.sessionM dropTableForTableName:@"boss" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"删除表成功...");
        }
    }];
}

#pragma mark - 方法三
- (void)execTableForOptDropTable{
    [self.sessionM execTableOptForSQL:@"DROP TABLE teacher" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"删除表成功...");
        }
    }];
}

@end
