//
//  PMDetailViewController.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/16/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMDetailInfo.h"

@interface PMDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextView *descTextView;

@property (weak, nonatomic) IBOutlet UIButton *descTextViewEditDoneButton;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;

- (IBAction)textViewDoneButtonTouchUp:(id)sender;
@property (weak, nonatomic) PMDetailInfo *detailInfo;
@end
