//
//  XXMarketData.m
//  Bhex
//
//  Created by Bhex on 2018/10/9.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXMarketData.h"
#import "FMDBManager.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>

@interface XXMarketData ()

/** 配置数据 */
@property (strong, nonatomic) NSDictionary *configData;

#pragma mark - || 缓存/
/** 币币quoteTokensString */
@property (strong, nonatomic) NSString *quoteTokensString;

/** 收藏币对id数组字符串 */
@property (strong, nonatomic, nullable) NSString *favoriteString;

/** 期权optionQuoteTokensString */
@property (strong, nonatomic) NSString *optionQuoteTokensString;

@end


@implementation XXMarketData
singleton_implementation(XXMarketData)

- (void)setQuoteTokensString:(NSString *)quoteTokensString {
    _quoteTokensString = quoteTokensString;
    [[NSUserDefaults standardUserDefaults] setObject:quoteTokensString forKey:@"quoteTokensStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSymbolString:(NSString *)symbolString {
    _symbolString = symbolString;
    [[NSUserDefaults standardUserDefaults] setObject:symbolString forKey:@"allSymbolsStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setFavoriteString:(NSString *)favoriteString {
    _favoriteString = favoriteString;
    [[NSUserDefaults standardUserDefaults] setObject:favoriteString forKey:@"favoritesMarket"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOptionQuoteTokensString:(NSString *)optionQuoteTokensString {
    _optionQuoteTokensString = optionQuoteTokensString;
    [[NSUserDefaults standardUserDefaults] setObject:optionQuoteTokensString forKey:@"optionQuoteTokensStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTokenString:(NSString *)tokenString {
    _tokenString = tokenString;
    [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"tokenStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOptionCoinToken:(NSString *)optionCoinToken {
    _optionCoinToken = optionCoinToken;
    [[NSUserDefaults standardUserDefaults] setObject:optionCoinToken forKey:@"optionCoinTokenKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setExploreTokens:(NSString *)exploreTokens {
    _exploreTokens = exploreTokens;
    [[NSUserDefaults standardUserDefaults] setObject:exploreTokens forKey:@"exploreTokensStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOptionUnderlying:(NSString *)optionUnderlying {
    _optionUnderlying = optionUnderlying;
    [[NSUserDefaults standardUserDefaults] setObject:optionUnderlying forKey:@"optionUnderlyingStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setContractUnderlyingString:(NSString *)contractUnderlyingString {
    _contractUnderlyingString = contractUnderlyingString;
    [[NSUserDefaults standardUserDefaults] setObject:contractUnderlyingString forKey:@"contractUnderlyingStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setContractSymbolString:(NSString *)contractSymbolString {
    _contractSymbolString = contractSymbolString;
    [[NSUserDefaults standardUserDefaults] setObject:contractSymbolString forKey:@"contractSymbolStringKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setContractCoinToken:(NSString *)contractCoinToken {
    _contractCoinToken = contractCoinToken;
    [[NSUserDefaults standardUserDefaults] setObject:contractCoinToken forKey:@"contractCoinTokenKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOrgId:(NSString *)orgId {
    _orgId = orgId;
    [[NSUserDefaults standardUserDefaults] setObject:KString(orgId) forKey:@"orgIdKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)readData {

    self.quoteTokensString = [[NSUserDefaults standardUserDefaults] objectForKey:@"quoteTokensStringKey"];
    self.symbolString = [[NSUserDefaults standardUserDefaults] objectForKey:@"allSymbolsStringKey"];
    self.favoriteString = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoritesMarket"];
    if (self.favoriteString) {
        self.favoritesArray = [NSMutableArray arrayWithArray:[self.favoriteString mj_JSONObject]];
    } else {
        self.favoritesArray = [NSMutableArray array];
    }
    self.tokenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenStringKey"];
    self.optionQuoteTokensString = [[NSUserDefaults standardUserDefaults] objectForKey:@"optionQuoteTokensStringKey"];
    self.optionCoinToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"optionCoinTokenKey"];
    self.exploreTokens = [[NSUserDefaults standardUserDefaults] objectForKey:@"exploreTokensStringKey"];
    self.optionUnderlying = [[NSUserDefaults standardUserDefaults] objectForKey:@"optionUnderlyingStringKey"];
    self.contractUnderlyingString = [[NSUserDefaults standardUserDefaults] objectForKey:@"contractUnderlyingStringKey"];
    self.contractSymbolString = [[NSUserDefaults standardUserDefaults] objectForKey:@"contractSymbolStringKey"];
    self.contractCoinToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"contractCoinTokenKey"];
    self.orgId = KString([[NSUserDefaults standardUserDefaults] objectForKey:@"orgIdKey"]);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 1. 登录成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataOfFavoriteSymbols) name:Login_In_NotificationName object:nil];

        // 2. 读取缓存
        [self readData];
        
        // 3. 加载自选列表
        if (KUser.isLogin) {
            [self loadDataOfFavoriteSymbols];
        }
    }
    return self;
}

#pragma mark - 1.0 读取市场数据
- (void)readCachedDataOfMarket {

    // 1. 判断是否存在币币缓存
    if (self.quoteTokensString.length > 0 && self.symbolString.length > 0) {
        [self integrationDataOfSymbolsFromCache];
    }

    // 2. 判断是否存在期权缓存
    if (self.optionQuoteTokensString.length > 0 && self.optionUnderlying && KConfigure.isHaveOption) {
        [self integrationDataOfOptionFromCache];
    }

    // 3. 判断合约缓存
    if (self.contractSymbolString && self.contractUnderlyingString.length > 0 && KConfigure.isHaveContract) {
        [self integrationDataOfContractFromCache];
    }
}

#pragma mark - 2.0 加载比对
- (void)loadDataOfSymbols {

    // 1. 取消定时任务
    [self cancelTimer];

    // 2. 加载配置信息
    [self loadDataOfConfig];
}

#pragma mark - 2.1 加载配置信息
- (void)loadDataOfConfig {

    // 获取主机ip
    [self getRemoteAddressIp];
    
    KWeakSelf
    [HttpManager ms_GetWithPath:@"basic/config_v1" params:@{@"type":@"all"} andBlock:^(NSDictionary *data, NSString *msg, NSInteger code) {
        if (code == 0) {
            weakSelf.configData = data;
            [weakSelf integrationDataOfSymbols];
            [weakSelf performSelector:@selector(loadDataOfSymbols) withObject:nil afterDelay:180.0f];
        } else {
            [weakSelf performSelector:@selector(loadDataOfSymbols) withObject:nil afterDelay:1.0f];
        }
    }];
}

#pragma mark - 3.0 处理请求过来的数据
- (void)integrationDataOfSymbols {

    // 1. 处理币币数据
    [self integrationDataOfCoin];
    
    // 2. 处理期权数据
    if (KConfigure.isHaveOption) {
        [self integrationDataOfOption];
    }

    // 3. 处理合约数据
    if (KConfigure.isHaveContract) {
        [self integrationDataOfContract];
    }
}

#pragma mark - 3.1 处理币币【HTTP】数据
- (void)integrationDataOfCoin {
    
    // 合约帮助URL
    self.contractHelpUrl = KString(self.configData[@"contractHelpUrl"]);
    
    // 0. 券商ID
    NSString *orgId = KString(self.configData[@"orgId"]);
    if (![orgId isEqualToString:self.orgId]) {
        self.orgId = orgId;
        [NotificationManager postOrgIdChangeNotification];
    }

    // 1. 处理币币资产token
    NSString *tokensString = [self.configData[@"token"] mj_JSONString];
    if (![self.tokenString isEqualToString:tokensString] && self.tokenChangeBlock) {
        self.tokenString = tokensString;
        self.tokenChangeBlock();
    } else {
        self.tokenString = tokensString;
    }
    
    // 2. 处理体验币
    NSArray *exploreTokensArray = self.configData[@"exploreToken"];
    NSMutableDictionary *exploreTokensDic = [NSMutableDictionary dictionary];
    for (NSInteger i=0; i < exploreTokensArray.count; i ++) {
        NSString *tokenId = exploreTokensArray[i];
        exploreTokensDic[tokenId] = tokenId;
    }
    self.exploreTokens = [exploreTokensDic mj_JSONString];

    // 3. 判断是否更新新数据
    NSArray *quoteTokensArray = self.configData[@"quoteToken"];
    NSString *quoteTokensString = [quoteTokensArray mj_JSONString];
    
    NSArray *symbolsArray = self.configData[@"symbol"];
    NSString *symbolString = [symbolsArray mj_JSONString];

    // 5. 判断是否需要更新
    if (![self.quoteTokensString isEqualToString:quoteTokensString] || ![self.symbolString isEqualToString:symbolString]) {
        self.quoteTokensString = quoteTokensString;
        self.symbolString = symbolString;
    } else {
        return;
    }
    
    // 5.1 币对处理
    NSMutableDictionary *symbolsDict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < symbolsArray.count; i ++) {
        XXSymbolModel *cModel = [XXSymbolModel mj_objectWithKeyValues:symbolsArray[i]];
        cModel.quote = [XXQuoteModel new];
        cModel.type = SymbolTypeCoin;
        symbolsDict[cModel.symbolId] = cModel;
    }

    // 6. 处理数据
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    self.keysArray = [NSMutableArray array];
    [self.keysArray addObject:@"自选"];
    XXQuoteTokenModel *favoriteModel = [[XXQuoteTokenModel alloc] init];
    favoriteModel.symbolsArray = [NSMutableArray array];
    favoriteModel.idsString = @"";
    favoriteModel.isFavorite = YES;
    dataDict[@"自选"] = favoriteModel;

    XXSymbolModel *firstModel = nil;
    for (NSInteger i=0; i < quoteTokensArray.count; i ++) {
        NSDictionary *dict = quoteTokensArray[i];
        NSString *tokenName = dict[@"tokenName"];
        [self.keysArray addObject:tokenName];
        XXQuoteTokenModel *tokenModel = [[XXQuoteTokenModel alloc] init];
        dataDict[tokenName] = tokenModel;
        tokenModel.symbolsArray = [NSMutableArray array];
        tokenModel.idsString = @"";
        NSArray *symbols = dict[@"quoteTokenSymbols"];
        for (NSInteger i=0; i < symbols.count; i ++) {
            NSDictionary *symbol = symbols[i];
            XXSymbolModel *cModel = symbolsDict[symbol[@"symbolId"]];
            cModel.isInTradeSection = YES;
            if (IsEmpty(cModel)) {
                continue;
            }
            if (cModel.showStatus == NO) {
                continue;
            }
            if (!firstModel) {
                firstModel = cModel;
            }

            if (tokenModel.idsString.length==0) {
                tokenModel.idsString = [NSString stringWithFormat:@"%@.%@", cModel.exchangeId, cModel.symbolId];
            } else {
                tokenModel.idsString = [NSString stringWithFormat:@"%@,%@.%@", tokenModel.idsString,  cModel.exchangeId, cModel.symbolId];
            }
            [tokenModel.symbolsArray addObject:cModel];

            if (!KTrade.coinTradeModel) {
                if (!KTrade.coinTradeSymbol) {
                    KTrade.coinTradeModel = cModel;
                    [NotificationManager postHaveTradeSymbolNotification];
                } else if ([KTrade.coinTradeSymbol isEqualToString:cModel.symbolName]) {
                    KTrade.coinTradeModel = cModel;
                    [NotificationManager postHaveTradeSymbolNotification];
                }
            } else {
                if ([KTrade.coinTradeSymbol isEqualToString:cModel.symbolId]) {
                    KTrade.coinTradeModel = cModel;
                }
            }
        }
    }

    if (!KTrade.coinTradeModel && firstModel) {
        KTrade.coinTradeModel = firstModel;
        [NotificationManager postHaveTradeSymbolNotification];
    }
    self.dataDict = dataDict;
    self.symbolsDict = symbolsDict;
    self.isFinishMarketData = YES;
    [self reloadFavoritesArray];
    [self reloadFavoriteQuoteTokenData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [NotificationManager postSymbolListNeedUpdateNotification];
    });
}

#pragma mark - 3.2 处理期权【HTTP】数据
- (void)integrationDataOfOption {

    // 1. 期权币
    self.optionCoinToken = [self.configData[@"optionCoinToken"] mj_JSONString];
    
    // 3.1 获取期权quoteToken
    NSArray *optionQuoteToken = self.configData[@"optionQuoteToken"];
    NSString *quoteTokenString = [optionQuoteToken mj_JSONString];

    // 3.2 获取板块数据
    NSString *optionUnderlying = [self.configData[@"optionUnderlying"] mj_JSONString];

    // 4. 判断是否有更新
    if ([self.optionQuoteTokensString isEqualToString:quoteTokenString] && [self.optionUnderlying isEqualToString:optionUnderlying]) {
        return;
    }
    self.optionUnderlying = optionUnderlying;
    self.optionQuoteTokensString = quoteTokenString;

    // 5. 处理数据
    NSMutableArray *optionKeysArray = [NSMutableArray array];
    NSMutableDictionary *optionDataDic = [NSMutableDictionary dictionary];
    XXSymbolModel *firstModel = nil;
    NSMutableDictionary *optionSymbolsDict = [NSMutableDictionary dictionary];
    for (NSInteger i=0; i < optionQuoteToken.count; i ++) {
        NSDictionary *dict = optionQuoteToken[i];
        NSString *tokenName = dict[@"tokenFullName"];
        if (!tokenName) {
            tokenName = dict[@"tokenName"];
        }
        if (!tokenName) {
            tokenName = dict[@"tokenId"];
        }
        [optionKeysArray addObject:tokenName];
        XXQuoteTokenModel *tokenModel = [[XXQuoteTokenModel alloc] init];
        optionDataDic[tokenName] = tokenModel;
        tokenModel.symbolsArray = [NSMutableArray array];
        tokenModel.idsString = @"";
        NSArray *symbols = dict[@"quoteTokenSymbols"];
        for (NSInteger i=0; i < symbols.count; i ++) {

            NSDictionary *symbol = symbols[i];
            XXSymbolModel *cModel = [XXSymbolModel mj_objectWithKeyValues:symbol];
            cModel.type = SymbolTypeOption;
            cModel.quote = [XXQuoteModel new];
            if (!firstModel) {
                firstModel = cModel;
            }
            optionSymbolsDict[cModel.symbolId] = cModel;
            if (tokenModel.idsString.length==0) {
                tokenModel.idsString = [NSString stringWithFormat:@"%@.%@", cModel.exchangeId, cModel.symbolId];
            } else {
                tokenModel.idsString = [NSString stringWithFormat:@"%@,%@.%@", tokenModel.idsString,  cModel.exchangeId, cModel.symbolId];
            }

            if (!KTrade.optionTradeModel) {
                if (!KTrade.optionTradeSymbolId) {
                    KTrade.optionTradeModel = cModel;
                    [NotificationManager postHaveOptionTradeSymbolNotification];
                } else if ([KTrade.optionTradeSymbolId isEqualToString:cModel.symbolId]) {
                    KTrade.optionTradeModel = cModel;
                    [NotificationManager postHaveOptionTradeSymbolNotification];
                }
            } else {
                if ([KTrade.optionTradeSymbolId isEqualToString:cModel.symbolId]) {
                    KTrade.optionTradeModel = cModel;
                }
            }
            [tokenModel.symbolsArray addObject:cModel];
        }
    }
    if (!KTrade.optionTradeModel && firstModel) {
        KTrade.optionTradeModel = firstModel;
        [NotificationManager postHaveOptionTradeSymbolNotification];
    }

    self.optionSymbolsDict = optionSymbolsDict;
    self.optionKeysArray = optionKeysArray;
    self.optionDataDict = optionDataDic;
    dispatch_async(dispatch_get_main_queue(), ^{
        [NotificationManager postOptionSymbolListNeedUpdateNotification];
    });
}

#pragma mark - 3.3 处理合约【HTTP】数据
- (void)integrationDataOfContract {

    // 0. 期权币
    self.contractCoinToken = [self.configData[@"futuresCoinToken"] mj_JSONString];

    // 1. 取出数据对比是否需要更新
    NSString *contractUnderlying = [self.configData[@"futuresUnderlying"] mj_JSONString];
    NSString *contractSymbolString = [self.configData[@"futuresSymbol"] mj_JSONString];

    if (!contractUnderlying || !contractSymbolString) {
        return;
    }
    if ([self.contractUnderlyingString isEqualToString:contractUnderlying] && [self.contractSymbolString isEqualToString:contractSymbolString]) {
        return;
    }

    // 2. 新数据赋值
    self.contractUnderlyingString = contractUnderlying;
    self.contractSymbolString = contractSymbolString;

    // 3. 创建大模型
    NSArray *onesArray = self.configData[@"futuresUnderlying"];
    NSArray *symbolsArray = [XXSymbolModel mj_objectArrayWithKeyValuesArray:self.configData[@"futuresSymbol"]];
    NSMutableArray *keysArray = [NSMutableArray array];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    XXSymbolModel *firstModel = nil;
    NSMutableDictionary *contractSymbolsDict = [NSMutableDictionary dictionary];
    for (NSInteger i=0; i < onesArray.count; i ++) {
        NSDictionary *dict = onesArray[i];
        [keysArray addObject:dict[@"name"]];
        XXQuoteTokenModel *tokenModel = [[XXQuoteTokenModel alloc] init];
        tokenModel.id = dict[@"id"];
        tokenModel.idsString = @"";
        tokenModel.symbolsArray = [NSMutableArray array];
        dataDict[dict[@"name"]] = tokenModel;

        for (NSInteger j=0; j < symbolsArray.count; j ++) {
            XXSymbolModel *sModel = symbolsArray[j];
            sModel.type = SymbolTypeContract;
            sModel.quote = [XXQuoteModel new];
            if ([tokenModel.id isEqualToString:sModel.firstLevelUnderlyingId]) {
                
                if (tokenModel.idsString.length==0) {
                    tokenModel.idsString = [NSString stringWithFormat:@"%@.%@", sModel.exchangeId, sModel.symbolId];
                } else {
                    tokenModel.idsString = [NSString stringWithFormat:@"%@,%@.%@", tokenModel.idsString,  sModel.exchangeId, sModel.symbolId];
                }
                [tokenModel.symbolsArray addObject:sModel];
            }
            contractSymbolsDict[sModel.symbolId] = sModel;
            if (!firstModel) {
                firstModel = sModel;
            }

            if (!KTrade.contractTradeModel) {
                if (!KTrade.contractTradeSymbolId) {
                    KTrade.contractTradeModel = sModel;
                    [NotificationManager postHaveContractTradeSymbolNotification];
                } else if ([KTrade.contractTradeSymbolId isEqualToString:sModel.symbolId]) {
                    KTrade.contractTradeModel = sModel;
                    [NotificationManager postHaveContractTradeSymbolNotification];
                }
            } else {
                if ([KTrade.contractTradeSymbolId isEqualToString:sModel.symbolId]) {
                    KTrade.contractTradeModel = sModel;
                }
            }
        }
    }

    if (!KTrade.contractTradeModel && firstModel) {
        KTrade.contractTradeModel = firstModel;
        [NotificationManager postHaveContractTradeSymbolNotification];
    }

    self.contractSymbolsDict = contractSymbolsDict;
    self.contractKeysArray = keysArray;
    self.contractDataDict = dataDict;
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [NotificationManager postContractSymbolListNeedUpdateNotification];
    });
}

#pragma mark - 4.1 处理币币【缓存】数据
- (void)integrationDataOfSymbolsFromCache {

    // 取出数据
    NSArray *quoteTokensArray = [self.quoteTokensString mj_JSONObject];
    NSArray *symbolsArray = [self.symbolString  mj_JSONObject];
    
    // 币对数据
    NSMutableDictionary *symbolsDict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < symbolsArray.count; i ++) {
        XXSymbolModel *cModel = [XXSymbolModel mj_objectWithKeyValues:symbolsArray[i]];
        cModel.quote = [XXQuoteModel new];
        cModel.type = SymbolTypeCoin;
        symbolsDict[cModel.symbolId] = cModel;
    }

    // 处理数据
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    self.keysArray = [NSMutableArray array];
    [self.keysArray addObject:@"自选"];
    XXQuoteTokenModel *favoriteModel = [[XXQuoteTokenModel alloc] init];
    favoriteModel.symbolsArray = [NSMutableArray array];
    favoriteModel.idsString = @"";
    favoriteModel.isFavorite = YES;
    dataDict[@"自选"] = favoriteModel;

    XXSymbolModel *firstModel = nil;
    for (NSInteger i=0; i < quoteTokensArray.count; i ++) {
        NSDictionary *dict = quoteTokensArray[i];
        NSString *tokenName = dict[@"tokenName"];
        [self.keysArray addObject:tokenName];

        XXQuoteTokenModel *tokenModel = [[XXQuoteTokenModel alloc] init];
        dataDict[tokenName] = tokenModel;
        tokenModel.symbolsArray = [NSMutableArray array];
        tokenModel.idsString = @"";
        NSArray *symbols = dict[@"quoteTokenSymbols"];
        for (NSInteger i=0; i < symbols.count; i ++) {

            NSDictionary *symbol = symbols[i];
            XXSymbolModel *cModel = symbolsDict[symbol[@"symbolId"]];
            cModel.isInTradeSection = YES;
            if (IsEmpty(cModel)) {
                continue;
            }
            if (cModel.showStatus == NO) {
                continue;
            }
            if (!firstModel) {
                firstModel = cModel;
            }

            if (tokenModel.idsString.length==0) {
                tokenModel.idsString = [NSString stringWithFormat:@"%@.%@", cModel.exchangeId, cModel.symbolId];
            } else {
                tokenModel.idsString = [NSString stringWithFormat:@"%@,%@.%@", tokenModel.idsString,  cModel.exchangeId, cModel.symbolId];
            }
            [tokenModel.symbolsArray addObject:cModel];

            if (!KTrade.coinTradeModel) {
                if (!KTrade.coinTradeSymbol) {
                    KTrade.coinTradeModel = cModel;
                } else if ([KTrade.coinTradeSymbol isEqualToString:cModel.symbolName]) {
                    KTrade.coinTradeModel = cModel;
                }
            }
        }
    }

    if (!KTrade.coinTradeModel && firstModel) {
        KTrade.coinTradeModel = firstModel;
    }
    self.dataDict = dataDict;
    self.symbolsDict = symbolsDict;
    self.isFinishMarketData = YES;
    [self reloadFavoritesArray];
    [self reloadFavoriteQuoteTokenData];
}

#pragma mark - 4.2 处理期权【缓存】数据
- (void)integrationDataOfOptionFromCache {
    
    // 2. 获取期权quoteToken
    NSArray *optionQuoteToken = [self.optionQuoteTokensString mj_JSONObject];

    // 3. 处理数据
    NSMutableArray *optionKeysArray = [NSMutableArray array];
    NSMutableDictionary *optionDataDic = [NSMutableDictionary dictionary];
    XXSymbolModel *firstModel = nil;
    NSMutableDictionary *optionSymbolsDict = [NSMutableDictionary dictionary];
    for (NSInteger i=0; i < optionQuoteToken.count; i ++) {
        NSDictionary *dict = optionQuoteToken[i];
        NSString *tokenName = dict[@"tokenFullName"];
        if (!tokenName) {
            tokenName = dict[@"tokenName"];
        }
        if (!tokenName) {
            tokenName = dict[@"tokenId"];
        }
        [optionKeysArray addObject:tokenName];
        XXQuoteTokenModel *tokenModel = [[XXQuoteTokenModel alloc] init];
        optionDataDic[tokenName] = tokenModel;
        tokenModel.symbolsArray = [NSMutableArray array];
        tokenModel.idsString = @"";
        NSArray *symbols = dict[@"quoteTokenSymbols"];
        for (NSInteger i=0; i < symbols.count; i ++) {

            NSDictionary *symbol = symbols[i];
            XXSymbolModel *cModel = [XXSymbolModel mj_objectWithKeyValues:symbol];
            cModel.type = SymbolTypeOption;
            cModel.quote = [XXQuoteModel new];
            if (!firstModel) {
                firstModel = cModel;
            }
            optionSymbolsDict[cModel.symbolId] = cModel;
            if (tokenModel.idsString.length==0) {
                tokenModel.idsString = [NSString stringWithFormat:@"%@.%@", cModel.exchangeId, cModel.symbolId];
            } else {
                tokenModel.idsString = [NSString stringWithFormat:@"%@,%@.%@", tokenModel.idsString,  cModel.exchangeId, cModel.symbolId];
            }

            if (!KTrade.optionTradeModel) {
                if (!KTrade.optionTradeSymbolId) {
                    KTrade.optionTradeModel = cModel;
                    [NotificationManager postHaveOptionTradeSymbolNotification];
                } else if ([KTrade.optionTradeSymbolId isEqualToString:cModel.symbolId]) {
                    KTrade.optionTradeModel = cModel;
                    [NotificationManager postHaveOptionTradeSymbolNotification];
                }
            }
            [tokenModel.symbolsArray addObject:cModel];
        }
    }

    self.optionSymbolsDict = optionSymbolsDict;
    self.optionKeysArray = optionKeysArray;
    self.optionDataDict = optionDataDic;

    if (!KTrade.optionTradeModel && firstModel) {
        KTrade.optionTradeModel = firstModel;
        [NotificationManager postHaveOptionTradeSymbolNotification];
    }
}

#pragma mark - 4.3 处理合约【缓存】数据
- (void)integrationDataOfContractFromCache {

    // 1. 创建大模型
    NSArray *onesArray = [self.contractUnderlyingString mj_JSONObject];
    NSArray *symbolsArray = [XXSymbolModel mj_objectArrayWithKeyValuesArray:[self.contractSymbolString mj_JSONObject]];
    NSMutableArray *keysArray = [NSMutableArray array];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    XXSymbolModel *firstModel = nil;
    NSMutableDictionary *contractSymbolsDict = [NSMutableDictionary dictionary];
    for (NSInteger i=0; i < onesArray.count; i ++) {
        NSDictionary *dict = onesArray[i];
        [keysArray addObject:dict[@"name"]];
        XXQuoteTokenModel *tokenModel = [[XXQuoteTokenModel alloc] init];
        tokenModel.id = dict[@"id"];
        tokenModel.idsString = @"";
        tokenModel.symbolsArray = [NSMutableArray array];
        dataDict[dict[@"name"]] = tokenModel;
        
        for (NSInteger j=0; j < symbolsArray.count; j ++) {
            XXSymbolModel *sModel = symbolsArray[j];
            sModel.type = SymbolTypeContract;
            sModel.quote = [XXQuoteModel new];
            if ([tokenModel.id isEqualToString:sModel.firstLevelUnderlyingId]) {

                if (tokenModel.idsString.length==0) {
                    tokenModel.idsString = [NSString stringWithFormat:@"%@.%@", sModel.exchangeId, sModel.symbolId];
                } else {
                    tokenModel.idsString = [NSString stringWithFormat:@"%@,%@.%@", tokenModel.idsString,  sModel.exchangeId, sModel.symbolId];
                }
                [tokenModel.symbolsArray addObject:sModel];
            }
            contractSymbolsDict[sModel.symbolId] = sModel;
            if (!firstModel) {
                firstModel = sModel;
            }

            if (!KTrade.contractTradeModel) {
                if (!KTrade.contractTradeSymbolId) {
                    KTrade.contractTradeModel = sModel;
                    [NotificationManager postHaveContractTradeSymbolNotification];
                } else if ([KTrade.contractTradeSymbolId isEqualToString:sModel.symbolId]) {
                    KTrade.contractTradeModel = sModel;
                    [NotificationManager postHaveContractTradeSymbolNotification];
                }
            }
        }
    }

    if (!KTrade.contractTradeModel && firstModel) {
        KTrade.contractTradeModel = firstModel;
        [NotificationManager postHaveContractTradeSymbolNotification];
    }

    self.contractSymbolsDict = contractSymbolsDict;
    self.contractKeysArray = keysArray;
    self.contractDataDict = dataDict;
    dispatch_async(dispatch_get_main_queue(), ^{
        [NotificationManager postContractSymbolListNeedUpdateNotification];
    });
}

#pragma mark - 5.0 登录成功加载自选列表
- (void)loadDataOfFavoriteSymbols {
    if (!KUser.isLogin) {
        return;
    }

//    KWeakSelf
//    [HttpManager user_GetWithPath:@"user/favorite/list" params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
//
//        if (code == 0) {
//            NSArray *dataArray = data;
//            NSMutableArray *symbolIdsArray = [NSMutableArray array];
//            for (NSInteger i=0; i < dataArray.count; i ++) {
//                NSString *symbolId = dataArray[i][@"symbolId"];
//                if (weakSelf.symbolsDict[symbolId]) {
//                    [symbolIdsArray addObject:symbolId];
//                }
//            }
//
//            if (weakSelf.favoritesArray.count == 0) {
//                weakSelf.favoritesArray = symbolIdsArray;
//            } else {
//                for (NSString *symbolId in symbolIdsArray) {
//                    BOOL isHave = NO;
//                    for (NSString *fSymbolId in weakSelf.favoritesArray) {
//                        if ([symbolId isEqualToString:fSymbolId]) {
//                            isHave = YES;
//                            break;
//                        }
//                    }
//                    if (isHave == NO) {
//                        [weakSelf.favoritesArray addObject:symbolId];
//                    }
//                }
//
//                NSMutableArray *notArray = [NSMutableArray array];
//                for (NSString *fSymbolId in weakSelf.favoritesArray) {
//                    BOOL isHave = NO;
//                    for (NSString *symbolId in symbolIdsArray) {
//                        if ([symbolId isEqualToString:fSymbolId]) {
//                            isHave = YES;
//                            break;
//                        }
//                    }
//                    if (isHave == NO) {
//                        [notArray addObject:fSymbolId];
//                    }
//                }
//
//                for (NSString *symbolId in notArray) {
//                    [weakSelf.favoritesArray removeObject:symbolId];
//                }
//            }
//
//            weakSelf.favoriteString = [weakSelf.favoritesArray mj_JSONString];
//            [weakSelf reloadFavoriteQuoteTokenData];
//        } else {
//            [weakSelf performSelector:@selector(loadDataOfFavoriteSymbols) withObject:nil afterDelay:2.0f];
//        }
//    }];
}

- (void)reloadFavoritesArray {
    NSMutableArray *notArray = [NSMutableArray array];
    for (NSString *symbolId in self.favoritesArray) {
        if (!self.symbolsDict[symbolId]) {
            [notArray addObject:symbolId];
        }
    }
    if (notArray.count > 0) {
        for (NSString *symbolId in notArray) {
            [self.favoritesArray removeObject:symbolId];
            self.favoriteString = [self.favoritesArray mj_JSONString];
        }
    }
}

#pragma mark - 5.1 更新自选交易区模型QuoteTokenModel
- (void)reloadFavoriteQuoteTokenData {
    XXQuoteTokenModel *favoriteTokenModel = self.dataDict[@"自选"];
    if (IsEmpty(favoriteTokenModel) || favoriteTokenModel.symbolsArray == nil) {
        return;
    }
    NSString *idsString = @"";
    NSMutableArray *symbolsArray = [NSMutableArray array];
    for (NSInteger i=0; i < self.favoritesArray.count; i ++) {
        NSString *symbolId = self.favoritesArray[i];
        XXSymbolModel *cModel = self.symbolsDict[symbolId];
        if (IsEmpty(cModel)) {
            continue;
        }
        cModel.favorite = YES;
        [symbolsArray addObject:cModel];
        if (idsString.length == 0) {
            idsString = [NSString stringWithFormat:@"%@.%@", cModel.exchangeId, cModel.symbolId];
        } else {
            idsString = [NSString stringWithFormat:@"%@,%@.%@", idsString,  cModel.exchangeId, cModel.symbolId];
        }
    }
    favoriteTokenModel.symbolsArray = symbolsArray;
    favoriteTokenModel.idsString = idsString;
}

#pragma mark - 5.2 添加自选
- (void)addFavoriteSymbolId:(NSString *)symbolId {
    
    if (IsEmpty(symbolId)) {
        return;
    }
    
    XXSymbolModel *sModel = self.symbolsDict[symbolId];
    
    if (IsEmpty(sModel)) {
        return;
    }
    sModel.favorite = YES;
    [self.favoritesArray insertObject:symbolId atIndex:0];
    self.favoriteString = [self.favoritesArray mj_JSONString];
    [self reloadFavoriteQuoteTokenData];
}

#pragma mark - 5.3 取消自选
- (void)cancelFavoriteSymbolId:(NSString *)symbolId {
    
    if (IsEmpty(symbolId)) {
        return;
    }
    
    XXSymbolModel *sModel = self.symbolsDict[symbolId];
    
    if (IsEmpty(sModel)) {
        return;
    }
    sModel.favorite = NO;
    [self.favoritesArray removeObject:symbolId];
    self.favoriteString = [self.favoritesArray mj_JSONString];
    [self reloadFavoriteQuoteTokenData];
}

#pragma mark - 5.4 交换位置
- (void)changeObjectAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex {
    if (!(index < self.favoritesArray.count && toIndex < self.favoritesArray.count)) {
        return;
    }
    NSString *symbolId = self.favoritesArray[index];
    [self.favoritesArray removeObject:symbolId];
    [self.favoritesArray insertObject:symbolId atIndex:toIndex];
    self.favoriteString = [self.favoritesArray mj_JSONString];
    [self reloadFavoriteQuoteTokenData];
}

#pragma mark - 5.5 置顶
- (void)changeObjectToTopAtIndex:(NSInteger)index {
    if (index >= self.favoritesArray.count) {
        return;
    }
    NSString *symbolId = self.favoritesArray[index];
    [self.favoritesArray removeObject:symbolId];
    [self.favoritesArray insertObject:symbolId atIndex:0];
    self.favoriteString = [self.favoritesArray mj_JSONString];
    [self reloadFavoriteQuoteTokenData];
}

#pragma mark - 6.1 获取数量精度
- (NSInteger)getNumberPrecisionWithSymbolId:(NSString *)symbolId quoteName:(NSString *)quoteName {
    XXQuoteTokenModel *tokenModel = self.dataDict[quoteName];
    for (NSInteger i=0; i < tokenModel.symbolsArray.count; i ++) {
        XXSymbolModel *cModel = tokenModel.symbolsArray[i];
        if ([cModel.symbolId isEqualToString:symbolId]) {
            return [KDecimal scale:cModel.basePrecision];
        }
    }
    return 8;
}

#pragma mark - 6.2 获取价格精度
- (NSInteger)getPricePrecisionWithSymbolId:(NSString *)symbolId quoteName:(NSString *)quoteName {
    XXQuoteTokenModel *tokenModel = self.dataDict[quoteName];
    for (NSInteger i=0; i < tokenModel.symbolsArray.count; i ++) {
        XXSymbolModel *cModel = tokenModel.symbolsArray[i];
        if ([cModel.symbolId isEqualToString:symbolId]) {
            return [KDecimal scale:cModel.minPricePrecision];
        }
    }
    return 8;
}

#pragma mark - 6.3 获取金额精度
- (NSInteger)getQuotePrecisionWithSymbolId:(NSString *)symbolId quoteName:(NSString *)quoteName {
    XXQuoteTokenModel *tokenModel = self.dataDict[quoteName];
    for (NSInteger i=0; i < tokenModel.symbolsArray.count; i ++) {
        XXSymbolModel *cModel = tokenModel.symbolsArray[i];
        if ([cModel.symbolId isEqualToString:symbolId]) {
            return [KDecimal scale:cModel.quotePrecision];
        }
    }
    return 8;
}

#pragma mark - 7. 获取链数组
- (NSArray *)chainTypesWithTokenId:(NSString *)tokenId {
    if (!tokenId) {
        return @[];
    }
    NSArray *tokensArray = [self.tokenString mj_JSONObject];
    for (NSDictionary *dict in tokensArray) {
        if ([tokenId isEqualToString:dict[@"tokenId"]]) {
            return dict[@"chainTypes"];
        }
    }
    return @[];
}

#pragma mark - 8. 取消定时任务
- (void)cancelTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadDataOfSymbols) object:nil];

}

#pragma mark - 9. 根据域名获取ip地址
- (void)getRemoteAddressIp{
    
    // 串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("com.remoteAddressIp.switchSymbol", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        double openTime = [[NSDate date] timeIntervalSince1970]*1000.0f;
        NSURL *url = [NSURL URLWithString:kServerUrl];
        self.remoteDomain = url.host;
        struct hostent *hs;
        struct sockaddr_in server;
        if ((hs = gethostbyname([self.remoteDomain UTF8String])) != NULL) {
            server.sin_addr = *((struct in_addr*)hs->h_addr_list[0]);
            self.remoteAddress = [NSString stringWithFormat:@"%@", [NSString stringWithUTF8String:inet_ntoa(server.sin_addr)]];
            double closeTime = [[NSDate date] timeIntervalSince1970]*1000.0f;
            self.dnsDuration = [NSString stringWithFormat:@"%.0f", closeTime - openTime];
        }
    });
}

@end
