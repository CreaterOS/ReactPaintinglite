//
//  PaintingliteException.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/29.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteException : NSException

+ (void)PaintingliteException:(NSString *)exceptionWithName reason:(NSString *)reason;

@end

NS_ASSUME_NONNULL_END
