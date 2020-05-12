//
//  XXTabBarController.m
//  Bhex
//
//  Created by BHEX on 2018/6/7.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXTabBarController.h"
#import "XXNavigationController.h"
#import "XXHomeVC.h"
#import "XXTradeHomeVC.h"
#import "XXQuoteVC.h"
#import "XXAssetsHomeVC.h"
#import "MainTabBtn.h"
#import "LocalizeHelper.h"
#import "XXBlurView.h"
#import "XXContractVC.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>

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
    
    // 1. 加载配置数据
    [KIndexModel loadData];
    KWeakSelf
    KIndexModel.tabbarBlock = ^{
        [weakSelf reloadButtonImage];
    };
    
    // 2. 初始化子试图控制器
    [self setupSubControllers];
    
    // 3. 添加分类按钮
    [self addItems];    
}

#pragma mark - 1. 初始化子控制器
- (void)setupSubControllers {
    
    NSMutableArray *controllers = [NSMutableArray array];
    
    // 0. 首页
    XXNavigationController *nav0 = [[XXNavigationController alloc] initWithRootViewController:[[XXHomeVC alloc] init]];
    [controllers addObject:nav0];
    
    // 1. 市场
    XXNavigationController *navOne = [[XXNavigationController alloc] initWithRootViewController:[[XXQuoteVC alloc] init]];
    [controllers addObject:navOne];

    // 2. 交易
    XXNavigationController *navTwo = [[XXNavigationController alloc] initWithRootViewController:[[XXTradeHomeVC alloc] init]];
    [controllers addObject:navTwo];
    
    // 3. 合约
    XXNavigationController *navThree = [[XXNavigationController alloc] initWithRootViewController:[[XXContractVC alloc] init]];
    if (KConfigure.isHaveOption || KConfigure.isHaveContract) {
        [controllers addObject:navThree];
    }

    // 4. 资产
    XXNavigationController *navFour = [[XXNavigationController alloc] initWithRootViewController:[[XXAssetsHomeVC alloc] init]];
    [controllers addObject:navFour];
    
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
        
//        NSDictionary *dict = self.namesArray[i];
//        [mainBtn setTitle:dict[@"title"] forState:UIControlStateNormal];
//        [mainBtn setImage:dict[@"normalImage"] forState:UIControlStateNormal];
//        [mainBtn setImage:dict[@"selectedImage"] forState:UIControlStateSelected];
        [mainBtn setTitleColor:kDark100 forState:UIControlStateNormal];
        [mainBtn setTitleColor:kBlue100 forState:UIControlStateSelected];
        mainBtn.tag = i;
        [mainBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:mainBtn];
        [self.buttonsArray addObject:mainBtn];
    }

    [self reloadButtonImage];
}

#pragma mark - 3. 刷新按钮图标
- (void)reloadButtonImage {
    if (IsEmpty(KIndexModel.tabbarArray)) {
        NSMutableArray *titlesArray = [NSMutableArray array];
        [titlesArray addObject:LocalizedString(@"Home")];
        [titlesArray addObject:LocalizedString(@"Markets")];
        [titlesArray addObject:LocalizedString(@"TradesTabbar")];
        if (KConfigure.isHaveContract || KConfigure.isHaveOption) {
            [titlesArray addObject:LocalizedString(@"Contract")];
        }
        [titlesArray addObject:LocalizedString(@"BalanceManagement")];
        for (NSInteger i=0; i < self.buttonsArray.count; i ++) {
            MainTabBtn *mainBtn = self.buttonsArray[i];
            
            [mainBtn setTitle:titlesArray[i] forState:UIControlStateNormal];
            [mainBtn setImage:[UIImage textImageName:[NSString stringWithFormat:@"tabbarNew_%zd", i]] forState:UIControlStateNormal];
            [mainBtn setImage:[UIImage mainImageName:[NSString stringWithFormat:@"tabbarNew_%zd", i]] forState:UIControlStateSelected];
        }
        return;
    }
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    [itemsArray addObject:KIndexModel.tabbarArray[0]];
    [itemsArray addObject:KIndexModel.tabbarArray[1]];
    [itemsArray addObject:KIndexModel.tabbarArray[2]];
    if (KConfigure.isHaveContract || KConfigure.isHaveOption) {
        [itemsArray addObject:KIndexModel.tabbarArray[3]];
    }
    [itemsArray addObject:KIndexModel.tabbarArray[4]];
    
    NSMutableArray *titlesArray = [NSMutableArray array];
    [titlesArray addObject:LocalizedString(@"Home")];
    [titlesArray addObject:LocalizedString(@"Markets")];
    [titlesArray addObject:LocalizedString(@"TradesTabbar")];
    if (KConfigure.isHaveContract || KConfigure.isHaveOption) {
        [titlesArray addObject:LocalizedString(@"Contract")];
    }
    [titlesArray addObject:LocalizedString(@"BalanceManagement")];
    
    
    // tabbarNew_0
    for (NSInteger i=0; i < self.buttonsArray.count; i ++) {
        XXIndexModel *model = itemsArray[i];
        MainTabBtn *mainBtn = self.buttonsArray[i];
        
        [mainBtn sd_setImageWithURL:[NSURL URLWithString:model.defaultIcon] forState:UIControlStateNormal placeholderImage:[UIImage textImageName:[NSString stringWithFormat:@"tabbarNew_%zd", i]]];
        [mainBtn sd_setImageWithURL:[NSURL URLWithString:model.selectedIcon] forState:UIControlStateSelected placeholderImage:[UIImage mainImageName:[NSString stringWithFormat:@"tabbarNew_%zd", i]]];
        if (IsEmpty(model.moduleName)) {
            [mainBtn setTitle:titlesArray[i] forState:UIControlStateNormal];
        } else {
            [mainBtn setTitle:model.moduleName forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 3. 分类按钮点击事件
- (void)clickMainBtn:(MainTabBtn *)sender {
    
    if (sender.tag == self.viewControllers.count - 1 && !KUser.isLogin) {
        KWeakSelf
        [XXPush toLoginViewController:self completeBlock:^{
            if (weakSelf.buttonsArray.count > 0) {
                [weakSelf clickMainBtn:[weakSelf.buttonsArray lastObject]];
            }
        }];
    
    } else {
        // 1. 改变选中状态
        self.senderBtn.selected = NO;
        
        sender.selected = YES;
        self.senderBtn = sender;
        
        // 2. 设置选中的索引的控制器
        self.selectedIndex = sender.tag;
    }
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
                                 @"title":LocalizedString(@"Home"),
                                 @"normalImage":[UIImage textImageName:@"tabbarNew_0"],
                                 @"selectedImage":[UIImage mainImageName:@"tabbarNew_0"]
                                 }];
        
        // 1. 行情
        [_namesArray addObject:@{
                                 @"title":LocalizedString(@"Markets"),
                                 @"normalImage":[UIImage textImageName:@"tabbarNew_1"],
                                 @"selectedImage":[UIImage mainImageName:@"tabbarNew_1"]
                                 }];
        
        // 2. 交易
        [_namesArray addObject:@{
                                 @"title":LocalizedString(@"TradesTabbar"),
                                 @"normalImage":[UIImage textImageName:@"tabbarNew_2"],
                                 @"selectedImage":[UIImage mainImageName:@"tabbarNew_2"]
                                 }];
        
        // 3. 合约
        if (KConfigure.isHaveOption || KConfigure.isHaveContract) {
            
            NSString *nameString = LocalizedString(@"Contract");
            if (KConfigure.isHaveOption && KConfigure.isHaveContract) { // 合约
                nameString = LocalizedString(@"Contract");
            } else if (KConfigure.isHaveOption) { // 期权
                nameString = LocalizedString(@"OptionQuote");
            } else if (KConfigure.isHaveContract) { // 合约
                nameString = LocalizedString(@"Contract");
            }
            [_namesArray addObject:@{
                                     @"title":nameString,
                                     @"normalImage":[UIImage textImageName:@"tabbarNew_3"],
                                     @"selectedImage":[UIImage mainImageName:@"tabbarNew_3"]
                                     }];
        }
        
        // 4. 资产
        [_namesArray addObject:@{
                                 @"title":LocalizedString(@"BalanceManagement"),
                                 @"normalImage":[UIImage textImageName:@"tabbarNew_4"],
                                 @"selectedImage":[UIImage mainImageName:@"tabbarNew_4"]
                                 }];
    }
    return _namesArray;
}

@end

