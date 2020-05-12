//
//  XXTickerModel.h
//  iOS
//
//  Created by iOS on 2018/6/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXTickerModel : NSObject

/** 时间 */
@property (assign, nonatomic) long t;

/** 最新价 */
@property (strong, nonatomic) NSString *c;

/** 最高价 */
@property (strong, nonatomic) NSString *h;

/** 最低价 */
@property (strong, nonatomic) NSString *l;

/** 开盘价 */
@property (strong, nonatomic) NSString *o;

/** 成交量 */
@property (strong, nonatomic) NSString *v;

#pragma mark - 涨跌幅及法币数据


/** 涨跌幅 */
@property (strong, nonatomic) NSString *rise;

/** 涨跌幅颜色 */
@property (strong, nonatomic) UIColor *riseColor;

@property (strong, nonatomic) NSString *closePrice;

/** 最新价 + 法币 */
@property (strong, nonatomic) NSAttributedString *closeMoney;

/** 获取涨跌幅数据 */
- (void)getRiseWithTokenId:(NSString *)tokenId closeCount:(NSInteger)count;
@end
