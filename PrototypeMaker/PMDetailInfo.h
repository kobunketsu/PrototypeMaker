//
//  PMDetailInfo.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/6/28.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import "PMBaseInfo.h"
typedef NS_ENUM(NSUInteger, ChakraEnum) {
    CharaSurvival,
    CharaEmotion,
    CharaPower,
    CharaLove,
    CharaConnect,
    CharaImagination,
    CharaSpiritual,
    CharaMax,
};

@interface PMDetailInfo : PMBaseInfo

@property(retain, nonatomic) NSMutableArray *imagePaths;
@end
