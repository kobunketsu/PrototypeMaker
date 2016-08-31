//
//  PMIdea.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDetailInfo.h"
@class PMPrototype;
@class PMTag;

#define kChakra @"Chakra"

@interface PMIdea : PMDetailInfo

/**
 *  优点，特点
 */
//@property (copy, nonatomic) NSString *pros;


/**
 *  缺陷
 */
//@property (copy, nonatomic) NSString *cons;


@property (assign, nonatomic) ChakraEnum chakra;

+ (PMIdea *)ideaOfId:(NSString *)indentifier;

+ (PMIdea *)ideaWithTitle:(NSString *)title desc:(NSString *)desc;

- (void)addPrototype:(PMPrototype *)prototype;

- (void)deletePrototype:(PMPrototype *)prototype;

- (void)addTag:(PMTag *)tag;

- (void)deleteTag:(PMTag *)tag;

- (NSMutableArray *)tagIds;

- (NSMutableArray *)protoIds;


@end
