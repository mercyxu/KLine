//
//  KLineTransverseLine.m
//  Bhex
//
//  Created by YiHeng on 2020/3/22.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "KLineTransverseLine.h"
#import "UIColor+Y_StockChart.h"

@interface KLineTransverseLine ()

/** 线条 */
@property (strong, nonatomic, nullable) UIView *lineView;

/** 点 */
@property (strong, nonatomic, nullable) UIView *pointView;

/** 背景框 */
@property (strong, nonatomic) CAShapeLayer *bgLayer;

/** 价格标签 */
@property (strong, nonatomic, nullable) XXLabel *priceLabel;

@end

@implementation KLineTransverseLine

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.lineView];
        [self addSubview:self.pointView];
        [self.layer addSublayer:self.bgLayer];
        [self addSubview:self.priceLabel];
    }
    return self;
}

#pragma mark - 1. 设置最新价
- (void)setPointPrice:(NSString *)pointPrice centerX:(CGFloat)centerX isRight:(BOOL)isRight {
    
    self.pointView.centerX = centerX;
    CGFloat labelWidth = [NSString widthWithText:pointPrice font:kFont10] + 5;
    self.priceLabel.text = pointPrice;
    self.priceLabel.width = labelWidth;
    self.lineView.width = self.width;
    
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    CGPoint point4;
    CGPoint point5;
    CGPoint point6;
    
    CGFloat jianWidth = 12;
    if (isRight) {
        self.priceLabel.left = self.width - labelWidth;
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        CGFloat startX = self.width - labelWidth - jianWidth;
        point1 = CGPointMake(startX, self.height / 2.0);
        point2 = CGPointMake(startX + jianWidth, 0);
        point3 = CGPointMake(self.width - 0.5, 0);
        point4 = CGPointMake(self.width - 0.5, self.height);
        point5 = CGPointMake(startX + jianWidth, self.height);
        point6 = CGPointMake(startX, self.height / 2.0);
        
    } else {
        self.priceLabel.left = 0;
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        CGFloat startX = labelWidth + jianWidth;
        point1 = CGPointMake(startX, self.height / 2.0);
        point2 = CGPointMake(startX - jianWidth, 0);
        point3 = CGPointMake(0.5, 0);
        point4 = CGPointMake(0.5, self.height);
        point5 = CGPointMake(startX - jianWidth, self.height);
        point6 = CGPointMake(startX, self.height / 2.0);
    }
    
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    [bgPath moveToPoint:point1];
    [bgPath addLineToPoint:point2];
    [bgPath addLineToPoint:point3];
    [bgPath addLineToPoint:point4];
    [bgPath addLineToPoint:point5];
    [bgPath addLineToPoint:point6];
    self.bgLayer.path = [bgPath CGPath];
}

#pragma mark - || 懒加载
/** 线条 */
- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 0.5) / 2, kScreen_Width, 0.5)];
        _lineView.backgroundColor = [UIColor longPressLineColor];
    }
    return _lineView;
}

/** 点 */
- (UIView *)pointView {
    if (_pointView == nil) {
        _pointView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height - 5.0f)/2.0f, 5, 5)];
        _pointView.backgroundColor = [UIColor mainTextColor];
        _pointView.layer.cornerRadius = _pointView.height / 2.0f;
        _pointView.layer.masksToBounds = YES;
    }
    return _pointView;
}

- (CAShapeLayer *)bgLayer {
    if (_bgLayer == nil) {
        _bgLayer = [CAShapeLayer new];
        _bgLayer.lineWidth = DepthMapLineWidth;
        _bgLayer.strokeColor = [UIColor mainTextColor].CGColor;
        _bgLayer.fillColor = [UIColor assistBackgroundColor].CGColor;
    }
    return _bgLayer;
}

/** 价格标签 */
- (XXLabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [XXLabel labelWithFrame:CGRectMake(0, 0, 0, self.height) font:kFont10 textColor:[UIColor mainTextColor]];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}
@end
