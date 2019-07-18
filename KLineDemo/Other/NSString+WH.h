//
//  NSString+Empty.h
//  fuDao
//
//  Created by Window on 2018/1/28.
//  Copyright © 2018年 fuDao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WH)

- (BOOL)isEmptyWithObject:(id)object;

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;
- (CGSize)calculateWebViewSize:(CGSize)size font:(UIFont *)font;
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (NSMutableAttributedString *)formatTipStr:(NSString *)tipStr andTipColor:(UIColor *)tipColor andFontSize:(float)tipFontSize andDesStr:(NSString *)desStr andDesColor:(UIColor *)desColor andFontSize:(float)desFontSize;
+ (NSMutableAttributedString *)setupAttributedSitringWithTitle:(NSString *)title attr:(NSString *)attrStr lastTitle:(NSString *)lastTitle;
+ (NSMutableAttributedString *)formatTipStr:(NSString *)tipStr andTipColor:(UIColor *)tipColor andFontSize:(float)tipFontSize andDesStr:(NSString *)desStr andDesColor:(UIColor *)desColor andFontSize:(float)desFontSize andLastStr:(NSString *)lastStr andDesColor:(UIColor *)lastColor andFontSize:(float)lastFontSize;

+ (NSMutableAttributedString *)formatBoldTipStr:(NSString *)tipStr andTipColor:(UIColor *)tipColor andFontSize:(UIFont *)font andDesStr:(NSString *)desStr andDesColor:(UIColor *)desColor andFontSize:(UIFont *)desFont;

+ (NSMutableAttributedString *)formatBoldTipStr:(NSString *)tipStr andTipColor:(UIColor *)tipColor andFontSize:(UIFont *)tipFont andDesStr:(NSString *)desStr andDesColor:(UIColor *)desColor andFontSize:(UIFont *)desFont andLastStr:(NSString *)lastStr andDesColor:(UIColor *)lastColor andFontSize:(UIFont *)lastFont;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
