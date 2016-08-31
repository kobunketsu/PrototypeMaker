//
//  PMDataViewController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/17/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMDataViewController.h"

@implementation PMDataViewController
static PMDataViewController* sharedInstance = nil;

+(PMDataViewController*)sharedInstance{
    if(sharedInstance != nil){
        return sharedInstance;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PMDataViewController alloc]init];
    });
    return sharedInstance;
}

#pragma mark- UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController.title isEqualToString:@"ProtoNavController" caseSensitive:false]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        if ([PMDataViewController sharedInstance].curIdea &&
            [PMDataViewController sharedInstance].curProto) {
            [nav popToRootViewControllerAnimated:true];
        }
        
    }
    else if ([viewController.title isEqualToString:@"IdeaNavController" caseSensitive:false]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        if ([PMDataViewController sharedInstance].curProto &&
            [PMDataViewController sharedInstance].curIdea) {
            [nav popToRootViewControllerAnimated:true];
        }
    }
}

- (void)setCurProto:(PMPrototype *)curProto{
    DebugLog(@"setCurProto %@", curProto);
    _curProto = curProto;
}
#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
