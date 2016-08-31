//
//  PMTagViewController.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMBasicInfoViewController.h"

@interface PMTagViewController : PMBasicInfoViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)clearButtonTouchUp:(UIBarButtonItem *)sender;
- (IBAction)addButtonTouchUp:(UIBarButtonItem *)sender;

@end
