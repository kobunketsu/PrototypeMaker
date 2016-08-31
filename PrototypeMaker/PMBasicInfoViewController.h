//
//  PMBasicInfoViewController.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/20/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMBasicInfoViewController : UIViewController

//retained全局数据将导致self无法有效释放,只有在curCollection 完全nil才会释放对象
//存储的是id列表
@property(retain, nonatomic) NSMutableArray *curCollection;
@end
