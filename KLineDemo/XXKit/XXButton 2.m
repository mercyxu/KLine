//
//  XXButton.m
//  Bhex
//
//  Created by BHEX on 2018/6/7.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXButton.h"

@interface XXButton()

@property (copy, nonatomic) XXButtonBlock sendBlock;

@end

@implementation XXButton

#pragma mark - 1. 利用工厂方法初始化对象
+ (XXButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                         font:(UIFont *)font
                   titleColor:(UIColor *)titleColor
                        block:(XXButtonBlock)myblock {
    
    // 1. 创建按钮
    XXButton *button = [XXButton buttonWithType:UIButtonTypeCustom];
    
    // 2. 设定按钮的Frame
    button.frame = frame;
    
    // 3. 设定按钮标题
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    // 4. 设置title字体大小
    if ( font ) {
        button.titleLabel.font = font;
    }
    
    // 5. 设定title字体颜色
    if ( titleColor ) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    // 6. 添加点击事件
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 7. 指定回调的block
    button.sendBlock = myblock;
    
    return button;
}

#pragma mark - 1.2 利用工厂方法初始化对象
+ (XXButton *)buttonWithFrame:(CGRect)frame block:(XXButtonBlock)myblock {
    
    // 1. 创建按钮
    XXButton *button = [XXButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    // 2. 添加点击事件
    [button addTarget:button action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 3. 指定回调的block
    button.sendBlock = myblock;
    
    return button;
}

#pragma mark - 按钮轻击事件
-(void)buttonClicked:(XXButton *)button{
    
    // 1. 回调block
    if (button.sendBlock) {
        button.sendBlock(button);
    }
}

@end
