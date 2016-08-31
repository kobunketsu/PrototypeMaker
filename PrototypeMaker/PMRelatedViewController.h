//
//  PMRelatedViewController.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/7/1.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMDetailInfo.h"

@interface PMRelatedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortTypeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *compareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pickbutton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)sortButtonTouchUp:(UIBarButtonItem *)sender;
- (IBAction)sortByTypeButtonTouchUP:(UIBarButtonItem *)sender;
- (IBAction)compareButtonTouchUp:(UIBarButtonItem *)sender;
- (IBAction)pickButtonTouchUp:(UIBarButtonItem *)sender;

@property(weak, nonatomic) PMDetailInfo *detailInfo;
@end
