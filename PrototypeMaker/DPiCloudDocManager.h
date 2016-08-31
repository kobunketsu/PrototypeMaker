//
//  DPiCloudDocManager.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/6/30.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPiCloudHelper.h"
@interface DPiCloudDocManager : NSObject
{
    
}
+(DPiCloudDocManager*)si;
- (void)saveDoc;
- (void)refresh;
- (NSURL *)getDocURL:(NSString *)filename;
- (NSURL *)getDirURL:(NSString *)dir;
- (void)loadDataFromJson;

//test
@property (assign, nonatomic) id delegate;
@end

@protocol DPiCloudDocManagerDelegate

- (void)willPromptiCloudSetup;

//debug
- (void)debugExportFileURL:(NSURL *)url;
@end
