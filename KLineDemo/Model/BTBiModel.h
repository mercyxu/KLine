//
//  BTBiModel.h
//  Bitbt
//
//  Created by iOS on 2019/4/30.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTBiModel : NSObject

@property (nonatomic, copy) NSString *CoinId; //虚拟币1ID

@property (nonatomic, copy) NSString *CoinCode;//虚拟币1编码

@property (nonatomic, copy) NSString *CurrencyId;

@property (nonatomic, copy) NSString *CurrencyCode;//虚拟币2编码

@property (nonatomic, assign) CGFloat LatestPrice;//最新价

@property (nonatomic, copy) NSString *Change; //涨跌幅内容

@property (nonatomic, assign) NSInteger ChangeType; //涨跌类型 1涨  0跌

@property (nonatomic, assign) CGFloat ExchangeAmt; //折算价格(CNY)

@property (nonatomic, assign) CGFloat NewPrice;

@property (nonatomic, copy) NSString *DealAmount24;//24H成交额(CNY)

@property (nonatomic, copy) NSString *SysCurrencyId; //交易对ID

@property (nonatomic, assign) CGFloat CurrencyRate; //CurrencyCode 的汇率

@property (nonatomic, copy) NSString *Price;

@property (nonatomic, assign) CGFloat DealNum;

@property (nonatomic, copy) NSString *Code;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) BOOL isSelect_BTAllEntrustFiltrateView;

@end

NS_ASSUME_NONNULL_END
