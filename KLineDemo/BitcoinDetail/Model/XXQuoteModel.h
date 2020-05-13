//
//  XXQuoteModel.h
//  iOS
//
//  Created by iOS on 2018/6/26.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXQuoteModel : NSObject

/** 行情时间 */
@property (strong, nonatomic) NSString *time;

/** 24h 最新价 */
@property (strong, nonatomic) NSString *close;

/** 24h 最高价 */
@property (strong, nonatomic) NSString *high;

/** 24h 最低价 */
@property (strong, nonatomic) NSString *low;

/** 24h  开盘价 */
@property (strong, nonatomic) NSString *open;

/** 24h 成交量 */
@property (strong, nonatomic) NSString *volume;

/** 最新价 */
@property (assign, nonatomic) double sortClose;

/** 24h 成交量 */
@property (assign, nonatomic) double sortVolume;

/** 涨跌幅 */
@property (assign, nonatomic) double sortChangedRate;

- (void)initSortData;

@end
