//
//  PaintingliteConfiguration.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteConfiguration.h"

@implementation PaintingliteConfiguration

#pragma mark - 配置数据库名称
+ (NSString *)configurationFileName:(NSString *)fileName{
    //传入fileName只有文件名称没有路径时候，自动拼接路径
    //传入fileName如果是绝对路径，直接返回，不做处理
   
    if (!fileName.isAbsolutePath) {
        //当前路径下生成fileName
        fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:fileName];
    }

    return fileName;
}

@end
