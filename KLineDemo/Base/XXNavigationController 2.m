//
//  XXNavigationController.m
//  Bhex
//
//  Created by BHEX on 2018/6/7.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXNavigationController.h"

@interface XXNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation XXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [KSystem statusBarSetUpDefault];
    
    // 隐藏系统导航栏
    self.navigationBar.hidden = YES;
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationBar.translucent=NO;
    
    // 如果是因为自定义导航按钮而导致手势返回失效，那么可以在NavigationController的viewDidLoad函数中添加如下代码：
    KWeakSelf
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
        
        // 自动显示和隐藏tabbar
        self.tabBarController.tabBar.hidden = YES;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]&&animated==YES)
        self.interactivePopGestureRecognizer.enabled = NO;
    [super pushViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]&&animated==YES)
        self.interactivePopGestureRecognizer.enabled = NO;
    return  [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    return [super popToViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
    // Enable the gesture again once the new controller is shown
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer==self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count<2||self.visibleViewController==[self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}
@end
