//
//  UILabel+Extension.m
//  WanRenHuiAgent
//
//  Created by 徐义恒 on 17/4/19.
//  Copyright © 2017年 徐义恒. All rights reserved.
//

#import "UILabel+Extension.h"

#define UILabel_Line_Space 5.0f
#define UILabel_Text_Space @0.3f

@implementation UILabel (Extension)

#pragma mark - 1. 设置text
- (void)setText:(NSString *)text alignment:(NSTextAlignment)alignment  isSetFrame:(BOOL)setFrame {

    if ( text.length == 0 ) {
        text = @"";
    }
    self.numberOfLines = 0;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment = alignment;
    paraStyle.lineSpacing = UILabel_Line_Space; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent =0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic =@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:UILabel_Text_Space
                         };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    self.attributedText = attributeStr;
    
    if ( setFrame ) {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [UILabel getSpaceLabelHeight:text withFont:self.font withWidth:self.frame.size.width]);
    }
}

#pragma mark - 2. 获取UILabel的高度(带有行间距的情况)
/**
 *  @author xuyiheng
 *
 *  计算UILabel的高度(带有行间距的情况)
 *
 *  @return text=文本
 */
+ (CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILabel_Line_Space;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:UILabel_Text_Space
                         };
    // 可以设置最大高度 0代表不限高度
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

#pragma mark - 3. 获取朋友圈评论内容的高度
/**
 *  @author xuyiheng
 *
 *  计算UILabel的高度(带有行间距的情况)
 *
 *  @return text=文本
 */
+ (CGFloat)getCommentLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILabel_Line_Space;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:UILabel_Text_Space
                         };
    // 可以设置最大高度 0代表不限高度
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
    
}

#pragma mark - 4. 设置带行间距参数的text
- (void)setText:(NSString *)text alignment:(NSTextAlignment)alignment lineSpacing:(CGFloat)lineSpacing  isSetFrame:(BOOL)setFrame {
    
    if ( text.length == 0 ) {
        text = @"";
    }
    self.numberOfLines = 0;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment = alignment;
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent =0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic =@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:UILabel_Text_Space
                         };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    self.attributedText = attributeStr;
    
    if ( setFrame ) {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [UILabel getSpaceLabelHeight:text withFont:self.font withWidth:self.frame.size.width lineSpacing:lineSpacing]);
    }
}

#pragma mark - 5. 获取UILabel的高度(带有行间距参数的情况)
/**
 *  @author xuyiheng
 *
 *  计算UILabel的高度(带有行间距的情况)
 *
 *  @return text=文本
 */
+ (CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:UILabel_Text_Space
                         };
    // 可以设置最大高度 0代表不限高度
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

- (void)setAppearanceFont:(UIFont *)appearanceFont
{
    if(appearanceFont)
    {
        [self setFont:appearanceFont];
    }
}

- (UIFont *)appearanceFont
{
    return self.font;
}

@end
