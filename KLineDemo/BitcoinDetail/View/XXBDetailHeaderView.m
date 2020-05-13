//
//  XXBDetailHeaderView.m
//  iOS
//
//  Created by iOS on 2018/6/13.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXBDetailHeaderView.h"
#import "XXTickerView.h"
#import "XXKlineDepthActionView.h"
#import "XXKineView.h"
#import "XXDepthMapView.h"
#import "AppDelegate.h"
#import "XXKlineActionView.h"
#import "XXFullView.h"
#import "UIColor+Y_StockChart.h"

#define Left_width 10

@interface XXBDetailHeaderView () <XXKlineDepthActionViewDelegate>

/** 行情视图 */
@property (strong, nonatomic) XXTickerView *tickerView;

/** 期权行情视图 */

/** 事件版式图 */
@property (strong, nonatomic) XXKlineDepthActionView *actionView;

/** 滚动式图 */
@property (strong, nonatomic) UIScrollView *scrollView;

/** K线图 */
@property (strong, nonatomic) XXKineView *klineView;

/** 深度图 */
@property (strong, nonatomic, nullable) XXDepthMapView *depthMapView;

/** k线图按钮视图 */
@property (strong, nonatomic) XXKlineActionView *kActionView;

/** <#注释#> */
@property (strong, nonatomic) XXButton *actionButton;

/** <#注释#> */
@property (strong, nonatomic) XXFullView *fullView;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

@end

@implementation XXBDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    /** 行情视图 */
    if (KDetail.symbolModel.type == SymbolTypeCoin || KDetail.symbolModel.type == SymbolTypeContract) {
        [self addSubview:self.tickerView];
    }
    
    /** 事件版式图 */
    [self addSubview:self.actionView];
    
    /** 滚动式图 */
    [self addSubview:self.scrollView];
    
    /** K线图 */
    [self.scrollView addSubview:self.klineView];
    
    /** 深度图 */
    [self.scrollView addSubview:self.depthMapView];

    [self addSubview:self.lineView];
    [self addSubview:self.kActionView];
    self.actionView.kMainbuttonsArray =  self.kActionView.kMainButtonsArray;
    self.kActionView.hidden = YES;
    self.height = CGRectGetMaxY(self.lineView.frame);
}

#pragma mark - 2. 出现
- (void)show {
    
    // 1. 顶部行情
    if (KDetail.symbolModel.type == 2) {
        
    } else {
        [self.tickerView show];
    }
    
    // 2. k线
    [self.klineView show];
    
    // 3. 深度图
    [self.depthMapView show];
}

#pragma mark - 3. 消失
- (void)dismiss {
    
   // 1. 顶部行情
    if (KDetail.symbolModel.type == 2) {
        
    } else {
        [self.tickerView dismiss];
    }
    
    // 2. k线
    [self.klineView dismiss];
    
    // 3. 深度图
    [self.depthMapView dismiss];
}

#pragma mark - 4. 清理数据
- (void)cleanData {
    
    // 1. 顶部行情
    if (KDetail.symbolModel.type == 2) {
        
    } else {
        [self.tickerView cleanData];
    }
    
    // 2. k线
    [self.klineView cleanData];
    
    // 3. 深度图
    [self.depthMapView cleanData];
}

#pragma mark - 5. <XXKlineDepthActionViewDelegate>
// iindex: 1. 更多  2. 全屏
- (void)klineDepthActionViewDidselctIndex:(NSInteger)index {
    
    if (index == 1) { // 分时展现选择视图
        if (self.kActionView.isShow) {
            [self.kActionView dismiss];
        } else {
            [self.kActionView show];
        }
    } else if (index == 2) { // 全屏
        
        if (self.kActionView.isShow) {
            [self.kActionView dismiss];
        }
        
        if (self.scrollView.contentOffset.x != 0) {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
        
        self.isScreen = YES;
        CGRect rect = [self.klineView convertRect:self.klineView.bounds toView:KWindow];
        self.fullView.klineFrame = rect;
        if (!self.fullView.leftLabel) {
            if (KDetail.symbolModel.type == SymbolTypeCoin || KDetail.symbolModel.type == SymbolTypeContract) {
                self.fullView.leftLabel = self.tickerView.leftLabel;
                self.fullView.rightLabel = self.tickerView.rightLabel;
            }
            self.fullView.klineView = self.klineView;
            self.fullView.kButtonsArray = self.kActionView.kButtonsArray;
            self.fullView.mainButtonsArray = self.kActionView.mainButtonsArray;
            self.fullView.fButtonsArray = self.kActionView.fButtonsArray;
            self.fullView.minuteButton = self.kActionView.minuteButton;
        }
        [self.fullView show];
    } else if (index == 3) { // 深度图
        
        [self.scrollView setContentOffset:CGPointMake(kScreen_Width, 0) animated:NO];
    }
}

#pragma mark - 6. 退出全屏事件
- (void)outFullScreenAction {
    
    
    self.isScreen = NO;

    // k线重置
    self.klineView.frame = CGRectMake(0, 0, kScreen_Width, self.scrollView.height);
    [self.scrollView addSubview:self.klineView];
    
    self.actionView.kMainbuttonsArray = self.kActionView.kMainButtonsArray;
    
    // KAction视图重新布局
    [self.kActionView reloadUI];
}

#pragma mark - || 懒加载
/** 行情视图 */
- (XXTickerView *)tickerView {
    if (_tickerView == nil) {
        _tickerView = [[XXTickerView alloc] initWithFrame:CGRectMake(0, 0, self.width, 75)];
    }
    return _tickerView;
}

/** 期权行情视图 */

/** 事件版式图 */
- (XXKlineDepthActionView *)actionView {
    if (_actionView == nil) {
        CGFloat actionY = 0;
        if (KDetail.symbolModel.type == SymbolTypeCoin || KDetail.symbolModel.type == SymbolTypeContract) {
            actionY = CGRectGetMaxY(self.tickerView.frame);
        }
        _actionView = [[XXKlineDepthActionView alloc] initWithFrame:CGRectMake(0, actionY, kScreen_Width, 36)];
        _actionView.delegate = self;
    }
    return _actionView;
}

/** 滚动式图 */
- (UIScrollView *)scrollView {
    if (_scrollView == nil) { // Kscal(1000)
       
        NSInteger mainViewHeight = BH_IS_IPHONE_X ? 83 : 65;
        double navHeight = kStatusBarHeight + 44;
        CGFloat height = kScreen_Height - navHeight - CGRectGetMaxY(self.actionView.frame) - 55 - mainViewHeight;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.actionView.frame), kScreen_Width, height)];
        _scrollView.contentSize = CGSizeMake(kScreen_Width*2, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

/** K线图 */
- (XXKineView *)klineView {
    if (_klineView == nil) {
        _klineView = [[XXKineView alloc] initWithFrame: CGRectMake(0, 0, kScreen_Width, self.scrollView.height)];
    }
    return _klineView;
}

/** 深度图 */
- (XXDepthMapView *)depthMapView {
    if (_depthMapView == nil) {
        _depthMapView = [[XXDepthMapView alloc] initWithFrame: CGRectMake(kScreen_Width, 0, kScreen_Width, self.scrollView.height)];
    }
    return _depthMapView;
}

- (XXKlineActionView *)kActionView {
    if (_kActionView == nil) {
        _kActionView = [[XXKlineActionView alloc] initWithFrame:CGRectMake(0, self.scrollView.top, kScreen_Width, K375(55))];
        KWeakSelf
        _kActionView.kActionBlock = ^(NSInteger index) {
            weakSelf.actionView.indexBtn = index;
            [weakSelf.klineView kButtonClickIndex:index];
            if (index < 14 && weakSelf.scrollView.contentOffset.x != 0) {
                [weakSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            }
        };
    }
    return _kActionView;
}

- (XXFullView *)fullView {
    if (_fullView == nil) {
        _fullView = [[XXFullView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Height, kScreen_Width)];
        KWeakSelf
        _fullView.outFullViewBlock = ^{
            [weakSelf outFullScreenAction];
        };
    }
    return _fullView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), kScreen_Width, 8)];
        _lineView.backgroundColor = [UIColor assistBackgroundColor];
    }
    return _lineView;
}


- (void)dealloc {


}
@end
