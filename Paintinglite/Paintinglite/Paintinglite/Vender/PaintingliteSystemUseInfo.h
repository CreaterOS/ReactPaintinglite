//
//  PaintingliteSystemUseInfo.h
//  Paintinglite
//
//  Created by 纽扣软件 on 2021/5/13.
//  Copyright © 2021 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaintingliteSystemUseInfo : NSObject

+ (instancetype)sharePaintingliteSystemUseInfo;

- (double)applicationCPU;
- (double)applicationMemory;
- (double)systemCPU;
- (double)systemMemory;

@end

NS_ASSUME_NONNULL_END
