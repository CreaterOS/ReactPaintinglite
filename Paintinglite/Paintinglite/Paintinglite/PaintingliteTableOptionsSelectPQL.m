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

    NSString *objName = [NSString string];
    PQL = [PQL uppercaseString];
    //判断表明是否存在，如果存在，则返回表名
    if ([PQL containsString:@"WHERE"]) {
        //含有WHERE
        objName = [[[PQL componentsSeparatedByString:@"FROM "][1] componentsSeparatedByString:@" WHERE"][0]  lowercaseString];
    }else{
        if ([PQL containsString:@"LIMIT"]) {
            //含有Limit
            objName = [[[PQL componentsSeparatedByString:@"FROM "][1] componentsSeparatedByString:@" LIMIT"][0] lowercaseString];
        }else if([PQL containsString:@"ORDER"]){
            //含有ORDER
            objName = [[[PQL componentsSeparatedByString:@"FROM "][1] componentsSeparatedByString:@" ORDER"][0] lowercaseString];
        }else{
            objName = [[PQL componentsSeparatedByString:@"FROM "][1] lowercaseString];
        }
        
    }

    //首字母大写，其余小写
    objName = [[[objName substringWithRange:NSMakeRange(0, 1)] uppercaseString] stringByAppendingString:[objName substringFromIndex:1]];
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
    //FROM user
    NSString *objName = [[self subStringISExistsTable:pql] lowercaseString];
    
    id obj = [self getObj:objName];
    
    Boolean success = false;
    
    if (objName != nil) {
        success = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",objName] obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
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
    return [[NSClassFromString([[[objName substringWithRange:NSMakeRange(0, 1)] uppercaseString] stringByAppendingString:[objName substringFromIndex:1]]) alloc] init];
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
    NSString *prepareStatementSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", [[self subStringISExistsTable:prepareStatementPQL] lowercaseString],[prepareStatementPQL componentsSeparatedByString:@" WHERE "][1]];
    self.obj = [self getObj:[[self subStringISExistsTable:prepareStatementPQL] lowercaseString]];
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
    NSString *likeSQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", [[self subStringISExistsTable:pql] lowercaseString],[pql componentsSeparatedByString:@" WHERE "][1]];
    id obj = [self getObj:[[self subStringISExistsTable:pql] lowercaseString]];
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
    NSString *limitSQL = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %@", [[self subStringISExistsTable:pql] lowercaseString],[pql componentsSeparatedByString:@" LIMIT "][1]];
    id obj = [self getObj:[[self subStringISExistsTable:pql] lowercaseString]];
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
    NSString *orderSQL = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@", [[self subStringISExistsTable:pql] lowercaseString],[pql componentsSeparatedByString:@" ORDER BY "][1]];
    id obj = [self getObj:[[self subStringISExistsTable:pql] lowercaseString]];
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
    
    if ([tempPql containsString:@"LIMIT"]) {
        return [self execLimitQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
            if (success) {
                completeHandler(error,success,resArray,resObjList);
            }
        }];
    }else if ([tempPql containsString:@"ORDER"]){
        return [self execOrderQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
            if (success) {
                completeHandler(error,success,resArray,resObjList);
            }
        }];
    }else if([tempPql containsString:@"LIKE"]){
        return [self execLikeQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
            if (success) {
                completeHandler(error,success,resArray,resObjList);
            }
        }];
    }else{
        return [self execQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
            if (success) {
                completeHandler(error,success,resArray,resObjList);
            }
        }];
    }
}

@end
