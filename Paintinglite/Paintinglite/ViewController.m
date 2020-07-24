//
//  ViewController.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "ViewController.h"
#import "Paintinglite/PaintingliteSessionManager.h"
#import "Paintinglite/PaintingliteBackUpManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    PaintingliteSessionManager *manager = [PaintingliteSessionManager sharePaintingliteSessionManager];
  
    [manager openSqlite:@"sqlite"];
    NSLog(@"%@",manager.databasePath);
//
//    [manager execQuerySQL:@"select * from eletest" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray) {
//        if (success) {
//            NSLog(@"%zd",resArray.count);
//        }
//    }];
//    NSLog(@"exec query sql success...");
    
    PaintingliteBackUpManager *backupM = [PaintingliteBackUpManager sharePaintingliteBackUpManager];
    if ([backupM backupDataBaseWithName:[manager getSqlite3] sqliteName:@"sqlite" type:PaintingliteBackUpSqlite3 completeHandler:nil]){
        if([backupM backupTableRowWithTableName:(NSMutableArray *)@[@"eletest",@"bus"] ppDb:[manager getSqlite3]]){
                NSLog(@"backup finish...");
        }
    }
}

@end
