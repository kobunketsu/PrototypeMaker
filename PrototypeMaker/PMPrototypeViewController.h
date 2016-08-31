//
//  PMPrototypeViewController.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMBasicInfoViewController.h"


@interface PMPrototypeViewController : PMBasicInfoViewController
@property (assign, nonatomic) id delelgate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (assign, nonatomic) NSInteger selectedIndex;

- (IBAction)flushFromIdeas:(UIBarButtonItem *)sender;

- (IBAction)rollProtoButtonTouchUp:(UIBarButtonItem *)sender;

- (IBAction)searchButtonTouchUp:(UIBarButtonItem *)sender;

- (IBAction)clearButtonTouchUp:(UIBarButtonItem *)sender;

- (IBAction)importFromBundleTouchUp:(UIButton *)sender;

@end
