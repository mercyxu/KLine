//
//  XXTradeData.h
//  iOS
//
//  Created by iOS on 2019/1/8.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XXSymbolModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol XXTradeDataDelegate <NSObject>

@optional

/** 行情数据 */
- (void)tradeQuoteData:(NSDictionary *)quoteDta;

/** 盘口20条列表 */
- (void)tradeDepthListData:(NSDictionary *)listData;

/** 清理数据 */
- (void)cleanData;

@end

@interface XXTradeData : NSObject
singleton_interface(XXTradeData)

/** 索引 0.币币交易 1. OTC  */
@property (assign, nonatomic) NSInteger indexTrade;

/** 索引 0.合约  1. 期权 */
@property (assign, nonatomic) NSInteger indexContract;

#pragma mark - ====================币币交易====================
/** 交易模块 显示的币对 */
@property (strong, nonatomic) XXSymbolModel *coinTradeModel;

/** 交易模块儿的币对 */
@property (strong, nonatomic) NSString *coinTradeSymbol;

/** 交易模块 是否卖出 */
@property (assign, nonatomic) BOOL coinIsSell;


#pragma mark - ====================期权交易====================

/** 是否关闭期权交易风险提示 */
@property (assign, nonatomic) BOOL closeOptionAlert;

//* 交易模块 显示的币对
@property (strong, nonatomic) XXSymbolModel *optionTradeModel;

/** 交易模块儿的币对 */
@property (strong, nonatomic) NSString *optionTradeSymbolId;

/** 交易模块 是否卖出 */
@property (assign, nonatomic) BOOL optionIsSell;

#pragma mark - ====================合约交易====================
/** 交易模块 显示的币对 */
@property (strong, nonatomic) XXSymbolModel *contractTradeModel;

/** 交易模块儿的币对 */
@property (strong, nonatomic) NSString *contractTradeSymbolId;

/** 0. 开仓 1. 平仓 2. 持仓 */
@property (assign, nonatomic) NSInteger contractIndexTab;

/** 开仓索引 0. 做多 1. 做空 */
@property (assign, nonatomic) NSInteger contractIndexOpen;

/** 平仓索引 0. 平空 1. 平多 */
@property (assign, nonatomic) NSInteger contractIndexClose;

/** 委托索引 0. 普通委托 1. 计划委托 */
@property (assign, nonatomic) NSInteger contractIndexOrder;

/** 价格类型索引 0. 限价 1. 市价 2. 对手价 3. 排队价 4. 超价 */
@property (assign, nonatomic) NSInteger contractIndexPrice;


#pragma mark - 3. 公共
/** 订阅的币对 */
@property (strong, nonatomic) NSString *webSymbolId;

/** 当前交易币对 */
@property (strong, nonatomic) XXSymbolModel *currentModel;

/** 价格位数 */
@property (assign, nonatomic) NSInteger priceDigit;

/** 数量位数 */
@property (assign, nonatomic) NSInteger numberDigit;

/** 币币代理 */
@property (weak, nonatomic) id <XXTradeDataDelegate> delegate;

/** 收到深度数据 */
- (void)receiveDeptchData:(id)data;

/** 打开Socket */
- (void)openSocketWithSymbolModel:(XXSymbolModel *)symbolModel;

/** 关闭Socket */
- (void)closeSocket;
@end

NS_ASSUME_NONNULL_END
