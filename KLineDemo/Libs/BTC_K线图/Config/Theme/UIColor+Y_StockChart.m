//
//  UIColor+Y_StockChart.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "UIColor+Y_StockChart.h"

@implementation UIColor (Y_StockChart)

+ (UIColor *)colorWithRGiOS:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

#pragma mark 所有图表的背景颜色
+(UIColor *)backgroundColor
{
    return RGBColor(19,31,48);
}

#pragma mark 辅助背景色
+(UIColor *)assistBackgroundColor
{
    return RGBColor(8,23,36);
}

#pragma mark 线条颜色
+(UIColor *)lineColor {
    return RGBColor(27, 40, 60);
}

#pragma mark 涨的颜色
+(UIColor *)increaseColor
{
    return kGreen100;
}

#pragma mark 跌的颜色
+(UIColor *)decreaseColor
{
    return kRed100;
}

#pragma mark 主文字颜色
+(UIColor *)mainTextColor
{
    return RGBColor(219, 225, 248);
}

#pragma mark 辅助文字颜色
+(UIColor *)assistTextColor
{
    return RGBColor(110, 133, 165);
}

#pragma mark 分时线下面的成交量线的颜色
+(UIColor *)timeLineVolumeLineColor
{
    return [UIColor colorWithRGiOS:0x2d333a];
}

#pragma mark 分时线界面线的颜色
+(UIColor *)timeLineLineColor
{
    return [UIColor colorWithRGiOS:0x49a5ff];
}

#pragma mark 长按时线的颜色
+(UIColor *)longPressLineColor
{
    return [UIColor colorWithRGiOS:0x919598];
}

#pragma mark ma5的颜色
+(UIColor *)ma5Color {
    return RGBColor(243, 217, 145);
}

#pragma mark ma10的颜色
+(UIColor *)ma10Color {
    return RGBColor(96, 207, 190);
}

#pragma mark ma7的颜色
+(UIColor *)ma7Color
{
    return [UIColor colorWithRGiOS:0xff783c];
}

#pragma mark ma30颜色
+(UIColor *)ma30Color
{
    return RGBColor(201, 145, 252);
}

#pragma mark BOLL_MB的颜色
+(UIColor *)BOLL_MBColor
{
    return RGBColor(243, 217, 145);
}

#pragma mark BOLL_UP的颜色
+(UIColor *)BOLL_UPColor
{
    return RGBColor(96, 207, 190);
}

#pragma mark BOLL_DN的颜色
+(UIColor *)BOLL_DNColor
{
    return RGBColor(201, 145, 252);
}


@end
