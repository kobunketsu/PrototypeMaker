//
//  PMiCloudHelper.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/6/28.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPiCloudHelper : NSObject

+ (NSURL *)iCloudContainer;

+ (void)listAllFilesInDirectory:(NSURL*)dir padding:(NSString*)padding;

+ (void)deleteItemAtURL:(NSURL *)fileURL;

+ (void)deleteAllFilesInDirectory:(NSURL*)dir;
@end
