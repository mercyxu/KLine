//
//  Y_SmallKLineView.m
//  iOS
//
//  Created by iOS on 2018/6/15.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "Y_SmallKLineView.h"
#import "XYHKLineView.h"
#import "Masonry.h"
#import "Y_StockChartGlobalVariable.h"

@interface Y_SmallKLineView () <XYHKLineViewDelegate>

/**
 *  K线图View
 */
@property (nonatomic, strong) XYHKLineView *kLineView;

/**
 *  图表类型
 */
@property(nonatomic,assign) Y_StockChartCenterViewType currentCenterViewType;

@end

@implementation Y_SmallKLineView

- (XYHKLineView *)kLineView
{
    if(!_kLineView)
    {
        _kLineView = [XYHKLineView new];
        _kLineView.delegate = self;
        [self addSubview:_kLineView];
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _kLineView;
}

- (void)setDataSource:(id<Y_StockChartViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _currentCenterViewType = Y_StockChartcenterViewTypeKline;
}

- (void)currentNeedDrawKLineModels:(NSArray *)needDrawKLineModels {
    if ([self.delegate respondsToSelector:@selector(currentNeedDrawKLineModels:)]) {
        [self.delegate currentNeedDrawKLineModels:needDrawKLineModels];
    }
}

#pragma mark - 代理方法

- (void)clickSegmentButtonIndex:(NSInteger)index
{
    
    if(index >= 100) {
        
        if (index > 102) {
            [Y_StockChartGlobalVariable setMainViewLineStatus:index];
        }
        self.kLineView.targetLineStatus = index;
        [self.kLineView reDraw];
        
    } else {
        if(self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)])
        {
            id stockData = [self.dataSource stockDatasWithIndex:index];
            
            if(!stockData)
            {
                return;
            }

            Y_StockChartCenterViewType type;
            
            // 1. 分时 2. 1分 3. 5分 等等
            if (index == 1) {
                type = Y_StockChartcenterViewTypeTimeLine;
            } else {
                type = Y_StockChartcenterViewTypeKline;
            }
            
            if(type != self.currentCenterViewType)
            {
                //移除当前View，设置新的View
                self.currentCenterViewType = type;
                switch (type) {
                    case Y_StockChartcenterViewTypeKline:
                    {
                        self.kLineView.hidden = NO;
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            if(type == Y_StockChartcenterViewTypeOther)
            {
                
            } else {
                self.kLineView.MainViewType = type;
                self.kLineView.kLineModels = (NSArray *)stockData;
                [self.kLineView reDraw];
            }
        }
    }
    
}

- (void)addkLineData:(id)data {
    [self.kLineView addkLineData:data];
}
- (void)updateLineData:(id)data {
    [self.kLineView updateLineData:data];
}

- (void)reloadLineLocation {
    [self.kLineView reloadLineLocation];
}
@end

