//
//  PaintinglitePressureOS.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/23.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintinglitePressureOS.h"
#import "PaintingliteTransaction.h"
#import <mach/mach.h>
#import <sys/utsname.h>

#define PRESSURETABLE @"CREATE TABLE IF NOT EXISTS pressure(ID INTEGER primary key AUTOINCREMENT,name TEXT,age INTEGER,teacher TEXT,tage INTEGER,desc TEXT)"
#define DROPPRESSURETABLE @"DROP TABLE pressure"

#define SAVEROOT(PATH) [NSTemporaryDirectory() stringByAppendingPathComponent:PATH]

@interface PaintinglitePressureOS()
@property (nonatomic)sqlite3 *ppDb;
@property (nonatomic,strong)NSMutableArray<NSString *> *pressureArray; //测试压力集
@end

@implementation PaintinglitePressureOS

#pragma mark - 懒加载
- (NSMutableArray<NSString *> *)pressureArray{
    if (!_pressureArray) {
        _pressureArray = [NSMutableArray array];
    }
    
    return _pressureArray;
}

#pragma mark - 获取手机型号
- (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    
    if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS MAX";
    
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    
    if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE2";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}

#pragma mark - 内存计算
- (int64_t)memoryUsage {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    return memoryUsageInByte / 1024 / 1024;
}

#pragma mark - CPU计算
- (float)cpu_usage
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

#pragma mark - 单例模式
static PaintinglitePressureOS *_instance = nil;
+ (instancetype)sharePaintinglitePressureOS{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 效率测试
- (float)paintingliteEfficiency:(void (^)(void))block{
    if (block != nil) {
        NSDate* start = [NSDate date];
    
        /* 执行block */
        block();
        double deltaTime = [[NSDate date] timeIntervalSinceDate:start];
        
        return deltaTime;
    }
    
    return 0.0f;
}

#pragma mark - 内存测试
- (int64_t)paintingliteMemoryUSE:(void (^)(void))block{
    if (block != nil) {
        /* 执行block */
        block();
        return [self memoryUsage];
    }
    
    return 0;
}

#pragma mark - CPU测试
- (float)paintingliteCPUUSAGE:(void (^)(void))block{
    if (block != nil) {
        /* 执行block */
        block();
        return [self cpu_usage];
    }
    
    return 0.0f;
}

#pragma mark - 压力测试
- (void)paintinglitePressure:(void (^)(void))block options:(NSString *__nonnull)options countIndex:(NSUInteger)countIndex{
    if (block != nil) {
        [self savePressure:self.saveType options:options countIndex:countIndex efficiency:[self paintingliteEfficiency:^{
            block();
        }] memoryUsage:[self memoryUsage] cpuUsage:[self cpu_usage]];
    }
}


#pragma mark - 保存测试数据
- (void)savePressure:(PaintinglitePressureOSSaveType)saveType options:(NSString *__nonnull)options countIndex:(NSUInteger)countIndex efficiency:(float)efficiency memoryUsage:(int64_t)memoryUsage cpuUsage:(float)cpuUsage{
    
    /* 文件管理者 */
    NSFileManager *fileM = [NSFileManager defaultManager];
    
    NSArray<NSString *> *countArray = @[@"一万数据量 [10,000]",@"十万数据量 [100,000]",@"百万数据量 [1,000,000]"];

    NSError *error = nil;
    NSString *LOGOPATH = [[NSBundle mainBundle] pathForResource:@"LOGO" ofType:@"txt"];
    NSString *textStart = [NSString stringWithFormat:@"Paintinglite Sqlite Pressure Report\n%@",[NSString stringWithContentsOfFile:LOGOPATH usedEncoding:nil error:&error]];
    ;
    
    /* 设备型号 */
    NSString *iphoneType = [self iphoneType];
    
    /* 当前系统版本 */
    NSString *version = [NSString stringWithFormat:@"系统版本: %@",[[UIDevice currentDevice] systemVersion]];
    
    /* 耗时 */
    NSString *efficiencyStr = [NSString stringWithFormat:@"程序段耗时:%.5fs",efficiency];
    /* 内存 */
    NSString *memoryUsageStr = [NSString stringWithFormat:@"APP占用内存: %lld",memoryUsage];
    /* CPU */
    NSString *cpuUsageStr = [NSString stringWithFormat:@"CPU消耗: %.2f百分比",cpuUsage];
    
    NSString *startStr = @"";
    if (countIndex == 0 && [options isEqualToString:@"INSERT PRESSURE RESULT"]) {
        
        if ([fileM fileExistsAtPath:SAVEROOT(@"pressure_report.txt")]) {
            [fileM removeItemAtPath:SAVEROOT(@"pressure_report.txt") error:&error];
        }
        
        startStr = [NSString stringWithFormat:@"%@\n手机型号:%@\t系统版本:%@\n",textStart,iphoneType,version];
    }
    
    NSString *pressureStr = [NSString stringWithFormat:@"\n测试数据量:%@\n%@_测试结果:\n(1)%@\n(2)%@\n(3)%@",countArray[countIndex],options,efficiencyStr,memoryUsageStr,cpuUsageStr];
    
    NSString *resStr = [NSString stringWithFormat:@"%@%@\n",startStr,pressureStr];
    
    if (saveType == PaintinglitePressureOSSaveTXT) {
        /* 保存文本格式 */
        if ([fileM fileExistsAtPath:SAVEROOT(@"pressure_report.txt")]) {
            /* 存在 */
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:SAVEROOT(@"pressure_report.txt")];
            /* 将节点跳到文件的末尾 */
            [fileHandle seekToEndOfFile];
            
            [fileHandle writeData:[resStr dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            /* 不存在 */
            [resStr writeToFile:SAVEROOT(@"pressure_report.txt") atomically:YES encoding:NSUTF8StringEncoding error:&error];
        }
    }
}

#pragma mark - 数据库压力测试
- (Boolean)paintingliteSqlitePressure:(NSString *)firstPressureStr, ...{
    va_list args;
    
    //添加第一个元素
    [self.pressureArray addObject:firstPressureStr];
    
    va_start(args, firstPressureStr);
    NSString *arg = [NSString string];
    while ((arg = va_arg(args, NSString *))) {
        /* 获得每一个参数 */
        /* 组合数组 */
        [self.pressureArray addObject:arg];
    }
    
    va_end(args);
    
    /* 创建测试数据库 */
    if (sqlite3_open([[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PressureOS.db"] UTF8String],&_ppDb) == SQLITE_OK){
        if(sqlite3_exec(_ppDb, [PRESSURETABLE UTF8String], 0, 0, NULL) == SQLITE_OK){
            /* 压力测试 */
            [self Pressure];
            
            /* 执行完成,删除测试数据库 */
            return sqlite3_exec(_ppDb, [DROPPRESSURETABLE UTF8String], 0, 0, NULL) == SQLITE_OK;
        }
    }
    
    
    return false;
}

static int i = 0;
- (void)Pressure{
    if ([self.pressureArray count] > 0) {
        @try {
            /* 开起事务 */
            [PaintingliteTransaction begainPaintingliteTransaction:_ppDb];
            
            /* 从集合中获得测试集 */
            /* 从测试集中拿出最后一个元素项作为数据集 */
            NSString *insertSQL = [self.pressureArray lastObject];
            
            /* 插入测试 */
            /* 插入数据库 */
            [self paintinglitePressure:^{
                sqlite3_exec(self.ppDb, [insertSQL UTF8String], 0, 0, 0);
            } options:@"INSERT PRESSURE RESULT" countIndex:i];
        
            /* 提交 */
            [PaintingliteTransaction commit:_ppDb];

            /* 查询测试 */
            [self paintinglitePressure:^{
                sqlite3_stmt *stmt;
                sqlite3_prepare_v2(self.ppDb, [@"SELECT * FROM pressure" UTF8String], -1, &stmt, nil);
            } options:@"SELECT PRESSURE RESULT" countIndex:i];
            
            
            /* 删除数据最后的元素 */
            [self.pressureArray removeLastObject];
            
            /* 删除表中全部数据 */
            sqlite3_exec(self.ppDb, [@"DELETE FROM pressure" UTF8String], 0, 0, NULL);
            
            if (sqlite3_exec(_ppDb, [DROPPRESSURETABLE UTF8String], 0, 0, NULL) == SQLITE_OK) {
                if (sqlite3_open([[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PressureOS.db"] UTF8String],&_ppDb) == SQLITE_OK){
                    if(sqlite3_exec(_ppDb, [PRESSURETABLE UTF8String], 0, 0, NULL) == SQLITE_OK){
                        i++;
                        /* 递归测试 */
                        [self Pressure];
                    }
                }
            }
            
        }@catch (NSException *exception) {
            /* 回滚 */
            [PaintingliteTransaction rollback:_ppDb];
            [exception raise];
        }
    }
}

#pragma mark - 获得字符串
- (NSString *__nonnull)getStrWithFile:(NSString *__nonnull)filePath{
    NSError *error = nil;
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
}

                     
@end
