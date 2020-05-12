//
//  BTMarketModel.h
//  Bitbt
//
//  Created by iOS on 2019/5/9.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BTDealMarketModel;
@interface BTMarketModel : NSObject

@property (nonatomic, copy) NSString *CurrencyId;

@property (nonatomic, copy) NSString *CurrencyCode;

@property (nonatomic, strong) NSArray *ProTradeDataReportList;

@property (nonatomic, assign) CGFloat CoinPrice;

@property (nonatomic, assign) CGFloat CurrencyPrice; //汇率

@property (nonatomic, copy) NSString *PushIP;

@property (nonatomic, strong) BTDealMarketModel *DealMarket;

@property (nonatomic, assign) BOOL isSelect_BTAllEntrustFiltrateView;

@end

NS_ASSUME_NONNULL_END
