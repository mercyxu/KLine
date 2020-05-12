//
//  XXKlineActionView.m
//  iOS
//
//  Created by iOS on 2018/6/28.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXKlineActionView.h"
#import "UIColor+Y_StockChart.h"

@interface XXKlineActionView ()

/** <#mark#> */
@property (strong, nonatomic) NSMutableArray *oneButtonsArray;

/** 背景框 */
@property (strong, nonatomic) CAShapeLayer *bgLayer;

/** k按钮 */
@property (strong, nonatomic) UIButton *kselectButton;

/** 主视图按钮 */
@property (strong, nonatomic) UIButton *mainSelectButton;

/** 副视图按钮 */
@property (strong, nonatomic) UIButton *fselectButton;

@end

@implementation XXKlineActionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGPoint point1 = CGPointMake(self.width * 4.5 / 7.0, -3);
        CGPoint point2 = CGPointMake(self.width * 4.5 / 7.0 - Kscal(30), Kscal(35));
        CGPoint point3 = CGPointMake(Kscal(35), Kscal(35));
        CGPoint point4 = CGPointMake(Kscal(35), Kscal(475));
        CGPoint point5 = CGPointMake(kScreen_Width - Kscal(35), Kscal(475));
        CGPoint point6 = CGPointMake(kScreen_Width - Kscal(35), Kscal(35));
        CGPoint point7 = CGPointMake(self.width * 4.5 / 7.0 + Kscal(30), Kscal(35));
        CGPoint point8 = CGPointMake(self.width * 4.5 / 7.0, -3);
        
        UIBezierPath *bgPath = [UIBezierPath bezierPath];
        CGFloat radius = 2;
        [bgPath moveToPoint:point1];
        [bgPath addLineToPoint:point2];
        
        [bgPath addArcWithCenter:CGPointMake(point3.x + radius, point3.y + radius) radius:radius startAngle:1.5*M_PI endAngle:M_PI clockwise:NO];
        
        [bgPath addArcWithCenter:CGPointMake(point4.x + radius, point4.y - radius) radius:radius startAngle:1*M_PI endAngle:0.5*M_PI clockwise:NO];
        
        [bgPath addArcWithCenter:CGPointMake(point5.x - radius, point5.y - radius) radius:radius startAngle:0.5*M_PI endAngle:0 clockwise:NO];
        
        [bgPath addArcWithCenter:CGPointMake(point6.x - radius, point6.y + radius) radius:radius startAngle:0 endAngle:1.5*M_PI clockwise:NO];
        
        [bgPath addLineToPoint:point7];
        [bgPath addLineToPoint:point8];
        self.bgLayer.path = [bgPath CGPath];
        [self.layer addSublayer:self.bgLayer];
        
//        self.backgroundColor = [UIColor assistBackgroundColor];
        [self setupUI];
    }
    return self;
}

- (void)show {
    
    self.hidden = NO;
    self.isShow = YES;
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.height = Kscal(475);
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.isShow = NO;
        self.height = 0;
    }];
}

- (void)reloadUI {
    
    CGFloat offetY = Kscal(55);
    CGFloat left = Kscal(235);
    CGFloat _btnWith = (kScreen_Width - Kscal(280)) / 5;
    CGFloat _btnHeight = Kscal(100);
    for (NSInteger i=0; i < self.oneButtonsArray.count; i ++) {
        XXButton *itemButton = self.oneButtonsArray[i];
        itemButton.frame = CGRectMake(left + _btnWith*(i%5), offetY + _btnHeight*(i/5), _btnWith, _btnHeight);
        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:itemButton];
    }
    
    // 主图
    offetY = Kscal(255);
    for (NSInteger i=0; i < self.mainButtonsArray.count; i ++) {
        XXButton *itemButton = self.mainButtonsArray[i];
        itemButton.frame = CGRectMake(left + _btnWith*i, offetY + _btnHeight*(i/5), _btnWith, _btnHeight);
        [self addSubview:itemButton];
        
        if (i==3) {
            itemButton.left = left + _btnWith*4;
        }
    }
    
    // 副图
    offetY = Kscal(355);
    for (NSInteger i=0; i < self.fButtonsArray.count; i ++) {
        XXButton *itemButton = self.fButtonsArray[i];
        itemButton.frame = CGRectMake(left + _btnWith*i, offetY + _btnHeight*(i/5), _btnWith, _btnHeight);
        [self addSubview:itemButton];
        if (i==2) {
            itemButton.left = left + _btnWith*4;
        }
    }
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    // 1. 创建K线图分类
    self.kButtonsArray = [NSMutableArray array];
    self.oneButtonsArray = [NSMutableArray array];
    self.kMainButtonsArray = [NSMutableArray array];
    NSArray *knamesArray = @[LocalizedString(@"Time"),
                             LocalizedString(@"1min"),
                             LocalizedString(@"5min"),
                             LocalizedString(@"15min"),
                             LocalizedString(@"30min"),
                             LocalizedString(@"1hour"),
                             LocalizedString(@"2hour"),
                             LocalizedString(@"4hour"),
                             LocalizedString(@"6hour"),
                             LocalizedString(@"12hour"),
                             LocalizedString(@"1day"),
                             LocalizedString(@"1week"),
                             LocalizedString(@"1mon")];
    
    CGFloat offetY = Kscal(55);
    XXLabel *klabel = [XXLabel labelWithFrame:CGRectMake(K375(24), offetY, Kscal(200), Kscal(100)) text:LocalizedString(@"Candles") font:kFontBold14 textColor:[UIColor mainTextColor] alignment:NSTextAlignmentLeft];
    [self addSubview:klabel];
    
    
    CGFloat _btnWith = (kScreen_Width - Kscal(280)) / 5;
    CGFloat _btnHeight = Kscal(100);
    CGFloat _btnOriginalX = 88;
    for (NSInteger i=0; i < knamesArray.count; i ++) {
        KWeakSelf
        XXButton *itemButton = [XXButton buttonWithFrame:CGRectMake(_btnOriginalX + _btnWith*(i%5), offetY + _btnHeight*(i/5), _btnWith, _btnHeight) title:knamesArray[i] font:kFontBold12 titleColor:[UIColor assistTextColor] block:^(UIButton *button) {
        
            weakSelf.kselectButton.selected = NO;
            weakSelf.kselectButton = button;
            weakSelf.kselectButton.selected = YES;
            [weakSelf dismiss];
            [weakSelf actionButtonClick:button];
        }];
        itemButton.tag = i + 1;
        [itemButton setTitleColor:kBlue100 forState:UIControlStateSelected];
        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.kButtonsArray addObject:itemButton];
        
        if (i == [KDetail.klineIndex integerValue] - 1) {
            itemButton.selected = YES;
            self.kselectButton = itemButton;
        }
        
        if (i == 3 || i == 5 || i == 7 || i == 10 ) {
            [self.kMainButtonsArray addObject:itemButton];
        } else {
            [self.oneButtonsArray addObject:itemButton];
        }
    }
    
    for (NSInteger i=0; i < self.oneButtonsArray.count; i ++) {
        XXButton *itemButton = self.oneButtonsArray[i];
        itemButton.frame = CGRectMake(_btnOriginalX + _btnWith*(i%5), offetY + _btnHeight*(i/5), _btnWith, _btnHeight);
        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:itemButton];
    }
  
    // 主图
    offetY = Kscal(255);
    self.mainButtonsArray = [NSMutableArray array];
    NSArray *mainNamesArray = @[@"MA", @"EMA", @"BOLL", LocalizedString(@"Hide")];
    XXLabel *mainlabel = [XXLabel labelWithFrame:CGRectMake(klabel.left, offetY, klabel.width, Kscal(100)) text:LocalizedString(@"MainGraph") font:kFontBold12 textColor:[UIColor mainTextColor] alignment:NSTextAlignmentLeft];
    [self addSubview:mainlabel];
    
    for (NSInteger i=0; i < mainNamesArray.count; i ++) {
        KWeakSelf
        XXButton *itemButton = [XXButton buttonWithFrame:CGRectMake(_btnOriginalX + _btnWith*i, offetY,  _btnWith, _btnHeight) title:mainNamesArray[i] font:kFont14 titleColor:[UIColor assistTextColor] block:^(UIButton *button) {
            weakSelf.mainSelectButton.selected = NO;
            weakSelf.mainSelectButton = button;
            weakSelf.mainSelectButton.selected = YES;
            [weakSelf dismiss];
            [weakSelf actionButtonClick:button];
        }];
        itemButton.tag = i + 103;
        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [itemButton setTitleColor:kBlue100 forState:UIControlStateSelected];
        [self addSubview:itemButton];
        [self.mainButtonsArray addObject:itemButton];
        
        if (i==3) {
            itemButton.left = _btnOriginalX + _btnWith*4;
            itemButton.titleLabel.font = kFont12;
        }
        
        if (itemButton.tag == [KDetail.klineMainIndex integerValue]) {
            itemButton.selected = YES;
            self.mainSelectButton = itemButton;
        }
    }
    
    // 副图
    offetY = Kscal(355);
    self.fButtonsArray = [NSMutableArray array];
    NSArray *fNamesArray = @[@"MACD", @"KDJ", LocalizedString(@"Hide")];
    XXLabel *flabel = [XXLabel labelWithFrame:CGRectMake(klabel.left, offetY, klabel.width, Kscal(100)) text:LocalizedString(@"AuxiliaryGraph") font:kFontBold14 textColor:[UIColor mainTextColor] alignment:NSTextAlignmentLeft];
    [self addSubview:flabel];
    
//    UIView *fLineView = [[UIView alloc] initWithFrame:CGRectMake(lineView.left, offetY + Kscal(25), lineView.width, Kscal(50))];
//    fLineView.backgroundColor = KLine_Color;
//    [self addSubview:fLineView];
    
    for (NSInteger i=0; i < fNamesArray.count; i ++) {
        KWeakSelf
        XXButton *itemButton = [XXButton buttonWithFrame:CGRectMake(_btnOriginalX + _btnWith*i, offetY,  _btnWith, _btnHeight) title:fNamesArray[i] font:kFontBold12 titleColor:[UIColor assistTextColor] block:^(UIButton *button) {
            weakSelf.fselectButton.selected = NO;
            weakSelf.fselectButton = button;
            weakSelf.fselectButton.selected = YES;
            [weakSelf dismiss];
            [weakSelf actionButtonClick:button];
        }];
        itemButton.tag = i + 100;
        [itemButton setTitleColor:kBlue100 forState:UIControlStateSelected];
        itemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:itemButton];
        [self.fButtonsArray addObject:itemButton];
        
        if (i==2) {
            itemButton.left = _btnOriginalX + _btnWith*4;
        }
        
        if (itemButton.tag == [KDetail.klineAccessoryIndex integerValue]) {
            itemButton.selected = YES;
            self.fselectButton = itemButton;
        }
    }
    
}

- (void)actionButtonClick:(UIButton *)sender {
    
    if (self.kActionBlock) {
        self.kActionBlock(sender.tag);
    }

    if (sender.tag > 1  && sender.tag < 6) {
        self.minuteButton.selected = YES;
        [self.minuteButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
        
        [_minuteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_minuteButton.imageView.size.width, 0, _minuteButton.imageView.size.width)];
        [_minuteButton setImageEdgeInsets:UIEdgeInsetsMake(0, _minuteButton.titleLabel.bounds.size.width, 0, -_minuteButton.titleLabel.bounds.size.width)];
        [self.minuteButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        
    } else if (sender.tag == 1 || (sender.tag >= 6 && sender.tag <= 9)) {
        self.minuteButton.selected = NO;
    }
}

- (CAShapeLayer *)bgLayer {
    if (_bgLayer == nil) {
        _bgLayer = [CAShapeLayer new];
        _bgLayer.lineWidth = DepthMapLineWidth;
        _bgLayer.strokeColor = [UIColor assistTextColor].CGColor;
        _bgLayer.fillColor = [UIColor backgroundColor].CGColor;
    }
    return _bgLayer;
}
@end
