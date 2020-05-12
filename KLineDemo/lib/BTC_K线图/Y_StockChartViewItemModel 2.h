//
//  Y_StockChartViewItemModel.h
//  Bhex
//
//  Created by BHEX on 2018/6/15.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y_StockChartConstant.h"

@interface Y_StockChartViewItemModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) Y_StockChartCenterViewType centerViewType;

+ (instancetype)itemModelWithTitle:(NSString *)title type:(Y_StockChartCenterViewType)type;

@end
