//
//  XYHKLineView.h
//  Bhex
//
//  Created by BHEX on 2018/6/19.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_KLineModel.h"
#import "Y_StockChartConstant.h"

@protocol XYHKLineViewDelegate <NSObject>

@optional

/**
 *  当前需要绘制的K线模型数组
 */
- (void)currentNeedDrawKLineModels:(NSArray *)needDrawKLineModels;

@end


@interface XYHKLineView : UIView

/** 代理 */
@property (weak, nonatomic) id<XYHKLineViewDelegate>delegate;

/**
 *  第一个View的高所占比例
 */
@property (nonatomic, assign) CGFloat mainViewRatio;

/**
 *  第二个View(成交量)的高所占比例
 */
@property (nonatomic, assign) CGFloat volumeViewRatio;

/**
 *  数据
 */
@property(nonatomic, copy) NSArray<Y_KLineModel *> *kLineModels;

/**
 *  重绘
 */
- (void)reDraw;


/**
 *  K线类型
 */
@property (nonatomic, assign) Y_StockChartCenterViewType MainViewType;

/**
 *  Accessory指标种类
 */
@property (nonatomic, assign) Y_StockChartTargetLineStatus targetLineStatus;

- (void)addkLineData:(id)data;
- (void)updateLineData:(id)data;
- (void)reloadLineLocation;
@end
