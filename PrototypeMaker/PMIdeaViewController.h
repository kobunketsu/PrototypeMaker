//
//  PMIdeaViewController.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMBasicInfoViewController.h"
#import "PMPrototype.h"
@interface PMIdeaViewController : PMBasicInfoViewController
@property (assign, nonatomic) id delelgate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;


- (IBAction)flushFromProtos:(UIBarButtonItem *)sender;

- (IBAction)searchButtonTouchUp:(UIBarButtonItem *)sender;

/**
 *  从创意库中随机出创意
 *
 *  @param sender <#sender description#>
 */
- (IBAction)rollIdeaButtonTouchUp:(UIBarButtonItem *)sender;

- (IBAction)clearButtonTouchUp:(UIBarButtonItem *)sender;
@end

@protocol PMIdeaViewControllerDelegate
- (void)didMakePrototype:(PMPrototype *)proto;
@end
