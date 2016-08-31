//
//  PMSetViewController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/15/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMSetupViewController.h"
#import "PMSetupTableViewCell.h"
#import "PMProtoCategoryTableViewController.h"
#import "PMDataViewController.h"
@interface PMSetupViewController ()

@end

@implementation PMSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"pushProtoCategoryTableView"]) {
        PMProtoCategoryTableViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        
    }
}


#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        static NSString * reuseIdentifier = @"SetupTableViewPickerCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        }
        //configure
        cell.textLabel.text = @"Prototype Type";
        cell.detailTextLabel.text = [PMDataViewController sharedInstance].curCategory.title;
        return cell;
    }
    else if (indexPath.row > 0 && indexPath.row < 3) {
        static NSString * reuseIdentifier = @"SetupTableViewCell";
        PMSetupTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[PMSetupTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        }
        //configure
        
        if (indexPath.row == 1) {
            cell.numOfRollLabel.text = @"Idea to Roll";
            NSInteger numOfRollIdea = [[NSUserDefaults standardUserDefaults] integerForKey:@"numOfRollIdea"];
            cell.numOfRollValue.text = [NSString stringWithFormat:@"%zd", numOfRollIdea];
            cell.stepper.value = numOfRollIdea;
            cell.stepper.tag = 1;
        }
        else if (indexPath.row == 2) {
            cell.numOfRollLabel.text = @"Proto to Roll";
            NSInteger numOfRollProto = [[NSUserDefaults standardUserDefaults] integerForKey:@"numOfRollProto"];
            cell.numOfRollValue.text = [NSString stringWithFormat:@"%zd", numOfRollProto];
            cell.stepper.value = numOfRollProto;
            cell.stepper.tag = 2;
        }
        return cell;
    }
    else if (indexPath.row == 3) {
        static NSString * reuseIdentifier = @"SwitchCell";
        PMSetupTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        cell.label.text = @"Sort Color";
        cell.switcher.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"isSortByColor"];
        return cell;
    }

    return nil;
}
#pragma mark- PMProtoCategoryTableViewControllerDelegate
- (void)didSelectProtoCategory:(PMCategory *)category{
    [self.navigationController popToRootViewControllerAnimated:true];
    [self.tableView reloadData];
}
#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
