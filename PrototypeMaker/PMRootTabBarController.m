//
//  PMRootTabBarController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMRootTabBarController.h"
#import "PMDataModel.h"
#import "PMDataViewController.h"
@interface PMRootTabBarController ()

@end

@implementation PMRootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = [PMDataViewController sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didBecomeActive:(NSNotification *)notification {
    DebugLog(@"didBecomeActive");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    DebugLog(@"tabBar didSelectItem");
}

- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray *)items{
    DebugLog(@"tabBar willBeginCustomizingItems");
}
- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray *)items{
    DebugLog(@"tabBar didBeginCustomizingItems");
}

- (void)tabBar:(UITabBar *)tabBar willEndCustomizingItems:(NSArray *)items changed:(BOOL)changed{
    DebugLog(@"tabBar willEndCustomizingItems");
}
- (void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed{
    DebugLog(@"tabBar didEndCustomizingItems");
}

#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
