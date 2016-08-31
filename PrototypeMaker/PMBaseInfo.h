//
//  PMBaseInfo.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/14/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

#define kIdentifierKey @"kIdentifierKey"
#define kTitleKey @"kTitleKey"
#define kDescKey @"kDescKey"

@interface PMBaseInfo : NSObject<NSCoding>
@property(copy, nonatomic) NSString *identifier;
@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *desc;

//editor
@property(assign, nonatomic) BOOL pinned;
- (id)initWithTitle:(NSString *)title desc:(NSString *)desc;
@end
