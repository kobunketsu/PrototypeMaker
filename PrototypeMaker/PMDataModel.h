//
//  PMDataModel.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMIdea.h"
#import "PMPrototype.h"
#import "PMTag.h"
#import "PMCategory.h"
#import "JSONModel.h"

//@interface PMDataManager : NSObject <NSCoding>
@protocol PMIdea
@end

@protocol PMPrototype
@end

@protocol PMTag
@end

@protocol PMCategory
@end

@interface PMDataModel : NSObject<NSCoding>
+ (PMDataModel*)current;
+ (void)setCurrent:(PMDataModel *)dataModel;

#pragma mark- Data Storage
@property (assign, nonatomic)NSInteger version;
/**
 *  库里的所有创意
 */
@property(retain, nonatomic) NSMutableDictionary <PMIdea>*ideas;

/**
 *  库里的所有原型
 */
@property(retain, nonatomic) NSMutableDictionary <PMPrototype>*protos;

/**
 *   库里的所有标志
 */
@property(retain, nonatomic) NSMutableDictionary <PMTag>*tags;

/**
 *  创意相关的原型map
 */
@property(retain, nonatomic) NSMutableDictionary *ideaIdMappedProtoIds;

/**
 *  原型相关的创意map
 */
@property(retain, nonatomic) NSMutableDictionary *protoIdMappedIdeaIds;

/**
 *  创意相关的tags组
 */
@property(retain, nonatomic) NSMutableDictionary *ideaIdMappedTagIds;

/**
 *  保存到json文件
 */
//- (void)saveToJson;

/**
 *  从json文件加载
 */
//- (void)loadFromJson;

#pragma mark- Under development
/**
 *  原型的类别，尚未开发
 */
@property(retain, nonatomic) NSMutableArray <PMCategory>*protoCategories;

/**
 * 原型相关的tags组, 尚未开发
 */
@property(retain, nonatomic) NSMutableDictionary *protoCategoryIdMappedTagIds;
#pragma mark- Collection is not for storage


/**
 *  过滤出的创意，用于生成原型
 */
@property(retain, nonatomic) NSMutableArray *ideaIdCollection;

/**
 *  过滤出的原型，用于生成创意
 */
@property(retain, nonatomic) NSMutableArray *protoIdCollection;

/**
 *  用于在生成或者搜索创意时添加条件
 */
@property(retain, nonatomic) NSMutableArray *tagIdCollection;


#pragma mark- Method
- (void)addIdea:(PMIdea *)idea;

- (void)deleteIdea:(PMIdea *)idea;

- (void)addProto:(PMPrototype *)prototype;

- (void)deleteProto:(PMPrototype *)prototype;

- (void)connectProto:(PMPrototype *)prototype withIdea:(PMIdea *)idea;

- (void)addTag:(PMTag *)tag;

- (void)deleteTag:(PMTag *)tag;

- (void)connectIdea:(PMIdea *)idea withTag:(PMTag *)tag;

- (void)feedSampleData;

/**
 *  由原型列表得到相关创意列表
 *
 *  @param prototypes <#prototypes description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)ideaIdsFromProtoIds:(NSMutableArray *)protoIds;

/**
 *  由创意列表得到相关原型列表
 *
 *  @param ideas <#ideas description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)protoIdsFromIdeaIds:(NSMutableArray *)ideaIds;

/**
 *  由创意列表得到相关标志列表
 *
 *  @param ideas <#ideas description#>
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)tagIdsFromIdeaIds:(NSMutableArray *)ideaIds;
///**
// *  得到一组proto中共享的idea列表
// *
// *  @param protoIds <#protoIds description#>
// *
// *  @return <#return value description#>
// */
//- (NSArray *)sharedIdeaIdsFromProtoIds:(NSArray *)protoIds;

#pragma mark- iCloud Save Load


@end
