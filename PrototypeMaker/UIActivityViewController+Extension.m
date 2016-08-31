//
//  UIActivityViewController+Extension.m
//  PaintProjector
//
//  Created by 文杰 胡 on 7/23/16.
//  Copyright © 2016 WenjiHu. All rights reserved.
//

#import "UIActivityViewController+Extension.h"

@implementation UIActivityViewController (Extension)
+ (void)airdropFileURL:(NSURL *)fileURL inViewController:(UIViewController *)viewController{
    NSURL *url = fileURL;
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    
    // Present the controller
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [viewController presentViewController:controller animated:YES completion:nil];
    }
    //if iPad
    else
    {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
        UIView *view = viewController.view;
        [popup presentPopoverFromRect:CGRectMake(view.frame.size.width/2, view.frame.size.height/4, 0, 0)inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

@end
