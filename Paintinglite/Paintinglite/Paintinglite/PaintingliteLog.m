//
//  PaintingliteLog.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteLog.h"
#import "PaintingliteConfiguration.h"
#import "PaintingliteSessionFactory.h"

#define PaintingliteLeft_Rigth_Line @"--------------------------"
#define PaintingliteLine @"------------------------------------------------------------------"


@interface PaintingliteLog()
@property (nonatomic,strong)PaintingliteConfiguration *configuration; //配置文件
@property (nonatomic,strong)NSFileManager *fileManager; //文件管理者
@property (nonatomic,strong)NSString *logFilePath; //日志文件
@end

@implementation PaintingliteLog

#pragma mark - 懒加载
- (PaintingliteConfiguration *)configuration{
    if (!_configuration) {
        _configuration = [PaintingliteConfiguration sharePaintingliteConfiguration];
    }
    
    return _configuration;
}

- (NSFileManager *)fileManager{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    
    return _fileManager;
}

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
/**
 * 写入日志文件
 * 专门开辟一个线程进行写入操作，但是写入操作和读取操作必须单独执行
 * 防止出现线程安全问题,因此需要使用多线程栅栏进行读写操作
 */
- (void)writeLogFileOptions:(NSString *__nonnull)options status:(PaintingliteLogStatus)status completeHandler:(void (^)(NSString * _Nonnull))completeHandler{
    self.options = options;
    self.status = status;
    self.optDate = [NSDate date];
    
    //写入日志文件使用数据库名称_Log
    NSString *logFilePath = [NSString stringWithFormat:@"%@_Log.txt",[self.configuration.fileName componentsSeparatedByString:@"."][0]];
    
    NSString *logStr = [NSString string];
    if (status == PaintingliteLogSuccess) {
        logStr = [NSString stringWithFormat:@"[%@] ---- [%@] ---- [%@]",self.options,[NSDateFormatter localizedStringFromDate:self.optDate dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle],@"success"];
    }else if (status == PaintingliteLogError){
        logStr = [NSString stringWithFormat:@"[%@] ---- [%@] ---- [%@]",self.options,[NSDateFormatter localizedStringFromDate:self.optDate dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle],@"error"];
    }
    
    if ([self.fileManager fileExistsAtPath:logFilePath]){
        NSError *error = nil;
        
        //读取里面的内容
        logStr = [logStr stringByAppendingFormat:@"\n%@",[NSString stringWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:&error]];
        [self.fileManager removeItemAtPath:logFilePath error:&error];
    }
    
    NSData *logData= [NSMutableData dataWithData:[logStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    //写入日志文件
    [logData writeToFile:logFilePath atomically:YES];
    
    self.logFilePath = logFilePath;
    
    if (completeHandler != nil) {
        completeHandler(logFilePath);
    }
    
    self.fileManager = nil;
    logData = nil;
}

#pragma mark - 删除日志文件
- (Boolean)removeLogFile{
    NSError *error = nil;
    return [self.fileManager removeItemAtPath:self.logFilePath error:&error];
}

- (Boolean)removeLogFile:(NSString *)fileName{
    NSError *error = nil;
    return [self.fileManager removeItemAtPath:[self LogFilePath:fileName] error:&error];
}

#pragma mark - 读取日志文件
- (NSString *)readLogFile:(NSString *__nonnull)fileName{
    if ([self.fileManager fileExistsAtPath:[self LogFilePath:fileName]]) {
        return [NSString stringWithFormat:@"\n%@ LOG FILE %@\n%@\n%@\n",PaintingliteLeft_Rigth_Line,PaintingliteLeft_Rigth_Line,[[NSString alloc] initWithData:[self logData:fileName] encoding:NSUTF8StringEncoding],PaintingliteLine];
    }
    return @"不存在数据库,无法输出日志文件";
}

- (NSString *)readLogFile:(NSString *)fileName dateTime:(NSDate *__nonnull)dateTime{
    __block NSMutableString *resStr = [NSMutableString string];
    NSString *logStr = [[NSString alloc] initWithData:[self logData:fileName] encoding:NSUTF8StringEncoding];
    
    if ([[logStr componentsSeparatedByString:@" ---- "][1] isEqualToString:[NSString stringWithFormat:@"[%@]",[NSDateFormatter localizedStringFromDate:dateTime dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle]]]) {
        //读取特定时间节点以后的日志
        [resStr appendFormat:@"\n%@ LOG FILE %@\n%@\n%@\n",PaintingliteLeft_Rigth_Line,PaintingliteLeft_Rigth_Line,logStr,PaintingliteLine];
    }
    return resStr;
}

- (NSString *)readLogFile:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus{
    NSMutableString *resStr = [NSMutableString string];
    NSString *logStr = [[NSString alloc] initWithData:[self logData:fileName] encoding:NSUTF8StringEncoding];
        
    if ([[logStr componentsSeparatedByString:@" ---- "][2] containsString:[NSString stringWithFormat:@"[%@]",logStatus == PaintingliteLogSuccess ? @"success" : @"error"]]) {
        //读取特定状态的日志
        [resStr appendFormat:@"\n%@ LOG FILE %@\n%@\n%@\n",PaintingliteLeft_Rigth_Line,PaintingliteLeft_Rigth_Line,logStr,PaintingliteLine];
    }
    
    return resStr;
}

#pragma mark - 基本设置
- (NSData *)logData:(NSString *__nonnull)fileName{
    return [NSData dataWithContentsOfFile:[self LogFilePath:fileName]];
}

- (NSString *)LogFilePath:(NSString *__nonnull)fileName{
    return [NSString stringWithFormat:@"%@_Log.txt",[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[fileName containsString:@"."] ? [NSString stringWithFormat:@"%@",[fileName componentsSeparatedByString:@"."][0]] : fileName]];
}

@end
