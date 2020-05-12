//
//  XXBlurView.m
//  iOS
//
//  Created by iOS on 2018/9/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXBlurView.h"

@implementation XXBlurView


- (instancetype)initWithFrame:(CGRect)frame effectAlpha:(CGFloat)alpha {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
        [self initBlurUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initBlurUI];
    }
    return self;
}

// custom blur view color
// https://medium.com/@tungfam/how-to-customize-the-intensity-of-blur-effect-on-ios-cc5698c49a91
// self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
- (void)initBlurUI {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    visualEffectView.frame = self.frame;
    [self addSubview:visualEffectView];
}

- (void)setAlpha:(CGFloat)alpha {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
}

@end
