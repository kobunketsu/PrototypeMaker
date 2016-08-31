//
//  PMTag.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/20/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMTag.h"
#import "PMDataModel.h"

@implementation PMTag
+ (PMTag *)tagOfId:(NSString *)indentifier{
    return [[PMDataModel current].tags valueForKey:indentifier];
}

+ (PMTag *)tagWithTitle:(NSString *)title{
    //desc nil导致jsonModel出错
    PMTag *tag = [[PMTag alloc]initWithTitle:title desc:@""];
    return tag;
}
#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
