//
//  XYHKLineView.m
//  iOS
//
//  Created by iOS on 2018/6/19.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XYHKLineView.h"
#import "Y_KLineMainView.h"
#import "Y_KLineMAView.h"
#import "Y_VolumeMAView.h"
#import "Y_AccessoryMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"

#import "Y_StockChartGlobalVariable.h"
#import "Y_KLineVolumeView.h"
#import "Y_StockChartRightYView.h"
#import "Y_KLineAccessoryView.h"
#import "XXTickerWindow.h"
#import <AudioToolbox/AudioToolbox.h>
#import "KLineTransverseLine.h"
#import "KLineHistoryView.h"
#import "KLineLastPriceView.h"
#import "KLineRightView.h"

#define kLineMainTop 0

@interface XYHKLineView () <UIScrollViewDelegate, Y_KLineMainViewDelegate, Y_KLineVolumeViewDelegate, Y_KLineAccessoryViewDelegate>

/** 长按或点击是否最后一根 */
@property (assign, nonatomic) BOOL isLastPoint;

/** 长按或点击的点 */
@property (assign, nonatomic) CGPoint point;

/** 是否是添加 */
@property (assign, nonatomic) BOOL isAddKLine;

/** 最新价标签 */
@property (strong, nonatomic) XXLabel *closeLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  主K线图
 */
@property (nonatomic, strong) Y_KLineMainView *kLineMainView;

/**
 *  成交量图
 */
@property (nonatomic, strong) Y_KLineVolumeView *kLineVolumeView;

/**
 *  副图
 */
@property (nonatomic, strong) Y_KLineAccessoryView *kLineAccessoryView;

/**
 *  右侧价格图
 */
@property (nonatomic, strong) Y_StockChartRightYView *priceView;

/**
 *  右侧成交量图
 */
@property (nonatomic, strong) Y_StockChartRightYView *volumeView;

/**
 *  右侧Accessory图
 */
@property (nonatomic, strong) Y_StockChartRightYView *accessoryView;

/**
 *  旧的scrollview准确位移
 */
@property (nonatomic, assign) double oldExactOffset;

/**
 *  kLine-MAView
 */
@property (nonatomic, strong) Y_KLineMAView *kLineMAView;

/**
 *  Volume-MAView
 */
@property (nonatomic, strong) Y_VolumeMAView *volumeMAView;

/**
 *  Accessory-MAView
 */
@property (nonatomic, strong) Y_AccessoryMAView *accessoryMAView;

/**
 *  长按后显示的View
 */
@property (nonatomic, strong) UIView *verticalView;
@property (nonatomic, strong) CAGradientLayer *gradient;

/** 横线 */
@property (strong, nonatomic) KLineTransverseLine *transverseLine;

/** <#注释#> */
@property (strong, nonatomic) XXTickerWindow *tickerWindow;

/** 浏览历史k线显示该虚线 */
@property (strong, nonatomic, nullable) KLineHistoryView *historyView;

/** 浏览历史k线显示最新价视图 */
@property (strong, nonatomic, nullable) KLineLastPriceView *lastPriceView;

/** 右侧最新价视图 */
@property (strong, nonatomic, nullable) KLineRightView *rightView;

@property (nonatomic, strong) MASConstraint *kLineMainViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *kLineVolumeViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *priceViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *volumeViewHeightConstraint;

@end

@implementation XYHKLineView

//initWithFrame设置视图比例
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
    
        [Y_StockChartGlobalVariable setkLineMainViewRadio:0.8];
        [Y_StockChartGlobalVariable setkLineVolumeViewRadio:0.2];
        self.mainViewRatio = [Y_StockChartGlobalVariable kLineMainViewRadio];
        self.volumeViewRatio = [Y_StockChartGlobalVariable kLineVolumeViewRadio];
        
        // 1. 接收到新币对通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveApplicationEnterForegroundNotification) name:ApplicationEnterForegroundNotificationName object:nil];      
    }
    return self;
}

- (void)receiveApplicationEnterForegroundNotification {
    if(self.verticalView)
    {
        self.verticalView.hidden = YES;
    }
    
    if(self.transverseLine)
    {
        self.transverseLine.hidden = YES;
    }
    if (self.tickerWindow) {
        self.tickerWindow.hidden = YES;
    }
}

- (UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 1.0f;
        //        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(event_pichMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(eventLongPressMethod:)];
        longPressGesture.minimumPressDuration = 0.5;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
        [_scrollView addGestureRecognizer:tapGesture];
        
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self layoutIfNeeded];
    }
    return _scrollView;
}

- (Y_KLineMAView *)kLineMAView
{
    if (!_kLineMAView) {
        _kLineMAView = [[Y_KLineMAView alloc] initSamall];
        [self addSubview:_kLineMAView];
        [_kLineMAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self).offset(kLineMainTop);
            make.height.equalTo(@10);
        }];
    }
    return _kLineMAView;
}

- (Y_VolumeMAView *)volumeMAView
{
    if (!_volumeMAView) {
        _volumeMAView = [Y_VolumeMAView view];
        [self addSubview:_volumeMAView];
        [_volumeMAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self.kLineVolumeView.mas_top);
            make.height.equalTo(@10);
        }];
    }
    return _volumeMAView;
}

- (Y_AccessoryMAView *)accessoryMAView
{
    if(!_accessoryMAView) {
        _accessoryMAView = [Y_AccessoryMAView new];
        [self addSubview:_accessoryMAView];
        [_accessoryMAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.top.equalTo(self.kLineAccessoryView.mas_top);
            make.height.equalTo(@10);
        }];
    }
    return _accessoryMAView;
}

- (Y_KLineMainView *)kLineMainView
{
    if (!_kLineMainView && self) {
        _kLineMainView = [Y_KLineMainView new];
        _kLineMainView.delegate = self;
        [self.scrollView addSubview:_kLineMainView];
        _kLineMainView.lineView = self.rightView;
        _kLineMainView.closeLabel = self.closeLabel;
        [_kLineMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).offset(kLineMainTop);
            make.left.equalTo(self.scrollView);
            self.kLineMainViewHeightConstraint = make.height.equalTo(self.scrollView).multipliedBy(self.mainViewRatio);
            make.width.equalTo(@0);
        }];
        
    }
    //加载rightYYView
    self.priceView.backgroundColor = [UIColor clearColor];
    self.volumeView.backgroundColor = [UIColor clearColor];
    self.accessoryView.backgroundColor = [UIColor clearColor];
    self.priceView.userInteractionEnabled = NO;
    self.volumeView.userInteractionEnabled = NO;
    self.accessoryView.userInteractionEnabled = NO;
    return _kLineMainView;
}

- (Y_KLineVolumeView *)kLineVolumeView
{
    if(!_kLineVolumeView && self)
    {
        _kLineVolumeView = [Y_KLineVolumeView new];
        _kLineVolumeView.delegate = self;
        [self.scrollView addSubview:_kLineVolumeView];
        [_kLineVolumeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kLineMainView);
            make.top.equalTo(self.kLineMainView.mas_bottom);
            make.width.equalTo(self.kLineMainView.mas_width);
            self.kLineVolumeViewHeightConstraint = make.height.equalTo(self.scrollView.mas_height).multipliedBy(self.volumeViewRatio);
        }];
        [self layoutIfNeeded];
    }
    return _kLineVolumeView;
}

- (Y_KLineAccessoryView *)kLineAccessoryView
{
    if(!_kLineAccessoryView && self)
    {
        _kLineAccessoryView = [Y_KLineAccessoryView new];
        _kLineAccessoryView.delegate = self;
        [self.scrollView addSubview:_kLineAccessoryView];
        [_kLineAccessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kLineVolumeView);
            make.top.equalTo(self.kLineVolumeView.mas_bottom);
            make.width.equalTo(self.kLineVolumeView.mas_width);
            make.height.equalTo(self.scrollView.mas_height).multipliedBy(0.19);
        }];
        [self layoutIfNeeded];
    }
    return _kLineAccessoryView;
}

- (Y_StockChartRightYView *)priceView
{
    if(!_priceView)
    {
        _priceView = [Y_StockChartRightYView new];
        [self insertSubview:_priceView aboveSubview:self.scrollView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.right.equalTo(self.mas_right);
            make.width.equalTo(@(Y_StockChartKLinePriceViewWidth));
            make.bottom.equalTo(self.kLineMainView.mas_bottom).offset(0);
        }];
    }
    return _priceView;
}

- (Y_StockChartRightYView *)volumeView
{
    if(!_volumeView)
    {
        _volumeView = [Y_StockChartRightYView new];
        _volumeView.middleValueLabel.hidden = YES;
        _volumeView.minValueLabel.hidden = YES;
        [self insertSubview:_volumeView aboveSubview:self.scrollView];
        [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kLineVolumeView.mas_top).offset(10);
            make.right.width.equalTo(self.priceView);
            make.bottom.equalTo(self.kLineVolumeView);
        }];
    }
    return _volumeView;
}

- (Y_StockChartRightYView *)accessoryView
{
    if(!_accessoryView)
    {
        _accessoryView = [Y_StockChartRightYView new];
        [self insertSubview:_accessoryView aboveSubview:self.scrollView];
        [_accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kLineAccessoryView.mas_top);
            make.right.width.equalTo(self.volumeView);
            make.height.equalTo(self.kLineAccessoryView.mas_height);
        }];
    }
    return _accessoryView;
}
#pragma mark - set方法
#pragma mark kLineModels设置方法
- (void)setKLineModels:(NSArray *)kLineModels
{
    if(!kLineModels) {
        return;
    }
    _kLineModels = kLineModels;
    [self private_drawKLineMainView];
    
    //设置contentOffset
    double lineGap = [Y_StockChartGlobalVariable kLineGap];
    double lineWidth = [Y_StockChartGlobalVariable kLineWidth];
    NSInteger count = self.scrollView.frame.size.width / (lineWidth + lineGap);
    double addWidth = (lineWidth + lineGap) * (count/4);
    double yuWidth = self.scrollView.frame.size.width - count*(lineWidth + lineGap);
    
    //根据stockModels的个数和间隔和K线的宽度计算出self的宽度，并设置contentsize
    double kLineViewWidth = self.kLineModels.count * lineWidth + (self.kLineModels.count + 1) * lineGap + addWidth + yuWidth;
    double offset = kLineViewWidth - count*(lineWidth + lineGap) - yuWidth;
    if (offset > 0)
    {
        self.scrollView.contentOffset = CGPointMake(offset, 0);
    } else {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }

    Y_KLineModel *model = [kLineModels lastObject];
    [self.kLineMAView maProfileWithModel:model];
    self.kLineMAView.MainViewType = self.MainViewType;
    [self.volumeMAView maProfileWithModel:model];
    self.accessoryMAView.targetLineStatus = self.targetLineStatus;
    [self.accessoryMAView maProfileWithModel:model];
}

- (void)setTargetLineStatus:(Y_StockChartTargetLineStatus)targetLineStatus
{
    _targetLineStatus = targetLineStatus;
    if(targetLineStatus < 103)
    {
        if(targetLineStatus == Y_StockChartTargetLineStatusAccessoryClose){
            
            [Y_StockChartGlobalVariable setkLineMainViewRadio:0.8];
            [Y_StockChartGlobalVariable setkLineVolumeViewRadio:0.2];
            
        } else {
            [Y_StockChartGlobalVariable setkLineMainViewRadio:0.6];
            [Y_StockChartGlobalVariable setkLineVolumeViewRadio:0.2];
            
        }
    
        [self.kLineMainViewHeightConstraint uninstall];
        [_kLineMainView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.kLineMainViewHeightConstraint = make.height.equalTo(self.scrollView).multipliedBy([Y_StockChartGlobalVariable kLineMainViewRadio]);
        }];
        [self.kLineVolumeViewHeightConstraint uninstall];
        [self.kLineVolumeView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.kLineVolumeViewHeightConstraint = make.height.equalTo(self.scrollView.mas_height).multipliedBy([Y_StockChartGlobalVariable kLineVolumeViewRadio]);
        }];
        
        [self reDraw];
    }
}

#pragma mark - 添加和更新方法
- (void)addkLineData:(NSArray *)data {
    
    self.isAddKLine = YES;
    _kLineModels = data;
    if (KDetail.isReloadKlineUI) {
        
        BOOL isHiden = self.closeLabel.isHidden;
        [self private_drawKLineMainView];
        
        double lineGap = [Y_StockChartGlobalVariable kLineGap];
        double lineWidth = [Y_StockChartGlobalVariable kLineWidth];
        NSInteger count = self.scrollView.frame.size.width / (lineWidth + lineGap);
        double addWidth = (lineWidth + lineGap) * (count/4);
        double yuWidth = self.scrollView.frame.size.width - count*(lineWidth + lineGap);
        double movie = (_kLineModels.count - self.kLineMainView.needDrawStartIndex)*(lineGap + lineWidth) - self.scrollView.frame.size.width;
        if (isHiden == NO) {
            double offetX = self.scrollView.contentSize.width  - self.scrollView.width;
            [self.scrollView setContentOffset:CGPointMake(offetX, 0)];
        } else if (movie > 0) {
            double offetX = self.scrollView.contentSize.width  - self.scrollView.width - addWidth - yuWidth;
            [self.scrollView setContentOffset:CGPointMake(offetX, 0)];
        }
        
    } else {
        self.kLineMainView.kLineModels = self.kLineModels;
    }
    
    Y_KLineModel *model = [_kLineModels lastObject];
    [self.kLineMAView maProfileWithModel:model];
    [self.volumeMAView maProfileWithModel:model];
    self.accessoryMAView.targetLineStatus = self.targetLineStatus;
    [self.accessoryMAView maProfileWithModel:model];
    
    if (self.isLastPoint && self.tickerWindow.hidden == NO) {
        if (self.scrollView.contentOffset.x == 0) {
            self.point = CGPointMake(self.point.y + ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]), self.point.y);
        }
        [self updateLocationAndData];
    }
    
    if (self.historyView.hidden == NO) {
        [self updateHistoryView];
    }
}
- (void)updateLineData:(NSArray *)data {
    
    _kLineModels = data;
    if (KDetail.isReloadKlineUI) {
        [self private_drawKLineMainView];
    } else {
        self.kLineMainView.kLineModels = self.kLineModels;
    }
    
    Y_KLineModel *model = [_kLineModels lastObject];
    [self.kLineMAView maProfileWithModel:model];
    [self.volumeMAView maProfileWithModel:model];
    self.accessoryMAView.targetLineStatus = self.targetLineStatus;
    [self.accessoryMAView maProfileWithModel:model];
    
    if (self.isLastPoint && self.tickerWindow.hidden == NO) {
        [self updateLocationAndData];
    }
    
    if (self.historyView.hidden == NO) {
        [self updateHistoryView];
    }
}

- (void)reloadLineLocation {
    
    if (self.tickerWindow.hidden == NO) {
        [self updateLocationAndData];
    }
    
    if (self.historyView.hidden == NO) {
        [self updateHistoryView];
    }
}

#pragma mark - event事件处理方法
#pragma mark 缩放执行方法
- (void)event_pichMethod:(UIPinchGestureRecognizer *)pinch
{
    static double oldScale = 1.0f;
    double difValue = pinch.scale - oldScale;
    if(ABS(difValue) > Y_StockChartScaleBound) {
        
        // 1. 找出缩放前左侧kline的条数
        NSUInteger leftArrCount = (self.scrollView.contentOffset.x + [Y_StockChartGlobalVariable kLineGap]) / ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]);
      
        // 2. 设置缩放后kline的宽度
        double oldKLineWidth = [Y_StockChartGlobalVariable kLineWidth];
        [Y_StockChartGlobalVariable setkLineWith:oldKLineWidth * (difValue > 0 ? (1 + Y_StockChartScaleFactor) : (1 - Y_StockChartScaleFactor))];
        oldScale = pinch.scale;
        
        // 3. 设置滚动视图相对应的位置【不用担心位置超出，绘制时候会进行判断】
        [self.scrollView setContentOffset:CGPointMake(leftArrCount*([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]), 0)];
        
        // 4. 更新MainView的宽度
        [self.kLineMainView updateMainViewWidth];
        
        // 5. 绘制
        [self.kLineMainView drawMainView];
    }
}

#pragma mark - 1.1 点击手势执行方法
- (void)tapGestureMethod:(UITapGestureRecognizer *)longPress
{
    CGPoint location = [longPress locationInView:self];
    self.point = location;
    
    if (self.point.y > self.kLineMainView.maxY && self.tickerWindow.hidden == NO) {
        [self dismissTickerWindow];
    } else {
        [self updateLocationAndData];
        
        self.verticalView.hidden = NO;
        self.transverseLine.hidden = NO;
        self.tickerWindow.hidden = NO;
        [self.verticalView layoutIfNeeded];
    }
}

#pragma mark - 1.2 长按手势执行方法
- (void)eventLongPressMethod:(UITapGestureRecognizer *)longPress
{
    static double oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {
        CGPoint location = [longPress locationInView:self];
        if(ABS(oldPositionX - location.x) < ([Y_StockChartGlobalVariable kLineWidth] + [Y_StockChartGlobalVariable kLineGap])/2)
        {
            return;
        }
        
        if (@available(iOS 11.0, *))
        {
            UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [feedBackGenertor impactOccurred];
        }
        
        self.point = location;
    
        //暂停滑动
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
       
        // 更新位置和数据
        [self updateLocationAndData];
        
        self.verticalView.hidden = NO;
        self.transverseLine.hidden = NO;
        self.tickerWindow.hidden = NO;
        [self.verticalView layoutIfNeeded];
        
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        //恢复scrollView的滑动
        self.scrollView.scrollEnabled = YES;
    }
}

#pragma mark - 1.3 更新数据位置
- (void)updateLocationAndData {
    
    CGPoint point = [self.kLineMainView getExactXPositionWithOriginXPosition:self.point.x];
    
    // 更新竖线位置
    [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(point.x - [Y_StockChartGlobalVariable kLineWidth]/2.0));
        make.width.equalTo(@([Y_StockChartGlobalVariable kLineWidth]));
    }];
    self.gradient.frame = self.verticalView.bounds;
    
    // 更新横线位置
    CGFloat lineCenterY;
    if (self.point.y > self.kLineMainView.maxY || self.point.y < self.kLineMainView.minY) {
        lineCenterY = point.y;
    } else {
        lineCenterY  = self.point.y;
    }
    
    self.transverseLine.width = self.width;
    if (self.transverseLine.top == 0) {
        self.transverseLine.centerY = lineCenterY;
    } else {
        [UIView animateWithDuration:0.05f animations:^{
            self.transverseLine.centerY = lineCenterY;
        }];
    }
    
    double price = self.kLineMainView.maxAssert - (lineCenterY - self.kLineMainView.minY) * self.kLineMainView.unitValue;
    NSString *priceString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", price] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]];;
    if (point.x < self.frame.size.width/2.0) {
        self.tickerWindow.left = self.frame.size.width - self.tickerWindow.width - Kscal(20);
        [self.transverseLine setPointPrice:priceString centerX:point.x isRight:NO];
    } else {
        self.tickerWindow.left = Kscal(20);
        [self.transverseLine setPointPrice:priceString centerX:point.x isRight:YES];
    }
}

- (void)updateHistoryView {
    Y_KLineModel *model = [_kLineModels lastObject];
    if (IsEmpty(model)) {
        return;
    }
    
    CGFloat centerY = self.kLineMainView.minY + (self.kLineMainView.maxAssert - model.Close.doubleValue) / self.kLineMainView.unitValue;
    if (centerY < self.kLineMainView.minY) {
        centerY = self.kLineMainView.minY;
    }
    
    if (centerY > self.kLineMainView.maxY) {
        centerY = self.kLineMainView.maxY;
    }
    
    self.lastPriceView.closePrice = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", model.Close.doubleValue] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]];
    self.historyView.width = self.scrollView.width;
    self.lastPriceView.left = self.scrollView.width * 270.0f / 375.0f;
    [UIView animateWithDuration:0.1f animations:^{
        self.historyView.centerY = centerY;
        self.lastPriceView.centerY = centerY;
    }];
}

- (void)dismissTickerWindow {
    
    if (self.verticalView.isHidden == NO) {
        //取消竖线
        if(self.verticalView)
        {
            self.verticalView.hidden = YES;
        }
        
        if(self.transverseLine)
        {
            self.transverseLine.hidden = YES;
        }
        
        self.tickerWindow.hidden = YES;
        
        Y_KLineModel *lastModel = self.kLineModels.lastObject;
        [self.kLineMAView maProfileWithModel:lastModel];
        [self.volumeMAView maProfileWithModel:lastModel];
        [self.accessoryMAView maProfileWithModel:lastModel];
    }
}

#pragma mark 重绘
- (void)reDraw
{
    self.kLineMainView.MainViewType = self.MainViewType;
    if(self.targetLineStatus >= 103)
    {
        self.kLineMainView.targetLineStatus = self.targetLineStatus;
    }
    [self.kLineMainView drawMainView];
}


#pragma mark - 私有方法
#pragma mark 画KLineMainView
- (void)private_drawKLineMainView
{
    self.kLineMainView.kLineModels = self.kLineModels;
    [self.kLineMainView drawMainView];
}
- (void)private_drawKLineVolumeView
{
    NSAssert(self.kLineVolumeView, @"kLineVolume不存在");
    //更新约束
    [self.kLineVolumeView layoutIfNeeded];
    [self.kLineVolumeView draw];
}
- (void)private_drawKLineAccessoryView
{
    //更新约束
    self.accessoryMAView.targetLineStatus = self.targetLineStatus;
    [self.accessoryMAView maProfileWithModel:_kLineModels.lastObject];
    [self.kLineAccessoryView layoutIfNeeded];
    [self.kLineAccessoryView draw];
}
#pragma mark VolumeView代理
- (void)kLineVolumeViewCurrentMaxVolume:(double)maxVolume minVolume:(double)minVolume
{
    if (maxVolume > 0) {
       self.volumeView.maxValueLabel.text = [NSString handValuemeLengthWithAmountStr:[NSString stringWithFormat:@"%.12f",maxVolume]];
    } else {
        self.volumeView.maxValueLabel.text = @"0.00";
    }
//    self.volumeView.maxValue = maxVolume;
//    self.volumeView.minValue = minVolume;
//    self.volumeView.middleValue = (maxVolume - minVolume)/2 + minVolume;
}
- (void)kLineMainViewCurrentMaxPrice:(double)maxPrice minPrice:(double)minPrice
{
    self.priceView.maxValue = maxPrice;
    self.priceView.minValue = minPrice;
    self.priceView.middleValue = (maxPrice - minPrice)/2 + minPrice;
}
- (void)kLineAccessoryViewCurrentMaxValue:(double)maxValue minValue:(double)minValue
{
    self.accessoryView.maxValue = maxValue;
    self.accessoryView.minValue = minValue;
    self.accessoryView.middleValue = (maxValue - minValue)/2 + minValue;
}

#pragma mark MainView更新时通知下方的view进行相应内容更新 Y_KLineMainViewDelegate
- (void)kLineMainViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels
{
    self.kLineVolumeView.needDrawKLineModels = needDrawKLineModels;
    self.kLineAccessoryView.needDrawKLineModels = needDrawKLineModels;
    if ([self.delegate respondsToSelector:@selector(currentNeedDrawKLineModels:)]) {
        [self.delegate currentNeedDrawKLineModels:needDrawKLineModels];
    }
}
- (void)kLineMainViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels
{
    self.kLineVolumeView.needDrawKLinePositionModels = needDrawKLinePositionModels;
    self.kLineAccessoryView.needDrawKLinePositionModels = needDrawKLinePositionModels;
}
- (void)kLineMainViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors
{
    self.kLineVolumeView.kLineColors = kLineColors;
    if(self.targetLineStatus >= 103)
    {
        self.kLineVolumeView.targetLineStatus = self.targetLineStatus;
    }
    [self private_drawKLineVolumeView];
    self.kLineAccessoryView.kLineColors = kLineColors;
    if(self.targetLineStatus < 103)
    {
        self.kLineAccessoryView.targetLineStatus = self.targetLineStatus;
    }
    [self private_drawKLineAccessoryView];
}
- (void)kLineMainViewLongPressKLinePositionModel:(Y_KLinePositionModel *)kLinePositionModel kLineModel:(Y_KLineModel *)kLineModel
{
    //更新ma信息
    self.tickerWindow.model = kLineModel;
    
    if (self.kLineModels.lastObject == kLineModel) {
        self.isLastPoint = YES;
    } else {
        self.isLastPoint = NO;
    }
    
    [self.kLineMAView maProfileWithModel:kLineModel];
    [self.volumeMAView maProfileWithModel:kLineModel];
    [self.accessoryMAView maProfileWithModel:kLineModel];
}
#pragma mark - UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isAddKLine) {
        [self dismissTickerWindow];
    } else {
        self.isAddKLine = NO;
    }

    double lineGap = [Y_StockChartGlobalVariable kLineGap];
    double lineWidth = [Y_StockChartGlobalVariable kLineWidth];
    NSInteger count = self.scrollView.frame.size.width / (lineWidth + lineGap);
    double addWidth = (lineWidth + lineGap) * (count/4);
    double yuWidth = self.scrollView.frame.size.width - count*(lineWidth + lineGap);
    if (scrollView.contentSize.width - scrollView.contentOffset.x - scrollView.width > (addWidth + yuWidth)) {
        KDetail.isReloadKlineUI = NO;
    } else {
        KDetail.isReloadKlineUI = YES;
    }
    
    if (self.scrollView.contentSize.width - self.scrollView.contentOffset.x > self.scrollView.width*1.25f) {
        self.historyView.hidden = NO;
        self.lastPriceView.hidden = NO;
        [self updateHistoryView];
    } else {
        self.historyView.hidden = YES;
        self.lastPriceView.hidden = YES;
    }
    
//    if (self.scrollView.contentOffset.x < self.scrollView.contentSize.width - self.scrollView.width*1.25f) {
//        self.historyView.hidden = NO;
//        self.lastPriceView.hidden = NO;
//        [self updateHistoryView];
//    } else {
//        self.historyView.hidden = YES;
//        self.lastPriceView.hidden = YES;
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    double movie = ABS((self.kLineMainView.needDrawStartIndex * ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]) - scrollView.contentOffset.x));
    if (movie != 0) {
        
        [scrollView setContentOffset:CGPointMake(self.kLineMainView.needDrawStartIndex * ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]), 0)];
        [self.kLineMainView setNeedsDisplay];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    double movie = ABS((self.kLineMainView.needDrawStartIndex * ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]) - scrollView.contentOffset.x));
    if (movie != 0) {
        
        [scrollView setContentOffset:CGPointMake(self.kLineMainView.needDrawStartIndex * ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]), 0)];
        [self.kLineMainView setNeedsDisplay];
    }
}

- (void)dealloc
{
    [_kLineMainView removeAllObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (XXTickerWindow *)tickerWindow {
    if (_tickerWindow == nil) {
        _tickerWindow = [[XXTickerWindow alloc] initWithFrame:CGRectMake(8, 20, 110, 160)];
        // 在主线程异步加载，使下面的方法最后执行，防止其他的控件挡住了导航栏
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addSubview:self->_tickerWindow];
        });
    }
    return _tickerWindow;
}

- (UIView *)verticalView {
    if (_verticalView == nil) {
        _verticalView = [UIView new];
        _verticalView.clipsToBounds = YES;
        _verticalView.userInteractionEnabled = NO;
        [self addSubview:_verticalView];
        [_verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.width.equalTo(@([Y_StockChartGlobalVariable kLineWidth]));
            make.height.equalTo(self.scrollView.mas_height);
            make.left.equalTo(@(-10));
        }];
        
        [_verticalView layoutIfNeeded];
        
        _gradient = [CAGradientLayer layer];
        _gradient.frame = _verticalView.bounds;
        
        _gradient.colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithRed:98/255.0 green:124/255.0 blue:158/255.0 alpha:0.0].CGColor,
                                (id)[UIColor colorWithRed:98/255.0 green:124/255.0 blue:158/255.0 alpha:0.5].CGColor,
                                (id)[UIColor colorWithRed:98/255.0 green:124/255.0 blue:158/255.0 alpha:0.1].CGColor, nil];
        [_verticalView.layer addSublayer:_gradient];
    }
    return _verticalView;
}

- (KLineTransverseLine *)transverseLine {
    if (_transverseLine == nil) {
        _transverseLine = [[KLineTransverseLine alloc] initWithFrame:CGRectMake(0, 0, self.width, 22)];
        _transverseLine.userInteractionEnabled = NO;
        _transverseLine.hidden = YES;
        [self addSubview:_transverseLine];
    }
    return _transverseLine;
}

/** 浏览历史k线显示该图 */
- (KLineHistoryView *)historyView {
    if (_historyView == nil) {
        _historyView = [[KLineHistoryView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
        _historyView.hidden = YES;
        [self addSubview:_historyView];
    }
    return _historyView;
}

/** 浏览历史k线显示最新价视图 */
- (KLineLastPriceView *)lastPriceView {
    if (_lastPriceView == nil) {
        _lastPriceView = [[KLineLastPriceView alloc] initWithFrame:CGRectMake(K375(270), 0, 20, 22)];
        _lastPriceView.hidden = YES;
        [self addSubview:_lastPriceView];
        KWeakSelf
        [_lastPriceView whenTapped:^{
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.contentSize.width - weakSelf.scrollView.width, 0) animated:YES];
        }];
    }
    return _lastPriceView;
}

/** 右侧最新价视图 */
- (KLineRightView *)rightView {
    if (_rightView == nil) {
        _rightView = [[KLineRightView alloc] initWithFrame:CGRectMake(0, 100, kScreen_Width, 1)];
        [self addSubview:_rightView];
    }
    return _rightView;
}

- (XXLabel *)closeLabel {
    if (_closeLabel == nil) {
        _closeLabel = [XXLabel labelWithFrame:CGRectMake(kScreen_Width - 87, 0, 80, 16) font:kFont10 textColor:kBlue100];
        _closeLabel.layer.cornerRadius = 2;
        _closeLabel.layer.masksToBounds = YES;
        [self addSubview:_closeLabel];
        
        self.gradient.colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithRed:98/255.0 green:124/255.0 blue:158/255.0 alpha:0.0].CGColor,
                                (id)[UIColor colorWithRed:98/255.0 green:124/255.0 blue:158/255.0 alpha:0.5].CGColor,
                                (id)[UIColor colorWithRed:98/255.0 green:124/255.0 blue:158/255.0 alpha:0.1].CGColor, nil];
        [self.verticalView.layer addSublayer:self.gradient];
    }
    return _closeLabel;
}
@end
