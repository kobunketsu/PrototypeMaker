//
//  PMiCloudHelper.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/6/28.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import "DPiCloudHelper.h"
#define ubiquityID @"iCloud.com.dreapp.PrototypeMaker"
@implementation DPiCloudHelper

+ (NSURL *)iCloudContainer{
    return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:ubiquityID];
}
/*! Recursively lists all files
 
 @param dir The directory to list
 @param padding A string padding to indent the output depending on the level of recursion
 */
+ (void)listAllFilesInDirectory:(NSURL*)dir padding:(NSString*)padding {
    DebugLog(@"listAllFilesInDirectory %@", dir);
    NSArray *docs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:dir includingPropertiesForKeys:nil options:0 error:nil];
    
    for (NSURL* document in docs) {
        
        DebugLog(@" %@ %@", padding, [document lastPathComponent]);
        
        BOOL isDir;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:document.path isDirectory:&isDir];
        
        if (fileExists && isDir) {
            [self listAllFilesInDirectory:document padding:[NSString stringWithFormat:@"  %@", padding]];
        }
        
    }
}

+ (void)deleteAllFilesInDirectory:(NSURL*)dir{
    NSArray *docs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:dir includingPropertiesForKeys:nil options:0 error:nil];
    
    for (NSURL* document in docs) {
        
        BOOL isDir;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:document.path isDirectory:&isDir];
        
        if (fileExists) {
            if (isDir) {
                [self deleteAllFilesInDirectory:document];
            }
            [self deleteItemAtURL:document];
        }
    }
}

+ (void)deleteItemAtURL:(NSURL *)fileURL{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        
        [fileCoordinator coordinateWritingItemAtURL:fileURL options:NSFileCoordinatorWritingForDeleting
                                              error:nil byAccessor:^(NSURL* writingURL) {
                                                  NSFileManager* fileManager = [[NSFileManager alloc] init];
                                                  NSError *er;
                                                  //FLOG(@" deleting %@", writingURL);
                                                  bool res = [fileManager removeItemAtURL:writingURL error:&er];
                                                  if (res) {
                                                      DebugLog(@"   iCloud files removed %@", [writingURL path]);
                                                  }
                                                  else {
                                                      DebugLog(@"   document NOT removed %@", [writingURL path]);
                                                      DebugLog(@"   error %@, %@", er, er.userInfo);
                                                  }
                                              }];
    });
}


@end
