//
//  RatesManager.m
//  iOS
//
//  Created by iOS on 2018/7/11.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "RatesManager.h"


@interface RatesManager ()

/** tokenString */
@property (strong, nonatomic, nullable) NSString *arrayString;

/** tokenString */
@property (strong, nonatomic, nullable) NSString *tokenString;

@end

@implementation RatesManager
singleton_implementation(RatesManager)

#pragma mark - 1. 加载汇率数据
- (void)loadDataOfRates {
    
    if (IsEmpty(KMarket.tokenString)) {
        [self performSelector:@selector(loadDataOfRates) withObject:nil afterDelay:1];
        return;
    }
    
    if (IsEmpty(self.arrayString) || ![self.arrayString isEqualToString:KMarket.tokenString]) {
        NSArray *tokensArray = [KMarket.tokenString mj_JSONObject];
        self.tokenString = @"";
        if (tokensArray.count == 0) {
            [self performSelector:@selector(loadDataOfRates) withObject:nil afterDelay:1];
            return;
        } else {
            for (NSInteger i=0; i < tokensArray.count; i ++) {
                NSDictionary *tokenDict = tokensArray[i];
                if (self.tokenString.length == 0) {
                    self.tokenString = tokenDict[@"tokenId"];
                } else {
                    self.tokenString = [NSString stringWithFormat:@"%@,%@", self.tokenString, tokenDict[@"tokenId"]];
                }
            }
        }
    }
    
    if (IsEmpty(self.tokenString)) {
        [self performSelector:@selector(loadDataOfRates) withObject:nil afterDelay:1];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokens"] = self.tokenString;
    params[@"legalCoins"] = @"BTC,CNY,USD,KRW,JPY,VND";
    KWeakSelf
    [HttpManager quote_GetWithPath:@"quote/v1/rates" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            if (IsEmpty(data)) {
                [weakSelf performSelector:@selector(loadDataOfRates) withObject:nil afterDelay:3];
            } else {
                NSArray *dataArray = data[@"data"];
                if (dataArray > 0) {
                    weakSelf.ratesArray = [NSMutableArray arrayWithArray:dataArray];
                    [weakSelf updataDataDic];
                }
                [weakSelf performSelector:@selector(loadDataOfRates) withObject:nil afterDelay:5];
            }
        } else {
            [weakSelf performSelector:@selector(loadDataOfRates) withObject:nil afterDelay:3];
        }
    }];
}

- (void)cancelTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - 2. 获取法币
- (NSString *)getRatesWithToken:(NSString *)tokenId priceValue:(double)priceValue {
    if (!self.ratesArray) {
        NSString *ratesString = [self getValueForKey:@"ratesArrayKey"];
        self.ratesArray = [ratesString mj_JSONObject];
        [self updataDataDic];
    }
    double rates = 0.0;
    NSDictionary *dict = self.dataDic[tokenId];
    if (dict) {
        rates = [dict[@"CNY"] doubleValue];
        if (rates < 0) {
            return @"--";
        }
    } else {
        return @"--";
    }

    return [NSString stringWithFormat:@"≈¥%@", [NSString getLengthMoney:rates*priceValue]];

}

- (NSString *)getTwoRatesWithToken:(NSString *)tokenId priceValue:(double)priceValue {
    if (!self.ratesArray) {
        NSString *ratesString = [self getValueForKey:@"ratesArrayKey"];
        self.ratesArray = [ratesString mj_JSONObject];
        [self updataDataDic];
    }
    double rates = 0.0;
    NSDictionary *dict = self.dataDic[tokenId];
    if (dict) {
        rates = [dict[@"CNY"] doubleValue];
        if (rates < 0) {
            return @"--";
        }
    } else {
        return @"--";
    }

    NSString *money = [NSString stringWithFormat:@"%.12f", rates*priceValue];
    return [KDecimal decimalNumber:money RoundingMode:NSRoundDown scale:2];
}


- (NSString *)getRatesFromToken:(NSString *)fromtokenId fromPrice:(double)fromPrice coinName:(NSString *)coinName {
    if (!self.ratesArray) {
        NSString *ratesString = [self getValueForKey:@"ratesArrayKey"];
        self.ratesArray = [ratesString mj_JSONObject];
        [self updataDataDic];
    }
    
    double rates = 0.0;
    NSDictionary *dict = self.dataDic[fromtokenId];
    if (dict) {
        rates = [dict[coinName] doubleValue];
        if (rates < 0) {
            return @"--";
        }
    } else {
        return @"--";
    }
    
    NSString *money = [NSString stringWithFormat:@"%.8f", rates*fromPrice];
    return money;
}

- (void)setRatesArray:(NSMutableArray *)ratesArray {
    _ratesArray = ratesArray;
    [self saveValeu:[ratesArray mj_JSONString] forKey:@"ratesArrayKey"];
}

- (void)updataDataDic {
    for (NSInteger i=0; i < self.ratesArray.count; i ++) {
        NSDictionary *dict = self.ratesArray[i];
        NSString *token = dict[@"token"];
        if (token) {
            self.dataDic[token] = dict[@"rates"];
        }
    }
}

#pragma mark 存取方法
-(id)getValueForKey:(NSString*)key{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}
-(void)saveValeu:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableDictionary *)dataDic {
    if (_dataDic == nil) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
@end
