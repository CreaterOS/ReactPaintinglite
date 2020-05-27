//
//  PaintingliteConfiguration.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteConfiguration : NSObject
@property (nonatomic,copy)NSString *fileName; //数据库文件名称

/* 单例模式 */
+ (instancetype)sharePaintingliteConfiguration;

/* 配置数据库文件名称 */
- (NSString *)configurationFileName:(NSString *__nonnull)fileName;

@end

NS_ASSUME_NONNULL_END
