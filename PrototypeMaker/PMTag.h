//
//  PMTag.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/20/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMBaseInfo.h"

@interface PMTag : PMBaseInfo
+ (PMTag *)tagOfId:(NSString *)indentifier;

+ (PMTag *)tagWithTitle:(NSString *)title;
@end
