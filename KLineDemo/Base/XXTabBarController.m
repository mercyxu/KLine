//
//  XXTabBarController.m
//  iOS
//
//  Created by iOS on 2018/6/7.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXTabBarController.h"
#import "XXNavigationController.h"
#import "MainTabBtn.h"
#import "LocalizeHelper.h"
#import "XXBlurView.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "ViewController.h"

@interface XXTabBarController ()

/** 主视图 */
@property (strong, nonatomic) UIView *mainView;

/** 子试图属性数组 */
@property (strong, nonatomic) NSMutableArray *namesArray;

/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *buttonsArray;

/** 选中的分类按钮 */
@property (nonatomic, strong) MainTabBtn *senderBtn;

@end

@implementation XXTabBarController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect tabFrame = self.tabBar.frame;
    CGFloat tab_H = 59;
    if (BH_IS_IPHONE_X) {
        tab_H = 83;
    }
    tabFrame.size.height = tab_H;
    tabFrame.origin.y = self.view.frame.size.height - tab_H;
    self.tabBar.frame = tabFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [KSystem statusBarSetUpDefault];
    self.view.backgroundColor = kWhite100;

    // 2. 初始化子试图控制器
    [self setupSubControllers];
    
    // 3. 添加分类按钮
    [self addItems];    
}

#pragma mark - 1. 初始化子控制器
- (void)setupSubControllers {
    
    NSMutableArray *controllers = [NSMutableArray array];
    XXNavigationController *nav0 = [[XXNavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    [controllers addObject:nav0];

    self.viewControllers = controllers;
}

#pragma mark - 2. 添加items
- (void)addItems {
    
    // 1. 创建版视图
    self.tabBar.backgroundImage = [UIImage createImageWithColor:kWhite100];
    [self.tabBar addSubview:self.mainView];
    
    // 2. 创建分类按钮
    self.buttonsArray = [NSMutableArray array];
    CGFloat kBtnW = kScreen_Width/self.namesArray.count;
    for (int i = 0; i < self.namesArray.count; i++) {
        MainTabBtn *mainBtn = [[MainTabBtn alloc] initWithFrame:CGRectMake(i*kBtnW, 0, kBtnW, 59)];
        if (i == 0) {
            mainBtn.selected = YES;
            self.senderBtn = mainBtn;
        }
        
        NSDictionary *dict = self.namesArray[i];
        [mainBtn setTitle:dict[@"title"] forState:UIControlStateNormal];
//        [mainBtn setImage:dict[@"normalImage"] forState:UIControlStateNormal];
//        [mainBtn setImage:dict[@"selectedImage"] forState:UIControlStateSelected];
        [mainBtn setTitleColor:kDark100 forState:UIControlStateNormal];
        [mainBtn setTitleColor:kBlue100 forState:UIControlStateSelected];
        mainBtn.tag = i;
        [mainBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:mainBtn];
        [self.buttonsArray addObject:mainBtn];
    }
}




#pragma mark - 3. 分类按钮点击事件
- (void)clickMainBtn:(MainTabBtn *)sender {
    
}

#pragma mark - 5. 设置想要展现的视图
- (void)setIndex:(NSInteger)index {
    [self clickMainBtn:self.buttonsArray[index]];
}

#pragma mark - || 懒加载
- (UIView *)mainView {
    if (_mainView == nil) {
        NSInteger mainViewHeight = BH_IS_IPHONE_X ? 83 : 59;
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, kScreen_Width, mainViewHeight)];
        _mainView.backgroundColor = kWhite100;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
        lineView.backgroundColor = kDark10;
        [_mainView addSubview:lineView];

    }
    return _mainView;
}

- (NSMutableArray *)namesArray {
    if (_namesArray == nil) {
        _namesArray = [NSMutableArray array];
        // 0. 首页
        [_namesArray addObject:@{
                                 @"title":@"Demo",
                                 @"normalImage":@"",
                                 @"selectedImage":@""
                                 }];

    }
    return _namesArray;
}

@end

