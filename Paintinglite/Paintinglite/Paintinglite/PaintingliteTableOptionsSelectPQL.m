//
//  PaintingliteTableOptionsSelectPQL.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/1.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteTableOptionsSelectPQL.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteTransaction.h"
#import "PaintingliteExecHeader.h"
#import "PaintingliteExec.h"

@interface PaintingliteTableOptionsSelectPQL()
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@property (nonatomic,strong)PaintingliteSessionError *sessionError;
@property (nonatomic,assign)NSUInteger paramterIndex; //下标
@property (nonatomic,strong)id obj; //对象

@end

@implementation PaintingliteTableOptionsSelectPQL

#pragma mark - 懒加载
- (PaintingliteExec *)exec{
    if (!_exec) {
        _exec = [[PaintingliteExec alloc] init];
    }
    
    return _exec;
}

- (PaintingliteSessionError *)sessionError{
    if (!_sessionError) {
        _sessionError = [PaintingliteSessionError sharePaintingliteSessionError];
    }
    
    return _sessionError;
}

#pragma mark - 单例模式
static PaintingliteTableOptionsSelectPQL *_instance = nil;
+ (instancetype)sharePaintingliteTableOptionsSelectPQL{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 截取操作
- (NSString *)subStringISExistsTable:(NSString *__nonnull)PQL{
    NSString *objName = NULL;
    
    //判断表明是否存在，如果存在，则返回表名

    if ([[PQL uppercaseString] containsString:@"WHERE"] || [[PQL uppercaseString] containsString:@"LIMIT"] || [[PQL uppercaseString] containsString:@"ORDER"]) {
        objName = [[[PQL uppercaseString] componentsSeparatedByString:@"FROM "][1] componentsSeparatedByString:@" "][0];
    }else{
        objName = [[PQL uppercaseString] componentsSeparatedByString:@"FROM "][1];
    }

    //首字母大写，其余小写
    objName = [PQL substringWithRange:[[PQL uppercaseString] rangeOfString:objName]];

    //判断是否有这个类
    
    return ([PaintingliteObjRuntimeProperty ObjNameExists:objName]) ? objName : NULL;
}

#pragma mark - 利用PQL语句操作
#pragma mark - 基本查询
- (id)execQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql{
   PaintingliteFun(ppDb, pql,@"execQueryPQL");
}

- (Boolean)execQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    //PQL需要转换为sql语句
    //FROM User
    NSString *objName = [[self subStringISExistsTable:pql] lowercaseString];
    objName = [[[objName substringWithRange:NSMakeRange(0, 1)] uppercaseString] stringByAppendingString:[objName substringFromIndex:1]];
    id obj = [self getObj:objName];

    Boolean success = false;
    
    //带有条件的查询需要追加条件
    //SELECT * FROM user WHERE name = '...'
    //SELECT * FROM user ORDER BY name DESC
    //SELECT * FROM user LIMIT 1,2
    //SELECT * FROM user ...
    if (objName == nil) {
        return false;
    }
    NSString *condatition = ([pql componentsSeparatedByString:objName][1].length != 0) ? [pql componentsSeparatedByString:objName][1] : @"" ;
    NSLog(@"%@",condatition);
    if (objName != nil) {
        NSLog(@"%@",[NSString stringWithFormat:@"SELECT * FROM %@%@",objName,condatition]);
        success = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@%@",objName,condatition] obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
            if (success) {
                if (completeHandler != nil) {
                    completeHandler(self.sessionError,success,resArray,resObjList);
                }
            }
        }];
    }
    
    return success;
}

#pragma mark - 获得对象
- (id)getObj:(NSString *)objName{
    if (objName == nil) {
        return NULL;
    }
    return [[NSClassFromString(objName) alloc] init];
}

#pragma mark - 条件查询
- (id)execPrepareStatementPQL:(sqlite3 *)ppDb{
    __block NSMutableArray *PQLPrepareStatementArray = [NSMutableArray array];

    [self execPrepareStatementPQL:ppDb
                  completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
                      if (success) {
                          PQLPrepareStatementArray = resObjList;
                      }
                  }];

    return PQLPrepareStatementArray;
}

- (Boolean)execPrepareStatementPQL:(sqlite3 *)ppDb completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    Boolean success = false;
    
    //使用SQL封装好的进行查询
    success = [self execPrepareStatementSql:ppDb obj:self.obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            self.obj = nil;
            if (completeHandler != nil) {
                completeHandler(self.sessionError,success,resArray,resObjList);
            }
        }
    }];

    return success;
}

#pragma mark - 条件查询语句
- (void)execQueryPQLPrepareStatementPQL:(NSString *)prepareStatementPQL{
    NSAssert(prepareStatementPQL != NULL, @"PrepareStatementPQL Not Is Empty");
    //PQL转换成为SQL语句
    NSString *objName = [self subStringISExistsTable:prepareStatementPQL];
    NSString *tableName = [objName lowercaseString];
    
    NSString *prepareStatementSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",tableName,[[prepareStatementPQL uppercaseString] componentsSeparatedByString:@" WHERE "][1]];
    self.obj = [self getObj:objName];
    [self execQuerySQLPrepareStatementSql:prepareStatementSQL];
}

- (void)setPrepareStatementPQLParameter:(NSUInteger)index paramter:(NSString *)paramter{
    [self setPrepareStatementSqlParameter:index paramter:paramter];
}

- (void)setPrepareStatementPQLParameter:(NSMutableArray *)paramter{
    [self setPrepareStatementSqlParameter:paramter];
}

#pragma mark - 模糊查询
- (id)execLikeQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql{
    PaintingliteFun(ppDb, pql, @"execLikeQueryPQL");
}

- (Boolean)execLikeQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    //PQL转换成为SQL语句
    NSString *objName = [self subStringISExistsTable:pql];
    NSString *tableName = [objName lowercaseString];
    NSString *likeSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", tableName,[[pql uppercaseString] componentsSeparatedByString:@" WHERE "][1]];
    id obj = [self getObj:objName];
    return [self execQuerySQL:ppDb sql:likeSQL obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(error,success,resArray,resObjList);
            }
        }
    }];
}

#pragma mark - 分页查询
- (id)execLimitQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql{
    PaintingliteFun(ppDb, pql, @"execLimitQueryPQL");
}

- (Boolean)execLimitQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    NSString *objName = [self subStringISExistsTable:pql];
    NSString *tableName = [objName lowercaseString];
    NSString *limitSQL = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %@", tableName,[[pql uppercaseString] componentsSeparatedByString:@" LIMIT "][1]];
    
    id obj = [self getObj:objName];

    return [self execQuerySQL:ppDb sql:limitSQL obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(error,success,resArray,resObjList);
            }
        }
    }];
}

#pragma mark - 排序查询
- (id)execOrderQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql{
    PaintingliteFun(ppDb, pql, @"execOrderQueryPQL");
}

- (Boolean)execOrderQueryPQL:(sqlite3 *)ppDb pql:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    NSString *objName = [self subStringISExistsTable:pql];
    NSString *tableName = [objName lowercaseString];

    NSString *orderSQL = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@", tableName,[[pql uppercaseString] componentsSeparatedByString:@" ORDER BY "][1]];
    id obj = [self getObj:objName];
    return [self execQuerySQL:ppDb sql:orderSQL obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(error,success,resArray,resObjList);
            }
        }
    }];
}

#pragma mark - 万能查询语句
- (id)execPQL:(sqlite3 *)ppDb pql:(NSString *)pql{
    PaintingliteFun(ppDb, pql, @"execPQL");
}

- (Boolean)execPQL:(sqlite3 *)ppDb pql:(NSString *)pql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    
    NSString *tempPql = [pql uppercaseString];

    for (NSString *tempStr in [tempPql componentsSeparatedByString:@" "]) {
        if ([tempStr isEqualToString:@"LIMIT"]) {
            return [self execLimitQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
                if (success) {
                    completeHandler(error,success,resArray,resObjList);
                }
            }];
        }else if ([tempStr isEqualToString:@"ORDER"]){
            return [self execOrderQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
                if (success) {
                    completeHandler(error,success,resArray,resObjList);
                }
            }];
        }else if([tempStr isEqualToString:@"LIKE"]){
            return [self execLikeQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
                if (success) {
                    completeHandler(error,success,resArray,resObjList);
                }
            }];
        }
    }
    
    return [self execQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(error,success,resArray,resObjList);
            }
            
        }
    }];
}

@end
