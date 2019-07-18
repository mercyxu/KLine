//
//  Y-StockChartView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartView.h"
#import "Y_KLineView.h"
#import "Masonry.h"
#import "Y_StockChartSegmentView.h"
#import "Y_StockChartGlobalVariable.h"


static NSInteger const Y_StockChartSegmentIndicatorIndex = 3000;

@interface Y_StockChartView() <Y_StockChartSegmentViewDelegate>



/**
 *  底部主选择View
 */
@property (nonatomic, strong) Y_StockChartSegmentView *segmentView;

@property (nonatomic, strong) UIView *scorllLine;

@property (nonatomic, strong) UIView *moreSegmentView;
@property (nonatomic, strong) UIButton *moreSelectedBtn;
@property (nonatomic, strong) UIView *indicatorSegmentView;
@property (nonatomic, strong) UIButton *indicatorSelectedBtn;
@property (nonatomic, strong) UIButton *indicatorSegmentSelectedBtnOne;
@property (nonatomic, strong) UIButton *indicatorSegmentSelectedBtnTwo;
//kline时间类型0~9  time  1 15 1h 4h 5 30 60 1d 1w 1m
@property (nonatomic, assign) NSInteger klineTime;
//当前是否显示
@property (nonatomic, assign) BOOL isShowMoreSegmentView;
@property (nonatomic, assign) BOOL isShowindicatorSegmentView;


/**
 *  图表类型
 */
@property(nonatomic,assign) Y_StockChartCenterViewType currentCenterViewType;

/**
 *  当前索引
 */
@property(nonatomic,assign,readwrite) NSInteger currentIndex;
@end


@implementation Y_StockChartView

- (Y_KLineView *)kLineView
{
    if(!_kLineView)
    {
        _kLineView = [Y_KLineView new];
        [_kLineView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_kLineView];
        self.targetLineStatus = Y_StockChartTargetLineStatusMACD;
        _kLineView.isFullScreen = self.isFullScreen;
        if (_isFullScreen) {
            [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.left.equalTo(self);
                make.bottom.equalTo(@-32);
            }];
        }else{
            [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.left.equalTo(self);
                make.top.equalTo(self.segmentView.mas_bottom);
            }];
        }
        
    }
    return _kLineView;
}

- (Y_StockChartSegmentView *)segmentView
{
    if(!_segmentView)
    {
        _segmentView = [Y_StockChartSegmentView new];
        _segmentView.isFullScreen = self.isFullScreen;
        _segmentView.delegate = self;
        [self addSubview:_segmentView];
        if (_isFullScreen) {
            [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.bottom.equalTo(self);
                make.top.equalTo(self.kLineView.mas_bottom);
                make.height.mas_equalTo(32);
            }];
        }
        else{
            [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.top.equalTo(self);
                make.height.mas_equalTo(32);
            }];
        }
        [_segmentView layoutIfNeeded];
        UIView *scorllLine = [[UIView alloc] init];
        scorllLine.backgroundColor = RGB(23, 100, 178);
        [_segmentView addSubview:scorllLine];
        scorllLine.frame = CGRectMake(0, self.isFullScreen?_segmentView.height-2:_segmentView.height-2-10, 20, 2);
        self.scorllLine = scorllLine;
    }
    return _segmentView;
}

- (UIView *)moreSegmentView
{
    if(!_moreSegmentView)
    {
        _moreSegmentView = [UIView new];
        _moreSegmentView.backgroundColor = RGB(21, 32, 54);
        _moreSegmentView.layer.borderWidth = 1;
        _moreSegmentView.layer.borderColor = RGB(24, 50, 102).CGColor;
        [_moreSegmentView isYY];
        
        NSArray *titleArr = @[BTLanguage(@"1分"),BTLanguage(@"5分"),BTLanguage(@"30分"),BTLanguage(@"周线"),BTLanguage(@"1月")];
        kWeakSelf(self);
        __block UIButton *preBtn;
        [titleArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:RGB(98, 124, 158) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.titleLabel.font = BOLDSYSTEMFONT(12);
            btn.tag = Y_StockChartSegmentIndicatorIndex + 100 + idx;
            [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            [weakself.moreSegmentView addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(weakself.moreSegmentView).multipliedBy(1.0f/6);
                make.height.equalTo(weakself.moreSegmentView);
                make.top.equalTo(weakself.moreSegmentView);
                if(preBtn)
                {
                    make.left.equalTo(preBtn.mas_right);
                } else {
                    make.left.equalTo(weakself.moreSegmentView);
                }
            }];
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor clearColor];
            [weakself.moreSegmentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(btn);
                make.top.equalTo(btn.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            preBtn = btn;
        }];
        [self addSubview:_moreSegmentView];
        _moreSegmentView.hidden = YES;
        self.isShowMoreSegmentView = NO;
        if (_isFullScreen) {
            [_moreSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.bottom.equalTo(self).offset(-32);
                make.height.equalTo(@42);
            }];
        }
        else{
            [_moreSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.top.equalTo(self).offset(32-5);
                make.height.equalTo(@42);
            }];
        }
       
    }
    return _moreSegmentView;
}

- (UIView *)indicatorSegmentView
{
    if(!_indicatorSegmentView)
    {
        _indicatorSegmentView = [UIView new];
        _indicatorSegmentView.layer.borderWidth = 1;
        _indicatorSegmentView.layer.borderColor = RGB(24, 50, 102).CGColor;
        _indicatorSegmentView.backgroundColor = RGB(21, 32, 54);
        [_indicatorSegmentView isYY];
        NSArray *titleArr = @[BTLanguage(@"主图"),@"MA",@"EMA",@"BOLL",BTLanguage(@""),BTLanguage(@"副图"),@"MACD",@"KDJ",@"RSI",@"WR",BTLanguage(@"")];
        __block UIButton *preBtn;
        kWeakSelf(self);
        [titleArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitleColor:RGB(98, 124, 158) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.titleLabel.font = BOLDSYSTEMFONT(12);
            if (idx == 0 || idx == 5) {
                btn.tag = Y_StockChartSegmentIndicatorIndex;
            }else{
                btn.tag = Y_StockChartSegmentIndicatorIndex + idx;
            }
            [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:title forState:UIControlStateNormal];
            if (idx == 4 || idx == 10) {
                [btn setImage:IMAGE_NAMED(@"line_see") forState:UIControlStateNormal];
                [btn setImage:IMAGE_NAMED(@"line_seeNot") forState:UIControlStateSelected];
            }else{
                [btn setTitle:title forState:UIControlStateNormal];
            }
            [weakself.indicatorSegmentView addSubview:btn];
            if (idx < 5){
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(weakself.indicatorSegmentView).multipliedBy(1.0f/6);
                    make.height.equalTo(@36);
                    make.top.equalTo(weakself.indicatorSegmentView);
                    if (idx == 4) {
                        make.right.equalTo(weakself.indicatorSegmentView);
                    }
                    else{
                        if(preBtn)
                        {
                            make.left.equalTo(preBtn.mas_right);
                        } else {
                            make.left.equalTo(weakself.indicatorSegmentView);
                        }
                    }
                    
                }];
            }
            else{
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(weakself.indicatorSegmentView).multipliedBy(1.0f/6);
                    make.height.equalTo(@36);
                    make.top.equalTo(weakself.indicatorSegmentView).offset(36);
                    if (idx == 10) {
                        make.right.equalTo(weakself.indicatorSegmentView);
                    }
                    else{
                        if(preBtn && (idx != 5))
                        {
                            make.left.equalTo(preBtn.mas_right);
                        } else {
                            make.left.equalTo(weakself.indicatorSegmentView);
                        }
                    }
                    
                }];
            }
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor clearColor];
            [weakself.indicatorSegmentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(btn);
                make.top.equalTo(btn.mas_bottom);
                make.height.equalTo(@0.5);
            }];
            preBtn = btn;
        }];
        [self addSubview:_indicatorSegmentView];
        _indicatorSegmentView.hidden = YES;
        if (_isFullScreen) {
            [_indicatorSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.bottom.equalTo(self).offset(-32);
                make.height.equalTo(@72);
            }];
        }
        else{
            [_indicatorSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(5);
                make.right.equalTo(self).offset(-5);
                make.top.equalTo(self).offset(32-5);
                make.height.equalTo(@72);
            }];
        }
    }
    return _indicatorSegmentView;
}

- (void)setItemModels:(NSArray *)itemModels {
    _itemModels = itemModels;
    if(itemModels){
        NSMutableArray *items = [NSMutableArray array];
        for(Y_StockChartViewItemModel *item in itemModels){
            [items addObject:item.title];
        }
        self.segmentView.items = items;
        Y_StockChartViewItemModel *firstModel = itemModels.firstObject;
        self.currentCenterViewType = firstModel.centerViewType;
    }
    if(self.dataSource){
        if (!self.isFullScreen) {
            self.segmentView.selectedIndex = 1;
            self.klineTime = 1;
            self.kLineView.lineKTime = 1;
        }
        else{
            self.segmentView.selectedIndex = 1;
            self.klineTime = 1;
            self.kLineView.lineKTime = 1;
        }
    }
}

- (void)setDataSource:(id<Y_StockChartViewDataSource>)dataSource {
    _dataSource = dataSource;
    if(self.itemModels)
    {
        if (!self.isFullScreen) {
            self.segmentView.selectedIndex = 1;
            self.klineTime = 1;
            self.kLineView.lineKTime = 1;
        }
        else{
            self.segmentView.selectedIndex = 1;
            self.klineTime = 1;
            self.kLineView.lineKTime = 1;
        }
    }
}

- (void)reloadData {
    self.isShowMoreSegmentView = YES;
    self.segmentView.selectedIndex = self.segmentView.selectedIndex;
    if (self.isMoreTimeDataUpdate && self.currentIndex == 4 && self.isFullScreen != YES) {
        id stockData = [self.dataSource stockDatasWithIndex:self.klineTime];
        if(!stockData) {
            return;
        }
        self.kLineView.kLineModels = (NSArray *)stockData;
        self.kLineView.targetLineStatus = self.targetLineStatus;
        if (self.klineTime == 0) {
            self.kLineView.MainViewType = Y_StockChartcenterViewTypeTimeLine;
        }
        [self.kLineView reDraw];
    }
}

#pragma mark - 代理方法

- (void)y_StockChartSegmentView:(Y_StockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index {
    self.currentIndex = index;
    if (!self.isFullScreen) {
        if (index == 4 ){//更多时间
            if (self.isShowMoreSegmentView == YES) {
                self.moreSegmentView.hidden = YES;
                self.isShowMoreSegmentView = NO;
                if (self.klineTime >= 0 && self.klineTime <= 3) {
                    self.segmentView.selectedIndex =  self.klineTime;
                    [self.segmentView setNeedsLayout];
                    
                }
                return;
            }
            if (self.klineTime <= 3) {
                [_moreSelectedBtn setSelected:NO];
                self.moreSegmentView.hidden = NO;
                self.isShowMoreSegmentView = YES;
            }
            else{
                if (self.isShowMoreSegmentView) {
                    self.moreSegmentView.hidden = YES;
                    self.isShowMoreSegmentView = NO;
                }
                else{
                    if (self.klineTime <= 3) {
                        [_moreSelectedBtn setSelected:NO];
                    }
                    self.moreSegmentView.hidden = NO;
                    self.isShowMoreSegmentView = YES;
                }
            }
            self.indicatorSegmentView.hidden = YES;
            self.isShowindicatorSegmentView = NO;
            UIButton *btn = [self.segmentView viewWithTag:2005];
            btn.selected = NO;
            [btn.titleLabel setFont:BOLDSYSTEMFONT(12)];
            [self bringSubviewToFront:self.moreSegmentView];
        }
        else if (index == 5 ){//指标
//            if (self.indicatorSegmentView.hidden == NO) {
//                self.indicatorSegmentView.hidden = YES;
//                return;
//            }
            if (self.klineTime >= 0 && self.klineTime <= 4) {
                self.segmentView.selectedIndex =  self.klineTime;
                [self.segmentView setNeedsLayout];
                
            }
            if (self.isShowindicatorSegmentView == YES) {
                self.indicatorSegmentView.hidden = YES;
                self.isShowindicatorSegmentView = NO;
                UIButton *btn = [self.segmentView viewWithTag:2005];
                btn.selected = NO;
                [btn.titleLabel setFont:BOLDSYSTEMFONT(12)];
            }
            else{
                self.indicatorSegmentView.hidden = NO;
                self.isShowindicatorSegmentView = YES;
                UIButton *btn = [self.segmentView viewWithTag:2005];
                btn.selected = YES;
                [btn.titleLabel setFont:BOLDSYSTEMFONT(12)];
                self.moreSegmentView.hidden = YES;
                self.isShowMoreSegmentView = NO;
                [self bringSubviewToFront:self.indicatorSegmentView];
            }
            
        }else { //分时、1分、15分、4小时
            self.klineTime = index;
            self.kLineView.lineKTime = self.klineTime;
            [self reloadDataWithTimeIndex:index];
            UIButton *btn = [self.segmentView viewWithTag:2004];
            [btn setTitle:BTLanguage(@"更多") forState:UIControlStateNormal];
            [btn.titleLabel setFont:BOLDSYSTEMFONT(12)];
        }
    }
    else{
        if (index == 9 ){//指标
            if (self.isFullScreen) {
                return;
            }
            if (self.isShowindicatorSegmentView == YES) {
                self.indicatorSegmentView.hidden = YES;
                self.isShowindicatorSegmentView = NO;
                UIButton *btn = [self.segmentView viewWithTag:2010];
                btn.selected = NO;
                [btn.titleLabel setFont:BOLDSYSTEMFONT(12)];
            }
            else{
                self.indicatorSegmentView.hidden = NO;
                self.isShowindicatorSegmentView = YES;
                UIButton *btn = [self.segmentView viewWithTag:2010];
                btn.selected = YES;
                [btn.titleLabel setFont:BOLDSYSTEMFONT(12)];
                self.moreSegmentView.hidden = YES;
                self.isShowMoreSegmentView = NO;
                [self bringSubviewToFront:self.indicatorSegmentView];
            }
        }
        else { //分时、1分、15分、1小时
            self.klineTime = index;
            self.kLineView.lineKTime = self.klineTime;
            [self reloadDataWithTimeIndex:index];
            [_moreSelectedBtn setSelected:NO];
        }
    }
    
}

- (void) reloadDataWithTimeIndex:(NSInteger )timeIndex {
    self.indicatorSegmentView.hidden = YES;
//    self.isShowindicatorSegmentView = NO;

    if (timeIndex >= 5) {
        UIButton *btn = [_segmentView viewWithTag:self.isFullScreen?2000+timeIndex:2000+4];
        CGFloat btnW = [CommonMethod computeTextSizeWithString:btn.currentTitle andFontSize:BOLDSYSTEMFONT(12)].width;
        self.scorllLine.width = btnW;
        self.scorllLine.centerX = btn.centerX;
    }else{
        UIButton *btn = [_segmentView viewWithTag:2000+timeIndex];
        CGFloat btnW = [CommonMethod computeTextSizeWithString:btn.currentTitle andFontSize:BOLDSYSTEMFONT(12)].width;
        self.scorllLine.width = btnW;
        self.scorllLine.centerX = btn.centerX;
    }
    
    if (!self.isFullScreen) {
        UIButton *btn = [self.segmentView viewWithTag:2005];
        btn.selected = NO;
        [btn.titleLabel setFont:BOLDSYSTEMFONT(12)];
    }
    self.moreSegmentView.hidden = YES;
    self.isShowMoreSegmentView = NO;
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)]) {
        id stockData = [self.dataSource stockDatasWithIndex:timeIndex];
        if(!stockData) {
            return;
        }
        Y_StockChartCenterViewType type = Y_StockChartcenterViewTypeKline;
        if (timeIndex < [self.itemModels count]) {
            Y_StockChartViewItemModel *itemModel = self.itemModels[timeIndex];
             type = itemModel.centerViewType;
        }
        if(type != self.currentCenterViewType) {
            //移除当前View，设置新的View
            self.currentCenterViewType = type;
            switch (type) {
                case Y_StockChartcenterViewTypeKline:
                {
                    self.kLineView.hidden = NO;
                    [self bringSubviewToFront:self.segmentView];
                }
                    break;
                default:
                    break;
            }
        }
        if(type == Y_StockChartcenterViewTypeOther)
        {
            if (self.klineTime >= 4 && self.klineTime<= 9) {
                self.kLineView.kLineModels = (NSArray *)stockData;
                self.kLineView.MainViewType = Y_StockChartcenterViewTypeKline;
                self.kLineView.targetLineStatus = self.targetLineStatus;
                [self.kLineView reDraw];
            }
            
        } else {
            
            self.kLineView.kLineModels = (NSArray *)stockData;
            self.kLineView.MainViewType = type;
            if (self.klineTime == 0) {
                self.kLineView.MainViewType = Y_StockChartcenterViewTypeTimeLine;
            }
            self.kLineView.targetLineStatus = self.targetLineStatus;
            [self.kLineView reDraw];
        }
        [self bringSubviewToFront:self.segmentView];
    }
}

- (void)setMoreSelectedBtn:(UIButton *)moreSelectedBtn {
    [_moreSelectedBtn setSelected:NO];
    [moreSelectedBtn setSelected:YES];
    UIButton *btn = [self.segmentView viewWithTag:2004];
    if (moreSelectedBtn.tag == 3100) {
        [btn setTitle:BTLanguage(@"1分") forState:UIControlStateNormal];
    }
    else if (moreSelectedBtn.tag == 3101) {
        [btn setTitle:BTLanguage(@"5分") forState:UIControlStateNormal];
    }
    else if (moreSelectedBtn.tag == 3102) {
        [btn setTitle:BTLanguage(@"30分") forState:UIControlStateNormal];
    }
    else if (moreSelectedBtn.tag == 3103) {
        [btn setTitle:BTLanguage(@"周线") forState:UIControlStateNormal];
    }
    else if (moreSelectedBtn.tag == 3104) {
        [btn setTitle:BTLanguage(@"1月") forState:UIControlStateNormal];
    }
    else if (moreSelectedBtn.tag == 3105) {
        [btn setTitle:BTLanguage(@"1月") forState:UIControlStateNormal];
    }
    _moreSelectedBtn = moreSelectedBtn;
    self.moreSegmentView.hidden = YES;
    self.isShowMoreSegmentView = NO;
}

- (void)setIndicatorSegmentSelectedBtnOne:(UIButton *)indicatorSegmentSelectedBtnOne {
    [_indicatorSegmentSelectedBtnOne setSelected:NO];
    [indicatorSegmentSelectedBtnOne setSelected:YES];
    _indicatorSegmentSelectedBtnOne = indicatorSegmentSelectedBtnOne;
}

- (void)setIndicatorSegmentSelectedBtnTwo:(UIButton *)indicatorSegmentSelectedBtnTwo {
    [_indicatorSegmentSelectedBtnTwo setSelected:NO];
    [indicatorSegmentSelectedBtnTwo setSelected:YES];
    _indicatorSegmentSelectedBtnTwo = indicatorSegmentSelectedBtnTwo;
}


#pragma mark 更多、指标action
- (void)event_segmentButtonClicked:(UIButton *)btn {
    if ((btn.tag == (Y_StockChartSegmentIndicatorIndex + 1)) || (btn.tag == (Y_StockChartSegmentIndicatorIndex + 2)) || (btn.tag == (Y_StockChartSegmentIndicatorIndex + 3)) ) {
        self.indicatorSegmentSelectedBtnOne = btn;
    }
    else if ((btn.tag > (Y_StockChartSegmentIndicatorIndex + 5)) &&  (btn.tag < (Y_StockChartSegmentIndicatorIndex + 10))){
        self.indicatorSegmentSelectedBtnTwo = btn;
    }
    else if ((btn.tag >= Y_StockChartSegmentIndicatorIndex + 100) ){
        self.moreSelectedBtn = btn;
    }    
    NSInteger index = btn.tag;
    //3001 macd  3002 kdj  3005ma 3   3006ema  4 3007boll 3008  6
    
    //3000  3001ma      3002ema  3003bool       4
    //5     3006macd    3007kdj                 3008
    if(index >= 3000 && index <= 3010) {
        NSInteger lineIndex = index - 2900;
        if (index == 3000 || index == 3005) {
            return;
        }
        //        else if (index == 3004){ //关闭指标
        //            lineIndex = 106;
        //        }
        //        else if (index == 3010){ //关闭副图
        //            lineIndex = 102;
        //        }
        //        else if (index >= 3001 && index < 3004){
        //            lineIndex = index - 2900 + 2;
        //        }
        //        else{
        //            lineIndex = index - 2900 - 6;
        //        }
        self.kLineView.targetLineStatus = lineIndex;
        self.targetLineStatus = lineIndex;
        NSLog(@"状态--%ld",(long)self.targetLineStatus);
        if (index == 3004) {
            self.indicatorSegmentSelectedBtnOne = nil;
            UIButton *btn = [self.indicatorSegmentView viewWithTag:index];
            btn.selected = YES;
        }else if (index == 3010) {
            self.indicatorSegmentSelectedBtnTwo = nil;
            UIButton *btn = [self.indicatorSegmentView viewWithTag:index];
            btn.selected = YES;
        }
        
        if (index > 3000 && index < 3004) {
            UIButton *btn = [self.indicatorSegmentView viewWithTag:3004];
            btn.selected = NO;
        }
        
        if (index > 3005 && index < 3010) {
            UIButton *btn = [self.indicatorSegmentView viewWithTag:3010];
            btn.selected = NO;
        }
        
        [Y_StockChartGlobalVariable setisEMALine:self.targetLineStatus];
//        if(lineIndex == Y_StockChartTargetLineStatusMA)
//        {
//            [Y_StockChartGlobalVariable setisEMALine:Y_StockChartTargetLineStatusMA];
//        }
//        else if(lineIndex == Y_StockChartTargetLineStatusCloseMA)
//        {
//            [Y_StockChartGlobalVariable setisEMALine:Y_StockChartTargetLineStatusCloseMA];
//        }  else {
//            [Y_StockChartGlobalVariable setisEMALine:Y_StockChartTargetLineStatusEMA];
//        }
        if (self.klineTime == 0) {
            self.kLineView.MainViewType = Y_StockChartcenterViewTypeTimeLine;
        }
        [self.kLineView reDraw];
        self.indicatorSegmentView.hidden = YES;
        self.isShowindicatorSegmentView = NO;
        UIButton *btn = [self.segmentView viewWithTag:2005];
        btn.selected = NO;
        [self bringSubviewToFront:self.segmentView];
    }
    else if ((index >= (Y_StockChartSegmentIndicatorIndex + 100)) && (index <= (Y_StockChartSegmentIndicatorIndex + 105))) {
        //更多时间里的
        self.indicatorSegmentView.hidden = YES;
        self.isShowindicatorSegmentView = NO;
        UIButton *btn = [self.segmentView viewWithTag:2005];
        btn.selected = NO;
        if (self.isShowMoreSegmentView) {
            self.moreSegmentView.hidden = YES;
            self.isShowMoreSegmentView = NO;
        }
        else{
            self.moreSegmentView.hidden = NO;
            self.isShowMoreSegmentView = YES;
        }
        [self bringSubviewToFront:self.segmentView];
        NSInteger timeIndex = index - Y_StockChartSegmentIndicatorIndex - 100 + 5;
        self.klineTime = timeIndex;
        self.kLineView.lineKTime = self.klineTime;
        [self reloadDataWithTimeIndex:timeIndex];
    }
}

- (void)fullScreenTargetClickWithIndex:(NSInteger)index
{
    self.kLineView.targetLineStatus = index;
    self.targetLineStatus = index;

    [Y_StockChartGlobalVariable setisEMALine:self.targetLineStatus];

    if (self.klineTime == 0) {
        self.kLineView.MainViewType = Y_StockChartcenterViewTypeTimeLine;
    }
    [self.kLineView reDraw];
}

@end


/************************ItemModel类************************/
@implementation Y_StockChartViewItemModel

+ (instancetype)itemModelWithTitle:(NSString *)title type:(Y_StockChartCenterViewType)type
{
    Y_StockChartViewItemModel *itemModel = [Y_StockChartViewItemModel new];
    itemModel.title = title;
    itemModel.centerViewType = type;
    return itemModel;
}

@end
