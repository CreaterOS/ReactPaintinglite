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
#import <Sqlite3.h>

#define PaintingliteSessionFactoryLite sqlite3
#define PaintingliteSessionFactory_Sqlite_Queque dispatch_queue_create("PaintingliteSessionFactory_Sqlite_Queque", NULL)

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteSessionFactory : NSObject

/* 单例模式 */
+ (instancetype)sharePaintingliteSessionFactory;

/* 执行查询 */
- (void)execQuery:(sqlite3 *)ppDb sql:(NSString *)sql;

@end

NS_ASSUME_NONNULL_END
