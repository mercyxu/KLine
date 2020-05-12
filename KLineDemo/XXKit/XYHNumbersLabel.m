//
//  XYHNumbersLabel.m
//  Tourist
//
//  Created by Mr on 16/11/17.
//  Copyright © 2016年 HG_hupfei. All rights reserved.
//

#import "XYHNumbersLabel.h"

@interface XYHNumbersLabel ()

/** <#mark#> */
@property (strong, nonatomic) UIFont *font;

@end

@implementation XYHNumbersLabel

#pragma mark - 1. 初始化方法
/**
 *  @author xuyiheng
 *
 *  多行文本
 *
 *  @return lineSpace=行距 textSpace=字距 textSize=字体大小
 */
- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1. 字体大小
        self.font = font;
        
        // 2. 行数
        self.numberOfLines = 0;
        
    }
    return self;
}

#pragma mark - 2. 文本赋值重写
/**
 *  @author xuyiheng
 *
 *  文本赋值重写
 *
 *  @return text=文本
 */
- (void)setText:(NSString *)text {

    if ( text.length == 0 ) {
        text = @"";
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment =NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILabel_Line_Space; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent =0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic =@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@UILabel_Text_Space};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    self.attributedText = attributeStr;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [XYHNumbersLabel getSpaceLabelHeight:text withFont:self.font withWidth:self.frame.size.width]);

}

- (void)setText:(NSString *)text alignment:(NSTextAlignment)alignment  {
    
    if ( text.length == 0 ) {
        text = @"";
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment =alignment;
    paraStyle.lineSpacing = UILabel_Line_Space; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent =0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic =@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@UILabel_Text_Space};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    self.attributedText = attributeStr;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [XYHNumbersLabel getSpaceLabelHeight:text withFont:self.font withWidth:self.frame.size.width]);
    
}

- (void)setAttributedText:(NSMutableAttributedString *)attributedText alignment:(NSTextAlignment)alignment  {
    
    if (IsEmpty(attributedText)) {
        return;
    }
    self.attributedText = attributedText;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [XYHNumbersLabel getSpaceLabelHeight:self.text withFont:self.font withWidth:self.frame.size.width]);
    
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
    NSDictionary *dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@UILabel_Text_Space
                         };
    
    // 可以设置最大高度 0代表不限高度
    CGSize size = [str boundingRectWithSize:CGSizeMake(width,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

#pragma mark - 3. 图文混排赋值
- (void)setVideoTitleText:(NSString *)text {

    if ( text.length == 0 ) {
        text = @"";
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILabel_Line_Space; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent =0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic =@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@UILabel_Text_Space
                         };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    self.attributedText = attributeStr;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [XYHNumbersLabel getSpaceLabelHeight:text withFont:self.font withWidth:self.frame.size.width]);
}

@end
