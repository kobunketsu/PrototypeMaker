//
//  ADAutoAlertView.m
//  PaintProjector
//
//  Created by kobunketsu on 9/19/14.
//  Copyright (c) 2014 WenjiHu. All rights reserved.
//

#import "ADSimpleAlertView.h"

@implementation ADSimpleAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initCustom];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCustom];
    }
    return self;
}

- (void)initCustom{
    super.delegate = self;
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.clickHandler) {
        self.clickHandler(buttonIndex);
        self.clickHandler = nil;
    }
}

@end
