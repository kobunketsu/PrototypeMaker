//
//  PMCategory.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/20/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMCategory.h"

@implementation PMCategory
- (id)initWithTitle:(NSString *)title desc:(NSString *)desc{
    self = [super initWithTitle:title desc:desc];
    if (self) {
        _tagIds = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)addTag:(PMTag *)tag{
    if ([self.tagIds containsObject:tag.identifier]) {
        return;
    }
    [self.tagIds addObject:tag.identifier];
}

- (void)deleteTag:(PMTag *)tag{
    if (![self.tagIds containsObject:tag.identifier]) {
        return;
    }
    [self.tagIds removeObject:tag.identifier];
}
#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
