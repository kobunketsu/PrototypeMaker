//
//  DPiCloudDocManager.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/6/30.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import "DPiCloudDocManager.h"
#import "PMDocument.h"
#define kFILENAME @"mydocument.ptm"
@interface DPiCloudDocManager()
<UIAlertViewDelegate>
{
    NSURL * _localRoot;
    NSURL * _iCloudRoot;
    BOOL _iCloudAvailable;
    BOOL _iCloudURLsReady;
    NSMutableArray * _iCloudURLs;
    BOOL _moveLocalToiCloud;
    BOOL _copyiCloudToLocal;
}
@property (strong) PMDocument * doc;
@property (strong) NSMetadataQuery *query;
@end

@implementation DPiCloudDocManager
static DPiCloudDocManager* si = nil;

+(DPiCloudDocManager*)si{
    if(si != nil){
        return si;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        si = [[DPiCloudDocManager alloc]init];
    });
    return si;
}

- (id)init{
    self = [super init];
    if (self) {
        _iCloudURLs = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark- iCloud 文件管理
- (void)loadDocAtURL:(NSURL *)fileURL {
    DebugLog(@"loadDocAtURL %@", fileURL);
    
    self.doc = [[PMDocument alloc]initWithFileURL:fileURL];
    [self.doc openWithCompletionHandler:^(BOOL success) {
        if (!success) {
            DebugLogError(@"failed to open doc %@", fileURL);
            //TODO:完成打开dataModel并赋值后需要关闭文档
            return;
        }
        
        DebugLog(@"doc opened %@", fileURL);
        
        // Close since we're done with it
        [self.doc closeWithCompletionHandler:^(BOOL success) {
            
            // Check status
            if (!success) {
                DebugLogError(@"Failed to close doc %@", fileURL);
                // Continue anyway...
            }
            
            // Add to the list of files on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }];
    }];
}

- (void)loadDocOnLocal{
    DebugLog(@"loadDocOnLocal");
    //从本地Document目录中加载指定文件
    NSString *filePath = [self.localRoot.path stringByAppendingPathComponent:kFILENAME];
    
    BOOL isDir = false;
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]){
        [self loadDocAtURL:[NSURL fileURLWithPath:filePath]];
    }
    else{

    }
}

- (void)createDocOnLocal{
    DebugLog(@"createDocOnLocal");
    
    NSURL *url = [NSURL fileURLWithPath:[[ADUltility applicationDocumentDirectory] stringByAppendingPathComponent:kFILENAME]];
    PMDocument *doc = [[PMDocument alloc] initWithFileURL:url];
    self.doc = doc;
    [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (success) {
            [doc openWithCompletionHandler:^(BOOL success) {
                DebugLog(@"new document opened from Local");
            }];
        }
    }];
}

- (void)loadDocOniCloud:(NSURL *)url{
    DebugLog(@"loadDocOniCloud");
    [self loadDocAtURL:url];
}

- (void)createDocOniCloud{
    DebugLog(@"createDocOniCloud");
    //如果iCloud没有文件，则直接在iCloud上创建出document，并打开
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:
                                 @"Documents"] URLByAppendingPathComponent:kFILENAME isDirectory:NO];
    
    PMDocument *doc = [[PMDocument alloc] initWithFileURL:ubiquitousPackage];
    self.doc = doc;
    
    [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (success) {
            DebugLogWriteSuccess(@"save document sucess %@", doc.fileURL);
            [doc openWithCompletionHandler:^(BOOL success) {
                DebugLog(@"document opened from iCloud %@", doc.fileURL);
            }];
        }
    }];
}

- (void)iCloudToLocalImpl {
    
    DebugLog(@"iCloud => local impl");
    
    for (NSURL * fileURL in _iCloudURLs) {
        
        NSString * fileName = [fileURL lastPathComponent];
        NSURL *destURL = [self getDocURL:fileName];
        
        // Perform copy on background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSFileCoordinator* fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
            [fileCoordinator coordinateReadingItemAtURL:fileURL options:NSFileCoordinatorReadingWithoutChanges error:nil byAccessor:^(NSURL *newURL) {
                NSFileManager * fileManager = [[NSFileManager alloc] init];
                NSError * error;
                if(![[NSFileManager defaultManager] removeItemAtURL:destURL error:&error]){
                    DebugLogError(@"removeItemAtURL %@ error %@", destURL, [error localizedDescription]);
                }
                BOOL success = [fileManager copyItemAtURL:fileURL toURL:destURL error:&error];
                if (success) {
                    DebugLogWriteSuccess(@"Copied %@ to %@ (%d)", fileURL, destURL, self.iCloudOn);
                    [self loadDocAtURL:destURL];
                } else {
                    DebugLogError(@"Failed to copy %@ to %@: %@", fileURL, destURL, error.localizedDescription);
                }
            }];
        });
    }
    
}

- (void)iCloudToLocal {
    DebugLog(@"iCloud => local");
    
    // Wait to find out what user wants first
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"You're Not Using iCloud" message:@"What would you like to do with the documents currently on this iPad?" delegate:self cancelButtonTitle:@"Continue Using iCloud" otherButtonTitles:@"Keep a Local Copy", @"Keep on iCloud Only", nil];
    alertView.tag = 2;
    [alertView show];
    
}

- (void)localToiCloudImpl {
    
    DebugLog(@"local => iCloud impl");
    
    NSURL * fileURL = [self.localRoot URLByAppendingPathComponent:kFILENAME isDirectory:NO];
    
    NSString * filePath = [fileURL lastPathComponent];
    NSURL *destURL = [self getDocURL:filePath];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileURL.path]){
        DebugLogError(@"filePath not exist %@", fileURL);
        return;
    }
    
    // Perform actual move in background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError * error;
        
        BOOL success = [[NSFileManager defaultManager] setUbiquitous:self.iCloudOn itemAtURL:fileURL destinationURL:destURL error:&error];
        if (success) {
            DebugLogWriteSuccess(@"Moved %@ to %@", fileURL, destURL);
            [self loadDocAtURL:destURL];
        } else {
            DebugLogError(@"Failed to move %@ to %@: %@", fileURL, destURL, error.localizedDescription);
        }
    });
    
    
}

- (void)localToiCloud {
    DebugLog(@"local => iCloud");
    
    // If we have a valid list of iCloud files, proceed
    if (_iCloudURLsReady) {
        [self localToiCloudImpl];
    }
    // Have to wait for list of iCloud files to refresh
    else {
        _moveLocalToiCloud = YES;
    }
}

- (void)saveDoc{
    [self.doc saveToURL:self.doc.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (!success) {
            DebugLogError(@"self.doc saveToURL failed %@", self.doc.fileURL);
        }
        else{
            DebugLogWriteSuccess(@"self.doc saveToURL success %@", self.doc.fileURL);
            [self.doc closeWithCompletionHandler:^(BOOL success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!success) {
                        DebugLogError(@"Failed to close %@", self.doc.fileURL);
                        // Continue anyway...
                    }
                    else{
                        DebugLog(@"self.doc closed %@", self.doc.fileURL);
                    }
                });
            }];
        }
    }];
}
#pragma mark- iCloud 查询
- (NSMetadataQuery *)documentQuery {
//    NSString *str = [kFILENAME stringByAppendingString:@".folder"];
    NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
    [query setSearchScopes:[NSArray arrayWithObject:
                            NSMetadataQueryUbiquitousDocumentsScope]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:
                         @"%K LIKE %@", NSMetadataItemFSNameKey, kFILENAME];
    [query setPredicate:pred];
    
    return query;
}

- (void)startQuery {
    DebugLog(@"startQuery iCloud");
    
    [self stopQuery];
    
    _query = [self documentQuery];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(queryDidFinishGathering:)
     name:NSMetadataQueryDidFinishGatheringNotification
     object:_query];
    
    [_query startQuery];
    
}

- (void)stopQuery {
    
    if (_query) {
        
        DebugLog(@"stopQuery iCloud");
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:nil];
        //        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidUpdateNotification object:nil];
        [_query stopQuery];
        _query = nil;
    }
    
}

- (void)queryDidFinishGathering:(NSNotification *)notification {
    DebugLog(@"queryDidFinishGathering");
    NSMetadataQuery *query = [notification object];
    
    // Always disable updates while processing results
    [query disableUpdates];
    
    //在query收集完信息之后不移除query，只有在新的startQuery时才开启
    //    [query stopQuery];
    //
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:NSMetadataQueryDidFinishGatheringNotification
    //                                                  object:query];
    //
    //    _query = nil;
    
    
    if ([self iCloudOn]) {
        [_iCloudURLs removeAllObjects];
        if (query.resultCount > 0) {
            NSMetadataItem *item = [query resultAtIndex:0];
            NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
            [_iCloudURLs addObject:url];
            _iCloudURLsReady = YES;
            
//            if (self.delegate) {
//                [self.delegate debugExportFileURL:url];
//            }
            
            [self loadDocOniCloud:url];
            
        }
        else{
            [self createDocOniCloud];
        }
    }
    else{
        NSString *filePath = [self.localRoot.path stringByAppendingPathComponent:kFILENAME];
        BOOL isDir = false;
        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]){
            [self createDocOnLocal];
        }
    }
    
    
    if (_moveLocalToiCloud) {
        _moveLocalToiCloud = NO;
        [self localToiCloudImpl];
    }
    else if (_copyiCloudToLocal) {
        _copyiCloudToLocal = NO;
        [self iCloudToLocalImpl];
    }
    
    [_query enableUpdates];
}



#pragma mark- iCloud 加载


- (void)refresh {
    DebugLog(@"refresh");
    [DPiCloudHelper listAllFilesInDirectory:[DPiCloudHelper iCloudContainer] padding:@"--"];
    
    _iCloudURLsReady = NO;
    
    [self initializeiCloudAccessWithCompletion:^(BOOL available) {
        
        _iCloudAvailable = available;
        
        if (!_iCloudAvailable) {
            
            // If iCloud isn't available, set promoted to no (so we can ask them next time it becomes available)
            [self setiCloudPrompted:NO];
            
            // If iCloud was toggled on previously, warn user that the docs will be loaded locally
            if ([self iCloudWasOn]) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"You're Not Using iCloud" message:@"Your documents were removed from this iPad but remain stored in iCloud." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }
            
            // No matter what, iCloud isn't available so switch it to off.
            [self setiCloudOn:NO];
            [self setiCloudWasOn:NO];
            
        } else {
            
            // Ask user if want to turn on iCloud if it's available and we haven't asked already
            //第一次启动如果有iCloud数据，需要iCloudToLocal
            if (![self iCloudOn] && ![self iCloudPrompted]) {
                
                [self setiCloudPrompted:YES];
                
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"iCloud is Available" message:@"Automatically store your documents in the cloud to keep them up-to-date across all your devices and the web." delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Use iCloud", nil];
                alertView.tag = 1;
                [alertView show];
                                
            }
            
            // If iCloud newly switched off, move local docs to iCloud
            if ([self iCloudOn] && ![self iCloudWasOn]) {
                [self localToiCloud];
            }
            
            // If iCloud newly switched on, move iCloud docs to local
            if (![self iCloudOn] && [self iCloudWasOn]) {
                [self iCloudToLocal];
            }
            
            // Start querying iCloud for files, whether on or off
            [self startQuery];
            
            // No matter what, refresh with current value of iCloudOn
            [self setiCloudWasOn:[self iCloudOn]];
            
        }
        
        if (![self iCloudOn]) {
            [self loadDocOnLocal];
        }
        
    }];
}

#pragma mark- iCloud 保存 加载
- (BOOL)iCloudOn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudOn"];
}

- (void)setiCloudOn:(BOOL)on {
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:@"iCloudOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)iCloudWasOn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudWasOn"];
}

- (void)setiCloudWasOn:(BOOL)on {
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:@"iCloudWasOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)iCloudPrompted {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudPrompted"];
}

- (void)setiCloudPrompted:(BOOL)prompted {
    [[NSUserDefaults standardUserDefaults] setBool:prompted forKey:@"iCloudPrompted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSURL *)localRoot {
    if (_localRoot != nil) {
        return _localRoot;
    }
    
    NSArray * paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    _localRoot = [paths objectAtIndex:0];
    return _localRoot;
}

- (NSURL *)getDocURL:(NSString *)filename {
    if ([self iCloudOn]) {
        NSURL * docsDir = [_iCloudRoot URLByAppendingPathComponent:@"Documents" isDirectory:YES];
        return [docsDir URLByAppendingPathComponent:filename isDirectory:NO];
    } else {
        return [self.localRoot URLByAppendingPathComponent:filename isDirectory:NO];
    }
}

- (NSURL *)getDirURL:(NSString *)dir {
    if ([self iCloudOn]) {
        NSURL * docsDir = [_iCloudRoot URLByAppendingPathComponent:@"Documents" isDirectory:YES];
        return [docsDir URLByAppendingPathComponent:dir isDirectory:YES];
    } else {
        return [self.localRoot URLByAppendingPathComponent:dir isDirectory:YES];
    }
}

- (void)initializeiCloudAccessWithCompletion:(void (^)(BOOL available)) completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _iCloudRoot = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:@"iCloud.com.dreapp.PrototypeMaker"];
        if (_iCloudRoot != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DebugLog(@"iCloud available at: %@", _iCloudRoot);
                completion(TRUE);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                DebugLog(@"iCloud not available");
                completion(FALSE);
            });
        }
    });
}
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // @"Automatically store your documents in the cloud to keep them up-to-date across all your devices and the web."
    // Cancel: @"Later"
    // Other: @"Use iCloud"
    if (alertView.tag == 1) {
        if (buttonIndex == alertView.firstOtherButtonIndex)
        {
            [self setiCloudOn:YES];
            [self refresh];
        }
    }
    // @"What would you like to do with the documents currently on this iPad?"
    // Cancel: @"Continue Using iCloud"
    // Other 1: @"Keep a Local Copy"
    // Other 2: @"Keep on iCloud Only"
    else if (alertView.tag == 2) {
        
        if (buttonIndex == alertView.cancelButtonIndex) {
            DebugLog(@"Continue Using iCloud");
            [self setiCloudOn:YES];
            [self refresh];
            
        } else if (buttonIndex == alertView.firstOtherButtonIndex) {
            DebugLog(@"Keep a Local Copy");
            if (_iCloudURLsReady) {
                [self iCloudToLocalImpl];
            } else {
                _copyiCloudToLocal = YES;
                [self startQuery];
            }
            
        } else if (buttonIndex == alertView.firstOtherButtonIndex + 1) {
            DebugLog(@"Keep on iCloud Only");
            // Do nothing
            
        }
    }
}

#pragma mark- load extern data
- (void)loadDataFromJson{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Data/gamedata" ofType:@"json"];
    NSArray *array = (NSArray *)[NSJSONSerialization dataWithJSONFilePath:path];
    
    if (!array) {
        return;
    }
    
    for (NSDictionary *dic in array) {
        NSString *name = dic[@"name"];
        NSString *desc = dic[@"desc"];
        NSArray *tags = dic[@"tags"];
        
        PMPrototype *proto = [PMPrototype prototypeWithTitle:name desc:desc];
        [[PMDataModel current] addProto:proto];
        
        for (NSString *tag in tags) {
            PMIdea *idea = [PMIdea ideaWithTitle:tag desc:nil];
            [[PMDataModel current] addIdea:idea];
            
            //建立proto和idea的链接
            [proto addIdea:idea];
            [idea addPrototype:proto];
        }

    }
    PMDataModel *model = [PMDataModel current];
}
@end
