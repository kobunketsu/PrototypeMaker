//
//  PMSetupTableViewCell.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/17/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMSetupTableViewCell.h"

@implementation PMSetupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"isSortByColor"];
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    self.numOfRollValue.text = [NSString stringWithFormat:@"%ld", (long)sender.value];;
    if (sender.tag == 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:sender.value forKey:@"numOfRollIdea"];
    }
    else if (sender.tag == 2) {
        [[NSUserDefaults standardUserDefaults] setInteger:sender.value forKey:@"numOfRollProto"];
    }
}

#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
