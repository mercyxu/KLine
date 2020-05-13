//
//  XXLabel.m
//  iOS
//
//  Created by iOS on 2018/6/7.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXLabel.h"
#define UILabel_Line_Space 5.0f
#define UILabel_Text_Space @0.3f

@implementation XXLabel

// 1. 利用工厂方法初始化对象
+ (XXLabel *)labelWithFrame:(CGRect)frame
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor {
    XXLabel *label = [[XXLabel alloc] initWithFrame:frame];
    
    if (font) {
        label.font = font;
    }
    
    if (textColor) {
        label.textColor = textColor;
    }
    return label;
}

// 2. 利用工厂方法初始化对象
+ (XXLabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor {
    XXLabel *label = [[XXLabel alloc] initWithFrame:frame];
    
    if (text) {
        label.text = text;
    }
    
    if (font) {
        label.font = font;
    }
    
    if (textColor) {
        label.textColor = textColor;
    }
    return label;
}

// 3. 利用工厂方法初始化对象
+ (XXLabel *)labelWithFrame:(CGRect)frame
                      text:(NSString *)text
                       font:(UIFont *)font
                 textColor:(UIColor *)textColor
                  alignment:(NSTextAlignment)alignment {
    XXLabel *label = [[XXLabel alloc] initWithFrame:frame];
    
    if (text) {
        label.text = text;
    }
    
    if (font) {
        label.font = font;
    }
    
    if (textColor) {
        label.textColor = textColor;
    }
    label.textAlignment = alignment;
    return label;
}

// 4. 利用工厂方法初始化对象
+ (XXLabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor
                  alignment:(NSTextAlignment)alignment
               cornerRadius:(CGFloat)cornerRadius {
    
    XXLabel *label = [[XXLabel alloc] initWithFrame:frame];
    if (text) {
        label.text = text;
    }
    
    if (font) {
        label.font = font;
    }
    
    if (textColor) {
        label.textColor = textColor;
    }
    label.textAlignment = alignment;
    
    if (cornerRadius > 0) {
        label.layer.cornerRadius = cornerRadius;
        label.layer.masksToBounds = YES;
    }
    return label;
}


// 5. 利用工厂方法初始化对象
+ (XXLabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor
                  alignment:(NSTextAlignment)alignment
               cornerRadius:(CGFloat)cornerRadius
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth {
    
    XXLabel *label = [[XXLabel alloc] initWithFrame:frame];
    if (text) {
        label.text = text;
    }
    
    if (font) {
        label.font = font;
    }
    
    if (textColor) {
        label.textColor = textColor;
    }
    label.textAlignment = alignment;
    
    if (cornerRadius > 0) {
        label.layer.cornerRadius = cornerRadius;
        label.layer.masksToBounds = YES;
    }
    
    if (borderColor && borderWidth > 0) {
        label.layer.borderColor = borderColor.CGColor;
        label.layer.borderWidth = borderWidth;
    }
    return label;
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)addClickCopyFunction {
    KWeakSelf
    [self whenTapped:^{
        if (weakSelf.text.length > 0) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            [pab setString:weakSelf.text];
        }
    }];
}

- (void)longPress {
    
    // 设置label为第一响应者
    [self becomeFirstResponder];
    
    // 自定义 UIMenuController
    UIMenuController * menu = [UIMenuController sharedMenuController];
    UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:LocalizedString(@"CopyKey") action:@selector(copyText:)];
    menu.menuItems = @[item1];
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
}




- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if(action == @selector(copyText:)) return YES;
    return NO;
}

- (void)copyText:(UIMenuController *)menu {

    if (self.text > 0) {
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:self.text];
    }
}

- (void)drawTextInRect:(CGRect)rect {
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}
@end
