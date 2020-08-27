//
//  ViewController.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "ViewController.h"
#import "PaintingliteSessionManager.h"
#import "PaintingliteShortcutSQL.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    NSLog(@"%@",CREATE_TBALE(@"user", @"username TEXT,age INTEGER"));
//    NSLog(@"%@",ALTER_TABLE_NAME(@"user", @"USER"));
//    NSLog(@"%@",ALTER_TABLE_ADD_COLUMN(@"user", @"birthday TEXT"));
//    NSLog(@"%@",DROP_TABLE(@"user"));
//    NSLog(@"%@",INSERT_TABLE(@"user", @"username,age", @"('CREATEROS',21),('REYNBRYANT',21)"));
//    NSLog(@"%@",UPDATE_TABLE(@"user", @"age=21", @"age=21"));
//    NSLog(@"%@",DELETE_TABLE(@"user", @"age=21"));
//    NSLog(@"%@",TRANSACTION);
//    NSLog(@"%@",COMMIT);
//    NSLog(@"%@",ROLLBACK);
    
//    [[PaintingliteSessionManager sharePaintingliteSessionManager] openSqlite:@"sqlite.db" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"%@",filePath);
//        }
//    }];
//
//    [[PaintingliteSessionManager sharePaintingliteSessionManager] createTableForName:@"user" content:@"ID INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"CREATE TABLE IS SUCCESS...");
//        }
//    }];
//
//    [[PaintingliteSessionManager sharePaintingliteSessionManager] insert:@"INSERT INTO user(name) VALUES ('CREATEROS')" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"INSERT SUCCESS...");
//        }
//    }];
//
//    [[PaintingliteSessionManager sharePaintingliteSessionManager] insert:@"INSERT INTO user(name) VALUES ('REYNBRYANT')" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"INSERT SUCCESS...");
//        }
//    }];
//
//    [[PaintingliteSessionManager sharePaintingliteSessionManager] insert:@"INSERT INTO user(name) VALUES ('PAINTINGLITE')" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"INSERT SUCCESS...");
//        }
//    }];
//
//    [[PaintingliteSessionManager sharePaintingliteSessionManager] releaseSqlite];
}

@end
