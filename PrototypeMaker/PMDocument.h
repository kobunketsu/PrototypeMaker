//
//  PMDocument.h
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/6/27.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMDataModel.h"

#define kPMDocumentDownloadedFromiCloud @"kPMDocumentDownloadedFromiCloud"

@interface PMDocument : UIDocument
@property (nonatomic, strong) NSFileWrapper * fileWrapper;
@property (nonatomic, strong) PMDataModel * data;
/**
 *  存储图片库图片的路径
 */
@property (nonatomic, strong) NSMutableArray * images;
@end
