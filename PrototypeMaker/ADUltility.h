//
//  Ultility.h
//  PaintProjector
//
//  Created by 文杰 胡 on 12-12-21.
//  Copyright (c) 2012年 Hu Wenjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#include <mach/mach.h>

@interface ADUltility : NSObject
+(id)sharedInstance;
#pragma mark- File

+ (NSString*)applicationDirectory;
+ (NSString*)applicationDocumentDirectory;
+ (NSString*)applicationPrivateDocumentDirectory;
+ (NSArray *)applicationDocumentSubDirectories;
//+ (NSString*)deviantArtDocumentDirectory;

+ (NSString*)getPathInApp:(NSString*)relativeFilePath;
+ (NSString*)getPathInBundle:(NSString*)relativeFilePath;
+ (NSString*)getPathInDocuments:(NSString*)relativeFilePath;


+ (BOOL)addBackupAttributeToItemAtPath:(NSString *)filePathString;
+ (BOOL)addBackupAttributeToItemAtURL:(NSURL *)URL;
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

#pragma mark- Temp Data
+(void)deleteTempData;

#pragma mark- Image
+ (void)deletePNGInDocument:(NSString*) filePathInDoc;
+ (void)saveUIImage:(UIImage*)uiImage ToPNGInDocument:(NSString*) filePathInDoc;
+ (void)saveUIImage:(UIImage*)uiImage ToJPGInDocument:(NSString*) filePathInDoc;
+ (UIImage*)loadUIImageFromPNGInDocument:(NSString*) filePathInDoc;
//save load
+ (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
+ (UIImage *)loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
//直接将image转换成data
+ (NSData *)dataFromImage:(UIImage *)image metadata:(NSDictionary *)metadata mimetype:(NSString *)mimetype;

//创建带遮罩图像
+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

//创建图像
+ (UIImage*)snapshotContext:(EAGLContext *)context InViewSize:(CGSize)viewportSize ToOutputSize:(CGSize)outputSize;

//多线程下载图片
+ (void)downloadImageData:(NSData *)data async:(BOOL)async onComplete:(void (^)(UIImage *image))onComplete;
+ (void)downloadImagePath:(NSString *)imagePath async:(BOOL)async onComplete:(void (^)(UIImage *image, NSError * error))onComplete;
+ (void)downloadImageURL:(NSURL *)imageURL async:(BOOL)async onComplete:(void (^)(UIImage *image, NSError * error))onComplete;
+ (void)downloadDataURL:(NSURL *)dataURL async:(BOOL)async onComplete:(void (^)(NSData *data, NSError * error))onComplete;

#pragma mark- CGImage
+ (void)CGImageWriteToFile:(CGImageRef)image :(NSString *)path;

#pragma mark- Texture
+ (GLubyte*)loadTextureDataFromFile:(NSString*)filePath;
+ (GLubyte*)loadTextureDataFromFileInDocument:(NSString*)filePathInDoc;
+ (GLubyte*)loadTextureDataFromCGImage:(CGImageRef)image;
+ (GLubyte*)loadTextureDataFromUIImage:(UIImage*)uiImage;


@end
