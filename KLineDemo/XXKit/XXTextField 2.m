//
//  XXTextField.m
//  Demo
//
//  Created by Bhex on 2019/7/25.
//  Copyright © 2019 徐义恒. All rights reserved.
//

#import "XXTextField.h"

@implementation XXTextField

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    [self reloadPlaceholder];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    [self reloadPlaceholder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self reloadPlaceholder];
}


- (void)reloadPlaceholder {
    
    NSString *text = self.placeholder ? self.placeholder : @"";
    UIColor *textColor = self.placeholderColor ? self.placeholderColor : [UIColor grayColor];
    UIFont *font = self.placeholderFont ? self.placeholderFont : self.font;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:textColor, NSFontAttributeName:font}];
    self.attributedPlaceholder = attrString;
}
@end
