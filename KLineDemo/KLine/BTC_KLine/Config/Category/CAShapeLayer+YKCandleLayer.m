//
//  CAShapeLayer+YKCandleLayer.m
//  kLineDemo
//
//  Created by duanmu on 2018/8/8.
//  Copyright © 2018年 duanmu. All rights reserved.
//

#import "CAShapeLayer+YKCandleLayer.h"
#import <UIKit/UIKit.h>
#import "UIColor+Y_StockChart.h"

@implementation CAShapeLayer (YKCandleLayer)


/**
 生成蜡烛Layer

 @param model 蜡烛坐标模型
 @return 返回layer
 */
+ (CAShapeLayer *)fl_getCandleLayerWithPointModel:(Y_KLinePositionModel *)model candleWidth:(CGFloat)candleWidth {
    //判断是否为涨跌
    BOOL isRed = (model.ClosePoint.y - model.OpenPoint.y < 0) ? YES : NO;
    
    CGPoint candlePoint = CGPointMake(isRed ? model.ClosePoint.x : model.OpenPoint.x, isRed ? model.ClosePoint.y : model.OpenPoint.y);
    
    CGRect candleFrame = CGRectMake(candlePoint.x - candleWidth/2 , candlePoint.y, candleWidth, ABS(model.OpenPoint.y - model.ClosePoint.y));
    //    NSLog(@"%@",NSStringFromCGRect(candleFrame));
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:candleFrame];
    
    //    //绘制上下影线
    [path moveToPoint:model.LowPoint];
    [path addLineToPoint:model.HighPoint];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0f;
    
    //判断涨跌来设置颜色
    if (model.OpenPoint.y - model.ClosePoint.y < 0) {
        //跌，设置红色
        layer.strokeColor = [UIColor decreaseColor].CGColor;
        layer.fillColor = [UIColor decreaseColor].CGColor;
    } 
    else {
        //不跌
        layer.strokeColor = [UIColor increaseColor].CGColor;
        layer.fillColor = [UIColor increaseColor].CGColor;
    }
    return layer;
}

+ (CAShapeLayer *)fl_getRectangleLayerWithFrame:(CGRect)rectangleFrame backgroundColor:(UIColor *)bgColor {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rectangleFrame];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0f;
    layer.strokeColor = bgColor.CGColor;
    layer.fillColor = bgColor.CGColor;
    return layer;
}
@end
