//
//  ViewController.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "ViewController.h"
#import "Paintinglite/PaintingliteSessionManager.h"
#import "UserClass.h"
#import "PaintingliteWarningHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];

}

- (void)test {
    PaintingliteSessionManager *manager = [PaintingliteSessionManager sharePaintingliteSessionManager];
    Boolean flag = [manager openSqlite:@"test.db" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
            if (success) {
                NSLog(@"%@",filePath);
            }
    }];
    
    for (NSUInteger i = 0; i < 10000; i++) {
        if (flag) {
            UserClass *user = [UserClass new];
            flag = [manager createTableForObj:user primaryKeyStyle:(PaintingliteDataBaseOptionsDefault) completeHandler:^(NSString *tableName,PaintingliteSessionError * _Nonnull error, Boolean success) {
                        if (success) {
                            NSLog(@"创建表[%@]成功",tableName);
                        }
            }];
            
            if (flag) {
                user.name = @"CreaterOS";
                user.age = [NSNumber numberWithInt:22];
                [manager insertWithObj:user completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
                    if (success) {
                        [manager execQuerySQL:@"select * from userClass" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray) {
                            if (success) {
                                for (NSDictionary *dict in resArray) {
                                    NSLog(@"%@",dict);
                                }
                            }
                        }];
                    }
                }];
                
                user.age = [NSNumber numberWithInt:22];
                [manager updateWithObj:user condition:@"name=CreaterOS" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
                    if (success) {
                        [manager execQuerySQL:@"select * from userClass" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray) {
                            if (success) {
                                for (NSDictionary *dict in resArray) {
                                    NSLog(@"%@",dict);
                                }
                            }
                        }];
                    }
                }];
                
                [manager del:@"DELETE FROM userclass WHERE name = 'CreaterOS'" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
                    if (success) {
                        [manager execQuerySQL:@"select * from userClass" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray) {
                            if (success) {
                                for (NSDictionary *dict in resArray) {
                                    NSLog(@"%@",dict);
                                }
                            }
                        }];
                    }
                }];
            }
        }
    }
}

@end
