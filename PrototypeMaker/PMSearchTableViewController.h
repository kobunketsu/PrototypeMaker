//
//  PMSearchTableViewController.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/16/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMBaseInfo.h"
typedef NS_ENUM(NSUInteger, PMSearchMode) {
    PMSearchIdea,
    PMSearchProto,
    PMSearchTag,
};
@interface PMSearchTableViewController : UITableViewController
@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) PMSearchMode searchMode;
@property (assign, nonatomic) BOOL isSearching;

@end

@protocol PMSearchTableViewControllerDelegate <NSObject>
- (void)willAddBaseInfo:(PMBaseInfo *)baseInfo;
@end
