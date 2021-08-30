//
//  PaintingliteConfiguration.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//
/*!
 @header PaintingliteConfiguration
 @abstract PaintingliteConfiguration 提供SDK框架中Sqlite3配置信息
 @author CreaterOS
 @version 1.00 2020/5/26 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import <Sqlite3.h>

/*!
 @abstract PaintingliteSynchronousMode Sync模式
 @constant PaintingliteSynchronousOFF OFF
 @constant PaintingliteSynchronousNORMAL NORMAL
 @constant PaintingliteSynchronousFULL FULL
 @discussion Sync模式
*/
typedef NS_ENUM(NSUInteger, PaintingliteSynchronousMode) {
    PaintingliteSynchronousOFF,
    PaintingliteSynchronousNORMAL,
    PaintingliteSynchronousFULL,
};

/*!
 @abstract PaintingliteEncoding 编码
 @constant PaintingliteEncodingUTF8 UTF8
 @constant PaintingliteEncodingUTF16 UTF16
 @constant PaintingliteEncodingUTF16le UTF16le
 @constant PaintingliteEncodingUTF16be UTF16be
 @discussion 编码
*/
typedef NS_ENUM(NSUInteger, PaintingliteEncoding) {
    PaintingliteEncodingUTF8,
    PaintingliteEncodingUTF16,
    PaintingliteEncodingUTF16le,
    PaintingliteEncodingUTF16be
};

/*!
 @abstract PaintingliteAutoVacuumMode Auto_Vacuum
 @constant PaintingliteAutoVacuumNONE NONE
 @constant PaintingliteAutoVacuumFULL FULL
 @constant PaintingliteAutoVacuumINCREMENTAL INCREMENTAL
 @discussion Auto_Vacuum
*/
typedef NS_ENUM(NSUInteger, PaintingliteAutoVacuumMode) {
    PaintingliteAutoVacuumNONE,
    PaintingliteAutoVacuumFULL,
    PaintingliteAutoVacuumINCREMENTAL,
};

/*!
 @abstract PaintingliteWalCheckpointMode wal_checkpoint
 @constant PaintingliteWalCheckpointPASSIVE PASSIVE
 @constant PaintingliteWalCheckpointFULL FULL
 @constant PaintingliteWalCheckpointRESTART RESTART
 @constant PaintingliteWalCheckpointTRUNCATE TRUNCATE
 @discussion wal_checkpoint
*/
typedef NS_ENUM(NSUInteger, PaintingliteWalCheckpointMode) {
    PaintingliteWalCheckpointPASSIVE,
    PaintingliteWalCheckpointFULL,
    PaintingliteWalCheckpointRESTART,
    PaintingliteWalCheckpointTRUNCATE
};

/*!
 @abstract PaintingliteJournalMode JournalMode
 @constant PaintingliteJournalDELETE DELETE
 @constant PaintingliteJournalTRUNCATE TRUNCATE
 @constant PaintingliteJournalPERSIST PERSIST
 @constant PaintingliteJournalMEMORY MEMORY
 @constant PaintingliteJournalOFF OFF
 @discussion JournalMode
*/
typedef NS_ENUM(NSUInteger, PaintingliteJournalMode) {
    PaintingliteJournalDELETE,
    PaintingliteJournalTRUNCATE,
    PaintingliteJournalPERSIST,
    PaintingliteJournalMEMORY,
    PaintingliteJournalOFF
};

NS_ASSUME_NONNULL_BEGIN

/*!
 @class PaintingliteConfiguration
 @abstract PaintingliteConfiguration 提供SDK框架中Sqlite3配置信息
 */
@interface PaintingliteConfiguration : NSObject
@property (nonatomic,copy)NSString *fileName; //数据库文件名称

/*!
 @method sharePaintingliteConfiguration
 @abstract 单例模式生成PaintingliteConfiguration对象
 @discussion 生成PaintingliteConfiguration在项目工程全局中只生成一个实例对象
 @result PaintingliteConfiguration
 */
+ (instancetype)share;

/*!
 @method configurationFileName:
 @abstract 配置数据库文件
 @discussion 配置数据库文件
 @param fileName 数据库名称
 @result NSString
 */
- (NSString *)configurationFileName:(NSString *__nonnull)fileName;

/*!
 @method setSynchronous: mode:
 @abstract Synchronous模式
 @discussion 配置Synchronous模式
 @param ppDb Sqlite3 ppDb
 @param mode 模式
 @result Boolean
 */
+ (Boolean)setSynchronous:(sqlite3 *)ppDb mode:(PaintingliteSynchronousMode)mode;

/*!
 @method getSynchronous:
 @abstract Synchronous模式
 @discussion 获得Synchronous模式
 @param ppDb Sqlite3 ppDb
 @result NSString
 */
+ (NSString *)getSynchronous:(sqlite3 *)ppDb;

/*!
 @method setEncoding: encoding:
 @abstract 数据库编码
 @discussion 配置数据库编码
 @param ppDb Sqlite3 ppDb
 @param encoding 编码
 @result Boolean
 */
+ (Boolean)setEncoding:(sqlite3 *)ppDb encoding:(PaintingliteEncoding)encoding;

/// 查看数据库编码
/// @param ppDb ppDb
+ (NSString *)getEncoding:(sqlite3 *)ppDb;

/*!
 @method setAutoVacuum: mode:
 @abstract Auto_Vacuum模式
 @discussion 配置Auto_Vacuum模式
 @param ppDb Sqlite3 ppDb
 @param mode 模式
 @result Boolean
 */
+ (Boolean)setAutoVacuum:(sqlite3 *)ppDb mode:(PaintingliteAutoVacuumMode)mode;

/// Auto_Vacuum模式
/// @param ppDb ppDb
+ (NSString *)getAutoVacuum:(sqlite3 *)ppDb;

/*!
 @method setWalCheckpoint: mode:
 @abstract wal_checkpoint模式
 @discussion 配置wal_checkpoint模式
 @param ppDb Sqlite3 ppDb
 @param mode 模式
 @result Boolean
 */
+ (Boolean)setWalCheckpoint:(sqlite3 *)ppDb mode:(PaintingliteWalCheckpointMode)mode;

/*!
 @method setCacheSize: size:
 @abstract CacheSize数值
 @discussion 配置CacheSize数值
 @param ppDb Sqlite3 ppDb
 @param size 缓存大小
 @result Boolean
 */
+ (Boolean)setCacheSize:(sqlite3 *)ppDb size:(NSUInteger)size;

/// CacheSize数值
/// @param ppDb ppDb
+ (NSString *)getCacheSize:(sqlite3 *)ppDb;

/*!
 @method setThreadNum: number:
 @abstract 线程数目
 @discussion 配置线程数目
 @param ppDb Sqlite3 ppDb
 @param number 线程数
 @result Boolean
 */
+ (Boolean)setThreadNum:(sqlite3 *)ppDb number:(NSUInteger)number;

/// 查看数据库Thread数值
/// @param ppDb ppDb
+ (NSString *)getThread:(sqlite3 *)ppDb;

/*!
 @method setTrustedSchema: boolean:
 @abstract trusted_schema
 @discussion 配置trusted_schema
 @param ppDb Sqlite3 ppDb
 @param boolean 是否开启
 @result Boolean
 */
+ (Boolean)setTrustedSchema:(sqlite3 *)ppDb boolean:(Boolean)boolean;

/*!
 @method setCaseSensitiveLike: boolean:
 @abstract case_sensitive_like
 @discussion 配置case_sensitive_like
 @param ppDb Sqlite3 ppDb
 @param boolean 是否开启
 @result Boolean
 */
+ (Boolean)setCaseSensitiveLike:(sqlite3 *)ppDb boolean:(Boolean)boolean;

/*!
 @method setCountChanges: boolean:
 @abstract count_changes
 @discussion 配置count_changes
 @param ppDb Sqlite3 ppDb
 @param boolean 是否开启
 @result Boolean
 */
+ (Boolean)setCountChanges:(sqlite3 *)ppDb boolean:(Boolean)boolean;

/*!
 @method setJournalMode: mode:
 @abstract journal_mode
 @discussion 配置journal_mode
 @param ppDb Sqlite3 ppDb
 @param mode 模式
 @result Boolean
 */
+ (Boolean)setJournalMode:(sqlite3 *)ppDb mode:(PaintingliteJournalMode)mode;

@end

NS_ASSUME_NONNULL_END
