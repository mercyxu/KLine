//
//  UILabel+TextSpece.m
//  间距行距字体封装居中封装
//
//  Created by yzr on 16/5/11.
//  Copyright © 2016年 tancan. All rights reserved.
//

#import "UILabel+TextSpace.h"

@implementation UILabel (TextSpace)

#pragma mark - 文字样式
-(void)setSpace:(NSString *)labelText lineSpace:(CGFloat)lf paraSpace:(CGFloat)pf alignment:(NSInteger)index kerSpace:(CGFloat)ker
{
       //文字、行距(5.0)、段距(5.0)、对齐方式(2) 、字间距(1.5)
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc]init];
        para.lineSpacing = lf;   //行距
        para.paragraphSpacing = pf; // 段距
        if (index == 3) {
            para.alignment = NSTextAlignmentRight; // 居右    //因为弄了这种样式textAlignment 无效了 所以要在这设置
        }else if (index == 2){
            para.alignment = NSTextAlignmentCenter; // 居中
        }else  para.alignment = NSTextAlignmentLeft; // 居左
        
        NSDictionary *attributes =
        @{    NSKernAttributeName: @(ker), // 字间距
              NSParagraphStyleAttributeName: para   //段落样式
              };
        // 生成一个NSAttributedString字符串
    if (!self.text) {
        self.text = @"";
    }
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
        // 设置到Label上
        self.attributedText = attributeStr;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

#pragma mark - 范围内字体大小改变

//参数  对齐方式 2居中 3居右 其他居左     范围内字体大小     从第几位开始， 多长字符串改变     范围内颜色
-(void)setRangeSize:(NSInteger)Alignment font:(CGFloat)font starIndex:(NSInteger)starIndex index:(NSInteger)index rangeColor:(UIColor*)color
{
    
    if (Alignment == 2) {
       self.textAlignment = NSTextAlignmentCenter; // 对齐方式
    }else if (Alignment == 3){
         self.textAlignment = NSTextAlignmentRight; // 对齐方式
    }else    self.textAlignment = NSTextAlignmentLeft; // 对齐方式
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    if (color == nil) {
        color = self.textColor;
    }
    if (starIndex + index > self.text.length || index < 0 || starIndex < 0) {
        return;
    }
    
    [attributeString setAttributes:@{ NSForegroundColorAttributeName :color, NSFontAttributeName : [UIFont systemFontOfSize:font] } range:NSMakeRange(starIndex, index)];
    
    self.attributedText = attributeString;
}

//参数  对齐方式 2居中 3居右 其他居左     范围内字体大小     从第几位开始， 多长字符串改变     范围内颜色
-(void)setRangeSize:(NSInteger)Alignment boldFont:(CGFloat)font starIndex:(NSInteger)starIndex index:(NSInteger)index rangeColor:(UIColor*)color
{
    
    if (Alignment == 2) {
        self.textAlignment = NSTextAlignmentCenter; // 对齐方式
    }else if (Alignment == 3){
        self.textAlignment = NSTextAlignmentRight; // 对齐方式
    }else    self.textAlignment = NSTextAlignmentLeft; // 对齐方式
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    if (color == nil) {
        color = self.textColor;
    }
    if (starIndex + index > self.text.length || index < 0 || starIndex < 0) {
        return;
    }
    
    [attributeString setAttributes:@{ NSForegroundColorAttributeName :color, NSFontAttributeName : [UIFont boldSystemFontOfSize:font] } range:NSMakeRange(starIndex, index)];
    
    self.attributedText = attributeString;
}

-(void)isFontBoldHelveticaNeue:(NSInteger)font
{
    self.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:font];
}


-(void)isFontHelveticaNeue:(NSInteger)font
{
   self.font = [UIFont fontWithName:@"HelveticaNeue" size:font];
}
#pragma mark - 设置label
-(void)isText:(NSString *)text textColor:(UIColor *)color font:(CGFloat)font textAlignment:(NSInteger)index backColor:(UIColor *)backColor
{
    self.text = [NSString stringWithFormat:@"%@",text];
    self.textColor = color;
    self.font = [UIFont systemFontOfSize:font];
    self.numberOfLines = 0;
    if (backColor == nil) {
        backColor = [UIColor clearColor];
    }
    self.backgroundColor = backColor;
    if (index == 2) {
          self.textAlignment = NSTextAlignmentCenter;
    }else if (index == 3){
          self.textAlignment = NSTextAlignmentRight;
    }else   self.textAlignment = NSTextAlignmentLeft;
}

- (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxW:(CGFloat)maxW{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - 设置范围内颜色和字体
-(void)setFont:(UIFont *)font starIndex:(NSInteger)starIndex Index:(NSInteger)index Color:(UIColor*)color
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    if (color == nil) {
        color = self.textColor;
    }
    [attributeString setAttributes:@{ NSForegroundColorAttributeName :color, NSFontAttributeName : font } range:NSMakeRange(starIndex, index)];
    
    self.attributedText = attributeString;
}

-(void)setFont:(CGFloat)font starIndex:(NSInteger)starIndex Index:(NSInteger)index Color:(UIColor*)color font2:(CGFloat)font2 starIndex2:(NSInteger)starIndex2 Index2:(NSInteger)index2 Color2:(UIColor*)color2
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    if (color == nil) {
        color = self.textColor;
    }
    
    [attributeString setAttributes:@{ NSForegroundColorAttributeName :color, NSFontAttributeName : [UIFont systemFontOfSize:font] } range:NSMakeRange(starIndex, index)];
    [attributeString setAttributes:@{ NSForegroundColorAttributeName :color2, NSFontAttributeName : [UIFont systemFontOfSize:font2] } range:NSMakeRange(starIndex2, index2)];
    
    self.attributedText = attributeString;
}


@end
