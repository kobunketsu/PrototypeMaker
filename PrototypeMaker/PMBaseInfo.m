//
//  PMBaseInfo.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/14/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMBaseInfo.h"

@implementation PMBaseInfo
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.identifier forKey:kIdentifierKey];
    [aCoder encodeObject:self.title forKey:kTitleKey];
    [aCoder encodeObject:self.desc forKey:kDescKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _identifier = [aDecoder decodeObjectForKey:kIdentifierKey];
        _title = [aDecoder decodeObjectForKey:kTitleKey];
        _desc = [aDecoder decodeObjectForKey:kDescKey];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title desc:(NSString *)desc{
    self = [super init];
    if (self) {
        _identifier = [NSString stringWithFormat:@"%zd", self.hash];
        _title = (title == nil) ? @"" : title; //jsonModel validation
        _desc = (desc == nil) ? @"" : desc; //jsonModel validation
    }
    return self;
}


#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
