//
//  PMTag1ViewController.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/21/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMTag1ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)clearButtonTouchUp:(UIBarButtonItem *)sender;

- (IBAction)addButtonTouchUp:(UIBarButtonItem *)sender;
@end
