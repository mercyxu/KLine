//
//  BTDealMarketModel.h
//  Bitbt
//
//  Created by iOS on 2019/5/10.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTDealMarketModel : NSObject

@property (nonatomic, copy) NSString *CoinID;

@property (nonatomic, copy) NSString *CurrencyID;

@property (nonatomic, copy) NSString *NewPrice;//最新价

@property (nonatomic, assign) CGFloat HighestPrice;//最高价

@property (nonatomic, assign) CGFloat LowestPrice;//最低价

@property (nonatomic, assign) CGFloat OpenPrice;//开盘价

@property (nonatomic, assign) CGFloat DealNum;

@property (nonatomic, assign) CGFloat SumNum;//24H

@property (nonatomic, copy) NSString *Change;//涨跌

@property (nonatomic, assign) NSInteger rote;//1涨  2跌

@property (nonatomic, assign) NSInteger ChangeType;

@property (nonatomic, copy) NSString *CoinCode;

@property (nonatomic, copy) NSString *CurrencyCode;

@property (nonatomic, copy) NSString *symbol;//兑换单位

@property (nonatomic, assign) NSInteger NumDecimal;//交易数量显示小数点

@property (nonatomic, assign) NSInteger PriceDecimal; //交易价格显示小数点

@property (nonatomic, assign) NSInteger TotalDecimal; //金额显示小数点

@end

NS_ASSUME_NONNULL_END
