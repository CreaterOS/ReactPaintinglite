//
//  PaintingliteSessionError.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteSessionError : NSError

/* 单例模式 */
+ (instancetype)sharePaintingliteSessionError;

@end

NS_ASSUME_NONNULL_END
