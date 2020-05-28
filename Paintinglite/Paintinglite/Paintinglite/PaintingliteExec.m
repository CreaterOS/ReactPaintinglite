//
//  PaintingliteExec.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/28.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteExec.h"
#import "PaintingliteSessionFactory.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteSecurity.h"
#import "PaintingliteLog.h"
#import <objc/runtime.h>

@interface PaintingliteExec()
@property (nonatomic,strong)PaintingliteSessionFactory *factory; //工厂
@property (nonatomic,strong)PaintingliteLog *log; //日志
@end

@implementation PaintingliteExec

#pragma mark - 懒加载
- (PaintingliteSessionFactory *)factory{
    if (!_factory) {
        _factory = [PaintingliteSessionFactory sharePaintingliteSessionFactory];
    }
    
    return _factory;
}

- (PaintingliteLog *)log{
    if (!_log) {
        _log = [PaintingliteLog sharePaintingliteLog];
    }
    
    return _log;
}

#pragma mark - 执行SQL语句
- (Boolean)sqlite3Exec:(sqlite3 *)ppDb sql:(NSString *)sql{
    NSAssert(sql != NULL, @"SQL Not IS Empty");
    
    Boolean flag = false;
    
    @synchronized (self) {
        flag = sqlite3_exec(ppDb, [sql UTF8String], 0, 0, 0) == SQLITE_OK;
        if (flag) {
            //保存快照
            NSString *masterSQL = @"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name";
            [self.factory execQuery:ppDb sql:masterSQL];
            //写入日志
            [self.log writeLogFileOptions:sql status:PaintingliteLogSuccess completeHandler:^(NSString * _Nonnull logFilePath) {
                ;
            }];
        }else{
            [self.log writeLogFileOptions:sql status:PaintingliteLogError completeHandler:^(NSString * _Nonnull logFilePath) {
                ;
            }];
        }
    }
    
    return flag;
}

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName content:(NSString *)content{
    NSAssert(tableName != NULL, @"TableName Not IS Empty");
    
    //根据表名来创建表语句
    //判断JSON文件中是否与这个表
    Boolean flag = true;
    
    @synchronized (self) {
        if ([[self getCurrentTableNameWithJSON] containsObject:tableName]) {
            //包含了就不能创建了
            flag = false;
            
            NSException *exception = [NSException exceptionWithName:@"表明重复" reason:@"数据库中已经含有此表,请重新设置表的名称" userInfo:nil];
            [exception raise];
        }else{
            //创建数据库
            if (flag) {
                NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@\n(\n\t%@\n)",tableName,content];
                NSLog(@"%@",createSQL);
                [self sqlite3Exec:ppDb sql:createSQL];
            }
        }
    }
    
    return flag;
}

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb tableName:(NSString *)tableName{
    NSAssert(tableName != NULL, @"TableName Not IS Empty");
    
    Boolean flag = true;
    
    @synchronized (self) {
        if ([[self getCurrentTableNameWithJSON] containsObject:tableName]) {
            //有表，则删除
            if (flag) {
                NSString *dropSQL = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
                NSLog(@"%@",dropSQL);
                [self sqlite3Exec:ppDb sql:dropSQL];
            }
        }else{
            //不能删除
            flag = false;
            
            NSException *exception = [NSException exceptionWithName:@"表名不存在" reason:@"数据库中未找到表名" userInfo:nil];
            [exception raise];
        }
    }
    
    return flag;
}

- (Boolean)sqlite3Exec:(sqlite3 *)ppDb obj:(id)obj status:(PaintingliteExecStatus)status{
    Boolean flag = false;
    
    @synchronized (self) {
        //获得obj的名称作为表的名称
        NSString *objName = NSStringFromClass([obj class]);
        if (status == PaintingliteExecCreate) {
            //获得obj的成员变量作为表的字段
            NSMutableDictionary *propertyDict = [PaintingliteObjRuntimeProperty getObjPropertyName:obj];
            
            NSMutableString *content = [NSMutableString string];
            
            for (NSString *ivarName in [propertyDict allKeys]) {
                NSString *ivarType = propertyDict[ivarName];
                [content appendFormat:@"%@ %@,",ivarName,ivarType];
            }
            
            content = (NSMutableString *)[content substringWithRange:NSMakeRange(0, content.length-1)];
            
            [self sqlite3Exec:ppDb tableName:[objName lowercaseString] content:content];
        }else if(status == PaintingliteExecDrop){
            [self sqlite3Exec:ppDb tableName:[objName lowercaseString]];
        }
    }
    
    return flag;
}

#pragma mark - 读取JSON文件
- (NSArray *)getCurrentTableNameWithJSON{
    NSError *error = nil;
    
    return [NSJSONSerialization JSONObjectWithData:[PaintingliteSecurity SecurityDecodeBase64:[NSData dataWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Tables_Snap.json"]]] options:NSJSONReadingAllowFragments error:&error][@"TablesSnap"];
}

@end
