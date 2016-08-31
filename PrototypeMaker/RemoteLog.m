//
//  IBActionReport.m
//  PaintProjector
//
//  Created by 胡 文杰 on 5/28/14.
//  Copyright (c) 2014 WenjiHu. All rights reserved.
//

#import "RemoteLog.h"
//#import "GAI.h"
//#import "GAIFields.h"
//#import "GAITracker.h"
//#import "GAIDictionaryBuilder.h"

@implementation RemoteLog

+ (void)logAction:(NSString *)name fromSender:(id)sender withParameters:(NSDictionary *)params timed:(BOOL)timed{
#if DEBUG
    DebugLogIBAction(@"%@",name);
    return;
#endif
    
#if DISTRIBUTION
    NSString *actionName = nil;
    if ([sender isKindOfClass:[UISlider class]]) {
        return;
    }
    else if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
        if ([sender isMemberOfClass:[UIPanGestureRecognizer class]]) {
            return;
        }
        UIGestureRecognizer *gesture = (UIGestureRecognizer *)sender;
        if (gesture.state != UIGestureRecognizerStateEnded){
            return;
        }
    }
    
    else if ([sender isKindOfClass:[UIButton class]]) {
        actionName = @"button_press";
    }
    else if ([sender isKindOfClass:[UITableViewCell class]]) {
        actionName = @"tableViewCell_press";
    }
    else if ([sender isKindOfClass:[UICollectionViewCell class]]) {
        actionName = @"collectionViewCell_press";
    }
    else if ([sender isKindOfClass:[UIViewController class]]) {
        actionName = @"controller_event";
    }
    
    //flurry
    if (params) {
        [Flurry logEvent:name withParameters:params timed:timed];
    }
    else{
        [Flurry logEvent:name timed:timed];
    }

    //google analytic
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    /********** Measuring Events**********/
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:actionName
                                                           label:name
                                                           value:nil] build]];
#endif
}

+ (void)endTimedAction:(NSString *)name withParameters:(NSDictionary *)params{
#if DISTRIBUTION
    [Flurry endTimedEvent:name withParameters:params];
#endif
}

+ (void)log:(NSString *)name{
#if DEBUG
    DebugLogWarn(@"%@", name);
//    CLSLog(name, nil);//debug release mode inside
#endif
}
@end


