//
//  PaintingliteCUDOptions.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/4.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteCUDOptions.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteTransaction.h"
#import "PaintingliteExec.h"
#import "PaintingliteException.h"

@interface PaintingliteCUDOptions()
@property (nonatomic,strong)PaintingliteSessionError *sessionError;
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@end

@implementation PaintingliteCUDOptions

#pragma mark - 懒加载
- (PaintingliteSessionError *)sessionError{
    if (!_sessionError) {
        _sessionError = [PaintingliteSessionError sharePaintingliteSessionError];
    }
    
    return _sessionError;
}

- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

#pragma mark - 单例模式
static PaintingliteCUDOptions *_instance = nil;
+ (instancetype)sharePaintingliteCUDOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 增加数据
- (Boolean)insert:(sqlite3 *)ppDb sql:(NSString *)sql{
    return [self insert:ppDb sql:sql completeHandler:nil];
}

#pragma mark - 基本操作
- (Boolean)baseCUD:(sqlite3 *)ppDb sql:(NSString *)sql CUDHandler:(NSString * (^)(void))CUDHandler completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<id> * _Nonnull))completeHandler{
    return [PaintingliteTransaction begainPaintingliteTransaction:ppDb exec:^Boolean{
        Boolean success = false;
        
        __block NSMutableArray *newList = [NSMutableArray array];
        
        //执行的CUD_Block操作
        NSString *tableName = [NSString string];
        if (CUDHandler != nil) tableName = CUDHandler();
        
        //判断表是否存在，判断表的字段
        if (![[self.exec getCurrentTableNameWithJSON] containsObject:[tableName lowercaseString]]){
            [PaintingliteException PaintingliteException:@"表名不存在" reason:@"数据库找不到表名,无法执行操作"];
        }
        
        if ([self.exec sqlite3Exec:ppDb sql:sql]) {
            //查询数据
            success = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",tableName] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
                if (success) {
                    newList = resArray;
                }
            }];
        }
        
        if (completeHandler != nil) {
            completeHandler(self.sessionError,success,newList);
        }
        
        return success;
    }];
}

- (Boolean)insert:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self baseCUD:ppDb sql:sql CUDHandler:^NSString * _Nonnull{
        //获得增加数据sql中的表名称
        //INSERT INTO user(...) VALUES()
        return [[[sql componentsSeparatedByString:@"("][0] componentsSeparatedByString:@" "]lastObject];
    } completeHandler:completeHandler];
}

- (Boolean)insert:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<id> * _Nonnull))completeHandler{
    return [PaintingliteTransaction begainPaintingliteTransaction:ppDb exec:^Boolean{
        Boolean success = false;

        //增加完成重新查询封装成一个新的集合
        __block NSMutableArray *newList = [NSMutableArray array];
        //获得增加数据sql中的表名称
        //INSERT INTO user(...) VALUES()
        NSString *tableName = [[PaintingliteObjRuntimeProperty getObjName:obj] lowercaseString];

        NSLog(@"%@",tableName);

        //判断表是否存在，判断表的字段
        [self.exec isNotExistsTable:tableName];

        //获取表的字段，寻找对应的对象字段
        NSMutableArray *tableInfoArray = [self.exec getTableInfo:ppDb objName:tableName];


        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(",tableName];

        //判断字段相同部分进行赋值
        for(NSUInteger i = 0; i < tableInfoArray.count; i++){
            NSString *tableInfoName = tableInfoArray[i];
            sql = (i == tableInfoArray.count - 1) ? [sql stringByAppendingString:[NSString stringWithFormat:@"%@",tableInfoName]] : [sql stringByAppendingString:[NSString stringWithFormat:@"%@,",tableInfoName]];
        }

        sql = [sql stringByAppendingString:@") VALUES("];

        //获得对应字段的对象的值
        NSMutableDictionary *propertyValue = [PaintingliteObjRuntimeProperty getObjPropertyValue:obj];
        for(NSUInteger i = 0; i < tableInfoArray.count; i++){
            NSString *tableInfoName = tableInfoArray[i];
            sql = (i == tableInfoArray.count - 1) ? [sql stringByAppendingString:[NSString stringWithFormat:@"'%@'",propertyValue[tableInfoName]]] : [sql stringByAppendingString:[NSString stringWithFormat:@"'%@',",propertyValue[tableInfoName]]];
        }

        sql = [sql stringByAppendingString:@");"];

        NSLog(@"%@",sql);
        //增加数据
        if ([self.exec sqlite3Exec:ppDb sql:sql]) {
            //增加数据成功,查询数据
            success = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",tableName] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
                if (success) {
                    newList = resArray;
                }
            }];
        }

        if (completeHandler != nil) {
            completeHandler(self.sessionError,success,newList);
        }

        return success;
    }];
}

#pragma mark - 更新数据
- (Boolean)update:(sqlite3 *)ppDb sql:(NSString *)sql{
    return [self update:ppDb sql:sql completeHandler:nil];
}

- (Boolean)update:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self baseCUD:ppDb sql:sql CUDHandler:^NSString * _Nonnull{
        //获得增加数据sql中的表名称
        //UPDATE user SET name = '...' WHERE age = '...'
        return [[[[[sql uppercaseString] componentsSeparatedByString:@" SET"][0] componentsSeparatedByString:@" "]lastObject] lowercaseString];
    } completeHandler:completeHandler];
}

- (Boolean)update:(sqlite3 *)ppDb obj:(id)obj condition:(NSString * _Nonnull)condition completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<id> * _Nonnull))completeHandler{
    return [PaintingliteTransaction begainPaintingliteTransaction:ppDb exec:^Boolean{
        Boolean success = false;
        
        //增加完成重新查询封装成一个新的集合
        __block NSMutableArray *newList = [NSMutableArray array];
        
        //获得增加数据sql中的表名称
        //UPDATE user SET name = '...' WHERE age = '...'
        NSString *tableName = [[PaintingliteObjRuntimeProperty getObjName:obj] lowercaseString];
        
        //判断表是否存在，判断表的字段
        [self.exec isNotExistsTable:tableName];
        
        //先查看表中已经有的数据然后和obj传入的进行对比,然后判断是否更改
        __block NSMutableArray *tempArray = [NSMutableArray array];
        [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",tableName] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
            if (success) {
                tempArray = resArray;
            }
        }];
        
        //获取表的字段，寻找对应的对象字段
        NSMutableArray *tableInfoArray = [self.exec getTableInfo:ppDb objName:tableName];
        //获得对应字段的对象的值
        NSMutableDictionary *propertyValue = [PaintingliteObjRuntimeProperty getObjPropertyValue:obj];
        
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET ",tableName];
        
        for (NSInteger i = 0; i < tableInfoArray.count; i++) {
            if (propertyValue[tableInfoArray[i]] == NULL) {
                //为nil则获得之前对应原来的值
                continue;
            }
            sql = (i == tableInfoArray.count - 1) ? [sql stringByAppendingString:[NSString stringWithFormat:@"%@='%@'",tableInfoArray[i],propertyValue[tableInfoArray[i]]]] :
            [sql stringByAppendingString:[NSString stringWithFormat:@"%@='%@',",tableInfoArray[i],propertyValue[tableInfoArray[i]]]];
        }
        
        sql = ([sql componentsSeparatedByString:@","][1].length == 0) ? [sql substringWithRange:NSMakeRange(0, sql.length-1)] : sql;
        
        sql = [sql stringByAppendingString:[NSString stringWithFormat:@" WHERE %@",[condition containsString:@"WHERE"] ? [[condition componentsSeparatedByString:@"WHERE "] lastObject] : condition]];
        
        //增加数据
        if ([self.exec sqlite3Exec:ppDb sql:sql]) {
            //增加数据成功,查询数据
            success = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",tableName] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
                if (success) {
                    newList = resArray;
                }
            }];
        }
        
        if (completeHandler != nil) {
            completeHandler(self.sessionError,success,newList);
        }
        
        return success;
    }];
}

#pragma mark - 删除数据
- (Boolean)del:(sqlite3 *)ppDb sql:(NSString *)sql{
    return [self del:ppDb sql:sql completeHandler:nil];
}

- (Boolean)del:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray<id> * _Nonnull))completeHandler{
    return [self baseCUD:ppDb sql:sql CUDHandler:^NSString * _Nonnull{
        //获得增加数据sql中的表名称
        //DELET FROM user WHERE name = '...'
        if ([[sql uppercaseString] containsString:@"WHERE"]) {
            return [[[[[sql uppercaseString] componentsSeparatedByString:@" WHERE"][0] componentsSeparatedByString:@"FROM "]lastObject] lowercaseString];
        }else{
            return [[[[sql uppercaseString] componentsSeparatedByString:@"FROM "]lastObject] lowercaseString];
        }
    } completeHandler:completeHandler];
}

@end
