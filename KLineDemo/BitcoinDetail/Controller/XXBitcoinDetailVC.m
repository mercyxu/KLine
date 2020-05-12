//
//  XXBDetailVC.m
//  iOS
//
//  Created by iOS on 2018/6/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXBitcoinDetailVC.h"
#import "XXBDetailHeaderView.h"
#import "XXBDetailSectionHeaderView.h"
#import "XXTabBarController.h"
#import "XXDetailDepthListView.h"
#import "XXDetailTradesListView.h"
#import "XXKlineShareView.h"
#import "UIColor+Y_StockChart.h"
#import "XXCoinInfoView.h"

@interface XXBitcoinDetailVC () <UITableViewDataSource, UITableViewDelegate>

/** 收藏按钮 */
@property (strong, nonatomic) UIButton *saveButton;

/** 竖线 */
@property (strong, nonatomic, nullable) UIView *lineView;

/** 切换按钮 */
@property (strong, nonatomic, nullable) UIButton *switchButton;

/** 看涨看跌标签 */
@property (strong, nonatomic) XXLabel *markLabel;

/** 头视图 */
@property (strong, nonatomic) XXBDetailHeaderView *headView;

/** 区头视图 */
@property (strong, nonatomic) XXBDetailSectionHeaderView *sectionHeaderView;

/** 表示图 */
@property (strong, nonatomic) UITableView *tableView;

/** 底版视图 */
@property (strong, nonatomic) UIVisualEffectView *lowView;

/** 买入按钮 */
@property (strong, nonatomic) XXButton *buyButton;

/** 卖出按钮 */
@property (strong, nonatomic) XXButton *sellButton;

/** 分享底视图 */
@property (strong, nonatomic) XXKlineShareView *shareLowView;

/** 深度图 */
@property (strong, nonatomic) XXDetailDepthListView *depthView;

/** 交易图 */
@property (strong, nonatomic) XXDetailTradesListView *tradesView;

/** 简介视图 */
@property (strong, nonatomic) XXCoinInfoView *infoView;

@end

@implementation XXBitcoinDetailVC
static NSString *identifier = @"XXBDetailCell";
static NSString *identifierTwo = @"XXEntrustmentOrderCell";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [KSystem statusBarSetUpWhiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [KSystem statusBarSetUpDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(klineViewImageShare) name:UIApplicationUserDidTakeScreenshotNotification object:nil];

    KDetail.isReloadKlineUI = YES;

    // 2. 初始化UI
    [self setupUI];
    
    // 3. 刷新币对数据
    [self showAndReloadSymbolData];
}

#pragma mark - 1. 初始化UI
- (void)setupUI {

    self.view.backgroundColor = [UIColor backgroundColor];
    self.navView.height = kStatusBarHeight + 44;
    
    self.leftButton.top = kStatusBarHeight;
    self.leftButton.height = 44;
    self.leftButton.width = 37;
    self.leftButton.left = 8;
    
    self.titleLabel.top = kStatusBarHeight;
    self.titleLabel.height = 44;
    self.rightButton.top = kStatusBarHeight;
    self.rightButton.height = 44;
    self.navView.backgroundColor = [UIColor backgroundColor];
    self.titleLabel.textColor = [UIColor mainTextColor];
    [self.leftButton setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
    
    self.rightButton.left = kScreen_Width - 50;
    self.rightButton.width = 40;
    [self.rightButton setImage:[UIImage imageNamed:@"shareKline_icon"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"shareKline_icon"] forState:UIControlStateHighlighted];
    
    // 2. 收藏按钮
    if (KDetail.symbolModel.type == SymbolTypeCoin) {
        [self.navView addSubview:self.saveButton];
    }

    // 3. 标题赋值
    [self.navView addSubview:self.lineView];
    [self.navView addSubview:self.switchButton];

    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    if (!KDetail.symbolModel.isDelivered) {
        [self.view addSubview:self.lowView];
        [self.lowView.contentView addSubview:self.buyButton];
        [self.lowView.contentView addSubview:self.sellButton];
    }
}

#pragma mark - 2. 刷新币对数据
- (void)showAndReloadSymbolData {
    
    // 1. 币对名称
    NSString *symbolName = @"";
    if (!IsEmpty(KDetail.symbolModel.baseTokenName) && !IsEmpty(KDetail.symbolModel.quoteTokenName)) {
        if (KDetail.symbolModel.type == SymbolTypeCoin) {
            symbolName = [NSString stringWithFormat:@" %@ /%@", KDetail.symbolModel.baseTokenName, KDetail.symbolModel.quoteTokenName];
        }
        [self.switchButton setTitle:symbolName forState:UIControlStateNormal];
    }
    
    // 3. 简介视图
    if (KDetail.symbolModel.type != SymbolTypeOption) {
        [self.infoView loadDataOfCoin];
    }
    
    // 4. header-show 【24H行情、k线】
    [self.headView show];
    
    // 5. 深度
    [self.depthView show];
    
    // 6. 成交
    [self.tradesView show];
}

#pragma mark - 3. 消失
- (void)dismiss {
    
    // 1. header-show 【24H行情、k线】
    [self.headView dismiss];
    
    // 2. 深度
    [self.depthView dismiss];
    
    // 3. 成交
    [self.tradesView dismiss];
}

#pragma mark - 4. 清理数据
- (void)cleanData {

    // 1. header-show 【24H行情、k线】
    [self.headView cleanData];
    
    // 2. 深度
    [self.depthView cleanData];
    
    // 3. 成交
    [self.tradesView cleanData];
    
    // 4. 简介视图
    if (KDetail.symbolModel.type != SymbolTypeOption) {
        [self.infoView cleanData];
    }
}

#pragma mark - 5. 切换按钮点击事件
- (void)switchButtonClick:(UIButton *)sender {
    

}

#pragma mark - 5. 右侧分享按钮点击事件
- (void)rightButtonClick:(UIButton *)sender {
    [self klineViewImageShare];
}


#pragma mark - 6. 收藏按钮点击事件
- (void)saveButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [KMarket addFavoriteSymbolId:KDetail.symbolModel.symbolId];
    } else {
        [KMarket cancelFavoriteSymbolId:KDetail.symbolModel.symbolId];
    }
}

//- (void)saveButtonClick:(UIButton *)sender {
//    sender.enabled = NO;
//    sender.selected = !sender.selected;
//    if (KUser.isLogin) {
//        if (sender.selected) {
//            [HttpManager user_PostWithPath:@"user/favorite/create" params:@{@"exchange_id":KDetail.symbolModel.exchangeId, @"symbol_id":KDetail.symbolModel.symbolId} andBlock:^(id data, NSString *msg, NSInteger code) {
//                sender.enabled = YES;
//                if (code == 0) {
//                    [MBProgressHUD showSuccessMessage:LocalizedString(@"AddFavoritesSucceeded")];
//                    [KMarket addFavoriteSymbolId:KDetail.symbolModel.symbolId];
//                } else {
//                    sender.selected = !sender.selected;
//                    [MBProgressHUD showErrorMessage:msg];
//                }
//            }];
//        } else {
//            [HttpManager user_PostWithPath:@"user/favorite/cancel" params:@{@"exchange_id":KDetail.symbolModel.exchangeId, @"symbol_id":KDetail.symbolModel.symbolId} andBlock:^(id data, NSString *msg, NSInteger code) {
//                sender.enabled = YES;
//                if (code == 0) {
//                    [MBProgressHUD showSuccessMessage:LocalizedString(@"CancelFavoritesSucceeded")];
//                    [KMarket cancelFavoriteSymbolId:KDetail.symbolModel.symbolId];
//                } else {
//                    sender.selected = !sender.selected;
//                    [MBProgressHUD showErrorMessage:msg];
//                }
//            }];
//        }
//    } else {
//        sender.enabled = YES;
//        if (sender.selected) {
//            [KMarket addFavoriteSymbolId:KDetail.symbolModel.symbolId];
//        } else {
//            [KMarket cancelFavoriteSymbolId:KDetail.symbolModel.symbolId];
//        }
//    }
//}

#pragma mark - 7. 表示图代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.sectionHeaderView.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.sectionHeaderView.index == 0) {
        return self.depthView.height;
    } else if (self.sectionHeaderView.index == 1) {
       return self.tradesView.height;
    } else {
        return self.infoView.height;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionHeaderView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.sectionHeaderView.index == 0) {
        return self.depthView;
    } else if (self.sectionHeaderView.index == 1) {
        return self.tradesView;
    } else {
        return self.infoView;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailSymbol"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailSymbol"];
    }
    return cell;
}

#pragma mark - 8. 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
    if (offY > kNavShadowHeight) {
        self.navView.layer.shadowOpacity = 1;
    } else {
        self.navView.layer.shadowOpacity = offY/kNavShadowHeight;

    }
}

#pragma mark - 9. 截图分享
- (void)klineViewImageShare {

    if (self.headView.isScreen) {
        return;
    }
    
}

#pragma mark - 10. 后台进入前台
- (void)didBecomeActive {
    
    XXNavigationController *navigationVC = self.tabBarController.selectedViewController;
    if ([navigationVC isKindOfClass:[XXNavigationController class]] && navigationVC.viewControllers.lastObject == self) {
        [self showAndReloadSymbolData];
    }
}

#pragma mark - 11. 前台台进入后
- (void)didEnterBackground {
    
    XXNavigationController *navigationVC = self.tabBarController.selectedViewController;
    if ([navigationVC isKindOfClass:[XXNavigationController class]] && navigationVC.viewControllers.lastObject == self) {
        [self dismiss];
    }
}

#pragma mark - || 懒加载
- (UIButton *)saveButton {
    if (_saveButton == nil) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.rightButton.left - self.rightButton.width, self.rightButton.top, self.rightButton.width, self.rightButton.height)];
        _saveButton.selected = KDetail.symbolModel.favorite;
        [_saveButton setImage:[UIImage imageNamed:@"save_0"] forState:UIControlStateNormal];
        [_saveButton setImage:[UIImage imageNamed:@"save_select"] forState:UIControlStateSelected];
        [_saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

/** 竖线 */
- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(52, kStatusBarHeight + 13, 1, 18)];
        _lineView.backgroundColor = [UIColor mainTextColor];
    }
    return _lineView;
}

/** 切换按钮 */
- (UIButton *)switchButton {
    if (_switchButton == nil) {
        _switchButton = [[UIButton alloc] initWithFrame:CGRectMake(64, kStatusBarHeight, kScreen_Width - 90 - 64, 44)];
        _switchButton.titleLabel.font = kFontBold18;
        [_switchButton setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
        _switchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_switchButton setImage:[[UIImage imageNamed:@"left_more"] imageWithColor:[UIColor mainTextColor]]  forState:UIControlStateNormal];
        [_switchButton addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

/** 看涨看跌标签 */
- (XXLabel *)markLabel {
    if (_markLabel == nil) {
        _markLabel = [XXLabel labelWithFrame:CGRectMake(K375(64), 0 + (self.switchButton.height - 16)/2.0, K375(30), 16) text:@"" font:kFontBold10 textColor:kWhite100 alignment:NSTextAlignmentCenter];
        _markLabel.layer.borderWidth = 1.5;
        _markLabel.layer.cornerRadius = 3;
        _markLabel.layer.masksToBounds = YES;
    }
    return _markLabel;
}

- (XXBDetailHeaderView *)headView {
    if (_headView == nil) {
        _headView = [[XXBDetailHeaderView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, 200)];
    }
    return _headView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight + 44, kScreen_Width, kScreen_Height - (kStatusBarHeight + 44)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, BH_IS_IPHONE_X ? 83 : 65)];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }


    }
    return _tableView;
}

- (XXBDetailSectionHeaderView *)sectionHeaderView {
    if (_sectionHeaderView == nil) {
        _sectionHeaderView = [[XXBDetailSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 42)];
        [_sectionHeaderView setupUI];
        KWeakSelf
        // index: 0. 委托订单 1. 最新成交
        _sectionHeaderView.headActionBlock = ^(NSInteger index) {
            [weakSelf.tableView reloadData];
        };
    }
    return _sectionHeaderView;
}

- (XXKlineShareView *)shareLowView {
    if (_shareLowView == nil) {
        _shareLowView = [[XXKlineShareView alloc] initWithFrame:CGRectMake(0, self.view.height - 91, kScreen_Width, 91)];
        _shareLowView.backgroundColor = kBlue100;
    }
    return _shareLowView;
}

- (UIVisualEffectView *)lowView {
    if (_lowView == nil) {

        NSInteger mainViewHeight = BH_IS_IPHONE_X ? 83 : 65;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _lowView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _lowView.frame = CGRectMake(0, kScreen_Height - mainViewHeight, kScreen_Width, mainViewHeight);

        UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
        upLine.backgroundColor = [UIColor assistBackgroundColor];
        [_lowView.contentView addSubview:upLine];
    }
    return _lowView;
}
/** 买入按钮 */
- (XXButton *)buyButton {
    if (_buyButton == nil) {
        KWeakSelf
        NSString *btnTitle = LocalizedString(@"BUY");
        if (KDetail.symbolModel.type == SymbolTypeContract) {
            btnTitle = [NSString stringWithFormat:@"%@(%@)", btnTitle,  LocalizedString(@"OpenMore")];
        }

        _buyButton = [XXButton buttonWithFrame:CGRectMake(K375(10), 10, (kScreen_Width - K375(30))/2, 45) title:btnTitle font:kFontBold18 titleColor:kMainTextColor block:^(UIButton *button) {
            if (KDetail.symbolModel.type == SymbolTypeCoin) {
                KTrade.coinTradeModel = KDetail.symbolModel;
                KTrade.coinIsSell = NO;
                KTrade.indexTrade = 0;
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                XXTabBarController *tabBarVC = (XXTabBarController *)KWindow.rootViewController;
                [tabBarVC setIndex:2];
            }
            [KSystem statusBarSetUpDefault];
        }];
        _buyButton.backgroundColor = kGreen100;
        _buyButton.layer.cornerRadius = 3;
        _buyButton.layer.masksToBounds = YES;
    }
    return _buyButton;
}

/** 卖出按钮 */
- (XXButton *)sellButton {
    if (_sellButton == nil) {
        KWeakSelf
        NSString *btnTitle = LocalizedString(@"SELL");
        if (KDetail.symbolModel.type == SymbolTypeContract) { // 合约
            btnTitle = [NSString stringWithFormat:@"%@(%@)", btnTitle, LocalizedString(@"OpenNil")];
        }
        _sellButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.buyButton.frame) + K375(10), self.buyButton.top, self.buyButton.width, self.buyButton.height) title:btnTitle font:kFontBold18 titleColor:kMainTextColor block:^(UIButton *button) {
            if (KDetail.symbolModel.type == SymbolTypeCoin) {
                KTrade.coinTradeModel = KDetail.symbolModel;
                KTrade.coinIsSell = YES;
                KTrade.indexTrade = 0;
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                XXTabBarController *tabBarVC = (XXTabBarController *)KWindow.rootViewController;
                [tabBarVC setIndex:2];
            }
            [KSystem statusBarSetUpDefault];
        }];
        _sellButton.backgroundColor = kRed100;
        _sellButton.layer.cornerRadius = 3;
        _sellButton.layer.masksToBounds = YES;
    }
    return _sellButton;
}

/** 深度图 */
- (XXDetailDepthListView *)depthView {
    if (_depthView == nil) {
        _depthView = [[XXDetailDepthListView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 911)];
    }
    return _depthView;
}

/** 交易图 */
- (XXDetailTradesListView *)tradesView {
    if (_tradesView == nil) {
        _tradesView = [[XXDetailTradesListView alloc] initWithFrame:CGRectMake(kScreen_Width, 0, kScreen_Width, 680)];
    }
    return _tradesView;
}

/** 简介视图 */
- (XXCoinInfoView *)infoView {
    if (_infoView == nil) {
        _infoView = [[XXCoinInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 250)];
        KWeakSelf
        _infoView.reloadMainUI = ^{
            [weakSelf.tableView reloadData];
        };
    }
    return _infoView;
}

- (void)dealloc {
    NSLog(@"==+==币对详情释放了");
    [self dismiss];
}
@end
