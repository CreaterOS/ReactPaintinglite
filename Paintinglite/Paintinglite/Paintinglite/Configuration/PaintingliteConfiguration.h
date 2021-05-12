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

typedef NS_ENUM(NSUInteger, PaintingliteJournalMode) {
    PaintingliteJournalDELETE,
    PaintingliteJournalTRUNCATE,
    PaintingliteJournalPERSIST,
    PaintingliteJournalMEMORY,
    PaintingliteJournalOFF
};

NS_ASSUME_NONNULL_BEGIN


@interface PaintingliteConfiguration : NSObject
@property (nonatomic,copy)NSString *fileName; //数据库文件名称

/// 单例模式
+ (instancetype)sharePaintingliteConfiguration;

/// 配置数据库文件名称
/// @param fileName 数据库名称
- (NSString *)configurationFileName:(NSString *__nonnull)fileName;

/* =====================================数据库模式操作======================================== */
/// Synchronous模式
/// @param ppDb ppDb
/// @param mode 模式
+ (Boolean)setSynchronous:(sqlite3 *)ppDb mode:(PaintingliteSynchronousMode)mode;

/// 查看数据库Synchronous模式
/// @param ppDb ppDb
+ (NSString *)getSynchronous:(sqlite3 *)ppDb;


/// 配置数据库编码
/// @param ppDb ppDb
/// @param encoding 编码
+ (Boolean)setEncoding:(sqlite3 *)ppDb encoding:(PaintingliteEncoding)encoding;

/// 查看数据库编码
/// @param ppDb ppDb
+ (NSString *)getEncoding:(sqlite3 *)ppDb;

/// Auto_Vacuum模式
/// @param ppDb ppDb
/// @param mode 模式
+ (Boolean)setAutoVacuum:(sqlite3 *)ppDb mode:(PaintingliteAutoVacuumMode)mode;

/// Auto_Vacuum模式
/// @param ppDb ppDb
+ (NSString *)getAutoVacuum:(sqlite3 *)ppDb;

/// wal_checkpoint模式
/// @param ppDb ppDb
/// @param mode 模式
+ (Boolean)setWalCheckpoint:(sqlite3 *)ppDb mode:(PaintingliteWalCheckpointMode)mode;

/// CacheSize数值
/// @param ppDb ppDb
/// @param size 缓存大小
+ (Boolean)setCacheSize:(sqlite3 *)ppDb size:(NSUInteger)size;

/// CacheSize数值
/// @param ppDb ppDb
+ (NSString *)getCacheSize:(sqlite3 *)ppDb;

/// Thread数值
/// @param ppDb ppDb
/// @param number 线程数
+ (Boolean)setThreadNum:(sqlite3 *)ppDb number:(NSUInteger)number;

/// 查看数据库Thread数值
/// @param ppDb ppDb
+ (NSString *)getThread:(sqlite3 *)ppDb;

/// trusted_schema
/// @param ppDb ppDb
/// @param boolean 是否开启
+ (Boolean)setTrustedSchema:(sqlite3 *)ppDb boolean:(Boolean)boolean;

/// case_sensitive_like
/// @param ppDb ppDb
/// @param boolean 是否开启
+ (Boolean)setCaseSensitiveLike:(sqlite3 *)ppDb boolean:(Boolean)boolean;

/// count_changes
/// @param ppDb ppDb
/// @param boolean 是否开启
+ (Boolean)setCountChanges:(sqlite3 *)ppDb boolean:(Boolean)boolean;

/// journal_mode
/// @param ppDb ppDb
/// @param mode 是否开启
+ (Boolean)setJournalMode:(sqlite3 *)ppDb mode:(PaintingliteJournalMode)mode;

@end

NS_ASSUME_NONNULL_END
