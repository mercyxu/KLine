//
//  XXEntrustmentOrderCell.h
//  iOS
//
//  Created by iOS on 2018/6/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXDepthOrderModel.h"

@interface XXDepthCell : UITableViewCell

@property (assign, nonatomic) BOOL isAmount;

/** 平均值 */
@property (assign, nonatomic) CGFloat ordersAverage;

/** 数据模型 */
@property (strong, nonatomic, nullable) XXDepthOrderModel *model;

- (void)reloadData;
@end
