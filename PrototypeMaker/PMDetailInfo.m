//
//  PMDetailInfo.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/6/28.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import "PMDetailInfo.h"

@implementation PMDetailInfo
- (id)initWithTitle:(NSString *)title desc:(NSString *)desc{
    self = [super initWithTitle:title desc:desc];
    if (self) {
        _imagePaths = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
