//
//  UIActivityViewController+Extension.h
//  PaintProjector
//
//  Created by 文杰 胡 on 7/23/16.
//  Copyright © 2016 WenjiHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActivityViewController (Extension)
+ (void)airdropFileURL:(NSURL *)fileURL inViewController:(UIViewController *)viewController;
@end
