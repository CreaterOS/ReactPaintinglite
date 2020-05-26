//
//  PaintingliteLog.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteLog.h"

@implementation PaintingliteLog

#pragma mark - 单例模式
static PaintingliteLog *_instance = nil;
+ (instancetype)sharePaintingliteLog{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}


#pragma mark - 写入日志文件
- (void)writeLogFileOptions:(NSString *__nonnull)options status:(PaintingliteLogStatus)status completeHandler:(void (^)(NSString * _Nonnull))completeHandler{
    self.options = options;
    self.status = status;
    self.optDate = [NSDate date];
    
    NSString *logFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Sqlite_Log.txt"];
    
    NSString *logStr = [NSString string];
    if (status == PaintingliteLogSuccess) {
        logStr = [NSString stringWithFormat:@"[%@] ---- [%@] ---- [%@]",self.options,[NSDateFormatter localizedStringFromDate:self.optDate dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle],@"success"];
    }else if (status == PaintingliteLogError){
        logStr = [NSString stringWithFormat:@"[%@] ---- [%@] ---- [%@]",self.options,[NSDateFormatter localizedStringFromDate:self.optDate dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle],@"error"];
    }
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if ([fileManger fileExistsAtPath:logFilePath]){
        NSError *error = nil;
        
        //读取里面的内容
        logStr = [logStr stringByAppendingFormat:@"\n%@",[NSString stringWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:&error]];
        [fileManger removeItemAtPath:logFilePath error:&error];
    }
    
    NSData *logData= [NSMutableData dataWithData:[logStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    //写入日志文件
    [logData writeToFile:logFilePath atomically:YES];
    
    if (completeHandler != nil) {
        completeHandler(logFilePath);
    }
    
}

@end
