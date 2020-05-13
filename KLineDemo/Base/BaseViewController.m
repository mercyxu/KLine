//
//  BaseViewController.m
//  iOS
//
//  Created by iOS on 2018/6/7.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NSLog(@"%@😁创建",NSStringFromClass([self class]));
    self.view.backgroundColor = kViewBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 1. 接收来网通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeNetNotification) name:ComeNet_NotificationName object:nil];
    
    // 2. 程序激活
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:@"applicationDidBecomeActiveKey" object:nil];

    // 3. 程序暂停
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:@"applicationWillResignActiveKey" object:nil];
    
    // 4. 创建导航栏
    [self createNavigation];
}


#pragma mark - 1. 创建导航栏
- (void)createNavigation {
    
    // 创建假的导航栏
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kNavHeight)];
    self.navView.backgroundColor = kViewBackgroundColor;
    self.navView.layer.cornerRadius = 0;
    self.navView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.navView.layer.shadowRadius = 1.0;
    self.navView.layer.shadowOpacity = 0;
    self.navView.layer.shadowColor = (KBigLine_Color).CGColor;
    
    // 标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(K375(64), kStatusBarHeight + 12, K375(247), kNavHeight - (kStatusBarHeight + 14))];
    self.titleLabel.font = kFontBold18;
    self.titleLabel.textColor = KNavigationBar_TitleColor;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:self.titleLabel];
    
    // 左侧按钮
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(K375(8), self.titleLabel.top, K375(56), self.titleLabel.height);
    [self.leftButton setImage:[UIImage textImageName:@"icon_back_0"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.leftButton];

    // 右侧按钮
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(kScreen_Width - K375(64), self.leftButton.top, self.leftButton.width, self.leftButton.height);
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:KNavigationBar_TitleColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = kFontBold18;
    [self.navView addSubview:self.rightButton];
    
    // 分割线
    self.navLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navView.height - 1, kScreen_Width, 1)];
    self.navLineView.backgroundColor = KLine_Color;
    self.navLineView.hidden = YES;
    [self.navView addSubview:self.navLineView];
    
    // 在主线程异步加载，使下面的方法最后执行，防止其他的控件挡住了导航栏
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:self.navView];
    });
}

#pragma mark - 2. 左侧返回按钮点击事件
- (void)leftButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonClick:(UIButton *)sender {}

#pragma mark - 3. 刷新导航栏样式
- (void)reloadNavigationStyle {
    self.navView.backgroundColor = kViewBackgroundColor;
    self.titleLabel.textColor = KNavigationBar_TitleColor;
    [self.leftButton setImage:[UIImage textImageName:@"icon_back_0"] forState:UIControlStateNormal];
}

#pragma mark - 4. 接收来网通知
- (void)comeNetNotification {
    
}

#pragma mark - 5. 后台进入前台
- (void)didBecomeActive {
    
}


#pragma mark - 6. 前台台进入后
- (void)didEnterBackground {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@😁销毁",NSStringFromClass([self class]));
}


@end
