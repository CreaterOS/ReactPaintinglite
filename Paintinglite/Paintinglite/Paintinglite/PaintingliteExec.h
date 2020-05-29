//
//  PaintingliteExec.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/28.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaintingliteDataBaseOptions.h"
#import <Sqlite3.h>

typedef NS_ENUM(NSInteger,PaintingliteExecStatus){
    PaintingliteExecCreate,
    PaintingliteExecDrop,
    PaintingliteExecAlterRename,
    PaintingliteExecAlterAddColumn,
    PaintingliteExecAlterObj
};

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteExec : NSObject

/* 执行SQL语句 */
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb sql:(NSString *)sql;

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content;

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName;

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb obj:(id)obj status:(PaintingliteExecStatus)status createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle;

- (void)sqlite3Exec:(sqlite3 *)ppDb objName:(NSString *)objName;

@end

NS_ASSUME_NONNULL_END
