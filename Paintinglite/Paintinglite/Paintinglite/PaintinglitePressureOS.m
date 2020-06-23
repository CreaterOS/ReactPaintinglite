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

#define PRESSURETABLE @"CREATE TABLE IF NOT EXISTS pressure(ID INTEGER primary key AUTOINCREMENT,name TEXT,age INTEGER,teacher TEXT,tage INTEGER,desc TEXT)"

@interface PaintinglitePressureOS()
@property (nonatomic)sqlite3 *ppDb;
@end

@implementation PaintinglitePressureOS

#pragma mark - 内存计算
- (int64_t)memoryUsage {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        int64_t mb = memoryUsageInByte / 1024 / 1024;
        NSLog(@"APP占用内存: %lldMB", mb);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    return memoryUsageInByte;
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
- (void)paintingliteEfficiency:(void (^)(void))block{
    if (block != nil) {
        NSDate* start = [NSDate date];
    
        /* 执行block */
        block();
        double deltaTime = [[NSDate date] timeIntervalSinceDate:start];
        NSLog(@"程序段耗时:%.5fs", deltaTime);
    }
}

#pragma mark - 内存测试
- (void)paintingliteMemoryUSE:(void (^)(void))block{
    if (block != nil) {
        /* 执行block */
        block();
        [self memoryUsage];
    }
}

#pragma mark - CPU测试
- (void)paintingliteCPUUSAGE:(void (^)(void))block{
    if (block != nil) {
        /* 执行block */
        block();
        NSLog(@"CPU消耗: %.2f百分比",[self cpu_usage]);
    }
}

#pragma mark - 压力测试
- (void)paintinglitePressure:(void (^)(void))block{
    if (block != nil) {
        NSDate* start = [NSDate date];
        block();
        double deltaTime = [[NSDate date] timeIntervalSinceDate:start];
        NSLog(@"程序段耗时:%.5fs", deltaTime);
        [self memoryUsage];
        NSLog(@"CPU消耗: %.2f百分比",[self cpu_usage]);
    }
}

#pragma mark - 数据库压力测试
- (void)paintingliteSqlitePressureWithCount{
    /* 创建测试数据库 */
    if (sqlite3_open([@"PressureOS" UTF8String],&_ppDb) == SQLITE_OK){
        if(sqlite3_exec(_ppDb, [PRESSURETABLE UTF8String], 0, 0, NULL) == SQLITE_OK){
            /* 插入测试 */
            /* 更新测试 */
            /* 查询测试 */
            /* 删除测试 */
        }
    }
}

- (void)insertPressure{
        @try {
    
            /* 开起事务 */
            [PaintingliteTransaction begainPaintingliteTransaction:_ppDb];
            
            /*
              准备四个文件
              100万
              1000万
              5000万
              1个亿
             */
//            NSString *millionData =
            
            
            
            /* 提交 */
            [PaintingliteTransaction commit:_ppDb];
        }@catch (NSException *exception) {
            /* 回滚 */
            [PaintingliteTransaction rollback:_ppDb];
            [exception raise];
        } @finally {
            
        }
}
                     
@end
