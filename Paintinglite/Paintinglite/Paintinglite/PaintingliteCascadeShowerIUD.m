//
//  PaintingliteCascadeShowerIUD.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/8.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteCascadeShowerIUD.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteSessionError.h"

@interface PaintingliteCascadeShowerIUD()
@property (nonatomic,strong)PaintingliteSessionError *sessionError;
@end

@implementation PaintingliteCascadeShowerIUD

#pragma mark - 懒加载
- (PaintingliteSessionError *)sessionError{
    if (!_sessionError) {
        _sessionError = [PaintingliteSessionError sharePaintingliteSessionError];
    }
    
    return _sessionError;
}

#pragma mark - 单例模式
static PaintingliteCascadeShowerIUD *_instance = nil;
+ (instancetype)sharePaintingliteCascadeShowerIUD{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 级联插入
- (Boolean)cascadeInsert:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    Boolean success = false;
    
    //判断obj中是否含有可变数组
    NSMutableDictionary *dict = [PaintingliteObjRuntimeProperty getObjPropertyType:obj];
    
    
    __block NSMutableArray *resArray = [NSMutableArray array];
    
    NSString *mutableArrayStr = [NSString stringWithFormat:@"@\"%@\"",@"NSMutableArray"];

    //判断是否含有数组
    if ([dict.allValues containsObject:mutableArrayStr]) {
        //包含,使用级联插入
        //便利集合,逐一插入
        //获得集合属性名称
        NSString *propertyNameForMutableArray = [dict allKeys][[[dict allValues] indexOfObject:mutableArrayStr]];
        NSMutableDictionary *propertyValueDict = [PaintingliteObjRuntimeProperty getObjPropertyValue:obj];
        
        //遍历对象
        for (id obj in [propertyValueDict valueForKey:propertyNameForMutableArray]) {
            success = [self insert:ppDb obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
                if (success) {
                    //查询数据,添加
                    NSMutableArray *newList = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",[[PaintingliteObjRuntimeProperty getObjName:obj]lowercaseString]]];
                    [resArray addObject:newList];
                }
            }];
        }
    }
    
    if (success) {
        success = [self insert:ppDb obj:obj completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
            if (success) {
                NSMutableArray *newList = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",[[PaintingliteObjRuntimeProperty getObjName:obj]lowercaseString]]];
                [resArray addObject:newList];
            }
        }];
    }

    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,resArray);
    }
    
    return success;
}

#pragma mark - 级联更新
- (Boolean)cascadeUpdate:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> *)condatation completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    Boolean success = false;
    
    //判断obj中是否含有可变数组
    NSMutableDictionary *dict = [PaintingliteObjRuntimeProperty getObjPropertyType:obj];
    
    
    __block NSMutableArray *resArray = [NSMutableArray array];
    
    NSString *mutableArrayStr = [NSString stringWithFormat:@"@\"%@\"",@"NSMutableArray"];
    
    //判断是否含有数组
    if ([dict.allValues containsObject:mutableArrayStr]) {
        //包含,使用级联插入
        //便利集合,逐一插入
        //获得集合属性名称
        NSString *propertyNameForMutableArray = [dict allKeys][[[dict allValues] indexOfObject:mutableArrayStr]];
        NSMutableDictionary *propertyValueDict = [PaintingliteObjRuntimeProperty getObjPropertyValue:obj];
        
        //遍历对象
        for (id obj in [propertyValueDict valueForKey:propertyNameForMutableArray]) {
            success = [self update:ppDb obj:obj condition:[condatation lastObject] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
                if(success){
                    NSMutableArray *newList = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",[[PaintingliteObjRuntimeProperty getObjName:obj]lowercaseString]]];
                    [resArray addObject:newList];
                }
            }];
        }
    }
    
    if (success) {
        success = [self update:ppDb obj:obj condition:[condatation firstObject] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
            if(success){
                NSMutableArray *newList = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",[[PaintingliteObjRuntimeProperty getObjName:obj]lowercaseString]]];
                [resArray addObject:newList];
            }
        }];
    }

    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,resArray);
    }
    
    return success;
}

#pragma mark - 级联删除
- (Boolean)cascadeDelete:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> *)condatation completeHandler:(void (^)(PaintingliteSessionError * _Nonnull, Boolean, NSMutableArray * _Nonnull))completeHandler{
    Boolean success = false;
    
    //判断obj中是否含有可变数组
    NSMutableDictionary *dict = [PaintingliteObjRuntimeProperty getObjPropertyType:obj];
    
    
    __block NSMutableArray *resArray = [NSMutableArray array];
    
    NSString *mutableArrayStr = [NSString stringWithFormat:@"@\"%@\"",@"NSMutableArray"];
    
    //判断是否含有数组
    if ([dict.allValues containsObject:mutableArrayStr]) {
        //包含,使用级联插入
        //便利集合,逐一插入
        //获得集合属性名称
        NSString *propertyNameForMutableArray = [dict allKeys][[[dict allValues] indexOfObject:mutableArrayStr]];
        NSMutableDictionary *propertyValueDict = [PaintingliteObjRuntimeProperty getObjPropertyValue:obj];
        
        //遍历对象
        for (id obj in [propertyValueDict valueForKey:propertyNameForMutableArray]) {
            success = [self del:ppDb sql:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",[PaintingliteObjRuntimeProperty getObjName:obj],[condatation lastObject]] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
                if(success){
                    NSMutableArray *newList = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",[[PaintingliteObjRuntimeProperty getObjName:obj]lowercaseString]]];
                    [resArray addObject:newList];
                }
            }];
        }
    }
    
    if (success) {
        success = [self del:ppDb sql:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",[PaintingliteObjRuntimeProperty getObjName:obj],[condatation firstObject]] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
            if(success){
                NSMutableArray *newList = [self execQuerySQL:ppDb sql:[NSString stringWithFormat:@"SELECT * FROM %@",[[PaintingliteObjRuntimeProperty getObjName:obj]lowercaseString]]];
                [resArray addObject:newList];
            }
        }];
    }

    if (completeHandler != nil) {
        completeHandler(self.sessionError,success,resArray);
    }
    
    return success;
}

@end
