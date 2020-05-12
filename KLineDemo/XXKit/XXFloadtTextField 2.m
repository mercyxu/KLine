//
//  XYHFloadtTextField.m
//  WanRenHui
//
//  Created by 徐义恒 on 17/3/25.
//  Copyright © 2017年 gansbat. All rights reserved.
//

#import "XXFloadtTextField.h"

@implementation XXFloadtTextField

#pragma mark - 1. 根据frame初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.keyboardType = UIKeyboardTypeDecimalPad;
        [self addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
        
    }
    return self;
}

#pragma mark - 2. 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
       
        [self addTarget:self
                 action:@selector(textFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
        
    }
    return self;
}

#pragma mark - 3. 输入框值改变的事件
- (void)textFieldDidChange:(UITextField *)textField {
    
    // 1. 去空格
    textField.text = [textField.text trimmingCharacters];
    
    // 2. 保证输入数字的有效性
    if ( textField.text.length > 0 ) {
        
        // 1. 防止输入多个小数点
        if ( [textField.text componentsSeparatedByString:@"."].count > 2 ) {
            
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
            
        }
        
        // 2. 控制精度
        if (self.isPrecision) {
            if ( [textField.text componentsSeparatedByString:@"."].count == 2 && [[textField.text componentsSeparatedByString:@"."] lastObject].length > self.count ) {
                
                NSString *firstString = [[textField.text componentsSeparatedByString:@"."] firstObject];
                NSString *lastString = [[textField.text componentsSeparatedByString:@"."] lastObject];
                textField.text = [NSString stringWithFormat:@"%@.%@", firstString, [lastString substringToIndex:self.count]];
            }
        }
    }
}
@end
