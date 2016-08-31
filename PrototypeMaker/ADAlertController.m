//
//  ADAlertController.m
//  PaintProjector
//
//  Created by 文杰 胡 on 2/18/15.
//  Copyright (c) 2015 WenjiHu. All rights reserved.
//

#import "ADAlertController.h"

@interface ADAlertController ()

@end

@implementation ADAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews{
//    DebugLogSystem(@"viewWillLayoutSubviews");
    UIView * backgroundView = nil;
    if (self.backgroundColor) {
        if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
            backgroundView = ((UIView *)((UIView *)self.view.subviews.firstObject).subviews.firstObject).subviews.firstObject;
        }
        else if (self.preferredStyle == UIAlertControllerStyleAlert) {
            backgroundView = ((UIView *)((UIView *)self.view.subviews.firstObject).subviews.lastObject).subviews.firstObject;
            
        }
        backgroundView.backgroundColor = self.backgroundColor;
    }
    if (self.titleColor) {
        if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        }
        else if (self.preferredStyle == UIAlertControllerStyleAlert) {
            UIView * backgroundView = ((UIView *)((UIView *)self.view.subviews.firstObject).subviews.lastObject).subviews.firstObject;
            UIView * labelContainer = ((UIView *)backgroundView.subviews.firstObject).subviews.firstObject;
            for (UIView *view in labelContainer.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                    ((UILabel*)view).textColor = self.titleColor;
                }
            }
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
