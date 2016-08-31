//
//  PMIdea.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMIdea.h"
#import "PMDataModel.h"
#import "PMRelation.h"

@implementation PMIdea
#pragma mark- class
+ (PMIdea *)ideaOfId:(NSString *)indentifier{
    return [[PMDataModel current].ideas valueForKey:indentifier];
}

+ (PMIdea *)ideaWithTitle:(NSString *)title desc:(NSString *)desc{
    for (PMIdea *idea in [PMDataModel current].ideas.allValues) {
        if ([idea.title isEqualToString:title caseSensitive:false]) {
            return idea;
        }
    }

    PMIdea *idea = [[PMIdea alloc]initWithTitle:title desc:desc];
    
    return idea;
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

#pragma mark-

- (void)addPrototype:(PMPrototype *)prototype{
    NSMutableArray *protoIds = [[PMDataModel current].ideaIdMappedProtoIds valueForKey:self.identifier];
    if (!protoIds) {
        protoIds = [[NSMutableArray alloc]init];
        [[PMDataModel current].ideaIdMappedProtoIds setValue:protoIds forKey:self.identifier];
    }
    
    if (![protoIds containsObject:prototype.identifier]) {
        [protoIds addObject:prototype.identifier];
    }
}

- (void)deletePrototype:(PMPrototype *)prototype{
    //data
    NSMutableArray *protoIds = [[PMDataModel current].ideaIdMappedProtoIds valueForKey:self.identifier];
    if (!protoIds) {
        return;
    }
    
    if ([protoIds containsObject:prototype.identifier]) {
        [protoIds removeObject:prototype.identifier];
    }
}

- (void)addTag:(PMTag *)tag{
    
    //data
    NSMutableArray *tagIds = [[PMDataModel current].ideaIdMappedTagIds valueForKey:self.identifier];
    if (!tagIds) {
        tagIds = [[NSMutableArray alloc]init];
        [[PMDataModel current].ideaIdMappedTagIds setValue:tagIds forKey:self.identifier];
    }
    
    if (![tagIds containsObject:tag.identifier]) {
        [tagIds addObject:tag.identifier];
    }
    
}


- (void)deleteTag:(PMTag *)tag{
    //data
    NSMutableArray *tagIds = [[PMDataModel current].ideaIdMappedTagIds valueForKey:self.identifier];
    if (!tagIds) {
        return;
    }
    
    if ([tagIds containsObject:tag.identifier]) {
        [tagIds removeObject:tag.identifier];
        
    }
}

- (NSMutableArray *)tagIds{
    return [[PMDataModel current].ideaIdMappedTagIds valueForKey:self.identifier];
}


- (NSMutableArray *)protoIds{
    return [[PMDataModel current].ideaIdMappedProtoIds valueForKey:self.identifier];
}


#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
