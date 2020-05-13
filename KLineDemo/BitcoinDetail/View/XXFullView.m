//
//  XXFullView.m
//  iOS
//
//  Created by iOS on 2018/7/29.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXFullView.h"
#import "XXFullPopButton.h"
#import "UIColor+Y_StockChart.h"

@interface XXFullView () {
    BOOL _isAddLeftRightLabel;
    BOOL _isHideIndexFlag; //右侧指标是否隐藏
}

/** 背景视图 */
@property (strong, nonatomic) UIView *bgView;

/** 上版式图 */
@property (strong, nonatomic) UIView *topView;

/** 右版式图1 */
@property (strong, nonatomic) UIView *rightView1;

/** 线条2 */
@property (strong, nonatomic) UIView *lineView2;

/** 底部视图 */
@property (strong, nonatomic) UIView *lowView;

/** 关闭按钮 */
@property (strong, nonatomic) XXButton *closeButton;

///** popView */
//@property (strong, nonatomic) XXFullPopButton *popButton;

/** 隐藏指标按钮*/
@property (strong, nonatomic) XXButton *hideIndexButton;

/**
顶部灰色线条
 */
@property (strong, nonatomic) UIView *topLineView;

@end

@implementation XXFullView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.001];
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.topView];
        [self.bgView addSubview:self.rightView1];

        [self.bgView addSubview:self.lowView];
        
        [self.topView addSubview:self.leftLabel];
        [self.topView addSubview:self.rightLabel];
        [self.topView addSubview:self.closeButton];
        [self.bgView addSubview:self.hideIndexButton];
        [self addSubview:self.topLineView];
    }
    return self;
}


#pragma mark - 1. 全屏出现
- (void)show {
    
    // 0. 判断是否添加了左右标签
    if (!_isAddLeftRightLabel) {
        _isAddLeftRightLabel = YES;
        [self.topView addSubview:self.leftLabel];
        [self.topView addSubview:self.rightLabel];
    }
    
    [self.rightLabel sizeToFit];
    self.rightLabel.frame = CGRectMake(self.width - 65 - self.rightLabel.width, 0, self.rightLabel.width, self.topView.height);
    self.leftLabel.frame = CGRectMake(16, 0, self.rightLabel.left - 16, self.topView.height);
    
    // 1. 添加k线图
    [self reloadKLineViewFrame];
    [self addSubview:self.klineView];
    
    
    // 2. 添加指标按钮
    CGFloat offetY = 0;
    CGFloat _btnHeight = self.rightView1.height / (self.fButtonsArray.count + self.mainButtonsArray.count + 2);
    XXLabel *mainLabel = [XXLabel labelWithFrame:CGRectMake(16, offetY, self.rightView1.width - 16, _btnHeight) text:LocalizedString(@"MainGraph") font:kFont12 textColor:[UIColor assistTextColor] alignment:NSTextAlignmentLeft];
    [self.rightView1 addSubview:mainLabel];
     offetY += _btnHeight;
    for (NSInteger i=0; i < self.mainButtonsArray.count; i ++) {
        XXButton *itemButton = self.mainButtonsArray[i];
        itemButton.frame = CGRectMake(16, offetY, self.rightView1.width - 16, _btnHeight);
        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.rightView1 addSubview:itemButton];
        offetY += _btnHeight;
    }
    
    XXLabel *subLabel = [XXLabel labelWithFrame:CGRectMake(16, offetY, self.rightView1.width - 16, _btnHeight) text:LocalizedString(@"AuxiliaryGraph") font:kFont12 textColor:[UIColor assistTextColor] alignment:NSTextAlignmentLeft];
    [self.rightView1 addSubview:subLabel];
    offetY += _btnHeight;
    for (NSInteger i=0; i < self.fButtonsArray.count; i ++) {
        XXButton *itemButton = self.fButtonsArray[i];
        itemButton.frame = CGRectMake(16, offetY, self.rightView1.width - 16, _btnHeight);
        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.rightView1 addSubview:itemButton];
        offetY += _btnHeight;
    }
    
    // 3. 添加分时按钮
    CGFloat _btnWidth = (kScreen_Height - 91) / 13;
    for (NSInteger i=0; i < self.kButtonsArray.count; i ++) {
        XXButton *itemButton = self.kButtonsArray[i];
            itemButton.frame = CGRectMake(_btnWidth*i + 16, 0, _btnWidth, self.lowView.height);
            [self.lowView addSubview:itemButton];
        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    
    // 4. 添加到窗口
    self.center = KWindow.center;
    [KWindow addSubview:self];
    
    // 5. 动画旋转
    self.topLineView.backgroundColor = [UIColor clearColor];
    self.lineView2.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformMakeRotation(0.5*M_PI);
    } completion:^(BOOL finished) {
        self.lineView2.backgroundColor = [UIColor assistBackgroundColor];
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.topLineView.backgroundColor = [UIColor assistBackgroundColor];
        [self.klineView reloadLineLocation];
    }];
}

#pragma mark - 2. 退出全屏
- (void)dismiss {
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.topLineView.backgroundColor = [UIColor clearColor];
    self.lineView2.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.15f animations:^{
        self.klineView.frame = CGRectMake((kScreen_Height - self.klineFrame.size.width)/2, self.klineFrame.origin.y - (kScreen_Height - kScreen_Width)/2, self.klineFrame.size.width, self.klineFrame.size.height);
        self.transform = CGAffineTransformIdentity;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        KDetail.isReloadKlineUI = YES;
        [self.klineView reloadUI];
        [self removeFromSuperview];
        self.bgView.alpha = 1;
        if (self.outFullViewBlock) {
            self.outFullViewBlock();
        }
        [self.klineView reloadLineLocation];
    }];
}

#pragma mark -3. 隐藏右侧指标
- (void)hideIndexAction {
    _isHideIndexFlag = !_isHideIndexFlag;
    self.hideIndexButton.selected = !self.hideIndexButton.selected;
    [self reloadKLineViewFrame];
}

#pragma mark -4. 刷新k线图frame
- (void)reloadKLineViewFrame {
    self.rightView1.hidden = _isHideIndexFlag;
    float indexWidth = _isHideIndexFlag ? 0 : 60;
    CGAffineTransform transform = _isHideIndexFlag ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
    if (BH_IS_IPHONE_X) {
        self.klineView.frame = CGRectMake(30, 68, kScreen_Height - 45 - indexWidth, kScreen_Width - 120);
    } else {
        self.klineView.frame = CGRectMake(0, 68, kScreen_Height - 15 - indexWidth, kScreen_Width - 120);
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.hideIndexButton.imageView.transform = transform;
    }];
    [self.klineView layoutIfNeeded];
    KDetail.isReloadKlineUI = YES;
    [self.klineView reloadUI];
}

#pragma mark - || 懒加载
- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Height, kScreen_Width)];
        _bgView.backgroundColor = [UIColor backgroundColor];
    }
    return _bgView;
}

/** 上版式图 */
- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Height, 56)];
        _topView.backgroundColor = [UIColor backgroundColor];
    }
    return _topView;
}

/** 右版式图1 */
- (UIView *)rightView1 {
    if (_rightView1 == nil) {
        _rightView1 = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Height - 75, 64, 75, kScreen_Width - 112)];
        _rightView1.backgroundColor = [UIColor backgroundColor];
        
        _lineView2 = [[UIView alloc] initWithFrame:CGRectMake(16, _rightView1.height*5/9 - 0.5, _rightView1.width - 16, 1)];
        _lineView2.backgroundColor = [UIColor assistBackgroundColor];
        [_rightView1 addSubview:_lineView2];
    }
    return _rightView1;
}


/** 底部视图 */
- (UIView *)lowView {
    if (_lowView == nil) {
        _lowView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Width - 48, kScreen_Height, 48)];
        _lowView.backgroundColor = [UIColor backgroundColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Height, 1)];
        lineView.backgroundColor = [UIColor assistBackgroundColor];
        [_lowView addSubview:lineView];
    }
    return _lowView;
}

/** 关闭按钮 */
- (XXButton *)closeButton {
    if (_closeButton == nil) {
        KWeakSelf
        _closeButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Height - 65, 0, 65, self.topView.height) block:^(UIButton *button) {
            [weakSelf dismiss];
        }];
        [_closeButton setImage:[[UIImage imageNamed:@"icon_dismiss_1"] imageWithColor:[UIColor mainTextColor]] forState:UIControlStateNormal];
    }
    return _closeButton;
}


/**
 隐藏右侧指标 按钮
 */
- (XXButton *)hideIndexButton {
    if (!_hideIndexButton) {
        KWeakSelf
        _hideIndexButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Height - self.rightView1.width, kScreen_Width - self.lowView.height, self.rightView1.width, self.lowView.height) title:LocalizedString(@"Index") font:kFont12 titleColor:[UIColor assistTextColor] block:^(UIButton *button) {
            [weakSelf hideIndexAction];
        }];
        [_hideIndexButton setTitleColor:kBlue100 forState:UIControlStateSelected];
        _hideIndexButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_hideIndexButton setImage:[UIImage subTextImageName:@"lineSelected_0"] forState:UIControlStateNormal];
        [_hideIndexButton setImage:[UIImage mainImageName:@"lineSelected_0"] forState:UIControlStateSelected];
        [_hideIndexButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_hideIndexButton.imageView.size.width, 0, _hideIndexButton.imageView.size.width)];
        [_hideIndexButton setImageEdgeInsets:UIEdgeInsetsMake(0, _hideIndexButton.titleLabel.bounds.size.width, 0, -_hideIndexButton.titleLabel.bounds.size.width)];
    }
    return _hideIndexButton;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 56, kScreen_Height, 8)];
        _topLineView.backgroundColor = [UIColor assistBackgroundColor];
    }
    return _topLineView;
}

@end
