//
//  UILabel+Extension.h
//  WanRenHuiAgent
//
//  Created by 徐义恒 on 17/4/19.
//  Copyright © 2017年 徐义恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

#pragma mark - 1. 设置text
- (void)setText:(NSString *)text alignment:(NSTextAlignment)alignment  isSetFrame:(BOOL)setFrame ;

#pragma mark - 2. 获取UILabel的高度(带有行间距的情况)
/**
 *  @author xuyiheng
 *
 *  计算UILabel的高度(带有行间距的情况)
 *
 *  @return text=文本
 */
+ (CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;


#pragma mark - 3. 获取朋友圈评论内容的高度
/**
 *  @author xuyiheng
 *
 *  计算UILabel的高度(带有行间距的情况)
 *
 *  @return text=文本
 */
+ (CGFloat)getCommentLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;

#pragma mark - 4. 设置带行间距参数的text
/**
 *  @author xuyiheng
 *
 *  设置带行间距参数的text 
 */
- (void)setText:(NSString *)text alignment:(NSTextAlignment)alignment lineSpacing:(CGFloat)lineSpacing  isSetFrame:(BOOL)setFrame;

@property (nonatomic,copy) UIFont *appearanceFont UI_APPEARANCE_SELECTOR;

@end
