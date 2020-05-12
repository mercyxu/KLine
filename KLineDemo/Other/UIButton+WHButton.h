//
//  UIButton+WHButton.h
//  
//
//  Created by chejingji on 2017/6/1.
//  Copyright © 2017年 chejingji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WHButton)

@property(nonatomic ,copy)void(^block)(UIButton*);

-(void)addTapBlock:(void(^)(UIButton*btn))block;

- (void)verticalImageAndTitle:(CGFloat)spacing;

/**  扩大buuton点击范围  */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

/**
 * 快速创建按钮
 * frame : frame
 * imageName : 图片
 * titleColor : 字体颜色
 * titleFont : 字体大小
 * backgroundColor : 背景颜色
 * cornerRadius : 圆角半径
 * borderWidth : 边框宽度
 * borderColor : 边款颜色
 * title : 标题
 */
+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor title:(NSString *)title;

/**
 * 快速创建按钮
 * frame : frame
 * imageName : 图片
 * titleColor : 字体颜色
 * titleFont : 字体大小
 * backgroundColor : 背景颜色
 * title : 标题
 */
+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)backgroundColor title:(NSString *)title;
/**
 * 快速创建按钮
 * frame : frame
 * imageName : 图片
 * titleColor : 字体颜色
 * titleFont : 字体大小
 * title : 标题
 */
+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont title:(NSString *)title ;
/**
 * 快速创建按钮
 * frame : frame
 * titleColor : 字体颜色
 * titleFont : 字体大小
 * backgroundColor : 背景颜色
 * title : 标题
 */
+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)backgroundColor title:(NSString *)title;
/**
 * 快速创建按钮
 * frame : frame
 * titleColor : 字体颜色
 * titleFont : 字体大小
 * title : 标题
 */
+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont title:(NSString *)title;
/**
 * 快速创建按钮
 * frame : frame
 * imageName : 图片
 * cornerRadius : 圆角半径
 * borderWidth : 边框宽度
 * borderColor : 边款颜色
 */
+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 * 快速创建按钮
 * frame : frame
 * imageName : 图片
 */
+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName;

@end
