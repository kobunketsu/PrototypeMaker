//
//  Ultility.m
//  PaintProjector
//
//  Created by 文杰 胡 on 12-12-21.
//  Copyright (c) 2012年 Hu Wenjie. All rights reserved.
//

#import "ADUltility.h"

@implementation ADUltility
static ADUltility* sharedInstance = nil;

+(ADUltility*)sharedInstance{
    if(sharedInstance != nil){
        return sharedInstance;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ADUltility alloc]init];
    });
    return sharedInstance;
}
#pragma mark- 文件访问
+ (NSString *)applicationDirectory {
    //    Returns the path to the application's documents directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString *)applicationLibraryDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString *)applicationPrivateDocumentDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* libDir = [self applicationLibraryDirectory];
    NSString *path = [libDir stringByAppendingPathComponent:@"PrivateDocuments"];
    NSError *error = nil;
    BOOL isDir;
    if(![fileManager fileExistsAtPath:path isDirectory:&isDir]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:&error];
    }
    return path;
}

//+ (NSString *)deviantArtDocumentDirectory {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString* libDir = NSTemporaryDirectory();
//    NSString *path = [libDir stringByAppendingPathComponent:@"DevientArt"];
//    NSError *error = nil;
//    BOOL isDir;
//    if(![fileManager fileExistsAtPath:path isDirectory:&isDir]){
//        [fileManager createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:&error];
//    }
//    return path;
//}

+ (NSString *)applicationDocumentDirectory {
    //    Returns the path to the application's documents directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSArray *)applicationDocumentSubDirectories{
    NSFileManager *fileManager = [NSFileManager defaultManager];    
    NSString* docsDir = [self applicationPrivateDocumentDirectory];
    NSError *error = nil;
    NSArray *fileList  = [fileManager contentsOfDirectoryAtPath:docsDir error:&error];
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    for (NSString *file in fileList) {
        NSString *path = [docsDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
        }
        isDir = NO;
    }
//    DebugLog(@"All folders:%@",dirArray);
    return dirArray;
}

+ (NSString*)getPathInApp:(NSString*)relativeFilePath{
    NSString* filePath = [ADUltility getPathInDocuments:relativeFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:false]) {
        //        DebugLog(@"_bgImageName not in Documents!");
        filePath = [ADUltility getPathInBundle:relativeFilePath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:false]) {
            //        DebugLog(@"_bgImageName not in Bundle!");
            filePath = nil;
        }
    }
    return filePath;
}
+ (NSString*)getPathInDocuments:(NSString*)relativeFilePath{
    return [[self applicationPrivateDocumentDirectory] stringByAppendingPathComponent:relativeFilePath];
}

+ (NSString*)getPathInBundle:(NSString*)relativeFilePath{
    NSArray* nameSplit = [relativeFilePath componentsSeparatedByString:@"/"];
    NSString* bgImageFullName = [nameSplit lastObject];
    NSString* dir = [relativeFilePath stringByDeletingLastPathComponent];
    NSArray* bgImageNameExt = [bgImageFullName componentsSeparatedByString:@"."];
    NSString* bgImageName = [bgImageNameExt objectAtIndex:0];
    NSString* bgImageType = [bgImageNameExt lastObject];
    
    NSString* bgImagePath = [[NSBundle mainBundle]pathForResource:bgImageName ofType:bgImageType inDirectory:dir];
    return bgImagePath;
}


+ (BOOL)addBackupAttributeToItemAtPath:(NSString *)filePathString {
    NSURL *fileURL =
    [NSURL fileURLWithPath:filePathString];
    
    assert([[NSFileManager defaultManager]
            fileExistsAtPath: [fileURL path]]);
    
    NSError *error = nil;
    
    BOOL success = [fileURL setResourceValue:[NSNumber numberWithBool:NO]
                                      forKey:NSURLIsExcludedFromBackupKey
                                       error:&error];
    if(!success){
        NSLog(@"Error %@ from backup %@", [fileURL lastPathComponent], error);
    }
    return success;
}

+ (BOOL)addBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: NO]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString {
    NSURL *fileURL =
    [NSURL fileURLWithPath:filePathString];
    
    assert([[NSFileManager defaultManager]
            fileExistsAtPath: [fileURL path]]);
    
    NSError *error = nil;
    
    BOOL success = [fileURL setResourceValue:[NSNumber numberWithBool:YES]
                                      forKey:NSURLIsExcludedFromBackupKey
                                       error:&error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [fileURL lastPathComponent], error);
    }
    return success;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

#pragma mark- 临时文件
+(void)deleteTempData
{
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *cacheFiles = [fileManager contentsOfDirectoryAtPath:tmpDirectory error:&error];
    for (NSString *file in cacheFiles)
    {
        error = nil;
        [fileManager removeItemAtPath:[tmpDirectory stringByAppendingPathComponent:file] error:&error];
    }
}
#pragma mark- 图片处理
+ (UIImage*)loadUIImageFromPNGInDocument:(NSString*) filePathInDoc{
    NSString* path = [[self applicationPrivateDocumentDirectory] stringByAppendingPathComponent:filePathInDoc];
    NSFileHandle* myFileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    if(myFileHandle == nil){
        DebugLogError(@"Error loading file %@", path);
        return nil;
    }
    DebugLog(@"Load image:%@", path);
    return [UIImage imageWithData:[myFileHandle readDataToEndOfFile]];
}

+ (void)deletePNGInDocument:(NSString*) filePathInDoc{
    NSString* path = [[self applicationPrivateDocumentDirectory] stringByAppendingPathComponent:filePathInDoc];
    BOOL ok = [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
    if (!ok) {
        DebugLogError(@"Error deleting file %@", path);
    }
}

+ (void)saveUIImage:(UIImage*)uiImage ToPNGInDocument:(NSString*) filePathInDoc{
    NSString* document = [self applicationPrivateDocumentDirectory];
    NSString* path = [document stringByAppendingPathComponent:filePathInDoc];

    BOOL ok = [[NSFileManager defaultManager] createFileAtPath:path 
                                                      contents:nil attributes:nil];
    
    if (!ok) {
        DebugLogError(@"Error creating file %@", path);
    } else {
        NSFileHandle* myFileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        [myFileHandle writeData:UIImagePNGRepresentation(uiImage)];
        [myFileHandle closeFile];
        DebugLogWriteSuccess(@"Saved to image:%@", path);
    }    
}
+ (void)saveUIImage:(UIImage*)uiImage ToJPGInDocument:(NSString*) filePathInDoc{
    NSString* document = [self applicationPrivateDocumentDirectory];
    NSString* path = [document stringByAppendingPathComponent:filePathInDoc];
    
    BOOL ok = [[NSFileManager defaultManager] createFileAtPath:path 
                                                      contents:nil attributes:nil];
    
    if (!ok) {
        DebugLogError(@"Error creating file %@", path);
    } else {
        NSFileHandle* myFileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        [myFileHandle writeData:UIImageJPEGRepresentation(uiImage, 1.0)];
        [myFileHandle closeFile];
        DebugLogWriteSuccess(@"Saved to image:%@", path);
    }    
}

+(void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    //if dir not exists, create dir
    NSError *error = nil;
    BOOL isDir = true;
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if(![[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:true attributes: nil error: &error]){
            DebugLogError(@"createDirectoryAtPath %@ error %@", directoryPath, error.localizedDescription);
        }
    }
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        if (![UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:&error]) {
            DebugLogError(@"saveImage:withFileName:%@ ofType:%@ inDirectory:%@ error %@", imageName, @"png", directoryPath, error.localizedDescription);
        };
        DebugLogWriteSuccess(@"saveImage:withFileName:%@ ofType:%@ inDirectory:%@", imageName, @"png", directoryPath);
        
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        if(![UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:&error]){
            DebugLogError(@"saveImage:withFileName:%@ ofType:%@ inDirectory:%@ error %@", imageName, @"png", directoryPath, error.localizedDescription);
        }
        DebugLogWriteSuccess(@"saveImage:withFileName:%@ ofType:%@ inDirectory:%@", imageName, @"jpg", directoryPath);
    } else {
        DebugLogError(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

+(UIImage *)loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}


+(GLubyte*)loadTextureDataFromFileInDocument:(NSString*)filePathInDoc{
    NSString* path = [[self applicationPrivateDocumentDirectory] stringByAppendingPathComponent:filePathInDoc];     
    
    return [self loadTextureDataFromFile:path];
}

//+ (void)reloadTexture:(GLuint)texture FromFile:(NSString*)filePath{
//    
//    GLubyte* data = [self loadTextureDataFromFile:filePath];
//    //make sure data width height align with UndoImageSize
//    glBindTexture(GL_TEXTURE_2D, texture);    
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  UndoImageSize, UndoImageSize, 0, GL_RGBA, GL_UNSIGNED_BYTE, data); 
//    glBindTexture(GL_TEXTURE_2D,0);     
//	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
//	{
//		DebugLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
//	}       
//}

+(GLubyte*)loadTextureDataFromFile:(NSString*)filePath{
    UIImage* uiImage = [UIImage imageWithContentsOfFile:filePath];
    if(uiImage == NULL){
        return NULL;
    }
    return [self loadTextureDataFromUIImage:uiImage];
}


+(GLubyte*)loadTextureDataFromUIImage:(UIImage*)uiImage{    // Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
    size_t width = CGImageGetWidth(uiImage.CGImage);
    size_t height = CGImageGetHeight(uiImage.CGImage);
    
    size_t srcSize = MAX(width, height);
    size_t destSize = 1;
    while (srcSize > destSize) {
        destSize *= 2;
    }
    
    if(width!=destSize || height != destSize){
        uiImage = [uiImage resizeImage:CGSizeMake(destSize, destSize)];
    }
    
    // Make sure the image exists
    return [self loadTextureDataFromCGImage:uiImage.CGImage];
}

+(GLubyte*)loadTextureDataFromCGImage:(CGImageRef)image{
    // Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
    // you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
    
    // Make sure the image exists
    if (!image)
    {
        DebugLog(@"Failed to load CGImage");
        exit(1);
    }
    
    // Get the width and height of the image
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    // Allocate  memory needed for the bitmap context
    GLubyte	*data = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
    // Use  the bitmatp creation function provided by the Core Graphics framework.
    CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width * 4, CGImageGetColorSpace(image), kCGBitmapByteOrderDefault);
    
    //flip uiImage for opengl
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1, -1);
    
    // After you create the context, you can draw the  image to the context.
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), image);
    // You don't need the context at this point, so you need to release it to avoid memory leaks.
    CGContextRelease(context);
    // Use OpenGL ES to generate a name for the texture.
    return data;
}



+ (void)CGImageWriteToFile:(CGImageRef)image :(NSString *)path{
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, image, nil);
    
    if (!CGImageDestinationFinalize(destination)) {
        DebugLog(@"Failed to write image to %@", path);
    }
    
    CFRelease(destination);
}

+ (NSData *)dataFromImage:(UIImage *)image metadata:(NSDictionary *)metadata mimetype:(NSString *)mimetype
{
    NSMutableData *imageData = [NSMutableData data];
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)mimetype, NULL);
    
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData, uti, 1, NULL);
    
    if (imageDestination == NULL)
    {
        NSLog(@"Failed to create image destination");
        imageData = nil;
    }
    else
    {
        CGImageDestinationAddImage(imageDestination, image.CGImage, (__bridge CFDictionaryRef)metadata);
        
        if (CGImageDestinationFinalize(imageDestination) == NO)
        {
            NSLog(@"Failed to finalise");
            imageData = nil;
        }
        CFRelease(imageDestination);
    }
    
    CFRelease(uti);
    
    return imageData;
}


#pragma mark UIImage Tools
static void providerReleaseData(void *info, const void *data, size_t size)
{
    free((void *)data);
}


+ (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    UIImage* newImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    CGImageRelease(mask);
    return newImage;
    
}

+ (void)downloadImageURL:(NSURL *)imageURL async:(BOOL)async onComplete:(void (^)(UIImage *image, NSError * error))onComplete
{
    DebugLog(@"downloadImageURL %@", imageURL);
    if (async) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfURL:imageURL options:NSDataReadingUncached error:&error];
            UIImage *image = [UIImage imageWithData:data];
            if (onComplete) {
                // Keep in mind that onComplete block will be called on a background thread.
                // If you need to use it on UIImageView, you must set it on main thread.
                //TODO: if on main thread
                onComplete(image, error);
            }
        });
    }
    else{
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:imageURL options:NSDataReadingUncached error:&error];
        UIImage *image = [UIImage imageWithData:data];
        if (onComplete) {
           //TODO: if on main thread
            onComplete(image, error);
        }
    }
}

+ (void)downloadDataURL:(NSURL *)dataURL async:(BOOL)async onComplete:(void (^)(NSData *data, NSError * error))onComplete{
    DebugLog(@"downloadImageURL %@", dataURL);
    if (async) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfURL:dataURL options:NSDataReadingUncached error:&error];
            if (onComplete) {
                // Keep in mind that onComplete block will be called on a background thread.
                // If you need to use it on UIImageView, you must set it on main thread.
                //TODO: if on main thread
                onComplete(data, error);
            }
        });
    }
    else{
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:dataURL options:NSDataReadingUncached error:&error];
        if (onComplete) {
            //TODO: if on main thread
            onComplete(data, error);
        }
    }
}

+ (void)downloadImageData:(NSData *)data async:(BOOL)async onComplete:(void (^)(UIImage *image))onComplete
{
    DebugLog(@"downloadImageData");
    if (async) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageWithData:data];
            if (onComplete) {
                // Keep in mind that onComplete block will be called on a background thread.
                // If you need to use it on UIImageView, you must set it on main thread.
                onComplete(image);
            }
        });
    }
    else{
        UIImage *image = [UIImage imageWithData:data];
        if (onComplete) {
            onComplete(image);
        }
    }
}

+ (void)downloadImagePath:(NSString *)imagePath async:(BOOL)async onComplete:(void (^)(UIImage *image, NSError * error))onComplete
{
    DebugLog(@"downloadImagePath %@", imagePath);
    if (async) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfFile:imagePath options:NSDataReadingUncached error:&error];
            UIImage *image = [UIImage imageWithData:data];
            if (onComplete) {
                // Keep in mind that onComplete block will be called on a background thread.
                // If you need to use it on UIImageView, you must set it on main thread.
                onComplete(image, error);
            }
        });
    }
    else{
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:imagePath options:NSDataReadingUncached error:&error];
        UIImage *image = [UIImage imageWithData:data];
        if (onComplete) {
            onComplete(image, error);
        }
    }
}

#pragma mark Memory Tools

//
//BOOL memoryInfo(vm_statistics_data_t *vmStats) {
//    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
//    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)vmStats, &infoCount);
//    
//    return kernReturn == KERN_SUCCESS;
//}
//
//void logMemoryInfo() {
//    vm_statistics_data_t vmStats;
//    
//    if (memoryInfo(&vmStats)) {
//        DebugLog(@"free: %u\nactive: %u\ninactive: %u\nwire: %u\nzero fill: %u\nreactivations: %u\npageins: %u\npageouts: %u\nfaults: %u\ncow_faults: %u\nlookups: %u\nhits: %u",
//              vmStats.free_count * vm_page_size,
//              vmStats.active_count * vm_page_size,
//              vmStats.inactive_count * vm_page_size,
//              vmStats.wire_count * vm_page_size,
//              vmStats.zero_fill_count * vm_page_size,
//              vmStats.reactivations * vm_page_size,
//              vmStats.pageins * vm_page_size,
//              vmStats.pageouts * vm_page_size,
//              vmStats.faults,
//              vmStats.cow_faults,
//              vmStats.lookups,
//              vmStats.hits
//              );
//    }
//}
@end
/*

*/