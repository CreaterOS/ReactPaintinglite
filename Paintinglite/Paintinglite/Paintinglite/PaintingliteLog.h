//
//  PaintingliteLog.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * 用于写入日志文件
 * 操作
 * 日期
 * 状态
 */
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PaintingliteLogStatus){
    PaintingliteLogSuccess, //成功
    PaintingliteLogError //错误
};

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteLog : NSObject
@property (nonatomic,strong)NSString *options; //操作
@property (nonatomic,strong)NSDate *optDate;  //操作日期
@property (nonatomic)PaintingliteLogStatus status; //操作状态

/* 单例模式 */
+ (instancetype)sharePaintingliteLog;

/* 写入日志文件 */
- (void)writeLogFileOptions:(NSString *__nonnull)options status:(PaintingliteLogStatus)status completeHandler:(void(^)(NSString *logFilePath))completeHandler;

@end

NS_ASSUME_NONNULL_END
