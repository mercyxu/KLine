//
//  XXKlineDepthActionView.m
//  iOS
//
//  Created by iOS on 2018/6/28.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXKlineDepthActionView.h"
#import "UIColor+Y_StockChart.h"

@interface XXKlineDepthActionView ()

@property (assign, nonatomic) CGFloat btnWidth;

/** 深度图按钮 */
@property (strong, nonatomic) XXButton *moreButton;

/** 深度按钮 */
@property (strong, nonatomic, nullable) XXButton *depthButton;

/** 全屏按钮 */
@property (strong, nonatomic) XXButton *fullScreenButton;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

/** 指示线 */
@property (strong, nonatomic) UIView *indexLine;

@end

@implementation XXKlineDepthActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _btnWidth = self.width / 7;
        
        self.backgroundColor = [UIColor backgroundColor];
        [self addSubview:self.moreButton];
        
        [self addSubview:self.depthButton];
        
        [self addSubview:self.fullScreenButton];
        
        [self addSubview:self.lineView];
        
        [self addSubview:self.indexLine];
        
        [self setIndexBtn:[KDetail.klineIndex integerValue]];
      
    }
    return self;
}

#pragma mark - 1. 主图分类按钮数组赋值添加到当前页面
- (void)setKMainbuttonsArray:(NSMutableArray *)kMainbuttonsArray {
    _kMainbuttonsArray = kMainbuttonsArray;
    for (NSInteger i=0; i < kMainbuttonsArray.count; i ++) {
        UIButton *itemButton = kMainbuttonsArray[i];
        itemButton.frame = CGRectMake(_btnWidth*i, 0, _btnWidth, self.height);
        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addSubview:itemButton];
    }
}

#pragma mark - 2. 更多 全屏 按钮点击事件
- (void)buttonClick:(UIButton *)sender {
    
    // 1. 更多  2. 全屏 3. 深度图
    if (sender.tag == 101) { // 更多
        
        if ([self.delegate respondsToSelector:@selector(klineDepthActionViewDidselctIndex:)]) {
            [self.delegate klineDepthActionViewDidselctIndex:1];
        }
        
    } else if (sender.tag == 102) { // 全屏
        
        if (self.depthButton.selected) {
            self.depthButton.selected = NO;
            [self setIndexBtn:[KDetail.klineIndex integerValue]];
        }
        
        if ([self.delegate respondsToSelector:@selector(klineDepthActionViewDidselctIndex:)]) {
            [self.delegate klineDepthActionViewDidselctIndex:2];
        }
    } else if (sender.tag == 103) { // 深度图
        
        // 1. 主图有选中的取消选中状态
        for (XXButton *mainItemButton in self.kMainbuttonsArray) {
            if (mainItemButton.selected) {
                mainItemButton.selected =  NO;
            }
        }
        
        // 2. 移动下划线
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*5.5;
        }];
        
        // 3. 改变深度按钮为选中状态
        self.depthButton.selected = YES;
        
        // 4. 更多按钮
        self.moreButton.selected = NO;
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"More")] forState:UIControlStateNormal];
        [self.moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.moreButton.imageView.size.width, 0, self.moreButton.imageView.size.width)];
        [self.moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.moreButton.titleLabel.bounds.size.width, 0, -self.moreButton.titleLabel.bounds.size.width)];
        
        // 5. 回调滚动
        if ([self.delegate respondsToSelector:@selector(klineDepthActionViewDidselctIndex:)]) {
            [self.delegate klineDepthActionViewDidselctIndex:3];
        }
    }
}

#pragma mark - 3. 所有k线分类按钮点击事件
- (void)setIndexBtn:(NSInteger)indexBtn {

    if (indexBtn < 14) {
        KDetail.klineIndex = [NSString stringWithFormat:@"%zd", indexBtn];
        
        if (self.depthButton.selected) {
            self.depthButton.selected = NO;
        }
    }
    
    if (indexBtn == 1) { // 分时
     
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"Time")] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*4.5;
        }];
        self.moreButton.selected = YES;
    } else if (indexBtn == 2) { // 1分
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"1min")] forState:UIControlStateNormal];
        self.moreButton.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*4.5;
        }];
    } else if (indexBtn == 3) { // 5分
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"5min")] forState:UIControlStateNormal];
        self.moreButton.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*4.5;
        }];
    } else if (indexBtn == 4) { // 15分
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*0.5;
        }];
        self.moreButton.selected = NO;
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"More")] forState:UIControlStateNormal];
    } else if (indexBtn == 5) { // 30分
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"30min")] forState:UIControlStateNormal];
        self.moreButton.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*4.5;
        }];
    } else if (indexBtn == 6) { // 1小时
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*1.5;
        }];
        self.moreButton.selected = NO;
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"More")] forState:UIControlStateNormal];
    } else if (indexBtn == 7) { // 2小时
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"2hour")] forState:UIControlStateNormal];
        self.moreButton.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*4.5;
        }];
    } else if (indexBtn == 8) {// 4小时
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*2.5;
        }];
        self.moreButton.selected = NO;
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"More")] forState:UIControlStateNormal];
    } else if (indexBtn == 9) {// 6小时
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"6hour")] forState:UIControlStateNormal];
        self.moreButton.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*4.5;
        }];
    } else if (indexBtn == 10) {// 12小时
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"12hour")] forState:UIControlStateNormal];
        self.moreButton.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*4.5;
        }];
    } else if (indexBtn == 11) {// 日线
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*3.5;
        }];
        self.moreButton.selected = NO;
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"More")] forState:UIControlStateNormal];
    } else if (indexBtn == 12) {// 周线
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"1week")] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*4.5;
        }];
        self.moreButton.selected = YES;
    } else if (indexBtn == 13) {// 月线
        [self.moreButton setTitle:[NSString stringWithFormat:@"%@ ",LocalizedString(@"1mon")] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            self.indexLine.centerX = self.btnWidth*4.5;
        }];
        self.moreButton.selected = YES;
    }
    
    [self.moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.moreButton.imageView.size.width, 0, self.moreButton.imageView.size.width)];
    [self.moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.moreButton.titleLabel.bounds.size.width, 0, -self.moreButton.titleLabel.bounds.size.width)];
}

/** 更多按钮 */
- (XXButton *)moreButton {
    if (_moreButton == nil) {
        KWeakSelf
        _moreButton = [XXButton buttonWithFrame:CGRectMake(self.width - _btnWidth*3, 0, _btnWidth, self.height) title:LocalizedString(@"Depth") font:kFontBold12 titleColor:[UIColor assistTextColor] block:^(UIButton *button) {
            [weakSelf buttonClick:button];
        }];
        [_moreButton setTitleColor:kBlue100 forState:UIControlStateSelected];
        [_moreButton setImage:[[UIImage imageNamed:@"lineSelected_0"] imageWithColor:[UIColor assistTextColor]] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage mainImageName:@"lineSelected_0"] forState:UIControlStateSelected];
        [_moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_moreButton.imageView.size.width, 0, _moreButton.imageView.size.width)];
        [_moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, _moreButton.titleLabel.bounds.size.width, 0, -_moreButton.titleLabel.bounds.size.width)];
        _moreButton.tag = 101;
    }
    return _moreButton;
}

/** 深度按钮 */
- (XXButton *)depthButton {
    if (_depthButton == nil) {
        KWeakSelf
        _depthButton = [XXButton buttonWithFrame:CGRectMake(self.width - _btnWidth * 2, 0, _btnWidth, self.height) title:LocalizedString(@"Depth") font:kFontBold12 titleColor:[UIColor assistTextColor] block:^(UIButton *button) {
            [weakSelf buttonClick:button];
        }];
        [_depthButton setTitleColor:kBlue100 forState:UIControlStateSelected];
        _depthButton.tag = 103;
    }
    return _depthButton;
}

/** 全屏按钮 */
- (XXButton *)fullScreenButton {
    if (_fullScreenButton == nil) {
        KWeakSelf
        _fullScreenButton = [XXButton buttonWithFrame:CGRectMake(self.width - _btnWidth, 0, _btnWidth, self.height) block:^(UIButton *button) {
            [weakSelf buttonClick:button];
        }];
        [_fullScreenButton setImage:[[UIImage imageNamed:@"fullScreen_0"] imageWithColor:[UIColor mainTextColor]] forState:UIControlStateNormal];
        _fullScreenButton.tag = 102;
    }
    return _fullScreenButton;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        _lineView.backgroundColor = [UIColor assistBackgroundColor];
    }
    return _lineView;
}

- (UIView *)indexLine {
    if (_indexLine == nil) {
        _indexLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 2, _btnWidth * 0.8, 2)];
        _indexLine.backgroundColor = kBlue100;
    }
    return _indexLine;
}
@end
