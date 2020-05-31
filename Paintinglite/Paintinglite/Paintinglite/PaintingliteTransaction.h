//
//  PaintingliteTransaction.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/31.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sqlite3.h>

/**
 * PaintingliteTransaction
 * 事务操作
 */

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteTransaction : NSObject

/* 开起事务 */
+ (Boolean)begainPaintingliteTransaction:(sqlite3 *)ppDb exec:(Boolean (^)(void))exec;

@end

NS_ASSUME_NONNULL_END
