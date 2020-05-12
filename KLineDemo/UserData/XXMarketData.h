//
//  XXMarketData.h
//  iOS
//
//  Created by iOS on 2018/10/9.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXQuoteTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXMarketData : NSObject
singleton_interface(XXMarketData)

/** 合约帮助URL */
@property (strong, nonatomic, nullable) NSString *contractHelpUrl;

/** Domain */
@property (strong, atomic) NSString *remoteDomain;

/** 远程主机地址-ip */
@property (strong, atomic) NSString *remoteAddress;

/** 解析域名所需时间 */
@property (strong, atomic) NSString *dnsDuration;

/** 缓存收藏币对id数组 */
@property (strong, nonatomic) NSMutableArray *favoritesArray;

/** 券商ID */
@property (strong, nonatomic) NSString *orgId;

#pragma mark - || 1.1 币币市场数据
/** 数组tabbar */
@property (strong, nonatomic) NSMutableArray *keysArray;

/** 总数据 */
@property (strong, nonatomic) NSMutableDictionary *dataDict;

/** 币币所有币对数组字符串 */
@property (strong, nonatomic, nullable) NSString *symbolString;

/** 币对字典 */
@property (strong, nonatomic) NSMutableDictionary *symbolsDict;

/** 币币资产token列表 */
@property (strong, nonatomic) NSString *tokenString;

/** 币币token变化回调 */
@property (strong, nonatomic) void(^tokenChangeBlock)(void);

/** 视图是否加载完毕 */
@property (assign, nonatomic) BOOL isFinishMarketData;


/** 读取缓存市场数据 */
- (void)readCachedDataOfMarket;

/** 加载币对数据 */
- (void)loadDataOfSymbols;

/** 取消定时任务 */
- (void)cancelTimer;

#pragma mark - || 1.2 期权市场数据

/** 数组tabbar */
@property (strong, nonatomic) NSMutableArray *optionKeysArray;

/** 总数据 */
@property (strong, nonatomic) NSMutableDictionary *optionDataDict;

/** 币对字典 */
@property (strong, nonatomic) NSMutableDictionary *optionSymbolsDict;

/** 期权板块数据
 "optionUnderlying":[
     {
     "id":"MAIN_BOARD",
     "name":"主板",
     "secondLevels":Array[1]
     },
     {
     "id":"INNOVATION_BOARD",
     "name":"创新板",
     "secondLevels":Array[3]
     }
 ],*/
@property (strong, nonatomic) NSString *optionUnderlying;

/** 期权币种数组字符串 [@"USDT"] */
@property (strong, nonatomic) NSString *optionCoinToken;

/** 期权体验币中 */
@property (strong, nonatomic) NSString *exploreTokens;

#pragma mark - || 1.3 合约市场数据
/** 合约以及类别数组 */
@property (strong, nonatomic) NSMutableArray *contractKeysArray;

/** 合约币对列表数组 */
@property (strong, nonatomic) NSMutableDictionary *contractDataDict;

/** 币对字典 */
@property (strong, nonatomic) NSMutableDictionary *contractSymbolsDict;

/** 合约以及类别字符串 */
@property (strong, nonatomic) NSString *contractUnderlyingString;

/** 合约币对列表字符串 */
@property (strong, nonatomic) NSString *contractSymbolString;

/** 合约币种字符串 [@"USDT"] */
@property (strong, nonatomic) NSString *contractCoinToken;

#pragma mark - 5.2 添加自选
- (void)addFavoriteSymbolId:(NSString *)symbolId;

#pragma mark - 5.3 取消自选
- (void)cancelFavoriteSymbolId:(NSString *)symbolId;

#pragma mark - 5.4 交换位置
- (void)changeObjectAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex;

#pragma mark - 5.5 置顶
- (void)changeObjectToTopAtIndex:(NSInteger)index;

#pragma mark - 6.1 获取数量精度
- (NSInteger)getNumberPrecisionWithSymbolId:(NSString *)symbolId quoteName:(NSString *)quoteName;

#pragma mark - 6.2 获取价格精度
- (NSInteger)getPricePrecisionWithSymbolId:(NSString *)symbolId quoteName:(NSString *)quoteName;

#pragma mark - 6.3 获取金额精度
- (NSInteger)getQuotePrecisionWithSymbolId:(NSString *)symbolId quoteName:(NSString *)quoteName;

#pragma mark - 7. 获取链数组
/** 4. 获取链数组 */
- (NSArray *)chainTypesWithTokenId:(NSString *)tokenId;

@end

NS_ASSUME_NONNULL_END
