//
//  PaintingliteTransaction.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/31.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteTransaction.h"

@implementation PaintingliteTransaction

#pragma mark - 开起事务
+ (Boolean)begainPaintingliteTransaction:(sqlite3 *)ppDb exec:(Boolean (^)(void))exec{
    //开起事务
    sqlite3_exec(ppDb, [@"BEGIN TRANSACTION" UTF8String], 0, 0, NULL);
    
    @try {
        Boolean flag = false;
        
        if (exec != nil) {
            flag = exec();
        }
        
        if (flag) {
            sqlite3_exec(ppDb, [@"COMMIT" UTF8String], 0, 0, NULL);
        }
        
        return flag;
    }  @catch (NSException *exception) {
        //回滚事务
        sqlite3_exec(ppDb, [@"ROLLBACK" UTF8String], 0, 0, NULL);
        [exception raise];
    }
}

@end
