//
//  PMDataViewController.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/17/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMPrototype.h"
#import "PMRootTabBarController.h"
#import "PMCategory.h"

@interface PMDataViewController : NSObject
<UITabBarControllerDelegate>
+(PMDataViewController*)sharedInstance;

@property(assign, nonatomic) BOOL isIdeaTabDataSourceDirty;

@property(assign, nonatomic) BOOL isProtoTabDataSourceDirty;

@property(assign, nonatomic) BOOL isTagTabDataSourceDirty;

//@property(assign, nonatomic) BOOL isMakeProto;

@property(retain, nonatomic) PMPrototype *curProto;

@property(retain, nonatomic) PMIdea *curIdea;

@property(retain, nonatomic) PMCategory *curCategory;
@end
