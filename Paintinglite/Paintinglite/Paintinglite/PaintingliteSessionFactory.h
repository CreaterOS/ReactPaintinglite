//
//  PaintingliteSessionFactory.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteSessionFactory
 * Session工厂类
 */
#import <Foundation/Foundation.h>
#import "PaintingliteLog.h"
#import <Sqlite3.h>

#define PaintingliteSessionFactoryLite sqlite3
#define PaintingliteSessionFactory_Sqlite_Queque dispatch_queue_create("PaintingliteSessionFactory_Sqlite_Queque", NULL)

typedef NS_ENUM(NSUInteger, PaintingliteSessionFactoryStatus) {
    PaintingliteSessionFactoryTableCache,
    PaintingliteSessionFactoryTableINFOCache
};

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteSessionFactory : NSObject

/* 单例模式 */
+ (instancetype)sharePaintingliteSessionFactory;

/* 执行查询 */
- (NSMutableArray *)execQuery:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableNaem sql:(NSString *__nonnull)sql status:(PaintingliteSessionFactoryStatus)status;

/* 删除日志文件 */
- (void)removeLogFile:(NSString *)fileName;

/* 读取日志文件 */
- (NSString *)readLogFile:(NSString *__nonnull)fileName;

- (NSString *)readLogFile:(NSString *)fileName dateTime:(NSDate *__nonnull)dateTime;

- (NSString *)readLogFile:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus;

@end

NS_ASSUME_NONNULL_END
