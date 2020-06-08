//
//  User.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/30.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSNumber *age;
@property (nonatomic,strong)NSString *tempStr;
@property (nonatomic,strong)NSString *tempStr1;
@property (nonatomic,strong)NSString *tempStr2;
@property (nonatomic,strong)NSString *tempStr3;
@property (nonatomic,strong)NSMutableArray<id> *mutableArray;

@end

NS_ASSUME_NONNULL_END
