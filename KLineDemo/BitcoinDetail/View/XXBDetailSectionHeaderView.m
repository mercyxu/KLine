//
//  XXBDetailSectionHeaderView.m
//  iOS
//
//  Created by iOS on 2018/6/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXBDetailSectionHeaderView.h"
#import "UIColor+Y_StockChart.h"

@interface XXBDetailSectionHeaderView ()

/** 委托订单 */
@property (strong, nonatomic) XXButton *orderButton;

/** 最新成交 */
@property (strong, nonatomic) XXButton *nowButton;

/** 简介按钮 */
@property (strong, nonatomic) XXButton *introButton;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

/** 指示线 */
@property (strong, nonatomic) UIView *indexLine;

@end

@implementation XXBDetailSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor backgroundColor];
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    [self addSubview:self.orderButton];
    
    [self addSubview:self.nowButton];
    
    if (KDetail.symbolModel.type == SymbolTypeCoin) {
        [self addSubview:self.introButton];
    }
    
    [self addSubview:self.lineView];
    
    [self addSubview:self.indexLine];
}

#pragma mark - || 懒加载
- (XXButton *)orderButton {
    if (_orderButton == nil) {
        KWeakSelf
        _orderButton = [XXButton buttonWithFrame:CGRectMake(0, 0, KSpacing*2 + [NSString widthWithText:LocalizedString(@"OrderBook") font:kFontBold14], self.height - 3) title:LocalizedString(@"OrderBook") font:kFontBold14 titleColor:[UIColor assistTextColor] block:^(UIButton *button) {
            
            if (weakSelf.index == 0) {
                return ;
            }
            self.index = 0;
            CGFloat width = button.titleLabel.width;
            CGFloat lineLeftX = button.centerX - width / 2.0f;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.indexLine.left = lineLeftX;
                weakSelf.indexLine.width = width;
            }];
            button.selected = YES;
            weakSelf.nowButton.selected = NO;
            weakSelf.introButton.selected = NO;
            if (weakSelf.headActionBlock) {
                weakSelf.headActionBlock(0);
            }
        }];
        [_orderButton setTitleColor:kBlue100 forState:UIControlStateSelected];
        _orderButton.selected = YES;
    }
    return _orderButton;
}

- (XXButton *)nowButton {
    if (_nowButton == nil) {
        KWeakSelf
        _nowButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width/2 - (KSpacing*2 + [NSString widthWithText:LocalizedString(@"Trades") font:kFontBold14])/2, 0, K375(48) + [NSString widthWithText:LocalizedString(@"Trades") font:kFontBold14], self.height - 3) title:LocalizedString(@"Trades") font:kFontBold14 titleColor:[UIColor assistTextColor] block:^(UIButton *button) {
            
            if (weakSelf.index == 1) {
                return ;
            }
            self.index = 1;
            
            CGFloat width = button.titleLabel.width;
            CGFloat lineLeftX = button.centerX - width / 2.0f;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.indexLine.left = lineLeftX;
                weakSelf.indexLine.width = width;
            }];
            button.selected = YES;
            weakSelf.orderButton.selected = NO;
            weakSelf.introButton.selected = NO;
            if (weakSelf.headActionBlock) {
                weakSelf.headActionBlock(1);
            }
        }];
        [_nowButton setTitleColor:kBlue100 forState:UIControlStateSelected];
    }
    return _nowButton;
}

- (XXButton *)introButton {
    if (_introButton == nil) {
        KWeakSelf
        _introButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - (KSpacing*2 + [NSString widthWithText:LocalizedString(@"Intro") font:kFontBold14]), 0, KSpacing*2 + [NSString widthWithText:LocalizedString(@"Intro") font:kFontBold14], self.height - 3) title:LocalizedString(@"Intro") font:kFontBold14 titleColor:[UIColor assistTextColor] block:^(UIButton *button) {
            
            if (weakSelf.index == 2) {
                return ;
            }
            self.index = 2;
            
            CGFloat width = button.titleLabel.width;
            CGFloat lineLeftX = button.centerX - width / 2.0f;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.indexLine.left = lineLeftX;
                weakSelf.indexLine.width = width;
            }];
            button.selected = YES;
            weakSelf.orderButton.selected = NO;
            weakSelf.nowButton.selected = NO;
            if (weakSelf.headActionBlock) {
                weakSelf.headActionBlock(2);
            }
        }];
        [_introButton setTitleColor:kBlue100 forState:UIControlStateSelected];
    }
    return _introButton;
}


- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, kScreen_Width, 1)];
        _lineView.backgroundColor = [UIColor lineColor];
    }
    return _lineView;
}

- (UIView *)indexLine {
    if (_indexLine == nil) {
        _indexLine = [[UIView alloc] initWithFrame:CGRectMake((self.orderButton.width - [NSString widthWithText:LocalizedString(@"OrderBook") font:kFontBold14])/2.0, self.height - 1.5, [NSString widthWithText:LocalizedString(@"OrderBook") font:kFontBold14], 1.5)];
        _indexLine.backgroundColor = kBlue100;
    }
    return _indexLine;
}

@end
