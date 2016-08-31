//
//  UIView+GLCoord.h
//  PaintProjector
//
//  Created by 胡 文杰 on 6/12/14.
//  Copyright (c) 2014 WenjiHu. All rights reserved.
//

#import <UIKit/UIKit.h>
static UIViewController *dismissDeepVC;
static UIView *dismissDeepFixView;

@interface UIViewController (Extension)
#pragma mark- Common
+ (UIViewController *)finalPresentedViewController:(UIViewController *)controller;
+ (UIViewController *)getCurrentRootViewController;

#pragma mark- AlertController
- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message fromView:(UIView *)fromView actionHandler:(void (^)(NSInteger actionIndex))actionHandler cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ...;



#pragma mark- Fix DismissViewController
- (void)dismissDeepViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion;

- (void)fixDismissDeepViewController;

#pragma mark- Fix PresentAlertController (iOS8.1)
- (void)presentAlertController:(id)sender;
@end
