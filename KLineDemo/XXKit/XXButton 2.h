//
//  XXButton.h
//  Bhex
//
//  Created by BHEX on 2018/6/7.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 1. 按钮点击回调block
 */
typedef void(^XXButtonBlock)(UIButton *button);

@interface XXButton : UIButton

// 1. 利用工厂方法初始化对象
+ (XXButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                         font:(UIFont *)font
                   titleColor:(UIColor *)titleColor
                        block:(XXButtonBlock)myblock;

// 1.2 利用工厂方法初始化对象
+ (XXButton *)buttonWithFrame:(CGRect)frame block:(XXButtonBlock)myblock;


@end
