
//
//  NSString+Empty.m
//  fuDao
//
//  Created by Window on 2018/1/28.
//  Copyright © 2018年 fuDao. All rights reserved.
//

#import "NSString+WH.h"

@implementation NSString (WH)

- (BOOL)isEmptyWithObject:(id)object{
    
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
        expectedLabelSize =  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

- (CGSize)calculateWebViewSize:(CGSize)size font:(UIFont *)font{
    NSString *replaceStr = [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
    CGSize expectedLabelSize = CGSizeZero;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    expectedLabelSize = [replaceStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (NSMutableAttributedString *)formatTipStr:(NSString *)tipStr andTipColor:(UIColor *)tipColor andFontSize:(float)tipFontSize andDesStr:(NSString *)desStr andDesColor:(UIColor *)desColor andFontSize:(float)desFontSize
{
    if (tipStr == nil) {
        tipStr = @"";
    }
    if (desStr == nil) {
        desStr = @"";
    }
    NSMutableAttributedString *str = [self formatDesc:tipStr withFontSize:tipFontSize andTextColor:tipColor];
    [str appendAttributedString:[self formatDesc:desStr withFontSize:desFontSize andTextColor:desColor]];
    return str;
}

+ (NSMutableAttributedString *)formatDesc:(NSString *)str withFontSize:(float)fontSize andTextColor:(UIColor *)textColor{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:str];
    [result addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, result.length)];
    [result addAttribute:NSFontAttributeName value:FONT_WITH_SIZE(fontSize) range:NSMakeRange(0, result.length)];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc]init];
    para.lineSpacing = 5;   //行距
    [result addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, result.length)];
    return result;
}


+ (NSMutableAttributedString *)formatTipStr:(NSString *)tipStr andTipColor:(UIColor *)tipColor andFontSize:(float)tipFontSize andDesStr:(NSString *)desStr andDesColor:(UIColor *)desColor andFontSize:(float)desFontSize andLastStr:(NSString *)lastStr andDesColor:(UIColor *)lastColor andFontSize:(float)lastFontSize
{
    if (tipStr == nil) {
        tipStr = @"";
    }
    if (desStr == nil) {
        desStr = @"";
    }
    if (lastStr == nil) {
        lastStr = @"";
    }
    NSMutableAttributedString *str = [self formatDesc:tipStr withFontSize:tipFontSize andTextColor:tipColor];
    [str appendAttributedString:[self formatDesc:desStr withFontSize:desFontSize andTextColor:desColor]];
    [str appendAttributedString:[self formatDesc:lastStr withFontSize:lastFontSize andTextColor:lastColor]];
    return str;
}


+ (NSMutableAttributedString *)setupAttributedSitringWithTitle:(NSString *)title attr:(NSString *)attrStr lastTitle:(NSString *)lastTitle
{
    NSString *newStr = [NSString stringWithFormat:@"%@%@%@",title,attrStr,lastTitle];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:newStr];
    [attr addAttributes:@{NSForegroundColorAttributeName:RGB(231, 0, 18)} range:NSMakeRange(title.length, newStr.length-title.length-lastTitle.length)];
    return attr;
}

//字体设置富文本
+ (NSMutableAttributedString *)formatBoldTipStr:(NSString *)tipStr andTipColor:(UIColor *)tipColor andFontSize:(UIFont *)font andDesStr:(NSString *)desStr andDesColor:(UIColor *)desColor andFontSize:(UIFont *)desFont
{
    if (tipStr == nil) {
        tipStr = @"";
    }
    if (desStr == nil) {
        desStr = @"";
    }
    NSMutableAttributedString *str = [self formatBoldDesc:tipStr withFontSize:font andTextColor:tipColor];
    [str appendAttributedString:[self formatBoldDesc:desStr withFontSize:desFont andTextColor:desColor]];
    return str;
}

+ (NSMutableAttributedString *)formatBoldTipStr:(NSString *)tipStr andTipColor:(UIColor *)tipColor andFontSize:(UIFont *)tipFont andDesStr:(NSString *)desStr andDesColor:(UIColor *)desColor andFontSize:(UIFont *)desFont andLastStr:(NSString *)lastStr andDesColor:(UIColor *)lastColor andFontSize:(UIFont *)lastFont
{
    if (tipStr == nil) {
        tipStr = @"";
    }
    if (desStr == nil) {
        desStr = @"";
    }
    if (lastStr == nil) {
        lastStr = @"";
    }
    NSMutableAttributedString *str = [self formatBoldDesc:tipStr withFontSize:tipFont andTextColor:tipColor];
    [str appendAttributedString:[self formatBoldDesc:desStr withFontSize:desFont andTextColor:desColor]];
    [str appendAttributedString:[self formatBoldDesc:lastStr withFontSize:lastFont andTextColor:lastColor]];
    return str;
}

+ (NSMutableAttributedString *)formatBoldDesc:(NSString *)str withFontSize:(UIFont *)font andTextColor:(UIColor *)textColor{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:str];
    [result addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, result.length)];
    [result addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, result.length)];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc]init];
    para.lineSpacing = 5;   //行距
    [result addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, result.length)];
    return result;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&err];
    if(err)
    {
//        NSLog(@"json解析失败：%@",jsonString);
        return nil;
    }
    return dic;
}

@end
