//
//  Y_StockChartSegmentView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/2.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartSegmentView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "UIButton+ImageTitleSpacing.h"


static NSInteger const Y_StockChartSegmentStartTag = 2000;

//static CGFloat const Y_StockChartSegmentIndicatorViewHeight = 2;
//
//static CGFloat const Y_StockChartSegmentIndicatorViewWidth = 40;

@interface Y_StockChartSegmentView()

@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation Y_StockChartSegmentView

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithFrame:CGRectZero];
    if(self)
    {
        self.items = items;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.clipsToBounds = YES;
        self.backgroundColor = RGB(21, 32, 54);
    }
    return self;
}

- (void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    if(items.count == 0 || !items)
    {
        return;
    }

    if (!self.isFullScreen) {
        UIView *line = [UIView new];
        line.backgroundColor = RGB(13, 23, 35);
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@10);
        }];
    }

    NSInteger index = 0;
    NSInteger count = items.count;
    UIButton *preBtn = nil;
    
    for (NSString *title in items)
    {
        UIButton *btn = [self private_createButtonWithTitle:title tag:Y_StockChartSegmentStartTag+index];
        UIView *view = [UIView new];
        view.backgroundColor = RGB(21, 32, 54);
        [self addSubview:btn];
        [self addSubview:view];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.width.equalTo(self).multipliedBy(1.0f/count);
            make.bottom.equalTo(self).offset(self.isFullScreen?0:-10);
            if(preBtn)
            {
                make.left.equalTo(preBtn.mas_right).offset(0.5);
            } else {
                make.left.equalTo(self);
            }
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(btn);
            make.top.equalTo(btn.mas_bottom);
            make.height.equalTo(@0.5);
        }];
        preBtn = btn;
        index++;
    }
}

#pragma mark 设置底部按钮index
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    UIButton *btn = (UIButton *)[self viewWithTag:Y_StockChartSegmentStartTag + selectedIndex];
    NSAssert(btn, @"按钮初始化出错");
    [self event_segmentButtonClicked:btn];
}

- (void)setSelectedBtn:(UIButton *)selectedBtn
{
    if(_selectedBtn == selectedBtn)
    {
        if(selectedBtn.tag != Y_StockChartSegmentStartTag)
        {
            return;
        } else {
            
        }
    }
    [_selectedBtn setSelected:NO];
    [_selectedBtn.titleLabel setFont:BOLDSYSTEMFONT(12)];
    [selectedBtn setSelected:YES];
    [selectedBtn.titleLabel setFont:BOLDSYSTEMFONT(12)];
    _selectedBtn = selectedBtn;
    _selectedIndex = selectedBtn.tag - Y_StockChartSegmentStartTag;
    [self layoutIfNeeded];
}

#pragma mark - 私有方法
#pragma mark 创建底部按钮
- (UIButton *)private_createButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:RGB(98, 124, 158) forState:UIControlStateNormal];
    [btn setTitleColor:RGB(23, 100, 178) forState:UIControlStateSelected];
    btn.titleLabel.font = BOLDSYSTEMFONT(12);
    btn.tag = tag;
    [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    if (!self.isFullScreen) {
        if (tag == 2004 || tag == 2005) {
            [btn setImage:IMAGE_NAMED(@"kline_arrow") forState:UIControlStateNormal];
            [btn layoutButtonWithEdgeInsetsStyle:ZMButtonEdgeInsetsStyleRight imageTitleSpace:12];
        }
        else if (tag == 2007){
            [btn setImage:IMAGE_NAMED(@"transaction-fullscreen-ic") forState:UIControlStateNormal];
        }
    }
    else{
        if (tag == 2009) {
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn setImage:IMAGE_NAMED(@"kline_more") forState:UIControlStateNormal];
//            [btn layoutButtonWithEdgeInsetsStyle:ZMButtonEdgeInsetsStyleRight imageTitleSpace:12];
        }
    }
    return btn;
}

#pragma mark 底部按钮点击事件
- (void)event_segmentButtonClicked:(UIButton *)btn {
    if (btn.tag == 2005) {
        if (self.isFullScreen) {
            self.selectedBtn = btn;
        }else{
            
        }
    }
    else{
        if (btn.tag == 2010 && self.isFullScreen) {
            
        }else{
            self.selectedBtn = btn;
        }
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(y_StockChartSegmentView:clickSegmentButtonIndex:)]) {
        [self.delegate y_StockChartSegmentView:self clickSegmentButtonIndex: btn.tag-Y_StockChartSegmentStartTag];
    }
}

@end
