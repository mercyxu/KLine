//
//  Y_SmallKLineView.h
//  Bhex
//
//  Created by BHEX on 2018/6/15.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_StockChartConstant.h"
#import "Y_StockChartViewItemModel.h"
//种类
typedef NS_ENUM(NSInteger, Y_KLineType) {
    KLineTypeTimeShare = 1,
    KLineType1Min,
    KLineType3MIn,
    KLineType5Min,
    KLineType10Min,
    KLineType15Min,
    KLineType30Min,
    KLineType1Hour,
    KLineType2Hour,
    KLineType4Hour,
    KLineType6Hour,
    KLineType12Hour,
    KLineType1Day,
    KLineType3Day,
    KLineType1Week
};

/**
 *  Y_StockChartView数据源
 */
@protocol Y_StockChartViewDataSource <NSObject>

-(id) stockDatasWithIndex:(NSInteger)index;

@end

// 代理
@protocol Y_SmallKLineViewDelegate <NSObject>

@optional

/**
 *  当前需要绘制的K线模型数组
 */
- (void)currentNeedDrawKLineModels:(NSArray *)needDrawKLineModels;

@end

@interface Y_SmallKLineView : UIView

@property (nonatomic, strong) NSArray *itemModels;

/** 代理 */
@property (weak, nonatomic) id <Y_SmallKLineViewDelegate>delegate;

/**
 *  数据源
 */
@property (nonatomic, weak) id<Y_StockChartViewDataSource> dataSource;

- (void)clickSegmentButtonIndex:(NSInteger)index;

- (void)addkLineData:(id)data;
- (void)updateLineData:(id)data;
- (void)reloadLineLocation;
@end

