//
//  Y_KLineView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineView.h"
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
#import "UIView+tap.h"
#import "BTKLineTipBoardView.h"


@interface Y_KLineView() <UIScrollViewDelegate, Y_KLineMainViewDelegate, Y_KLineVolumeViewDelegate, Y_KLineAccessoryViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

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
@property (nonatomic, assign) CGFloat oldExactOffset;

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
 *  长按后显示的竖线、横线、时间、位置、数据
 */
@property (nonatomic, strong) UIView *verticalView;
@property (nonatomic, strong) UIView *horizonView;
@property (nonatomic, strong) UIView *lightPoint;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) Y_KLinePositionModel *currentPositionModel;
@property (nonatomic, strong) Y_KLineModel *currentKLineModel;
@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, assign) BOOL isSetCloseMA;

@property (nonatomic, strong) CAGradientLayer *gradient;

@property (nonatomic, strong) BTKLineTipBoardView *tipBoard;

@property (nonatomic, strong) MASConstraint *kLineMainViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *kLineVolumeViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *priceViewHeightConstraint;

@property (nonatomic, strong) MASConstraint *volumeViewHeightConstraint;

@end

@implementation Y_KLineView

//initWithFrame设置视图比例
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.mainViewRatio = [Y_StockChartGlobalVariable kLineMainViewRadio];
        self.volumeViewRatio = 0.28;
    }
    return self;
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
        _scrollView.backgroundColor = [UIColor clearColor];
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(event_pichMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod:)];
        [self addGestureRecognizer:tapGesture];
        
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressMethod:)];
        longPressGesture.minimumPressDuration = 0.5;
        [_scrollView addGestureRecognizer:longPressGesture];
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.left.equalTo(self.mas_left).offset(5);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self layoutIfNeeded];
    }
    return _scrollView;
}

- (Y_KLineMAView *)kLineMAView
{
    if (!_kLineMAView) {
        _kLineMAView = [Y_KLineMAView view];
        [self addSubview:_kLineMAView];
        [_kLineMAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(2);
            make.left.equalTo(self).offset(2);
            make.top.equalTo(self).offset(5);
            make.height.equalTo(@15);
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
            make.top.equalTo(self.kLineAccessoryView.mas_top).offset(10);
            make.height.equalTo(@10);
        }];
    }
    return _accessoryMAView;
}

- (Y_KLineMainView *)kLineMainView
{
    if (!_kLineMainView && self) {
        _kLineMainView = [Y_KLineMainView new];
        _kLineMainView.isFullScreen = self.isFullScreen;
        _kLineMainView.mainViewRatio = 0.65;
        _kLineMainView.delegate = self;
        _kLineMainView.lineKTime = self.lineKTime;
        _kLineMainView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_kLineMainView];
        [_kLineMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).offset(5);
            make.left.equalTo(self.scrollView);
            self.kLineMainViewHeightConstraint = make.height.equalTo(self.scrollView).multipliedBy(self.mainViewRatio);
            make.width.equalTo(@0);
        }];
    }
    //加载rightYYView
    self.priceView.backgroundColor = [UIColor clearColor];
    self.volumeView.backgroundColor = [UIColor clearColor];
    self.accessoryView.backgroundColor = [UIColor clearColor];
    return _kLineMainView;
}

- (Y_KLineVolumeView *)kLineVolumeView
{
    if(!_kLineVolumeView && self)
    {
        _kLineVolumeView = [Y_KLineVolumeView new];
        _kLineVolumeView.backgroundColor = [UIColor clearColor];
        _kLineVolumeView.delegate = self;
        [self.scrollView addSubview:_kLineVolumeView];
        [_kLineVolumeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kLineMainView);
            make.top.equalTo(self.kLineMainView.mas_bottom).offset(5);
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
            make.top.equalTo(self.kLineVolumeView.mas_bottom).offset(5);
            make.width.equalTo(self.kLineVolumeView.mas_width);
            make.height.equalTo(self.scrollView.mas_height).multipliedBy(0.2);
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
        _priceView.precision = 4;
        [self insertSubview:_priceView belowSubview:self.scrollView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.right.equalTo(self.mas_right);
            make.width.equalTo(@(Y_StockChartKLinePriceViewWidth));
            make.bottom.equalTo(self.kLineMainView.mas_bottom).offset(-15);
        }];
    }
    return _priceView;
}

- (Y_StockChartRightYView *)volumeView
{
    if(!_volumeView)
    {
        _volumeView = [Y_StockChartRightYView new];
        _volumeView.precision = 4;
        [self insertSubview:_volumeView aboveSubview:self.scrollView];
        [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kLineVolumeView.mas_top).offset(10);
            make.right.width.equalTo(self.priceView);
//            make.height.equalTo(self).multipliedBy(self.volumeViewRatio);
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
        _accessoryView.precision = 2;
        [self insertSubview:_accessoryView aboveSubview:self.scrollView];
        [_accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kLineAccessoryView.mas_top).offset(10);
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
    self.kLineMainView.lineKTime = self.lineKTime;
    [self private_drawKLineMainView];
    //设置contentOffset
    CGFloat kLineViewWidth = self.kLineModels.count * [Y_StockChartGlobalVariable kLineWidth] + (self.kLineModels.count + 1) * [Y_StockChartGlobalVariable kLineGap] + 10;
    _priceView.precision = self.kLineModels.firstObject.price;
    _volumeView.precision = self.kLineModels.firstObject.coin;
    CGFloat offset = kLineViewWidth - self.scrollView.frame.size.width;
    if (offset > 0)
    {
        self.scrollView.contentOffset = CGPointMake(offset, 0);
    } else {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    Y_KLineModel *model = [kLineModels lastObject];
    [self.kLineMAView maProfileWithModel:model];
    [self.volumeMAView maProfileWithModel:model];
    self.accessoryMAView.targetLineStatus = self.targetLineStatus;
    [self.accessoryMAView maProfileWithModel:model];
    if (self.scrollView.contentSize.width - 47 >= KScreenWidth) {
        [self.scrollView setContentOffset:CGPointMake(offset + 47, 0) animated:NO];
    }
}
- (void)setTargetLineStatus:(Y_StockChartTargetLineStatus)targetLineStatus
{
    _targetLineStatus = targetLineStatus;
    if(targetLineStatus <= 110)
    {
        if(targetLineStatus == Y_StockChartTargetLineStatusAccessoryClose){
            self.kLineAccessoryView.hidden = YES;
            self.accessoryView.hidden = YES;
            self.accessoryMAView.hidden = YES;
            [Y_StockChartGlobalVariable setkLineMainViewRadio:0.65];
            [Y_StockChartGlobalVariable setkLineVolumeViewRadio:0.28];

        } else {
            self.kLineAccessoryView.hidden = NO;
            self.accessoryView.hidden = NO;
            self.accessoryMAView.hidden = NO;
            [Y_StockChartGlobalVariable setkLineMainViewRadio:0.5];
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
#pragma mark - event事件处理方法

#pragma mark 缩放执行方法
- (void)event_pichMethod:(UIPinchGestureRecognizer *)pinch
{
    //取消竖线
    if(self.verticalView)
    {
        self.verticalView.hidden = YES;
        self.gradient.frame = self.verticalView.bounds;
    }
    //取消横线
    if(self.horizonView)
    {
        self.horizonView.hidden = YES;
    }
    if (self.dateLabel) {
        self.dateLabel.hidden = YES;
    }
    if (self.priceLabel) {
        self.priceLabel.hidden = YES;
    }
    
    if (self.tipBoard) {
        [self.tipBoard hide];
    }
    
    if(self.lightPoint){
        self.lightPoint.hidden = YES;
    }
    
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    if(ABS(difValue) > Y_StockChartScaleBound) {
        CGFloat oldKLineWidth = [Y_StockChartGlobalVariable kLineWidth];

        NSInteger oldNeedDrawStartIndex = self.kLineMainView.needDrawStartIndex;
        //NSLog(@"原来的index-----：%ld",self.kLineMainView.needDrawStartIndex);
        [Y_StockChartGlobalVariable setkLineWith:oldKLineWidth * (difValue > 0 ? (1 + Y_StockChartScaleFactor) : (1 - Y_StockChartScaleFactor))];
        oldScale = pinch.scale;
        //更新MainView的宽度
        [self.kLineMainView updateMainViewWidth];
        
        if( pinch.numberOfTouches == 2 ) {
            CGPoint p1 = [pinch locationOfTouch:0 inView:self.scrollView];
            CGPoint p2 = [pinch locationOfTouch:1 inView:self.scrollView];
            CGPoint centerPoint = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
            NSUInteger oldLeftArrCount = ABS((centerPoint.x - self.scrollView.contentOffset.x) - [Y_StockChartGlobalVariable kLineGap]) / ([Y_StockChartGlobalVariable kLineGap] + oldKLineWidth);
            NSUInteger newLeftArrCount = ABS((centerPoint.x - self.scrollView.contentOffset.x) - [Y_StockChartGlobalVariable kLineGap]) / ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]);
            
            self.kLineMainView.pinchStartIndex = oldNeedDrawStartIndex + oldLeftArrCount - newLeftArrCount;
            //            self.kLineMainView.pinchPoint = centerPoint;
            //NSLog(@"计算得出的index----：%lu",self.kLineMainView.pinchStartIndex);
        }
        [self.kLineMainView drawMainView];
    }
}
#pragma mark 长按手势执行方法
- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress {
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state){
        CGPoint location = [longPress locationInView:self.scrollView];
        if(ABS(oldPositionX - location.x) < ([Y_StockChartGlobalVariable kLineWidth] + [Y_StockChartGlobalVariable kLineGap])/2){
            return;
        }
        //暂停滑动
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        
        //初始化竖线
        if(!self.verticalView){
            self.verticalView = [UIView new];
            self.verticalView.clipsToBounds = YES;
            [self.scrollView addSubview:self.verticalView];
//            self.verticalView.backgroundColor = RGB(241, 241, 241);
            [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(15);
                make.width.equalTo(@([Y_StockChartGlobalVariable kLineWidth]));
                make.height.equalTo(self.scrollView.mas_height);
                make.left.equalTo(@(-10));
            }];
            
            [self.verticalView layoutIfNeeded];
            
            self.gradient = [CAGradientLayer layer];
            self.gradient.frame = self.verticalView.bounds;
            
            self.gradient.colors = [NSArray arrayWithObjects:
                               (id)[UIColor colorWithRed:98/255.0 green:124/255.0 blue:158/255.0 alpha:0.0].CGColor,
                               (id)[UIColor colorWithRed:98/255.0 green:124/255.0 blue:158/255.0 alpha:0.5].CGColor,
                               (id)[UIColor colorWithRed:98/255.0 green:124/255.0 blue:158/255.0 alpha:0.1].CGColor, nil];
            [self.verticalView.layer addSublayer:self.gradient];
        }
        
        //更新竖线位置
        CGFloat rightXPosition = [self.kLineMainView getExactXPositionWithOriginXPosition:location.x];
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([Y_StockChartGlobalVariable kLineWidth]));
            make.left.equalTo(@(rightXPosition-[Y_StockChartGlobalVariable kLineWidth]/2.0));
            
        }];
        [self.verticalView layoutIfNeeded];
        self.verticalView.hidden = NO;
        self.gradient.frame = self.verticalView.bounds;
        
        //初始化横线
        if(!self.horizonView){
            self.horizonView = [UIView new];
            self.horizonView.clipsToBounds = YES;
            [self.scrollView addSubview:self.horizonView];
            self.horizonView.backgroundColor = RGB(193, 197, 222);
            [self.horizonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.height.equalTo(@(Y_StockChartLongPressVerticalViewWidth));
                make.width.equalTo(self.isFullScreen?@(self.scrollView.width-50):self.scrollView.mas_width);
                make.top.equalTo(@(-100));
            }];
        }
        //更新横线位置
        CGFloat rightYPosition = [self.kLineMainView getExactXPositionWithOriginYPosition:location.x];
        if (rightYPosition <= 15) {
            rightYPosition = 15;
        }
        [self.horizonView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(rightYPosition + 5));
        }];
        [self.horizonView layoutIfNeeded];
        self.horizonView.hidden = NO;
        
        
        //初始化光点
        if(!self.lightPoint){
            self.lightPoint = [UIView new];
            self.lightPoint.clipsToBounds = YES;
            self.lightPoint.layer.cornerRadius = 2;
            [self.scrollView addSubview:self.lightPoint];
            self.lightPoint.backgroundColor = [UIColor whiteColor];
            [self.lightPoint mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@4);
                make.centerX.equalTo(self.verticalView);
                make.centerY.equalTo(self.horizonView);
            }];
        }
        [self.lightPoint layoutIfNeeded];
        self.lightPoint.hidden = NO;
        
        //初始化时间
        if(!self.dateLabel){
            self.dateLabel = [UILabel new];
            [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
            [self.dateLabel setTextColor:[UIColor whiteColor]];
            self.dateLabel.layer.borderColor = RGB(98, 124, 158).CGColor;
            self.dateLabel.layer.borderWidth = 1;
            [self.dateLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:9.0]];
            [self.dateLabel setBackgroundColor:RGB(10, 23, 33)];
            [self.scrollView addSubview:self.dateLabel];
            double top = self.scrollView.frame.size.height - 20.0;
            [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(top);
                make.width.equalTo(@(60));
                make.height.equalTo(@(20));
                make.left.equalTo(@(-10));
            }];
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:(self.currentKLineModel.Date.doubleValue) / 1000];
        if (self.currentKLineModel == nil) {
            Y_KLineModel *lastModel = self.kLineModels.lastObject;
            date = [NSDate dateWithTimeIntervalSince1970:lastModel.Date.doubleValue];
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        if (self.lineKTime == 0 || self.lineKTime == 6) {
            formatter.dateFormat = @"HH:mm";
        }
        else if (self.lineKTime == 3 ||self.lineKTime == 7 || self.lineKTime == 8 ){
            formatter.dateFormat = @"YYYY MM-dd";
        }
        else{
            formatter.dateFormat = @"MM-dd HH:mm";
        }
        NSString *dateStr = [formatter stringFromDate:date];
        [self.dateLabel setText:[@" " stringByAppendingString: dateStr]];
        //更新时间位置
        CGFloat datePositionX = rightXPosition - 30;
        if ( (rightXPosition - 30) <= self.scrollView.contentOffset.x) {
            datePositionX = self.scrollView.contentOffset.x;
        }
        else if ((rightXPosition + 30) >= (self.scrollView.contentOffset.x + KScreenWidth) ) {
            if (self.isFullScreen){
                datePositionX = rightXPosition - 30;
            }else{
                datePositionX = self.scrollView.contentOffset.x + KScreenWidth - 70;
            }
        }
        else {
            datePositionX = rightXPosition - 30;
        }
        [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(datePositionX));
        }];
        [self.dateLabel layoutIfNeeded];
        self.dateLabel.hidden = NO;
        
        //初始化价格
        if(!self.priceLabel){
            self.priceLabel = [UILabel new];
            [self.priceLabel setTextAlignment:NSTextAlignmentCenter];
            [self.priceLabel setTextColor:[UIColor whiteColor]];
            self.priceLabel.layer.borderColor = RGB(193, 197, 222).CGColor;
            self.priceLabel.layer.borderWidth = 1;
            [self.priceLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:9.0]];
            [self.priceLabel setBackgroundColor:RGBA(10, 23, 33, 0.9)];
            [self.scrollView addSubview:self.priceLabel];
            [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(-100));
                make.left.equalTo(@(-10));
                make.width.equalTo(@(55));
                make.height.equalTo(@(20));
               
            }];
        }
        [self.priceLabel setText:[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:self.currentKLineModel.Close.doubleValue afterPoint:self.currentKLineModel.price]];
        if (self.currentKLineModel == nil) {
            Y_KLineModel *lastModel = self.kLineModels.lastObject;
            [self.priceLabel setText:[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:lastModel.Close.doubleValue afterPoint:lastModel.price]];
        }
        //更新价格位置
        CGFloat pricePositionX;
        //手指在屏幕上的x坐标
        CGPoint windowLocation = [longPress locationInView:kAppWindow];
        if (self.isFullScreen){ //横屏
            if (windowLocation.y > KScreenHeight/2.0) {
                pricePositionX = self.scrollView.contentOffset.x + KScreenHeight - 60-50-SafeAreaBottomHeight; //减去指标宽度 右侧价格宽度
            }else {
                pricePositionX = self.scrollView.contentOffset.x + SafeAreaTopHeight; //减去指标宽度 右侧价格宽度; //减去指标宽度
            }
        }else{
            if (windowLocation.x > KScreenWidth/2.0) {
                pricePositionX = self.scrollView.contentOffset.x + KScreenWidth - 60;
            }else {
                pricePositionX = self.scrollView.contentOffset.x;
            }
        }

        [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(rightYPosition-5));
            make.left.equalTo(@(pricePositionX));
        }];
        [self.priceLabel layoutIfNeeded];
        self.priceLabel.hidden = NO;
        
        //提示版
        self.tipBoard.open = tipViewDecimalNumberWithDouble(self.currentKLineModel.Open.doubleValue);
        self.tipBoard.close = tipViewDecimalNumberWithDouble(self.currentKLineModel.Close.doubleValue);
        self.tipBoard.high = tipViewDecimalNumberWithDouble(self.currentKLineModel.High.doubleValue);
        self.tipBoard.low = tipViewDecimalNumberWithDouble(self.currentKLineModel.Low.doubleValue);
        self.tipBoard.time = dateStr;
        self.tipBoard.vol = tipViewDecimalNumberWithDouble(self.currentKLineModel.Volume);
        
        if (self.isFullScreen){
            [self.tipBoard showWithTipPoint:CGPointMake(windowLocation.y, 20) isFullScreen:YES];
        }else{
            [self.tipBoard showWithTipPoint:CGPointMake(windowLocation.x, 20) isFullScreen:NO];
        }
    }
//    if (!self.isShow) {
//        self.isShow = YES;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            //取消竖线
//            if(self.verticalView)
//            {
//                self.verticalView.hidden = YES;
//            }
//            //取消横线
//            if(self.horizonView)
//            {
//                self.horizonView.hidden = YES;
//            }
//            if (self.dateLabel) {
//                self.dateLabel.hidden = YES;
//            }
//            if (self.priceLabel) {
//                self.priceLabel.hidden = YES;
//            }
//            Y_KLineModel *lastModel = self.kLineModels.lastObject;
//            [self.kLineMAView maProfileWithModel:lastModel];
//            [self.volumeMAView maProfileWithModel:lastModel];
//            [self.accessoryMAView maProfileWithModel:lastModel];
//            self.isShow = NO;
//        });
//    }
//    else{
//        //取消竖线
//        if(self.verticalView)
//        {
//            self.verticalView.hidden = NO;
//        }
//        //取消横线
//        if(self.horizonView)
//        {
//            self.horizonView.hidden = NO;
//        }
//        if (self.dateLabel) {
//            self.dateLabel.hidden = NO;
//        }
//        if (self.priceLabel) {
//            self.priceLabel.hidden = NO;
//        }
//    }
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
//        //取消竖线
//        if(self.verticalView)
//        {
//            self.verticalView.hidden = YES;
//        }
//        //取消横线
//        if(self.horizonView)
//        {
//            self.horizonView.hidden = YES;
//        }
//        if (self.dateLabel) {
//            self.dateLabel.hidden = YES;
//        }
//        if (self.priceLabel) {
//            self.priceLabel.hidden = YES;
//        }
//        oldPositionX = 0;
        //恢复scrollView的滑动
        self.scrollView.scrollEnabled = YES;
        
//        Y_KLineModel *lastModel = self.kLineModels.lastObject;
//        [self.kLineMAView maProfileWithModel:lastModel];
//        [self.volumeMAView maProfileWithModel:lastModel];
//        [self.accessoryMAView maProfileWithModel:lastModel];
    }
}

NSString *tipViewDecimalNumberWithDouble(double conversionValue){
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

- (BTKLineTipBoardView *)tipBoard {
    if (!_tipBoard) {
        _tipBoard = [[BTKLineTipBoardView alloc] initWithFrame:CGRectMake(10, 20, 130.0f, 140)];
        _tipBoard.backgroundColor = RGB(20, 29, 42);
        [self addSubview:_tipBoard];
    }
    return _tipBoard;
}

- (void)tapMethod:(UIGestureRecognizer *)tap
{
    //取消竖线
    if(self.verticalView)
    {
        self.verticalView.hidden = YES;
        self.gradient.frame = self.verticalView.bounds;
    }
    //取消横线
    if(self.horizonView)
    {
        self.horizonView.hidden = YES;
    }
    if (self.dateLabel) {
        self.dateLabel.hidden = YES;
    }
    if (self.priceLabel) {
        self.priceLabel.hidden = YES;
    }
    
    if (self.tipBoard) {
        [self.tipBoard hide];
    }
    
    if(self.lightPoint){
        self.lightPoint.hidden = YES;
    }
}

#pragma mark 重绘
- (void)reDraw
{
    if (!self.isSetCloseMA) {
        self.isSetCloseMA = YES;
        self.targetLineStatus = Y_StockChartTargetLineStatusMA;
        [Y_StockChartGlobalVariable setisEMALine:Y_StockChartTargetLineStatusMA];
    }
    self.kLineMainView.MainViewType = self.MainViewType;
    self.kLineMainView.lineKTime = self.lineKTime;
    if(self.targetLineStatus >= 101)
    {
        self.kLineMainView.targetLineStatus = self.targetLineStatus;
    }
    if (self.targetLineStatus == Y_StockChartTargetLineStatusAccessoryClose) {
        self.volumeViewRatio = 0.28;
        self.kLineMainView.mainViewRatio = 0.65;
    }
    else{
        self.volumeViewRatio = 0.2;
        self.kLineMainView.mainViewRatio = 0.5;
    }
    
    [self.kLineVolumeView setNeedsLayout];
    [self.kLineAccessoryView setNeedsLayout];
    [self.kLineMainView drawMainView];
}

- (void)drawMainView
{
    [self.kLineMainView drawMainView];
}

#pragma mark - 私有方法
#pragma mark 画KLineMainView
- (void)private_drawKLineMainView
{
    self.kLineMainView.kLineModels = self.kLineModels;
    self.kLineMainView.lineKTime = self.lineKTime;
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
- (void)kLineVolumeViewCurrentMaxVolume:(CGFloat)maxVolume minVolume:(CGFloat)minVolume
{
    self.volumeView.maxValue = maxVolume;
    self.volumeView.minValue = minVolume;
    self.volumeView.middleValue = (maxVolume - minVolume)/2 + minVolume;
}
- (void)kLineMainViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice
{
    self.priceView.maxValue = maxPrice;
    self.priceView.minValue = minPrice;
    self.priceView.middleValue = (maxPrice - minPrice)/2 + minPrice;
}
- (void)kLineAccessoryViewCurrentMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue
{
    self.accessoryView.maxValue = maxValue;
    self.accessoryView.minValue = minValue;
    self.accessoryView.middleValue = (maxValue - minValue)/2 + minValue;
}
#pragma mark MainView更新时通知下方的view进行相应内容更新
- (void)kLineMainViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels
{
    self.kLineVolumeView.needDrawKLineModels = needDrawKLineModels;
    self.kLineAccessoryView.needDrawKLineModels = needDrawKLineModels;
}
- (void)kLineMainViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels
{
    self.kLineVolumeView.needDrawKLinePositionModels = needDrawKLinePositionModels;
    self.kLineAccessoryView.needDrawKLinePositionModels = needDrawKLinePositionModels;
}
- (void)kLineMainViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors
{
    self.kLineVolumeView.kLineColors = kLineColors;
     self.kLineAccessoryView.kLineColors = kLineColors;
    if(self.targetLineStatus >= 103)
    {
        self.kLineVolumeView.targetLineStatus = self.targetLineStatus;
    }
    [self private_drawKLineVolumeView];
    if(self.targetLineStatus < 110)
    {
        self.kLineAccessoryView.targetLineStatus = self.targetLineStatus;
    }
    [self private_drawKLineAccessoryView];
}
- (void)kLineMainViewLongPressKLinePositionModel:(Y_KLinePositionModel *)kLinePositionModel kLineModel:(Y_KLineModel *)kLineModel {
    //更新ma信息
    self.currentPositionModel = kLinePositionModel;
    self.currentKLineModel = kLineModel;
    [self.kLineMAView maProfileWithModel:kLineModel];
    [self.volumeMAView maProfileWithModel:kLineModel];
    [self.accessoryMAView maProfileWithModel:kLineModel];
}
#pragma mark - UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    if (self.scrollView.contentOffset.x > (self.scrollView.contentSize.width -47 - SCREEN_WIDTH)) {
//         [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + 47, 0) animated:YES];
//    }
//    else if (self.scrollView.contentOffset.x < (self.scrollView.contentSize.width -45)) {
//        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - 45, 0) animated:YES];
//    }
    
    //取消竖线
    if(self.verticalView)
    {
        self.verticalView.hidden = YES;
    }
    //取消横线
    if(self.horizonView)
    {
        self.horizonView.hidden = YES;
    }
    if (self.dateLabel) {
        self.dateLabel.hidden = YES;
    }
    if (self.priceLabel) {
        self.priceLabel.hidden = YES;
    }
    
    if (self.tipBoard) {
        [self.tipBoard hide];
    }
    
    if(self.lightPoint){
        self.lightPoint.hidden = YES;
    }
    
    Y_KLineModel *lastModel = self.kLineModels.lastObject;
    [self.kLineMAView maProfileWithModel:lastModel];
    [self.volumeMAView maProfileWithModel:lastModel];
    [self.accessoryMAView maProfileWithModel:lastModel];
    
//    static BOOL isNeedPostNotification = YES;
//    if(scrollView.contentOffset.x < scrollView.frame.size.width * 2)
//    {
//        if(isNeedPostNotification)
//        {
//            self.oldExactOffset = scrollView.contentSize.width - scrollView.contentOffset.x;
//            isNeedPostNotification = NO;
//        }
//    } else {
//        isNeedPostNotification = YES;
//    }
    
    //NSLog(@"这是  %f-----%f=====%f",scrollView.contentSize.width,scrollView.contentOffset.x,self.kLineMainView.frame.size.width);
}

- (void)dealloc
{
    [_kLineMainView removeAllObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
