//
//  PaintingliteLog.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteLog
 @abstract PaintingliteLog 提供SDK框架中操作日志写入,针对操作进行日期和状态写入
 @author CreaterOS
 @version 1.00 2020/5/26 Creation (此文档的版本信息)
 */

#import <Foundation/Foundation.h>

/*!
 @abstract kLogStatus 日志保存状态
 @constant kLogSuccess 日志保存成功 @constant kLogError 日志保存失败
 @discussion 测试报告保存类型
*/
typedef NS_ENUM(NSInteger, kLogStatus){
    kLogSuccess, //成功
    kLogError //错误
};

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteLog
 @abstract PaintingliteLog 提供SDK框架中操作日志写入,针对操作进行日期和状态写入
 */
@interface PaintingliteLog : NSObject
/*!
 @property options
 @abstract 操作语句
 */
@property (nonatomic,copy)NSString *options;
/*!
 @property optDate
 @abstract 操作日期
 */
@property (nonatomic,strong)NSDate *optDate;
/*!
 @property status
 @abstract 日志保存状态
 */
@property (nonatomic)kLogStatus status;
/*!
 @property logsPath
 @abstract 目录下所有的日志文件绝对路径
 */
@property (nonatomic,strong)NSDictionary<NSString *,NSString *> *logsPath;

/*!
 @method PaintingliteLog
 @abstract 单例模式生成PaintingliteLog对象
 @discussion 生成PaintingliteLog在项目工程全局中只生成一个实例对象
 @result PaintingliteLog
 */
+ (instancetype)sharePaintingliteLog;

/*!
 @method writeLogFileOptions: status: completeHandler:
 @abstract 写入日志文件
 @discussion 写入日志文件
 @param options 操作语句
 @param status 日志保存状态
 @param completeHandler 回调操作
 */
- (void)writeLogFileOptions:(NSString *__nonnull)options status:(kLogStatus)status completeHandler:(void(^ __nullable)(NSString *logFilePath))completeHandler;

/*!
 @method removeLogFile:
 @abstract 删除日志文件
 @discussion 删除日志文件
 @param fileName 日志名称
 @result Boolean
 */
- (Boolean)removeLogFile:(NSString *)fileName;

/*!
 @method readLogFile:
 @abstract 读取日志文件
 @discussion 读取日志文件
 @param fileName 日志名称
 @result NSString
 */
- (NSString *)readLogFile:(NSString *__nonnull)fileName;

/*!
 @method readLogFile:
 @abstract 读取日志文件
 @discussion 读取日志文件
 @param fileName 日志名称
 @param dateTime 时间节点
 @result NSString
 */
- (NSString *)readLogFile:(NSString *)fileName dateTime:(NSDate *__nonnull)dateTime;

/*!
 @method readLogFile: logStatus:
 @abstract 读取日志文件
 @discussion 读取日志文件
 @param fileName 日志名称
 @param logStatus 日志保存状态
 @result NSString
 */
- (NSString *)readLogFile:(NSString *)fileName logStatus:(kLogStatus)logStatus;

/*!
 @method logFileModificationTime:
 @abstract 查看日志文件最终修改时间
 @discussion 查看日志文件最终修改时间
 @param logFilePath 日志文件路径
 @result NSDate
 */
- (NSDate *)logFileModificationTime:(NSString *__nonnull)logFilePath;

/*!
 @method logFileSize:
 @abstract 查看日志文件大小
 @discussion 查看日志文件大小
 @param logFilePath 日志文件路径
 @result double
 */
- (double)logFileSize:(NSString *__nonnull)logFilePath;

/*!
 @method logfileLineWithDatabaseName:
 @abstract 查看日志文件条数
 @discussion 查看日志文件条数
 @param logfileName 日志名称
 @result NSUInteger
 */
- (NSUInteger)logfileLineWithDatabaseName:(NSString *__nonnull)logfileName;

@end

NS_ASSUME_NONNULL_END
