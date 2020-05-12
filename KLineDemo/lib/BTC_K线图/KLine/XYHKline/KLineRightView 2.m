//
//  KLineRightView.m
//  Bhex
//
//  Created by YiHeng on 2020/3/22.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "KLineRightView.h"
#import "UIColor+Y_StockChart.h"

@interface KLineRightView ()

/** 标签 */
@property (strong, nonatomic, nullable) XXLabel *priceLabel;

@end

@implementation KLineRightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
//    //如果数组为空，则不进行绘制，直接设置本view为背景
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextClearRect(context, rect);
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//
//
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, (kBlue100).CGColor);
    
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, 0.6);
    
    //设置虚线绘制起点
    CGContextMoveToPoint(currentContext, self.startX, self.height * 0.5);
    
    //设置虚线绘制终点
    CGContextAddLineToPoint(currentContext, self.endX, self.height * 0.5);
    
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {5,2};
    
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}

@end
