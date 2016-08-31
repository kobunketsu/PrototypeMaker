//
//  NSString+Extension.m
//  PaintProjector
//
//  Created by 文杰 胡 on 4/5/15.
//  Copyright (c) 2015 WenjiHu. All rights reserved.
//

#import "NSString+Extension.h"
//#import "ADUnitConverter.h"
@implementation NSString (Extension)
//+(NSString*)unitStringFromFloat:(CGFloat)value{
//    BOOL isMetric = [[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue];
//    if (isMetric) {
//        return [NSString stringWithFormat:@"%.3f M", value];
//    }
//    else{
//        USUnit unit = [ADUnitConverter usUnitFromMeter:value];
//        return [NSString stringWithFormat:@"'%.f ''%.1f", unit.feet, unit.inch];
//    }
//}

- (NSInteger)numOfLines{
    NSInteger numOfLines = [self componentsSeparatedByString:@"\n"].count;
    return numOfLines;
}

- (BOOL)containSubstring:(NSString *)string{
    if([UIDevice currentDevice].systemVersion.floatValue >= IOSCapVersion){
        return [self containsString:string];
    }
    else{
        return [self rangeOfString:string].location != NSNotFound;
    }
}

//- (NSAttributedString*)decorateStringOfNormalColor:(UIColor *)normalColor emphasizedColor:(UIColor *)emphasizedColor{
//    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:self];
//    NSMutableAttributedString * resultString = [[NSMutableAttributedString alloc] init];
//    
//    NSError *error = nil;
//    NSString *pattern = @"\\[(.*?)\\]";
//    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
//                                                                                options:0
//                                                                                  error:&error];
//    NSTextCheckingResult *result = [expression firstMatchInString:self
//                                                          options:0
//                                                            range:NSMakeRange(0, self.length)];
//    if (result) {
//        NSRange range1 = [result rangeAtIndex:1];
//        NSString *rangeString = [NSString stringWithFormat:@"%zd %zd", 0, range1.location-1];
//        NSRange range0 = NSRangeFromString(rangeString);
//        NSUInteger start = range1.location + range1.length + 1;
//        rangeString = [NSString stringWithFormat:@"%zd %zd", start, self.length - start];
//        NSRange range2 = NSRangeFromString(rangeString);
//        
//        [attributeString addAttribute:NSForegroundColorAttributeName value:normalColor range:range0];
//        [attributeString addAttribute:NSForegroundColorAttributeName value:emphasizedColor range:range1];
//        [attributeString addAttribute:NSForegroundColorAttributeName value:normalColor range:range2];
//        
//        [resultString appendAttributedString:[attributeString attributedSubstringFromRange:range0]];
//        [resultString appendAttributedString:[attributeString attributedSubstringFromRange:range1]];
//        [resultString appendAttributedString:[attributeString attributedSubstringFromRange:range2]];
//        
//    }
//    else{
//        resultString = attributeString;
//    }
//    
//    
//    return resultString;
//}

//- (NSAttributedString*)decorateString{
//    return [self decorateStringOfNormalColor:[ADSharedUIStyleKit cText] emphasizedColor:UIColor.redColor];
//}

- (Boolean)isEqualToString:(NSString *)string caseSensitive:(BOOL)caseSensitive{
    if (caseSensitive) {
        return [self isEqualToString:string];
    }
    else{
        return [self caseInsensitiveCompare:string] == NSOrderedSame;
    }
    
    
}
@end
