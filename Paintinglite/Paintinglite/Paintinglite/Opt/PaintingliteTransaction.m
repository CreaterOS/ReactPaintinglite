//
//  PaintingliteTransaction.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/31.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteTransaction.h"

#define Paintinglite_BEGIN_TRANSACTION @"BEGIN"
#define Paintinglite_COMMIT_TRANSACTION @"COMMIT"
#define Paintinglite_ROLLBACK_TRANSACTION @"ROLLBACK"

@implementation PaintingliteTransaction

#pragma mark - 开起事务
+ (Boolean)begainPaintingliteTransaction:(sqlite3 *)ppDb exec:(Boolean (^)(void))exec{
    //开起事务
    sqlite3_exec(ppDb, [Paintinglite_BEGIN_TRANSACTION UTF8String], 0, 0, NULL);
    @try {
        Boolean flag = false;
        
        if (exec != nil) {
            flag = exec();
        }
        
        if (flag) {
            sqlite3_exec(ppDb, [Paintinglite_COMMIT_TRANSACTION UTF8String], 0, 0, NULL);
        }
        
        return flag;
    }  @catch (NSException *exception) {
        //回滚事务
        sqlite3_exec(ppDb, [Paintinglite_ROLLBACK_TRANSACTION UTF8String], 0, 0, NULL);
        [exception raise];
    }
}

#pragma mark - 事务
+ (void)begainPaintingliteTransaction:(sqlite3 *)ppDb{
    sqlite3_exec(ppDb, [Paintinglite_BEGIN_TRANSACTION UTF8String], 0, 0, NULL);
}

#pragma mark - 提交
+ (void)commit:(sqlite3 *)ppDb{
    sqlite3_exec(ppDb, [Paintinglite_COMMIT_TRANSACTION UTF8String], 0, 0, NULL);
}

#pragma mark - 回滚
+ (void)rollback:(sqlite3 *)ppDb{
    sqlite3_exec(ppDb, [Paintinglite_ROLLBACK_TRANSACTION UTF8String], 0, 0, NULL);
}

@end
