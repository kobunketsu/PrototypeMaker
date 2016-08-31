//
//  PMProtoCategoryTableViewController.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/20/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCategory.h"
@interface PMProtoCategoryTableViewController : UITableViewController
@property (assign, nonatomic) id delegate;
@end
@protocol PMProtoCategoryTableViewControllerDelegate
- (void)didSelectProtoCategory:(PMCategory *)category;

@end

