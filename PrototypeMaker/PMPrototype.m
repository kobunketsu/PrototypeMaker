//
//  PMPrototype.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMPrototype.h"
#import "PMDataModel.h"
#import "PMRelation.h"
@implementation PMPrototype
+ (PMPrototype *)protoOfId:(NSString *)indentifier{
    return [[PMDataModel current].protos valueForKey:indentifier];
}

+ (NSString *)protoIdOfTitle:(NSString *)title{
    for (NSString *protoId in [PMDataModel current].protos.allKeys) {
        PMPrototype *proto = [[PMDataModel current].protos valueForKey:protoId];
        if ([proto.title isEqualToString:title caseSensitive:false]) {
            return protoId;
        }
    }
    return nil;
}

#pragma mark-
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.chakra forKey:kChakra];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _chakra = [aDecoder decodeIntegerForKey:kChakra];
    }
    return self;
}

- (void)addIdea:(PMIdea *)idea{
    NSMutableArray *ideaIds = [[PMDataModel current].protoIdMappedIdeaIds valueForKey:self.identifier];
    if (!ideaIds) {
        ideaIds = [[NSMutableArray alloc]init];
        [[PMDataModel current].protoIdMappedIdeaIds setValue:ideaIds forKey:self.identifier];
    }
    
    if (![ideaIds containsObject:idea.identifier]) {
        [ideaIds addObject:idea.identifier];
    }

}

- (void)deleteIdea:(PMIdea *)idea{
    NSMutableArray *ideaIds = [[PMDataModel current].protoIdMappedIdeaIds valueForKey:self.identifier];
    if (!ideaIds) {
        return;
    }
    
    if ([ideaIds containsObject:idea.identifier]) {
        [ideaIds removeObject:idea.identifier];
    }

}

- (NSMutableArray *)ideaIds{
    return  [[PMDataModel current].protoIdMappedIdeaIds valueForKey:self.identifier];
}

+ (PMPrototype *)prototypeWithTitle:(NSString *)title desc:(NSString *)desc{
    for (NSString *protoId in [PMDataModel current].protos.allKeys) {
        PMPrototype *proto = [PMDataModel current].protos[protoId];
        if ([proto.title isEqualToString:title caseSensitive:false]) {
            //update params
            proto.desc = desc;
            return proto;
        }
    }
    
    PMPrototype *pt = [[PMPrototype alloc]initWithTitle:title desc:desc];
    return pt;
}

#pragma mark- Related
- (NSArray *)relatedProtosByType:(ProtoRelatedType)type{
    if (type == RT_Idea) {
        /**
         *  遍历库里的所有protos，比较每个proto的idea的交集，将交集数量排序
         */
        NSArray *sortedProtoIds = [[PMDataModel current].protos.allKeys sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *protoId1 = obj1;
            NSString *protoId2 = obj2;
            if ([self intersectionIdeaIdsOfProtoId:protoId1].count > [self intersectionIdeaIdsOfProtoId:protoId2].count) {
                return NSOrderedAscending;
            }
            else{
                return NSOrderedDescending;
            }
        }];
        
        return sortedProtoIds;
    }
    return nil;
}

- (NSArray *)intersectionIdeaIdsOfProtoId:(NSString *)protoId{
    NSMutableOrderedSet *intersection = [NSMutableOrderedSet orderedSetWithArray:self.ideaIds];
    
    NSMutableArray *ideaIds = [[PMDataModel current].protoIdMappedIdeaIds valueForKey:protoId];
    [intersection intersectSet:[NSSet setWithArray:ideaIds]];
    
    return  intersection.array;
}
#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
