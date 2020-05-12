//
//  KLineLastPriceView.m
//  Bhex
//
//  Created by YiHeng on 2020/3/22.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "KLineLastPriceView.h"
#import "UIColor+Y_StockChart.h"

@interface KLineLastPriceView ()

/** 标签 */
@property (strong, nonatomic, nullable) XXLabel *priceLabel;

/** 三角 */
@property (strong, nonatomic) CAShapeLayer *sanJiaoLayer;

@end

@implementation KLineLastPriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor assistBackgroundColor];
        self.layer.cornerRadius = self.height / 2.0;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor assistTextColor].CGColor;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        
        [self addSubview:self.priceLabel];
        [self.layer addSublayer:self.sanJiaoLayer];
    }
    return self;
}

- (void)setClosePrice:(NSString *)closePrice {
    _closePrice = closePrice;
    if (IsEmpty(closePrice)) {
        return;
    }
    
    CGFloat labelWidth = [NSString widthWithText:_closePrice font:kFont10] + 10;
    self.priceLabel.width = labelWidth;
    self.width = labelWidth + 10 + 3;
    self.priceLabel.text =  _closePrice;
    
    CGFloat leftX = CGRectGetMaxX(self.priceLabel.frame);
    CGPoint point1 = CGPointMake(leftX, self.height / 2.0f - 3.5f);
    CGPoint point2 = CGPointMake(leftX + 4, self.height / 2.0f);
    CGPoint point3 = CGPointMake(leftX, self.height / 2.0f + 3.5f);
    
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    [bgPath moveToPoint:point1];
    [bgPath addLineToPoint:point2];
    [bgPath addLineToPoint:point3];
    self.sanJiaoLayer.path = [bgPath CGPath];
}

#pragma mark - || 懒加载
/** 标签 */
- (XXLabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [XXLabel labelWithFrame:CGRectMake(3, 0, 10, self.height) font:kFont10 textColor:[UIColor assistTextColor]];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.userInteractionEnabled = NO;
    }
    return _priceLabel;
}

- (CAShapeLayer *)sanJiaoLayer {
    if (_sanJiaoLayer == nil) {
        _sanJiaoLayer = [CAShapeLayer new];
        _sanJiaoLayer.lineWidth = 0;
        _sanJiaoLayer.strokeColor = [UIColor assistTextColor].CGColor;
        _sanJiaoLayer.fillColor = [UIColor assistTextColor].CGColor;
    }
    return _sanJiaoLayer;
}
@end
