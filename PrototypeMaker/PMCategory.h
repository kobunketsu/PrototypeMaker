//
//  PMCategory.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/20/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMBaseInfo.h"
#import "PMTag.h"
@interface PMCategory : PMBaseInfo
/**
 *  过滤出的标志
 */
@property(retain, nonatomic) NSMutableArray *tagIds;

- (void)addTag:(PMTag *)tag;

- (void)deleteTag:(PMTag *)tag;
@end
