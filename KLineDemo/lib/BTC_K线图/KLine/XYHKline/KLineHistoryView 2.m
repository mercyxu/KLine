//
//  KLineHistoryView.m
//  Bhex
//
//  Created by YiHeng on 2020/3/22.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "KLineHistoryView.h"
#import "UIColor+Y_StockChart.h"

@implementation KLineHistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, [UIColor assistTextColor].CGColor);
    
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, 0.6);
    
    //设置虚线绘制起点
    CGContextMoveToPoint(currentContext, 0, self.height * 0.5);
    
    //设置虚线绘制终点
    CGContextAddLineToPoint(currentContext, self.width, self.height * 0.5);
    
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {5,2};
    
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}


@end
