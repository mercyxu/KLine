//
//  XXBDetailCell.h
//  iOS
//
//  Created by iOS on 2018/6/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTradeModel.h"

@interface XXTradeCell : UITableViewCell

/** 价格位数 */
@property (assign, nonatomic) NSInteger priceDigit;

/** 数量位数 */
@property (assign, nonatomic) NSInteger numberDigit;

/** 交易数据模型 */
@property (strong, atomic) XXTradeModel *model;

@end
