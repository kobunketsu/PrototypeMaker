//
//  NSString+Extension.h
//  PaintProjector
//
//  Created by 文杰 胡 on 4/5/15.
//  Copyright (c) 2015 WenjiHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
//+ (NSString*)unitStringFromFloat:(CGFloat)value;
- (Boolean)isEqualToString:(NSString *)string caseSensitive:(BOOL)caseSensitive;
- (BOOL)containSubstring:(NSString *)string;
- (NSInteger)numOfLines;
#pragma mark- Custom Decorate
//- (NSAttributedString*)decorateStringOfNormalColor:(UIColor *)normalColor emphasizedColor:(UIColor *)emphasizedColor;
//- (NSAttributedString*)decorateString;

@end
