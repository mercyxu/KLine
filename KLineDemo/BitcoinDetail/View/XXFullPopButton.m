//
//  XXFullPopButton.m
//  iOS
//
//  Created by iOS on 2018/7/30.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXFullPopButton.h"

@interface XXFullPopButton ()

/** popView */
@property (strong, nonatomic) UIView *popView;

/** popLayer */
@property (strong, nonatomic) CAShapeLayer *popLayer;

@end

@implementation XXFullPopButton

- (void)show {
    self.isShowing = YES;
    self.alpha = 1;
}

- (void)dismiss {
    self.isShowing = NO;
    self.alpha = 0;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.popView];
        
        CGPoint point1 = CGPointMake(self.popView.width/2, self.popView.height);
        CGPoint point2 = CGPointMake(self.popView.width/2 - Kscal(26), self.popView.height - Kscal(30));
        CGPoint point3 = CGPointMake(0, self.popView.height - Kscal(30));
        CGPoint point4 = CGPointMake(0, 0);
        CGPoint point5 = CGPointMake(self.popView.width, 0);
        CGPoint point6 = CGPointMake(self.popView.width, self.popView.height - Kscal(30));
        CGPoint point7 = CGPointMake(self.popView.width/2 + Kscal(26), self.popView.height - Kscal(30));
        CGPoint point8 = CGPointMake(self.popView.width/2, self.popView.height);
        
        
        UIBezierPath *bgPath = [UIBezierPath bezierPath];
        CGFloat radius = 2;
        [bgPath moveToPoint:point1];
        [bgPath addLineToPoint:point2];
        
        [bgPath addArcWithCenter:CGPointMake(point3.x + radius, point3.y - radius) radius:radius startAngle:0.5*M_PI endAngle:1*M_PI clockwise:YES];
        
        [bgPath addArcWithCenter:CGPointMake(point4.x + radius, point4.y + radius) radius:radius startAngle:M_PI endAngle:1.5*M_PI clockwise:YES];
        
        [bgPath addArcWithCenter:CGPointMake(point5.x - radius, point5.y + radius) radius:radius startAngle:1.5*M_PI endAngle:2*M_PI clockwise:YES];
        
        [bgPath addArcWithCenter:CGPointMake(point6.x - radius, point6.y - radius) radius:radius startAngle:0 endAngle:0.5*M_PI clockwise:YES];
        
        [bgPath addLineToPoint:point7];
        [bgPath addLineToPoint:point8];
        self.popLayer.path = [bgPath CGPath];
        [self.popView.layer addSublayer:self.popLayer];
    }
    return self;
}

- (void)setButtonsArray:(NSArray *)buttonsArray {
    _buttonsArray = buttonsArray;
    CGFloat _btnHeight = Kscal(130);
    for (NSInteger i=0; i < buttonsArray.count; i ++) {
        XXButton *itemButton = buttonsArray[i];
        itemButton.frame = CGRectMake(0, _btnHeight*i, self.popView.width, _btnHeight);
        [self.popView addSubview:itemButton];
    }
}

- (UIView *)popView {
    if (_popView == nil) {
        _popView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Height/6 + (kScreen_Height/6 - Kscal(270))/2, kScreen_Width - Kscal(135) - Kscal(550), Kscal(270), Kscal(550))];
    }
    return _popView;
}

- (CAShapeLayer *)popLayer {
    if (_popLayer == nil) {
        _popLayer = [CAShapeLayer new];
        _popLayer.lineWidth = DepthMapLineWidth;
        _popLayer.strokeColor = KLine_Color.CGColor;
        _popLayer.fillColor = (RGBColor(248, 248, 248)).CGColor;
    }
    return _popLayer;
}
@end
