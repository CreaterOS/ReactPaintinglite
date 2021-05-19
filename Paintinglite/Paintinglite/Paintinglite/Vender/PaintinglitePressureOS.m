//
//  PaintinglitePressureOS.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/23.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintinglitePressureOS.h"
#import "PaintingliteTransaction.h"
#import "PaintingliteFileManager.h"
#import "PaintingliteSystemUseInfo.h"
#import <mach/mach.h>
#import <sys/utsname.h>

#define PRESSOS_DB_PATH(PATH) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:PATH]

#define PRESSURETABLE @"CREATE TABLE IF NOT EXISTS pressure(ID INTEGER primary key AUTOINCREMENT,name TEXT,age INTEGER,teacher TEXT,tage INTEGER,desc TEXT)"
#define DROPPRESSURETABLE @"DROP TABLE pressure"

#define SAVEROOT(PATH) [NSTemporaryDirectory() stringByAppendingPathComponent:PATH]

/**
 * 设备模型类
 */
@interface MobileModel : NSObject
@property (nonatomic,copy)NSString *version; //设备版本
@property (nonatomic,copy)NSString *mobileType; //设备类型
@property (nonatomic,copy)NSString *cpu; //处理器
@property (nonatomic,copy)NSString *speed; //下载上传速度

/// 模型字典KVO
/// @param dict 数组
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end

@implementation MobileModel
#pragma mark - 模型字典KVO
+ (instancetype)modelWithDict:(NSDictionary *)dict{
    /**
     MobileModel *model = [MobileModel new];
     do not create objects with +new
     Finds calls to +new or overrides of it, which are prohibited by the Google Objective-C style guide.

     The Google Objective-C style guide forbids calling +new or overriding it in class implementations, preferring +alloc and -init methods to instantiate objects.
     */
    MobileModel *model = [[MobileModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end

/**
 * 设备类
 * 设备型号 ｜设备参数
*/
@interface Mobile : NSObject
/// 获得设备型号
- (MobileModel *)getMobileType;
@end

@interface Mobile()
@property (nonatomic,strong)NSMutableArray<MobileModel *> *modelArr; //模型数组
@end

@implementation Mobile
#pragma mark - 懒加载
- (NSMutableArray<MobileModel *> *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
        //读取MobileInfo.plist文件
        NSString *infoPath = [[NSBundle mainBundle] pathForResource:@"MobileInfo" ofType:@"plist"];
        NSArray *mobileArr = [[NSArray alloc] initWithContentsOfFile:infoPath];
        for (NSDictionary *dict in mobileArr) {
            [_modelArr addObject:[MobileModel modelWithDict:dict]];
        }
    }
    
    return _modelArr;
}

//返回设备型号
- (MobileModel *)getMobileType{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];

    for (MobileModel *model in self.modelArr) {
        if ([platform isEqualToString:model.version]) {
            return model;
        }
    }
    
    return nil;
}

@end

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
        return [PaintingliteSystemUseInfo sharePaintingliteSystemUseInfo].applicationMemory;
    }
    
    return 0;
}

#pragma mark - CPU测试
- (float)paintingliteCPUUSAGE:(void (^)(void))block{
    if (block != nil) {
        /* 执行block */
        block();
        return [PaintingliteSystemUseInfo sharePaintingliteSystemUseInfo].applicationCPU;
    }
    
    return 0.0f;
}

#pragma mark - 压力测试
- (void)paintinglitePressure:(void (^)(void))block options:(NSString *__nonnull)options countIndex:(NSUInteger)countIndex{
    if (block != nil) {
        [self savePressure:self.saveType options:options countIndex:countIndex efficiency:[self paintingliteEfficiency:^{
            block();
        }] memoryUsage:[PaintingliteSystemUseInfo sharePaintingliteSystemUseInfo].applicationMemory cpuUsage:[PaintingliteSystemUseInfo sharePaintingliteSystemUseInfo].applicationCPU];
    }
}


#pragma mark - 保存测试数据
static NSUInteger groupCount = -1;
- (void)savePressure:(PaintinglitePressureOSSaveType)saveType options:(NSString *__nonnull)options countIndex:(NSUInteger)countIndex efficiency:(float)efficiency memoryUsage:(int64_t)memoryUsage cpuUsage:(float)cpuUsage{
    Boolean newGroupFlag = false;
    if (groupCount != countIndex){
        groupCount = countIndex;
        newGroupFlag = true;
    }
    
    /* 文件管理者 */
    NSFileManager *fileM = [NSFileManager defaultManager];
    
    NSArray<NSString *> *countArray = @[@"一万数据量 [10,000]",@"十万数据量 [100,000]",@"百万数据量 [1,000,000]"];

    NSError *error = nil;
    NSString *LOGOPATH = [[NSBundle mainBundle] pathForResource:@"LOGO" ofType:@"txt"];
    NSString *textStart = [NSString stringWithFormat:@"Paintinglite Sqlite Pressure Report\n%@",[NSString stringWithContentsOfFile:LOGOPATH usedEncoding:nil error:&error]];
    ;
    
    /* 获得MobileModel */
    MobileModel *model = [[[Mobile alloc] init] getMobileType];
    /* 设备型号 */
    NSString *iphoneType = model.mobileType != NULL ? model.mobileType : @"未知设备";
    /* 设备处理器信息 */
    NSString *cpuInfo = model.cpu != NULL ? model.cpu : @"未录入库";
    /* 设备下载上传速度 */
    NSString *speedInfo = model.speed != NULL ? model.speed : @"未录入库";
    
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
        
        startStr = [NSString stringWithFormat:@"%@\n手机型号:%@\t%@\t处理器:%@\t下载/上传速率:%@\n",textStart,iphoneType,version,cpuInfo,speedInfo];
    }
    
    NSString *pressureStr = [NSString stringWithFormat:@"\n测试数据量:%@\n%@_测试结果:\n(1)%@\n(2)%@\n(3)%@",countArray[countIndex],options,efficiencyStr,memoryUsageStr,cpuUsageStr];
    
    if (newGroupFlag){
        pressureStr = [[NSString stringWithFormat:@"\n======= GROUP %zd =======\n",groupCount] stringByAppendingString:pressureStr];
    }
    
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
    NSString *arg;
    while ((arg = va_arg(args, NSString *))) {
        /* 获得每一个参数 */
        /* 组合数组 */
        [self.pressureArray addObject:arg];
    }
    
    va_end(args);
    
    /* 创建测试数据库 */
    //存在PressureOS数据库,删除后在添加
    NSString *path = PRESSOS_DB_PATH(@"PressureOS.db");
    NSError *error = nil;
    if ([[PaintingliteFileManager defaultManager] fileExistsAtPath:path]){
        if (![[PaintingliteFileManager defaultManager] removeItemAtPath:path error:&error]){
            if (error) {
                NSLog(@" === REMOVE PRESSURE OS DATABASE ERROR: %@ ===",error.localizedDescription);
            }
        }
    }
    
    if (sqlite3_open([path UTF8String],&_ppDb) == SQLITE_OK){
        /*
         CREATE TABLE IF NOT EXISTS pressure(ID INTEGER primary key AUTOINCREMENT,name TEXT,age INTEGER,teacher TEXT,tage INTEGER,desc TEXT)
         */
        if(sqlite3_exec(_ppDb, [PRESSURETABLE UTF8String], 0, 0, NULL) == SQLITE_OK){
            /* 压力测试 */
            [self Pressure];
            
            /* 执行完成,删除测试数据库 */
            /*
                @"DROP TABLE pressure"
             */
            if (sqlite3_exec(_ppDb, [DROPPRESSURETABLE UTF8String], 0, 0, NULL) == SQLITE_OK){
                //释放数据库
                sqlite3_close(_ppDb);
                //删除压力测试数据库文件
                if (![[PaintingliteFileManager defaultManager] removeItemAtPath:path error:&error]){
                    if (error) {
                        NSLog(@" === REMOVE PRESSURE OS DATABASE ERROR: %@ ===",error.localizedDescription);
                    }
                }else return true;
            }
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
