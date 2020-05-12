//
//  XXLabel.h
//  Bhex
//
//  Created by BHEX on 2018/6/7.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/**
 *  @author xuyiheng
 *
 *  1.【frame、字体大小、字体颜色】
 */
+ (XXLabel *)labelWithFrame:(CGRect)frame
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor;

/**
 *  @author xuyiheng
 *
 *  2.【frame、text、字体大小、字体颜色】
 */
+ (XXLabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor;

/**
 *  @author xuyiheng
 *
 *  3.【frame、text、字体大小、字体颜色、对齐方式】
 */
+ (XXLabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor
                  alignment:(NSTextAlignment)alignment;

/**
 *  @author xuyiheng
 *
 *  4.【frame、text、字体大小、字体颜色、对齐方式、圆角】
 */
+ (XXLabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor
                  alignment:(NSTextAlignment)alignment
               cornerRadius:(CGFloat)cornerRadius;


/**
 *  @author xuyiheng
 *
 *  5.【frame、text、字体大小、字体颜色、对齐方式、圆角、边框颜色及宽度】
 */
+ (XXLabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor
                  alignment:(NSTextAlignment)alignment
               cornerRadius:(CGFloat)cornerRadius
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth;

/** 6. 添加点击拷贝方法 */
- (void)addClickCopyFunction;

- (void)longPress;

@end
