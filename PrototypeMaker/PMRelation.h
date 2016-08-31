//
//  PMConnection.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMRelation : NSObject
@property (copy, nonatomic) NSString *keyIdentifier;
@property (copy, nonatomic) NSString *valueIdentifier;
+ (PMRelation*)relationWithKeyId:(NSString *)keyIdentifier valueId:(NSString *)valueIdentifier;
@end
