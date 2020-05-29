//
//  ViewController.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "ViewController.h"
#import "Paintinglite/PaintingliteSessionManager.h"
#import "Paintinglite/PaintingliteSecurity.h"
#import "Paintinglite/PaintingliteDataBaseOptions.h"
#import "Dogs.h"
#import "Mouse.h"
#import "Person.h"
#import "Elephant.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
//    NSString *fileName = [filePath stringByAppendingPathComponent:@"sqlite.db"];
    
    PaintingliteSessionManager *sessionManager = [PaintingliteSessionManager sharePaintingliteSessionManager];

//    Boolean flag = [sessionManager openSqlite:@"sqlite.db"];
    
//    NSLog(@"%hhu",flag);
    
    [sessionManager openSqlite:@"sqlite.db" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"%@",filePath);
            NSLog(@"连接数据库成功...");
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
   
//    NSLog(@"%hhu",[sessionManager releaseSqlite]);
//
//    [sessionManager releaseSqliteCompleteHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"关闭数据库成功...");
//        }
//    }];
//
//    NSLog(@"%hhu",[sessionManager releaseSqlite]);
    
//    [sessionManager removeLogFile:@"sqlite"];
//    NSLog(@"%@",[sessionManager readLogFile:@"sqlite.db"]);
//    NSLog(@"%@",[sessionManager readLogFile:@"sqlite" dateTime:[NSDate date]]);
//    NSLog(@"%@",[sessionManager readLogFile:@"sqlites.db"]);
    
//    NSString *baseStr = [PaintingliteSecurity StringWithSecurityBase64:@"加密操作"];
//    NSLog(@"%@",baseStr);
//    NSLog(@"%@",[PaintingliteSecurity StringWithDecodeSecurityBase64:baseStr]);
    
//    [sessionManager createTableForSQL:@"CREATE TABLE IF NOT EXISTS person(name TEXT,age INTEGER)"];
//    [sessionManager dropTableForSQL:@"DROP TABLE user"];
    
//    [sessionManager createTableForSQL:@"CREATE TABLE IF NOT EXISTS user(name TEXT,age INTEGER)" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"创建表成功");
//        }
//    }];
//
//    [sessionManager dropTableForSQL:@"DROP TABLE teacher" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"%@",@"删除表成功");
//        }
//    }];
//
//    [sessionManager createTableForSQL:@"CREATE TABLE IF NOT EXISTS person(phone TEXT)" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"创建表成功");
//        }
//    }];
//
//
//    NSLog(@"%@",[sessionManager readLogFile:@"sqlite" logStatus:PaintingliteLogSuccess]);
//    NSLog(@"%@",[sessionManager readLogFile:@"sqlite" logStatus:PaintingliteLogError]);
    
//    NSError *error = nil;
//    NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:[PaintingliteSecurity SecurityDecodeBase64:[NSData dataWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Tables_Snap.json"]]] options:NSJSONReadingAllowFragments error:&error][@"TablesSnap"]);

//    [sessionManager createTableForName:@"person" content:@"id INTEGER" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"person表创建成功...");
//        }
//    }];

//    [sessionManager dropTableForTableName:@"user" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"user表删除成功...");
//        }
//    }];
    
//    [sessionManager dropTableForTableName:@"dog"];
    
//    Dogs *dogs = [[Dogs alloc] init];
//    [sessionManager createTableForObj:dogs completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"dog表创建成功...");
//        }
//    }];
    
//    Person *person = [[Person alloc] init];
//
//    [sessionManager dropTableForObj:person completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"dogs表删除成功...");
//        }
//    }];
    
//    [sessionManager alterTableForSQL:@"ALTER TABLE teacher RENAME TO teachers" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"teacher表重新命名成功...");
//        }
//    }];
    
//    [sessionManager alterTableForSQL:@"ALTER TABLE teachers ADD COLUMN year TEXT"];
    
//    [sessionManager alterTableForName:@"teachers" newName:@"teacher" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"teachers表重新命名成功...");
//        }
//    }];
    
//    [sessionManager alterTableAddColumn:@"teachers" columnName:@"phone" columnType:@"TEXT"];
//    
//    Person *person = [[Person alloc] init];
//    [sessionManager alterTableForObj:person completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"person更新成功...");
//        }
//    }];
    
//    Elephant *ele = [[Elephant alloc] init];
//    [sessionManager dropTableForObj:mouse];
//    [sessionManager createTableForObj:ele createStyle:PaintingliteDataBaseOptionsUUID completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"ele创建成功...");
//        }
//    }];
    
    
    
    
}


@end
