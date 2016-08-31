//
//  PMConnection.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMRelation.h"

@implementation PMRelation
+ (PMRelation*)relationWithKeyId:(NSString *)keyIdentifier valueId:(NSString *)valueIdentifier{
    PMRelation *relation = [[PMRelation alloc]init];
    relation.keyIdentifier = keyIdentifier;
    relation.valueIdentifier = valueIdentifier;
    return relation;
}
#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
