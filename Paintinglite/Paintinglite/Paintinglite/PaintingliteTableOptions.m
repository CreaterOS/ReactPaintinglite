//
//  PaintingliteTableOptions.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/29.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteTableOptions.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteExec.h"
#import "PaintingliteTransaction.h"

@interface PaintingliteTableOptions()
@property (nonatomic,strong)PaintingliteSessionError *sessionError;
@property (nonatomic,strong)PaintingliteExec *exec; //执行语句
@property (nonatomic,strong,readwrite,nonnull)NSString *prepareStatementSql;
@property (nonatomic,assign)NSUInteger paramterIndex; //下标
@end

@implementation PaintingliteTableOptions

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
static PaintingliteTableOptions *_instance = nil;
+ (instancetype)sharePaintingliteTableOptions{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}


#pragma mark - 利用SQL语句操作
#pragma mark - 基本查询
- (NSMutableArray *)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql{
    __block NSMutableArray *execQueryArray = [NSMutableArray array];
    [self execQuerySQL:ppDb sql:sql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        if (success) {
            execQueryArray = resArray;
        }
    }];
    
    return execQueryArray;
}

- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    
    return [PaintingliteTransaction begainPaintingliteTransaction:ppDb exec:^Boolean{
        Boolean success = ([self.exec sqlite3ExecQuery:ppDb sql:sql].count != 0);
        NSMutableArray *resArray = [NSMutableArray array];
        
        if (success) {
            resArray = [self.exec sqlite3ExecQuery:ppDb sql:sql];
        }
        
        if (completeHandler != nil) {
            completeHandler(self.sessionError,success,resArray);
        }
        
        return success;
    }];
}

#pragma mark - 封装查询
- (id)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql obj:(id)obj{
    __block id paintingObj = NULL;
    [self execQuerySQL:ppDb sql:sql obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> *  _Nonnull resObjList) {
        paintingObj = resObjList;
    }];
    
    return paintingObj;
}

- (Boolean)execQuerySQL:(sqlite3 *)ppDb sql:(NSString *)sql obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    
    //执行普通查询，然后进行封装
    __block NSMutableArray *execQueryArray = [NSMutableArray array];
    
    return [PaintingliteTransaction begainPaintingliteTransaction:ppDb exec:^Boolean{
        Boolean success = [self execQuerySQL:ppDb sql:sql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
            if (success) {
                execQueryArray = resArray;
            }
        }];
        
        NSMutableArray<id> *resObjList = [NSMutableArray array];
        
        @synchronized (self) {
            //开始封装
            for (NSUInteger i = 0; i < execQueryArray.count; i++) {
                id tempObj = nil;
                
                tempObj = [PaintingliteObjRuntimeProperty setObjPropertyValue:obj value: execQueryArray[i]];
                
                [resObjList addObject:tempObj];
            }
            
        }
        
        if (completeHandler != nil) {
            completeHandler(self.sessionError,success,execQueryArray,resObjList);
        }
        
        return success;
    }];
}

/**
 * sql查找 -- 添加条件
 * 例: select * from user where id = ? and name = ?
 * 分别设置 id 和 name的值
 * prepareStatement setStatement  ---> 从1开始计数
 * 保存prepareStatementSql语句
 * 通过另一个方法进行传入?对应的值，然后进行查询工作
 */

- (void)execQuerySQLPrepareStatementSql:(NSString *)prepareStatementSql{
    NSAssert(prepareStatementSql != NULL, @"PrepareStatementSql Not Is Empty");
    
    self.prepareStatementSql = prepareStatementSql;
}

/**
 * 调用这个方法进行对于问号进行处理
 * 传入参数两个
 * 1. 下标 index
 * 2. 参数值 paramter
 */
- (void)setPrepareStatementSqlParameter:(NSUInteger)index paramter:(NSString *)paramter{
    //获取prepareStatementSql
    NSString *tempPrepareStatementSql = [NSString string];
    
    if (self.prepareStatementSql.length != 0) {
        tempPrepareStatementSql = self.prepareStatementSql;
    }
    
    NSInteger count = 0;

    count = [self getParamterCount:tempPrepareStatementSql];

    //对比index传入的下标
    if ((index - self.paramterIndex) < count) {
        if (index == self.paramterIndex) {
            /**
             * 查看是否含有'?'
             */
            if ([tempPrepareStatementSql containsString:@"?"]) {
                NSRange range = [tempPrepareStatementSql rangeOfString:@"?"];
                tempPrepareStatementSql = [tempPrepareStatementSql stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"\'%@\'",paramter]];
                self.prepareStatementSql = tempPrepareStatementSql;
                NSLog(@"%@",tempPrepareStatementSql);
                //更新下标
                self.paramterIndex++;
            }
        }
    }else{
        self.paramterIndex = 0;
    }
}

/**
 * 递归式的传递参数
 * 传入参数形式使用数组来进行设置
 */
- (void)setPrepareStatementSqlParameter:(NSMutableArray *)paramter{
    NSString *tempPrepareStatementSql = [NSString string];
    if (self.prepareStatementSql.length != 0) {
        tempPrepareStatementSql = self.prepareStatementSql;
    }
    
    if ([tempPrepareStatementSql containsString:@"?"]) {
        NSRange range = [tempPrepareStatementSql rangeOfString:@"?"];
        tempPrepareStatementSql = [tempPrepareStatementSql stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"\'%@\'",[paramter firstObject]]];
        self.prepareStatementSql = tempPrepareStatementSql;
        //删除第一个下标
        [paramter removeObject:[paramter firstObject]];
        //递归调用
        [self setPrepareStatementSqlParameter:paramter];
        
        NSLog(@"%@",tempPrepareStatementSql);
        //更新下标
        self.paramterIndex++;
    }
}

/* 获得'?'的个数 */
- (NSInteger)getParamterCount:(NSString *__nonnull)tempPrepareStatementSql{
    NSInteger count = 0;
    const char *chars = [tempPrepareStatementSql UTF8String];
    
    for (int i = 0; i < tempPrepareStatementSql.length; i++) {
        char ch = chars[i];
        if (ch == '?') {
            count++;
        }
    }
    
    return count;
}

/**
 * 执行查询PrepareStatementSql
 */
- (NSMutableArray *)execPrepareStatementSql:(sqlite3 *)ppDb{
    __block NSMutableArray *prepareStatementResArray = [NSMutableArray array];
    
    [self execPrepareStatementSql:ppDb completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        prepareStatementResArray = resArray;
    }];
    
    return prepareStatementResArray;
}
            
- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    
    return [self execQuerySQL:ppDb sql:self.prepareStatementSql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(error,success,resArray);
            }
        }
    }];
    
}

/**
 * 执行查询PrepareStatementSql -- 封装对象
 */

- (id)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj{
    __block NSMutableArray *prepareStatementArray = [NSMutableArray array];
    [self execPrepareStatementSql:ppDb obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        prepareStatementArray = resObjList;
    }];
    
    return prepareStatementArray;
}

- (Boolean)execPrepareStatementSql:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull, NSMutableArray<id> * _Nonnull))completeHandler{
    
    return [self execQuerySQL:ppDb sql:self.prepareStatementSql obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            if (completeHandler != nil) {
                completeHandler(error,success,resArray,resObjList);
            }
        }
    }];
}

@end
