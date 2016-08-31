//
//  PMNavigationController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/7/6.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import "PMNavigationController.h"
#import "PMRelatedViewController.h"
#import "PMDetailViewController.h"
#import "PMDataViewController.h"
#import "PMCompareViewController.h"
@interface PMNavigationController ()

@end

@implementation PMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pushRelatedView"]) {
        PMDetailViewController *detailVC = (PMDetailViewController *)sender;
        PMRelatedViewController *vc = (PMRelatedViewController *)segue.destinationViewController;
        vc.detailInfo = detailVC.detailInfo;
    }
    else if ([segue.identifier isEqualToString:@"pushDetailView"]) {
        PMCompareViewController *compareVC = (PMCompareViewController *)sender;

//        PMIdea *idea = [PMIdea ideaOfId:self.curCollection[cell.tag]];
//        [PMDataViewController sharedInstance].curIdea = idea;
//        
//        PMDetailViewController *vc = (PMDetailViewController *)segue.destinationViewController;
//        vc.detailInfo = idea;
    }
    
}
@end
