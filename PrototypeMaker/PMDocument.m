//
//  PMDocument.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/6/27.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import "PMDocument.h"
#define DATA_FILENAME       @"pm.json"
#define USE_JSONFORMAT 0
@implementation PMDocument

- (void)dealloc{
    DebugLog(@"dealloc");
}
/**
 *  需要写的数据内容转化为nsdata
 *
 *  @param typeName <#typeName description#>
 *  @param outError <#outError description#>
 *
 *  @return <#return value description#>
 */
- (void)encodeObject:(id<NSCoding>)object toWrappers:(NSMutableDictionary *)wrappers preferredFilename:(NSString *)preferredFilename {
    DebugLog(@"encodeObject toWrappers preferredFilename %@", preferredFilename);
    @autoreleasepool {
        NSMutableData * data = [NSMutableData data];
        NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:object forKey:@"data"];
        [archiver finishEncoding];
        NSFileWrapper * wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
        [wrappers setObject:wrapper forKey:preferredFilename];
    }
}
/**
 *  从nsdata转化成数据
 *
 *  @param preferredFilename <#preferredFilename description#>
 *
 *  @return <#return value description#>
 */
- (id)decodeObjectFromWrapperWithPreferredFilename:(NSString *)preferredFilename {
    DebugLog(@"decodeObjectFromWrapperWithPreferredFilename %@", preferredFilename);
    
    NSFileWrapper * fileWrapper = [self.fileWrapper.fileWrappers objectForKey:preferredFilename];
    if (!fileWrapper) {
        NSLog(@"Unexpected error: Couldn't find %@ in file wrapper!", preferredFilename);
        return nil;
    }
    
    NSData * data = [fileWrapper regularFileContents];
    
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    return [unarchiver decodeObjectForKey:@"data"];
    
}
/**
 *  保持数据到iCloud
 *
 *  @param typeName <#typeName description#>
 *  @param outError <#outError description#>
 *
 *  @return <#return value description#>
 */
- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    DebugLog(@"contentsForType %@", typeName);
    if (self.data == nil) {
        //MARK:第一次本地上传iCloud如果没数据，添加测试数据
        self.data = [PMDataModel current];
        [self.data feedSampleData];
    }
    
    NSMutableDictionary * wrappers = [NSMutableDictionary dictionary];
    //    [self encodeObject:self.data.toDictionary toWrappers:wrappers preferredFilename:DATA_FILENAME];
    //将不同类型的数据wrapper到fileWrapper下
    //当前由一个Key文档字典
#if USE_JSONFORMAT
    NSData *jsonData = [self.data toJSONData];
    NSFileWrapper *dataWrapper = [[NSFileWrapper alloc]initRegularFileWithContents:jsonData];
    [wrappers setObject:dataWrapper forKey:DATA_FILENAME];
#else
    [self encodeObject:self.data toWrappers:wrappers preferredFilename:DATA_FILENAME];
#endif
    
    NSFileWrapper * fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:wrappers];
    
    return fileWrapper;
}

/**
 *  从读取iCloud读取数据
 *
 *  @param contents <#contents description#>
 *  @param typeName <#typeName description#>
 *  @param outError <#outError description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    DebugLog(@"loadFromContentsOfType %@", typeName);
    
    self.fileWrapper = (NSFileWrapper *) contents;
    if (self.fileWrapper != nil) {
        PMDataModel *data = nil;
        NSError *error = nil;
        
#if USE_JSONFORMAT
        //加载data
        NSFileWrapper *dataWrapper = [self.fileWrapper.fileWrappers objectForKey:DATA_FILENAME];
        if (!dataWrapper) {
            DebugLog(@"Unexpected error: Couldn't find %@ in file wrapper!", DATA_FILENAME);
        }
        else{
            DebugLog(@"extract jsonData from dataWrapper of contents");
            NSData * jsonData = [dataWrapper regularFileContents];
            //从jsonData创建data
//            data = [[PMDataModel alloc]initWithData:jsonData error:&error];
        }
#else
        data = [self decodeObjectFromWrapperWithPreferredFilename:DATA_FILENAME];
#endif
        if (!data) {
            DebugLog(@"jsonData error %@", [error localizedDescription]);
            return NO;
        }
        
        //MARK:不考虑conflict
        [PMDataModel setCurrent:data];
        self.data = data;
    }
    else {
        //第一次下载iCloud时创建空数据
        DebugLog(@"Content fileWrapper nil");
        self.data = [PMDataModel current];
        [self.data feedSampleData];
    }
    
    DebugLog(@"postNotificationName:kPMDocumentDownloadedFromiCloud");
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMDocumentDownloadedFromiCloud object:self];
    
    return YES;
    
}


@end
