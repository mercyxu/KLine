//
//  UIViewController+INMOChildViewControlers.h
//  PocketFarm
//
//  Created by hexuren on 17/2/22.
//  Copyright © 2017年 hexuren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (INMOChildViewControlers)

- (void)containerAddChildViewController:(UIViewController *)childViewController parentView:(UIView *)view;

- (void)containerAddChildViewController:(UIViewController *)childViewController toContainerView:(UIView *)view useAutolayout:(BOOL)autolayout;

- (void)containerAddChildViewController:(UIViewController *)childViewController toContainerView:(UIView *)view;

- (void)containerAddChildViewController:(UIViewController *)childViewController;

- (void)containerRemoveChildViewController:(UIViewController *)childViewController;

@end
