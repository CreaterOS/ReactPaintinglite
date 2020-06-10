//
//  PaintingliteUUID.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/10.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/**
 * PaintingliteUUID
 * 生成UUID
 */
#import "PaintingliteCUDOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteUUID : PaintingliteCUDOptions

/* 获得UUID */
+ (NSString *__nonnull)getPaintingliteUUID;

@end

NS_ASSUME_NONNULL_END
