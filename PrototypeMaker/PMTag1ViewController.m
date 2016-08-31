//
//  PMTag1ViewController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/21/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMTag1ViewController.h"
//#import "MGSwipeTableCell.h"
//#import "MGSwipeButton.h"
#import "PMSearchTableViewController.h"
//#import "PMDataViewController.h"
//#import "PMDataManager.h"

@interface PMTag1ViewController ()
<
//UITableViewDataSource,
//UITableViewDelegate,
//MGSwipeTableCellDelegate,
UINavigationControllerDelegate
>

@end

@implementation PMTag1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"dealloc tagVC");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)clearButtonTouchUp:(UIBarButtonItem *)sender{
    
}

- (IBAction)addButtonTouchUp:(UIBarButtonItem *)sender{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"search"]) {
        PMSearchTableViewController *vc = segue.destinationViewController;
        vc.searchMode = PMSearchTag;
    }
}
@end
