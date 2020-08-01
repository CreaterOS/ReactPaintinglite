//
//  Bus.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/31.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Bus : NSObject
@property (nonatomic,copy)NSString *BusDesc;
@property (nonatomic,copy)NSString *BusTitle;
@property (nonatomic,strong)NSNumber *BusYear;
@property (nonatomic,copy)NSString *UUID;
@end

NS_ASSUME_NONNULL_END
