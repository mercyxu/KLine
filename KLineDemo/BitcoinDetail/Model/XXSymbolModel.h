//
//  XXCoinPairModel.h
//  iOS
//
//  Created by iOS on 2018/6/26.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXQuoteModel.h"

typedef NS_ENUM(NSInteger, SymbolType) {
    SymbolTypeCoin,          // 币币
    SymbolTypeContract,       // 合约
    SymbolTypeOption         // 期权
};

@interface XXSymbolModel : NSObject

/** 索引 0. 币币 1. 合约 2. 期权  */
@property (assign, nonatomic) SymbolType type;

/** 是否已交割 */
@property (assign, nonatomic) BOOL isDelivered;

/** 是否被选中 */
@property (assign, nonatomic) BOOL isSelect;

/** 币对id */
@property (strong, nonatomic) NSString *symbolId;

/** 币对 */
@property (strong, nonatomic) NSString *symbolName;

/** 交易所id */
@property (strong, nonatomic) NSString *exchangeId;

/** 基础token id */
@property (strong, nonatomic) NSString *baseTokenId;

/** 基础token name */
@property (strong, nonatomic) NSString *baseTokenName;

/** 报价token id */
@property (strong, nonatomic) NSString *quoteTokenId;

/** 报价token name */
@property (strong, nonatomic) NSString *quoteTokenName;

/** 行情合并单位 */
@property (strong, nonatomic) NSString *digitMerge;

/** 默认显示精度 （数量） */
@property (strong, nonatomic) NSString *basePrecision;

/** 默认显示精度 （价格） */
@property (strong, nonatomic) NSString *quotePrecision;

/** 能否交易 */
@property (assign, nonatomic) BOOL canTrade;

/** 是否显示 */
@property (assign, nonatomic) BOOL showStatus;

/** 是否在交易区中 */
@property (assign, nonatomic) BOOL isInTradeSection;

/** 单次交易最小交易base的数量 */
@property (strong, nonatomic) NSString *minTradeQuantity;

/** 最小交易额 */
@property (strong, nonatomic) NSString *minTradeAmount;

/** 每次价格变动，最小的变动单位 */
@property (strong, nonatomic) NSString *minPricePrecision;

/** 是否自选 */
@property (assign, nonatomic) BOOL favorite;

/** 交易最新价输入框是否赋值 */
@property (assign, nonatomic) BOOL isSetPrice;

/** 行情模型 */
@property (strong, nonatomic) XXQuoteModel *quote;

/** <#mark#> */
@property (strong, nonatomic) NSString *firstLevelUnderlyingId;

/** <#mark#> */
@property (strong, nonatomic) NSString *firstLevelUnderlyingName;

/** <#mark#> */
@property (strong, nonatomic) NSString *secondLevelUnderlyingId;

/** <#mark#> */
@property (strong, nonatomic) NSString *secondLevelUnderlyingName;



/** 是否是反向合约 */
@property (assign, nonatomic) BOOL isReverse;

/** 其他cell索引 */
@property (assign, nonatomic) NSInteger indexCell;

@end
