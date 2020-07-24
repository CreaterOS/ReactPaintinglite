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
#import "PaintingliteFileManager.h"

#define PaintingliteLeft_Rigth_Line @"--------------------------"
#define PaintingliteLine @"------------------------------------------------------------------"
#define WEAKSELF(SELF) __weak typeof(SELF) weakself = SELF
#define STRONGSELF(WEAKSELF) __strong typeof(WEAKSELF) self = WEAKSELF

@interface PaintingliteLog()
@property (nonatomic,strong)PaintingliteConfiguration *configuration; //配置文件
@property (nonatomic,strong)PaintingliteFileManager *fileManager; //文件管理者
@property (nonatomic,copy)NSString *logFilePath; //日志文件

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
        _fileManager = [PaintingliteFileManager defaultManager];
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
    
    NSData *logData= [NSMutableData dataWithData:[logStr dataUsingEncoding:NSUTF8StringEncoding]];
    if ([self.fileManager fileExistsAtPath:logFilePath]){
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:logData];
        [fileHandle closeFile];
    }else{
        //写入日志文件
    dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [logData writeToFile:logFilePath atomically:YES];
        });
        
    }
    
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
    __block Boolean success = false;
    
    //创建信号量
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        success = [self.fileManager removeItemAtPath:[self LogFilePath:fileName] error:&error];
        
        //增加信号量
        dispatch_semaphore_signal(signal);
    });
    
    //等待信号量
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    return success;
}

#pragma mark - 读取日志文件
- (NSString *)readLogFile:(NSString *__nonnull)fileName{
    __block NSString *logStr = [NSString string];
    
    //创建信号量
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    WEAKSELF(self);
    dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF(weakself);
        if ([self.fileManager fileExistsAtPath:[self LogFilePath:fileName]]) {
            logStr = [NSString stringWithFormat:@"\n%@ LOG FILE %@\n%@\n%@\n",PaintingliteLeft_Rigth_Line,PaintingliteLeft_Rigth_Line,[[NSString alloc] initWithData:[self logData:fileName] encoding:NSUTF8StringEncoding],PaintingliteLine];
        }
        
        //信号量增加
        dispatch_semaphore_signal(signal);
    });
    
    //等待信号量
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
  
    return logStr.length != 0 ? logStr : @"不存在数据库,无法输出日志文件";
}

- (NSString *)readLogFile:(NSString *)fileName dateTime:(NSDate *__nonnull)dateTime{
    __block NSMutableString *resStr = [NSMutableString string];
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    WEAKSELF(self);
    dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF(weakself);
        NSString *logStr = [[NSString alloc] initWithData:[self logData:fileName] encoding:NSUTF8StringEncoding];
        
        if ([[logStr componentsSeparatedByString:@" ---- "][1] isEqualToString:[NSString stringWithFormat:@"[%@]",[NSDateFormatter localizedStringFromDate:dateTime dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle]]]) {
            //读取特定时间节点以后的日志
            [resStr appendFormat:@"\n%@ LOG FILE %@\n%@\n%@\n",PaintingliteLeft_Rigth_Line,PaintingliteLeft_Rigth_Line,logStr,PaintingliteLine];
        }
        
        dispatch_semaphore_signal(signal);
    });

    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    return resStr;
}

- (NSString *)readLogFile:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus{
    __block NSMutableString *resStr = [NSMutableString string];
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    WEAKSELF(self);
    dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF(weakself);
        NSString *logStr = [[NSString alloc] initWithData:[self logData:fileName] encoding:NSUTF8StringEncoding];
        
        if ([[logStr componentsSeparatedByString:@" ---- "][2] containsString:[NSString stringWithFormat:@"[%@]",logStatus == PaintingliteLogSuccess ? @"success" : @"error"]]) {
            //读取特定状态的日志
            [resStr appendFormat:@"\n%@ LOG FILE %@\n%@\n%@\n",PaintingliteLeft_Rigth_Line,PaintingliteLeft_Rigth_Line,logStr,PaintingliteLine];
        }
        
        dispatch_semaphore_signal(signal);
    });
    
    dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    return resStr;
}

#pragma mark - 查看日志文件行数
- (NSUInteger)logfileLineWithDatabaseName:(NSString *)logfileName{
    /* 读取日志文件 */
    return ([[self readLogFile:logfileName] componentsSeparatedByString:@"\n"].count-4);
}

#pragma mark - 目录下所有的日志文件路径
- (NSDictionary<NSString *,NSString *> *)logsPath{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray<NSString *> *filePathArray = [self.fileManager dictExistsFile:rootPath];
    NSMutableDictionary *logsPathDict = [NSMutableDictionary dictionary];

    for (NSString *fileName in filePathArray) {
        if ([fileName hasSuffix:@"txt"]) {
            if ([fileName containsString:@"_Log"]){
                //返回文件名称
                [logsPathDict setObject:[rootPath stringByAppendingPathComponent:fileName] forKey:fileName];
            }
        }
    }
    
    return (NSDictionary *)logsPathDict;
}

#pragma mark - 查看日志文件最终修改时间
- (NSDate *)logFileModificationTime:(NSString *)logFilePath{
    return (NSDate *)[self.fileManager databaseInfo:logFilePath][NSFileModificationDate];
}

#pragma mark - 查看日志文件大小
- (double)logFileSize:(NSString *)logFilePath{
    NSUInteger logfileSize = [(NSNumber *)[self.fileManager databaseInfo:logFilePath][NSFileSize] integerValue];
    return logfileSize/1024.0/1024.0;
}

#pragma mark - 基本设置
- (NSData *)logData:(NSString *__nonnull)fileName{
    return [NSData dataWithContentsOfFile:[self LogFilePath:fileName]];
}

- (NSString *)LogFilePath:(NSString *__nonnull)fileName{
    return [NSString stringWithFormat:@"%@_Log.txt",[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[fileName containsString:@"."] ? [NSString stringWithFormat:@"%@",[fileName componentsSeparatedByString:@"."][0]] : fileName]];
}

@end
