//
//  ADAlertController.h
//  PaintProjector
//
//  Created by 文杰 胡 on 2/18/15.
//  Copyright (c) 2015 WenjiHu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ADAlertViewActionHandler)(NSInteger actionIndex);

@interface ADAlertController : UIAlertController
@property (retain, nonatomic)UIColor *titleColor;
@property (retain, nonatomic)UIColor *backgroundColor;
@end
