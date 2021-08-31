//
//  PaintingliteIntellegenceSelect.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/3.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteIntellegenceSelect.h"
#import "PaintingliteException.h"
#import "PaintingliteSessionError.h"

@interface PaintingliteIntellegenceSelect()
@property (nonatomic,strong)PaintingliteSessionError *sessionError; //错误
@property (nonatomic,strong)id objs; //保存对象
@end

@implementation PaintingliteIntellegenceSelect

#pragma mark - 单例模式
static PaintingliteIntellegenceSelect *_instance = nil;
+ (instancetype)sharePaintingliteIntellegenceSelect{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (PaintingliteSessionError *)sessionError{
    if (!_sessionError) {
        _sessionError = [PaintingliteSessionError sharePaintingliteSessionError];
    }
    
    return _sessionError;
}

#pragma mark - 普通查询
/**
 * 传入的参数是可变参数，根据id对象进行查询操作
 */
- (Boolean)load:(sqlite3 *)ppDb completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler objects:(id)objects, ...{
    //获取每一个对象，从可变参数中获取
    id obj = NULL;
    
    __block NSMutableArray *loadArray = [NSMutableArray array];
    Boolean success = false;
    
    //取出第一个参数
    obj = objects;
    self.objs = obj;

    success = [self execPQL:ppDb pql:[NSString stringWithFormat:@"FROM %@",[NSStringFromClass([obj class]) lowercaseString]] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            [loadArray addObject:resObjList];
        }
    }];
    
    va_list arg_list;
    va_start(arg_list, objects);
    
    while ((obj = va_arg(arg_list, NSObject *))) {
        if ([self.objs isEqual:obj]) {
            //报出异常
            [PaintingliteException paintingliteException:@"重复对象" reason:@"传入对象重复"];
        }
        
        //获得每一个id对象
        //调用对象封装基本SQL查询
        success = [self execPQL:ppDb pql:[NSString stringWithFormat:@"FROM %@",[NSStringFromClass([obj class]) lowercaseString]] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
            if (success) {
                [loadArray addObject:resObjList];
            }
        }];
    }
    va_end(arg_list);
    self.objs = nil;
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,loadArray);
    }
    
    return success;
}

#pragma mark - 分页查询
- (Boolean)limit:(sqlite3 *)ppDb start:(NSUInteger)start end:(NSUInteger)end completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler objects:(id)objects, ...{
    //获取每一个对象，从可变参数中获取
    id obj = NULL;
    
    __block NSMutableArray *limitsArray = [NSMutableArray array];
    Boolean success = false;
    
    //取出第一个参数
    obj = objects;
    self.objs = obj;
    
    success = [self execLimitQueryPQL:ppDb pql:[NSString stringWithFormat:@"FROM %@ LIMIT %zd,%zd",NSStringFromClass([obj class]),start,end] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if(success){
            [limitsArray addObject:resObjList];
        }
    }];
    
    va_list arg_list;
    va_start(arg_list, objects);
    
    while ((obj = va_arg(arg_list, NSObject *))) {
        if ([self.objs isEqual:obj]) {
            //报出异常
            [PaintingliteException paintingliteException:@"重复对象" reason:@"传入对象重复"];
        }
        
        
        //获得每一个id对象
        //调用对象封装基本SQL查询
        success =  [self execLimitQueryPQL:ppDb pql:[NSString stringWithFormat:@"FROM %@ LIMIT %zd,%zd",NSStringFromClass([obj class]),start,end] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
            if(success){
                [limitsArray addObject:resObjList];
            }
        }];
    }
    va_end(arg_list);
    self.objs = nil;
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,limitsArray);
    }
    
    return success;
}

- (Boolean)limit:(sqlite3 *)ppDb startAndEnd:(NSArray<NSArray<NSNumber *> *> *)startAndEnd completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler objects:(id)objects, ...{
    //获取每一个对象，从可变参数中获取
    id obj = NULL;
    
    __block NSMutableArray *limitsArray = [NSMutableArray array];
    Boolean success = false;
    
    //取出第一个参数
    obj = objects;
    self.objs = obj;
    
    //每两个数进行划分
    success = [self execLimitQueryPQL:ppDb pql:[NSString stringWithFormat:@"FROM %@ LIMIT %zd,%zd",NSStringFromClass([obj class]),[startAndEnd[0][0] integerValue],[startAndEnd[0][1] integerValue]] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if(success){
            [limitsArray addObject:resObjList];
        }
    }];
    
    va_list arg_list;
    va_start(arg_list, objects);
    
    NSUInteger i = 1;
    while ((obj = va_arg(arg_list, NSObject *))) {
        if ([self.objs isEqual:obj]) {
            //报出异常
            [PaintingliteException paintingliteException:@"重复对象" reason:@"传入对象重复"];
        }
        
        
        //获得每一个id对象
        //调用对象封装基本SQL查询
        success =  [self execLimitQueryPQL:ppDb pql:[NSString stringWithFormat:@"FROM %@ LIMIT %zd,%zd",NSStringFromClass([obj class]),[startAndEnd[i][0] integerValue],[startAndEnd[i][1] integerValue]] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
            if(success){
                [limitsArray addObject:resObjList];
            }
        }];
        
        i++;
    }
    va_end(arg_list);
    self.objs = nil;
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,limitsArray);
    }
    
    return success;
}

#pragma mark - 排序查询
- (Boolean)orderBy:(sqlite3 *)ppDb orderStyle:(kOrderByStyle)orderStyle condation:(nonnull NSArray<NSString *> *)condation completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler objects:(id)objects, ...{
//    //获取每一个对象，从可变参数中获取
//    id obj = NULL;
//
//    __block NSMutableArray *ordersArray = [NSMutableArray array];
//    Boolean success = false;
//
//    //取出第一个参数
//    obj = objects;
//    self.objs = obj;
//
//    success = [self execOrderQueryPQL:ppDb pql:[NSString stringWithFormat:@"FROM %@ ORDER BY %@ %@",NSStringFromClass([obj class]),[condation firstObject],(orderStyle == PaintingliteOrderByASC) ? @"ASC" : @"DESC"] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
//        if(success){
//            [ordersArray addObject:resObjList];
//        }
//    }];
//
//    va_list arg_list;
//    va_start(arg_list, objects);
//
//    NSUInteger i = 1;
//    while ((obj = va_arg(arg_list, NSObject *))) {
//        if ([self.objs isEqual:obj]) {
//            //报出异常
//            [PaintingliteException PaintingliteException:@"重复对象" reason:@"传入对象重复"];
//        }
//
//
//        //获得每一个id对象
//        //调用对象封装基本SQL查询
//        success = [self execOrderQueryPQL:ppDb pql:[NSString stringWithFormat:@"FROM %@ ORDER BY %@ %@",NSStringFromClass([obj class]),condation[i],(orderStyle == PaintingliteOrderByASC) ? @"ASC" : @"DESC"] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
//            if(success){
//                [ordersArray addObject:resObjList];
//            }
//        }];
//
//        i++;
//    }
//    va_end(arg_list);
//    self.objs = nil;
//
//    if (completeHandler != nil) {
//        completeHandler(self.sessionError,success,ordersArray);
//    }
//
//    return success;
    
    return [self orderBy:ppDb orderStyleArray:@[(orderStyle == kOrderByASC) ? @"ASC" : @"DESC"] condation:condation completeHandler:completeHandler objects:objects, nil];
}

- (Boolean)orderBy:(sqlite3 *)ppDb orderStyleArray:(NSArray<NSString *> *)orderStyleArray condation:(NSArray<NSString *> *)condation completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler objects:(id)objects, ...{
    //获取每一个对象，从可变参数中获取
    id obj = NULL;
    
    __block NSMutableArray *ordersArray = [NSMutableArray array];
    Boolean success = false;
    
    //取出第一个参数
    obj = objects;
    self.objs = obj;
    
    success = [self execOrderQueryPQL:ppDb pql:[NSString stringWithFormat:@"FROM %@ ORDER BY %@ %@",NSStringFromClass([obj class]),[condation firstObject],[orderStyleArray[0] uppercaseString]] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if(success){
            [ordersArray addObject:resObjList];
        }
    }];
    
    va_list arg_list;
    va_start(arg_list, objects);
    
    NSUInteger i = 1;
    while ((obj = va_arg(arg_list, NSObject *))) {
        if ([self.objs isEqual:obj]) {
            //报出异常
            [PaintingliteException paintingliteException:@"重复对象" reason:@"传入对象重复"];
        }
        
        //获得每一个id对象
        //调用对象封装基本SQL查询
        success = [self execOrderQueryPQL:ppDb pql:[NSString stringWithFormat:@"FROM %@ ORDER BY %@ %@",NSStringFromClass([obj class]),condation[i],[orderStyleArray[i] uppercaseString]] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
            if(success){
                [ordersArray addObject:resObjList];
            }
        }];
        
        i++;
    }
    va_end(arg_list);
    self.objs = nil;
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,ordersArray);
    }
    
    return success;
}

#pragma mark - 万能查询
- (Boolean)query:(sqlite3 *)ppDb sql:(NSArray<NSString *> *)sql completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler objects:(id)objects, ...{
    //获取每一个对象，从可变参数中获取
    id obj = NULL;
    
    __block NSMutableArray *queryArray = [NSMutableArray array];
    Boolean success = false;
    
    //取出第一个参数
    obj = objects;
    self.objs = obj;
    
    success = [self execQuerySQL:ppDb sql:[sql firstObject] obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if(success){
            [queryArray addObject:resObjList];
        }
    }];
    
    va_list arg_list;
    va_start(arg_list, objects);
    
    NSUInteger i = 1;
    while ((obj = va_arg(arg_list, NSObject *))) {
        if ([self.objs isEqual:obj]) {
            //报出异常
            [PaintingliteException paintingliteException:@"重复对象" reason:@"传入对象重复"];
        }
        
        
        //获得每一个id对象
        //调用对象封装基本SQL查询
        success = [self execQuerySQL:ppDb sql:sql[i] obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
            if(success){
                [queryArray addObject:resObjList];
            }
        }];
        
        i++;
    }
    va_end(arg_list);
    self.objs = nil;
    
    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,queryArray);
    }
    
    return success;
}

@end
