//
//  ViewController.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "ViewController.h"
#import "Paintinglite/PaintingliteSessionManager.h"
#import "Paintinglite/PaintingliteExec.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    PaintingliteSessionManager *manager = [PaintingliteSessionManager sharePaintingliteSessionManager];
    
    [manager openSqlite:@"sqlite.db"];
//    [manager openSqliteWithFilePath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sqlite.db"]];
    
    NSLog(@"Database file isOpen: %hhu",manager.isOpen);
    NSLog(@"Database file path: %@",manager.databasePath);
    NSLog(@"Database info: %@",[manager databaseInfoDict:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sqlite.db"]]);
    NSLog(@"Database total size: %f",manager.totalSize);
    NSLog(@"Dict has database list: %@",[manager dictExistsDatabaseList:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]]);
    
    PaintingliteExec *exec = [[PaintingliteExec alloc] init];
    NSLog(@"Cache: %@",[exec getCurrentTableNameWithCache]);

    [manager releaseSqlite];
}

@end
