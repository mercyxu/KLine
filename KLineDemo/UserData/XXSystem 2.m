//
//  XXSystem.m
//  Bhex
//
//  Created by Bhex on 2019/10/21.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXSystem.h"

@implementation XXSystem
singleton_implementation(XXSystem)

#pragma mark - 1. 获取是否夜色模式
- (BOOL)isDarkStyle {
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        if (mode == UIUserInterfaceStyleDark) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

#pragma mark - 2. 状态栏设置为白色
- (void)statusBarSetUpWhiteColor {
    
    if (self.isDarkStyle) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

#pragma mark - 3. 状态栏设置为黑色
- (void)statusBarSetUpDarkColor {
    if (self.isDarkStyle) {
        if (@available(iOS 13.0, *)) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
        } else {
            
        }
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

#pragma mark - 4. 状态栏设置为默认色
- (void)statusBarSetUpDefault {
    if (KUser.isNightType) {
        [self statusBarSetUpWhiteColor];
    } else {
        [self statusBarSetUpDarkColor];
    }
}
@end
