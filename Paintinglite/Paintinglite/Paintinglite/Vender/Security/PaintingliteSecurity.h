//
//  PaintingliteSecurity.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/27.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

/*!
 @header PaintingliteSecurity
 @abstract PaintingliteSecurity 提供SDK框架中数据安全保护机制
 @author CreaterOS
 @version 1.00 2020/5/27 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import "PaintingliteSecurityCodeTool.h"
#import "PaintingliteSecurityDecodeTool.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 @class PaintingliteSecurity
 @abstract PaintingliteSecurity 提供SDK框架中数据安全保护机制
 */
@interface PaintingliteSecurity : NSObject

- (PaintingliteSecurityCodeTool *__nonnull)getSecurityCode; /** 加密*/

- (PaintingliteSecurityDecodeTool *__nonnull)getSecurityDecode; /** 解密*/

@end

NS_ASSUME_NONNULL_END
