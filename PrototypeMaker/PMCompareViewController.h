//
//  PMCompareViewController.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/7/5.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMPrototype.h"
@interface PMCompareViewController : UIViewController
@property (weak, nonatomic) NSString *srcProtoId;
@property (weak, nonatomic) NSString *destProtoId;
@end
