//
//  UIView+GLCoord.m
//  PaintProjector
//
//  Created by 胡 文杰 on 6/12/14.
//  Copyright (c) 2014 WenjiHu. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "ADSimpleAlertView.h"
#import "AppDelegate.h"
#import "ADAlertController.h"

@implementation UIViewController (Extension)

-(void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message fromView:(UIView *)fromView actionHandler:(void (^)(NSInteger actionIndex))actionHandler cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ...{
    NSMutableArray *otherButtonTitles = [[NSMutableArray alloc]init];
    if (otherButtonTitle) {
        [otherButtonTitles addObject:otherButtonTitle];
    }
    
    va_list arg_list;
    va_start(arg_list, otherButtonTitle);
    while (YES)
    {
        //返回可变参数，va_arg第二个参数为可变参数类型，如果有多个可变参数，依次调用可获取各个参数
        NSString *string = va_arg(arg_list, NSString*);
        if (!string) {
            break;
        }
        [otherButtonTitles addObject:string];
    }
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < IOSCapVersion){
        if (cancelButtonTitle) {
            ADSimpleAlertView *alertView = [[ADSimpleAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
            alertView.delegate = alertView;
            [alertView setClickHandler:^(NSInteger index){
                if (actionHandler) {
                    actionHandler(index);
                }
            }];
            [alertView show];
        }
        else{
            //MARK: assume 3 titles
            NSString *otherButtonTitle1 = otherButtonTitles[1];
            NSString *otherButtonTitle2 = otherButtonTitles[2];
            ADSimpleAlertView *alertView = [[ADSimpleAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:otherButtonTitle, otherButtonTitle1, otherButtonTitle2, nil];
            alertView.delegate = alertView;
            [alertView setClickHandler:^(NSInteger index){
                if (actionHandler) {
                    actionHandler(index);
                }
            }];
            [alertView show];
        }
        
    }
    else{
        if (cancelButtonTitle) {
            ADAlertController *alertController = [ADAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//            alertController.backgroundColor = [ADSharedUIStyleKit cToolViewBackground];
//            alertController.titleColor = [ADSharedUIStyleKit cText];
            if (cancelButtonTitle) {
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    if(actionHandler){
                        actionHandler(0);
                    }
                }]];
            }
            
            for (NSInteger i = 0; i < otherButtonTitles.count; i++) {
                [alertController addAction:[UIAlertAction actionWithTitle:otherButtonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if(actionHandler){
                        actionHandler(i+1);
                    }
                }]];
            }
            [self presentViewController:alertController animated:true completion:^{
                //                DebugLog(@"alertController.view %@", alertController.view);
            }];
        }
        else{
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            if (title) {
                [dic setObject:title forKey:@"title"];
            }
            if (message) {
                [dic setObject:message forKey:@"message"];
            }
            if (otherButtonTitles) {
                [dic setObject:otherButtonTitles forKey:@"otherButtonTitles"];
            }
            if (actionHandler) {
                [dic setObject:actionHandler forKey:@"actionHandler"];
            }
            if (fromView) {
                [dic setObject:fromView forKey:@"fromView"];
            }
            
            //MARK:解决多次快速present同一个vc可能导致的错误。有很小的几率还是会重现（ios8.1）
            [self performSelector:@selector(presentAlertController:) withObject:dic afterDelay:AnimDurationPresentAlertControllerFix];
        }
    }
    
    va_end(arg_list);
}


- (void)presentAlertController:(id)sender{
    NSDictionary * dic = (NSDictionary *)sender;
    NSString *title = [dic objectForKey:@"title"];
    NSString *message = [dic objectForKey:@"message"];
    NSArray *otherButtonTitles = [dic objectForKey:@"otherButtonTitles"];
    void (^actionHandler)(NSInteger) = [dic objectForKey:@"actionHandler"];
    UIView *fromView = [dic objectForKey:@"fromView"];
    
    ADAlertController *alertController = [ADAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
//    alertController.backgroundColor = [ADSharedUIStyleKit cToolViewBackground];
//    alertController.titleColor = [ADSharedUIStyleKit cText];
    for (NSInteger i = 0; i < otherButtonTitles.count; i++) {
        [alertController addAction:[UIAlertAction actionWithTitle:otherButtonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if(actionHandler){
                actionHandler(i);
            }
        }]];
    }
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
//    popPresenter.backgroundColor = [ADSharedUIStyleKit cToolViewBackground];
    popPresenter.sourceView = fromView;
    popPresenter.sourceRect = fromView.bounds;
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

+(UIViewController *)getCurrentRootViewController {
    
    
    UIViewController *result;
    
    
    // Try to find the root view controller programmically
    
    
    // Find the top window (that is not an alert view or other window)
    
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    
    if (topWindow.windowLevel != UIWindowLevelNormal)
        
        
    {
        
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        
        for(topWindow in windows)
            
            
        {
            
            
            if (topWindow.windowLevel == UIWindowLevelNormal)
                
                
                break;
            
            
        }
        
        
    }
    
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    
    id nextResponder = [rootView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        
        
        result = nextResponder;
    
    
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        
        
        result = topWindow.rootViewController;
    
    
    else
        
        
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    
    
    return result;
    
    
}

+ (UIViewController *)finalPresentedViewController:(UIViewController *)controller{
    UIViewController *vc = controller.presentedViewController;
    if (vc) {
        return [self finalPresentedViewController:vc];
    }
    else{
        return controller;
    }
}

- (void)dismissDeepViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion {
    if([UIDevice currentDevice].systemVersion.floatValue >= IOSCapVersion){
        UIView *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        UIView *view = [window snapshotViewAfterScreenUpdates:false];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        dismissDeepFixView = view;
        [appDelegate.window addSubview:view];
        
        dismissDeepVC = self;
        [self dismissViewControllerAnimated:true completion:^{
            if(dismissDeepVC){
                [self fixDismissDeepViewController];
            }
            
            completion();
        }];
    }
    else{
        [self dismissViewControllerAnimated:flag completion:^{
            completion();
        }];
    }
}

#pragma mark- Fix DismissViewController
- (void)fixDismissDeepViewController{
    if([UIDevice currentDevice].systemVersion.floatValue >= IOSCapVersion){
        UIViewController *presentingVC = self.presentingViewController;
        if ([presentingVC isEqual:dismissDeepVC] ||
            [self isEqual:dismissDeepVC]) {
            [UIView animateWithDuration:AnimDurationDismissViewController delay:AnimDurationDismissViewControllerDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                dismissDeepFixView.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    [dismissDeepFixView removeFromSuperview];
                    dismissDeepFixView = nil;
                    dismissDeepVC = nil;
                }
                
            }];
        }
    }
}
@end
