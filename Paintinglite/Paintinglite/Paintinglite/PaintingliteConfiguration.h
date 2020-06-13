//
//  PaintingliteConfiguration.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sqlite3.h>

/* Sync模式 */
typedef NS_ENUM(NSUInteger, PaintingliteSynchronousMode) {
    PaintingliteSynchronousOFF,
    PaintingliteSynchronousNORMAL,
    PaintingliteSynchronousFULL,
};

/* 编码 */
typedef NS_ENUM(NSUInteger, PaintingliteEncoding) {
    PaintingliteEncodingUTF8,
    PaintingliteEncodingUTF16,
    PaintingliteEncodingUTF16le,
    PaintingliteEncodingUTF16be
};

/* Auto_Vacuum */
typedef NS_ENUM(NSUInteger, PaintingliteAutoVacuumMode) {
    PaintingliteAutoVacuumNONE,
    PaintingliteAutoVacuumFULL,
    PaintingliteAutoVacuumINCREMENTAL,
};

/* wal_checkpoint */
typedef NS_ENUM(NSUInteger, PaintingliteWalCheckpointMode) {
    PaintingliteWalCheckpointPASSIVE,
    PaintingliteWalCheckpointFULL,
    PaintingliteWalCheckpointRESTART,
    PaintingliteWalCheckpointTRUNCATE
};

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteConfiguration : NSObject
@property (nonatomic,copy)NSString *fileName; //数据库文件名称

/* 单例模式 */
+ (instancetype)sharePaintingliteConfiguration;

/* 配置数据库文件名称 */
- (NSString *)configurationFileName:(NSString *__nonnull)fileName;

/* 修改数据库Synchronous模式 */
+ (Boolean)setSynchronous:(sqlite3 *)ppDb mode:(PaintingliteSynchronousMode)mode;

/* 查看数据库Synchronous模式 */
+ (NSString *)getSynchronous:(sqlite3 *)ppDb;

/* 配置数据库编码 */
+ (Boolean)setEncoding:(sqlite3 *)ppDb encoding:(PaintingliteEncoding)encoding;

/* 查看数据库编码 */
+ (NSString *)getEncoding:(sqlite3 *)ppDb;

/* 修改数据库Auto_Vacuum模式 */
+ (Boolean)setAutoVacuum:(sqlite3 *)ppDb mode:(PaintingliteAutoVacuumMode)mode;

/* 查看数据库Auto_Vacuum模式 */
+ (NSString *)getAutoVacuum:(sqlite3 *)ppDb;

/* 修改数据库wal_checkpoint模式 */
+ (Boolean)setWalCheckpoint:(sqlite3 *)ppDb mode:(PaintingliteWalCheckpointMode)mode;

/* 修改数据库CacheSize数值 */
+ (Boolean)setCacheSize:(sqlite3 *)ppDb size:(NSUInteger)size;

/* 查看数据库CacheSize数值 */
+ (NSString *)getCacheSize:(sqlite3 *)ppDb;

/* 修改数据库Thread数值 */
+ (Boolean)setThreadNum:(sqlite3 *)ppDb number:(NSUInteger)number;

/* 查看数据库Thread数值 */
+ (NSString *)getThread:(sqlite3 *)ppDb;

/* 修改数据库trusted_schema */
+ (Boolean)setTrustedSchema:(sqlite3 *)ppDb boolean:(Boolean)boolean;

@end

NS_ASSUME_NONNULL_END
