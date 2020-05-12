//
//  UIViewController+INMOChildViewControlers.m
//  PocketFarm
//
//  Created by hexuren on 17/2/22.
//  Copyright © 2017年 hexuren. All rights reserved.
//

#import "UIViewController+INMOChildViewControlers.h"

@implementation UIViewController (INMOChildViewControlers)

- (void)containerAddChildViewController:(UIViewController *)childViewController parentView:(UIView *)view {
    [self containerAddChildViewController:childViewController toContainerView:view];
}

- (void)containerAddChildViewController:(UIViewController *)childViewController toContainerView:(UIView *)view useAutolayout:(BOOL)autolayout {
    
    childViewController.view.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
    
    [self addChildViewController:childViewController];
    [view addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
    [view bringSubviewToFront:childViewController.view];
    
    if (autolayout) {
        UIView * parent = view;
        UIView * child = childViewController.view;
        [child setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [parent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[child]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(child)]];
        [parent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[child]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(child)]];
        [parent layoutIfNeeded];
    }
    
}

- (void)containerAddChildViewController:(UIViewController *)childViewController toContainerView:(UIView *)view {
    
    [self containerAddChildViewController:childViewController toContainerView:view useAutolayout:NO];
    
}

- (void)containerAddChildViewController:(UIViewController *)childViewController {
    
    [self containerAddChildViewController:childViewController toContainerView:self.view];
    
}

- (void)containerRemoveChildViewController:(UIViewController *)childViewController {
    
    [childViewController willMoveToParentViewController:nil];
    [childViewController.view removeFromSuperview];
    [childViewController removeFromParentViewController];
    
}


@end
