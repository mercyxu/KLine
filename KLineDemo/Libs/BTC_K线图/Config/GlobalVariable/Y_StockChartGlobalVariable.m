//
//  Y_StockChartGlobalVariable.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//
#import "Y_StockChartGlobalVariable.h"

/**
 *  K线图的宽度，默认20
 */
static CGFloat Y_StockChartKLineWidth = 7;

/**
 *  K线图的间隔，默认1
 */
static CGFloat Y_StockChartKLineGap = 1;


/**
 *  MainView的高度占比,默认为0.5
 */
static CGFloat Y_StockChartKLineMainViewRadio = 0.6;

/**
 *  VolumeView的高度占比,默认为0.5
 */
static CGFloat Y_StockChartKLineVolumeViewRadio = 0.2;


/**
 *  主视图指标
 */
static Y_StockChartTargetLineStatus Y_StockChartKLineMainViewType = Y_StockChartTargetLineStatusMA;


@implementation Y_StockChartGlobalVariable

/**
 *  K线图的宽度，默认20
 */
+(CGFloat)kLineWidth
{
    return Y_StockChartKLineWidth;
}
+(void)setkLineWith:(CGFloat)kLineWidth
{
    if (kLineWidth > Y_StockChartKLineMaxWidth) {
        kLineWidth = Y_StockChartKLineMaxWidth;
    }else if (kLineWidth < Y_StockChartKLineMinWidth){
        kLineWidth = Y_StockChartKLineMinWidth;
    }
    Y_StockChartKLineWidth = kLineWidth;
}


/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap
{
    return Y_StockChartKLineGap;
}

+(void)setkLineGap:(CGFloat)kLineGap
{
    Y_StockChartKLineGap = kLineGap;
}

/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRadio
{
    return Y_StockChartKLineMainViewRadio;
}
+ (void)setkLineMainViewRadio:(CGFloat)radio
{
    Y_StockChartKLineMainViewRadio = radio;
}

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRadio
{
    return Y_StockChartKLineVolumeViewRadio;
}
+ (void)setkLineVolumeViewRadio:(CGFloat)radio
{
    Y_StockChartKLineVolumeViewRadio = radio;
}

/**
 *  主图指标
 */
+ (CGFloat)mainViewLineStatus {
    return Y_StockChartKLineMainViewType;
}
+ (void)setMainViewLineStatus:(Y_StockChartTargetLineStatus)type {
    Y_StockChartKLineMainViewType = type;
}

@end
