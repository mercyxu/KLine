//
//  Y-StockChartView.h
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_StockChartConstant.h"

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
 *  Y_StockChartView代理
 */
@class Y_KLineView;
@protocol Y_StockChartViewDelegate <NSObject>

- (void)onClickFullScreenButtonWithTimeType:(Y_StockChartCenterViewType )timeType;

@end



/**
 *  Y_StockChartView数据源
 */
@protocol Y_StockChartViewDataSource <NSObject>

-(id) stockDatasWithIndex:(NSInteger)index;

@end


@interface Y_StockChartView : UIView

/**
 *  K线图View
 */
@property (nonatomic, strong) Y_KLineView *kLineView;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, assign) BOOL isMoreTimeDataUpdate;

@property (nonatomic, strong) NSArray *itemModels;

@property (nonatomic, strong) NSArray *moreItemModels;

@property (nonatomic, strong) NSArray *indicatorItemModels;


@property (nonatomic, weak) id<Y_StockChartViewDelegate> delegate;

/**
 *  数据源
 */
@property (nonatomic, weak) id<Y_StockChartViewDataSource> dataSource;

/**
 *  当前选中的索引
 */
@property (nonatomic, assign,readonly) Y_KLineType currentLineTypeIndex;


@property (nonatomic, assign) Y_StockChartTargetLineStatus targetLineStatus;


-(void) reloadData;

//指标点击
- (void)fullScreenTargetClickWithIndex:(NSInteger)index;

@end

/************************ItemModel类************************/
@interface Y_StockChartViewItemModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) Y_StockChartCenterViewType centerViewType;

+ (instancetype)itemModelWithTitle:(NSString *)title type:(Y_StockChartCenterViewType)type;

@end
