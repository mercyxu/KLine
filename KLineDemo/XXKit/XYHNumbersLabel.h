//
//  XYHNumbersLabel.h
//  Tourist
//
//  Created by Mr on 16/11/17.
//  Copyright © 2016年 HG_hupfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYHNumbersLabel : UILabel


- (void)setText:(NSString *)text alignment:(NSTextAlignment)alignment;

- (void)setAttributedText:(NSMutableAttributedString *)attributedText alignment:(NSTextAlignment)alignment;

#pragma mark - 1. 初始化方法
/**
 *  @author xuyiheng
 *
 *  多行文本
 *
 *  @return textSize=字体大小
 */
- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font;

#pragma mark - 2. 获取UILabel的高度(带有行间距的情况)
/**
 *  @author xuyiheng
 *
 *  计算UILabel的高度(带有行间距的情况)
 *
 *  @return text=文本
 */
+ (CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;

#pragma mark - 3. 图文混排赋值
- (void)setVideoTitleText:(NSString *)text;


@end
