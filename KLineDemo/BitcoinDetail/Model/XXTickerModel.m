//
//  XXTickerModel.m
//  iOS
//
//  Created by iOS on 2018/6/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXTickerModel.h"

@implementation XXTickerModel

/** 获取涨跌幅数据 */
- (void)getRiseWithTokenId:(NSString *)tokenId closeCount:(NSInteger)count {
    
    tokenId = KString(tokenId);
    double rise = ([self.c doubleValue] - [self.o doubleValue])*100/[self.o doubleValue];
    if (isnan(rise)) {
        rise = 0.00;
    }
    if (rise >= 0) {
        self.riseColor = kGreen100;
        self.rise = [NSString stringWithFormat:@"+%@", [NSString riseFallValue:rise]];
    } else {
        self.rise = [NSString riseFallValue:rise];
        self.riseColor = kRed100;
    }

    self.closePrice = [KDecimal decimalNumber:self.c RoundingMode:NSRoundDown scale:count];
    NSString *money = [NSString stringWithFormat:@"\n%@", [[RatesManager sharedRatesManager] getRatesWithToken:tokenId priceValue:[self.c doubleValue]]];
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":self.closePrice, @"color":self.riseColor, @"font":kFontBold14};
    itemsArray[1] = @{@"string":money, @"color":kDark50, @"font":kFont10};
    self.closeMoney = [NSString mergeStrings:itemsArray];
}
@end
