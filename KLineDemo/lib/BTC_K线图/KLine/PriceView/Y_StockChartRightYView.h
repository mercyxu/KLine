//
//  Y_StockChartRightYView.h
//  BTC-Kline
//
//  Created by yate1996 on 16/5/3.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Y_StockChartRightYView : UIView
@property(nonatomic,assign) double maxValue;

@property(nonatomic,assign) double middleValue;

@property(nonatomic,assign) double minValue;

@property(nonatomic,copy) NSString *minLabelText;

@property(nonatomic,strong) UILabel *maxValueLabel;

@property(nonatomic,strong) UILabel *middleValueLabel;

@property(nonatomic,strong) UILabel *minValueLabel;


@end
