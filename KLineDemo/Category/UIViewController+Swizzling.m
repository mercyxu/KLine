//
//  UIViewController+Swizzling.m
//  iOS
//
//  Created by iOS on 2018/9/18.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "UIViewController+Swizzling.h"

@implementation UIViewController (Swizzling)

/**
 友盟打点
 */
+(void)load {
    Method originalSelector = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledSelector = class_getInstanceMethod(self, @selector(swiz_viewWillAppear:));
    method_exchangeImplementations(originalSelector, swizzledSelector);
    
    Method originalSelector_dis = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    Method swizzledSelector_dis = class_getInstanceMethod(self, @selector(swiz_viewWillDisappear:));
    method_exchangeImplementations(originalSelector_dis, swizzledSelector_dis);
}

- (void)swiz_viewWillAppear:(BOOL)animated {
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
    [self swiz_viewWillAppear:animated];
}

- (void)swiz_viewWillDisappear:(BOOL)animated {
//    [MobClick endLogPageView:NSStringFromClass([self class])];
    [self swiz_viewWillDisappear:animated];
}

@end
