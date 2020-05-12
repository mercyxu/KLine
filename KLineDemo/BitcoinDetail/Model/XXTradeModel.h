//
//  XXTradeModel.h
//  iOS
//
//  Created by iOS on 2018/6/14.
//  Copyright © 2018年 iOS. All rights reserved.
//   【交易数据模型】

#import <Foundation/Foundation.h>

@interface XXTradeModel : NSObject

/** 时间 */
@property (assign, nonatomic) long t;

/** 价格 */
@property (strong, nonatomic) NSString *p;

/** 成交量 */
@property (strong, nonatomic) NSString *q;

/** 是否卖 true is buy, flase is sell */
@property (assign, nonatomic) BOOL m;

@end
