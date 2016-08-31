//
//  NSJSONSerialization+Extension.m
//  PaintProjector
//
//  Created by 文杰 胡 on 3/4/16.
//  Copyright © 2016 WenjiHu. All rights reserved.
//

#import "NSJSONSerialization+Extension.h"

@implementation NSJSONSerialization (Extension)
+(NSData *)dataWithJSONFilePath:(NSString *)filePath{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (!jsonObject) {
        DebugLogError(@"NSJSONSerialization JSONObjectWithData failed at %@ error %@", filePath, [error localizedDescription]);
        return nil;
    }
    
    return jsonObject;
}

@end
