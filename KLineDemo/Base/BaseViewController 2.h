//
//  BaseViewController.h
//  Bhex
//
//  Created by BHEX on 2018/6/7.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/** 导航栏视图 */
@property (strong, nonatomic) UIView *navView;

/** 标题 */
@property (strong, nonatomic) UILabel *titleLabel;

/** 左侧返回按钮 */
@property (strong, nonatomic) UIButton *leftButton;

/** 右侧按钮 */
@property (strong, nonatomic) UIButton *rightButton;

/** 导航栏分割线 */
@property (strong, nonatomic) UIView *navLineView;

/**
 0. 创建导航栏
 */
- (void)createNavigation;

/**
 1. 刷新导航栏样式
 */
- (void)reloadNavigationStyle;

/**
 3. 左侧按钮点击事件
 */
- (void)leftButtonClick:(UIButton *)sender;

/**
 3. 右侧按钮点击事件
 */
- (void)rightButtonClick:(UIButton *)sender;

/**
 4. 接收来网通知
 */
- (void)comeNetNotification;

/**
5. 后台进入前台
*/
- (void)didBecomeActive;

/**
6. 前台台进入后
*/
- (void)didEnterBackground;

@end
