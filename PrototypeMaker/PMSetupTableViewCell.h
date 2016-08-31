//
//  PMSetupTableViewCell.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/17/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMSetupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@property (weak, nonatomic) IBOutlet UILabel *numOfRollLabel;

@property (weak, nonatomic) IBOutlet UILabel *numOfRollValue;

- (IBAction)switchValueChanged:(UISwitch *)sender;
- (IBAction)stepperValueChanged:(UIStepper *)sender;
@end
