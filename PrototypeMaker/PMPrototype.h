//
//  PMPrototype.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDetailInfo.h"
typedef NS_ENUM(NSUInteger, ProtoRelatedType) {
    RT_Idea,
};
@protocol NSString
@end

@class PMIdea;

@interface PMPrototype : PMDetailInfo
@property (assign, nonatomic) ChakraEnum chakra;

+ (PMPrototype *)protoOfId:(NSString *)indentifier;

+ (NSString *)protoIdOfTitle:(NSString *)title;

+ (PMPrototype *)prototypeWithTitle:(NSString *)title desc:(NSString *)desc;

- (NSMutableArray *)ideaIds;

- (void)addIdea:(PMIdea *)idea;

- (void)deleteIdea:(PMIdea *)idea;

#pragma mark- Related
/**
 *  取得相关的原型列表
 *
 *  @return <#return value description#>
 */
- (NSArray *)relatedProtosByType:(ProtoRelatedType)type;
/**
 *  <#Description#>
 *
 *  @param protoId <#protoId description#>
 *
 *  @return <#return value description#>
 */

- (NSArray *)intersectionIdeaIdsOfProtoId:(NSString *)protoId;
@end
