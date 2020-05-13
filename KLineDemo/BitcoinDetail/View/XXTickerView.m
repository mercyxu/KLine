//
//  XXTickerView.m
//  iOS
//
//  Created by iOS on 2018/6/28.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXTickerView.h"
#import "XXTickerModel.h"
#import "UIColor+Y_StockChart.h"

@interface XXTickerView ()

@property (strong, nonatomic) XXWebQuoteModel *webModel;

/** 行情数据模型 */
@property (strong, nonatomic) XXTickerModel *tickerModel;

/** 最新价 */
@property (strong, nonatomic) XXLabel *nowLabel;

/** 法币价格 */
@property (strong, nonatomic) XXLabel *moneyLabel;

/** 成交量 */
@property (strong, nonatomic) XXLabel *numberLabel;

/** 成交量值标签 */
@property (strong, nonatomic) XXLabel *numberValueLabel;

/** 最高价 */
@property (strong, nonatomic) XXLabel *hPriceLabel;

/** 最高价值标签 */
@property (strong, nonatomic) XXLabel *hPriceValueLabel;

/** 最低价 */
@property (strong, nonatomic) XXLabel *lPriceLabel;

/** 最低价值标签 */
@property (strong, nonatomic) XXLabel *lPriceValueLabel;

@end

@implementation XXTickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       
        self.backgroundColor = [UIColor backgroundColor];
                
        // 1. 初始化UI
        [self setupUI];
        
        self.webModel = [[XXWebQuoteModel alloc] init];
        KWeakSelf
        
        // 2. webSocket成功回调
        self.webModel.successBlock = ^(NSArray *data) {
            if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
                NSDictionary *dict = [data lastObject];
                if (!IsEmpty(dict)) {
                    weakSelf.tickerModel.t = [dict[@"t"] longLongValue];
                    weakSelf.tickerModel.c = dict[@"c"];
                    weakSelf.tickerModel.l = dict[@"l"];
                    weakSelf.tickerModel.h = dict[@"h"];
                    weakSelf.tickerModel.v = dict[@"v"];
                    weakSelf.tickerModel.o = dict[@"o"];
                    [weakSelf refreshDataOfTicker];
                }
            }
        };
        
        // 3. webSocket失败回调
        self.webModel.failureBlock = ^{
            
        };
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    /** 最新价 */
    [self addSubview:self.nowLabel];
    [self addSubview:self.moneyLabel];
    
    /** 成交量 */
    [self addSubview:self.hPriceLabel];
    [self addSubview:self.hPriceValueLabel];
    [self addSubview:self.lPriceLabel];
    [self addSubview:self.lPriceValueLabel];
    [self addSubview:self.numberLabel];
    [self addSubview:self.numberValueLabel];
}

#pragma mark - 2. 行情数据UI赋值
- (void)refreshDataOfTicker {
    
    NSString *closePrice = [KDecimal decimalNumber:self.tickerModel.c RoundingMode:NSRoundDown scale:KDetail.priceDigit];
    UIColor *textColor;
    NSString *riseString = [NSString riseFallValue:([self.tickerModel.c doubleValue] - [self.tickerModel.o doubleValue])*100/[self.tickerModel.o doubleValue]];
    if (([self.tickerModel.c doubleValue] - [self.tickerModel.o doubleValue]) >= 0) {
        textColor = [UIColor increaseColor];
        riseString = [NSString stringWithFormat:@"+%@", riseString];
    } else {
        textColor = [UIColor decreaseColor];
        riseString = [NSString stringWithFormat:@"%@", riseString];
    }
    
    if (closePrice.length > 12) {
        self.nowLabel.font = kFontBold(26.0f);
    } else if (closePrice.length > 10) {
        self.nowLabel.font = kFontBold(30.0f);
    } else {
        self.nowLabel.font = kFontBold(32.0f);
    }
    
    self.nowLabel.text = closePrice;
    
    self.nowLabel.textColor = textColor;
    
    NSString *money = money = [[RatesManager sharedRatesManager] getRatesWithToken:KDetail.symbolModel.quoteTokenId priceValue:[closePrice doubleValue]];
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":money, @"color":[UIColor assistTextColor], @"font":kFont12};
    itemsArray[1] = @{@"string":[NSString stringWithFormat:@"  %@", riseString], @"color":textColor, @"font":kFontBold14};
    self.moneyLabel.attributedText = [NSString mergeStrings:itemsArray];
    
    NSString *hStr = [KDecimal decimalNumber:KString(self.tickerModel.h) RoundingMode:NSRoundDown scale:KDetail.priceDigit];
    NSString *lStr = [KDecimal decimalNumber:KString(self.tickerModel.l) RoundingMode:NSRoundDown scale:KDetail.priceDigit];
    NSString *aStr = KString([KDecimal decimalNumber:self.tickerModel.v RoundingMode:NSRoundDown scale:0]);
    
    CGFloat hWidth = [NSString widthWithText:[NSString stringWithFormat:@"%@%@", LocalizedString(@"HIGH"), hStr] font:kFont12] + K375(10);
    CGFloat lWidth = [NSString widthWithText:[NSString stringWithFormat:@"%@%@", LocalizedString(@"LOW"), lStr] font:kFont12] + K375(10);
    CGFloat aWidth = [NSString widthWithText:[NSString stringWithFormat:@"%@%@", @"24H", aStr] font:kFont12] + K375(10);
    CGFloat width = hWidth;
    if (width < lWidth) {
        width = lWidth;
    }
    
    if (width < aWidth) {
        width = aWidth;
    }
    
    self.hPriceLabel.width = width;
    self.hPriceValueLabel.width = width;
    self.lPriceLabel.width = width;
    self.lPriceValueLabel.width = width;
    self.numberLabel.width = width;
    self.numberValueLabel.width = width;
    
    self.hPriceLabel.left = kScreen_Width - K375(15) - width;
    self.hPriceValueLabel.left = kScreen_Width - K375(15) - width;
    self.lPriceLabel.left = kScreen_Width - K375(15) - width;
    self.lPriceValueLabel.left = kScreen_Width - K375(15) - width;
    self.numberLabel.left = kScreen_Width - K375(15) - width;
    self.numberValueLabel.left = kScreen_Width - K375(15) - width;
    
    self.hPriceValueLabel.text = hStr;
    self.lPriceValueLabel.text = lStr;
    self.numberValueLabel.text = aStr;

    // 全屏所用
    NSString *symbolString = [NSString stringWithFormat:@"%@  ", KDetail.symbolModel.symbolName];
    if (KDetail.symbolModel.type == SymbolTypeCoin) {
        symbolString = [NSString stringWithFormat:@"%@/%@   ", KDetail.symbolModel.baseTokenName, KDetail.symbolModel.quoteTokenName];
    }
    
    NSMutableArray *textsArray = [NSMutableArray array];
    textsArray[0] = @{@"string":symbolString, @"color":[UIColor mainTextColor], @"font":kFontBold14};
    textsArray[1] = @{@"string":closePrice, @"color":textColor, @"font":kFont14};
    textsArray[2] = @{@"string":[NSString stringWithFormat:@"（%@）", riseString], @"color":textColor, @"font":kFont14};
    
    self.leftLabel.attributedText = [NSString mergeStrings:textsArray];
    
    // 24量 高 低
    NSMutableArray *pricesArray = [NSMutableArray array];
    pricesArray[0] = @{@"string":LocalizedString(@"24H VOL"), @"color":[UIColor assistTextColor], @"font":kFont10};
    pricesArray[1] = @{@"string":[NSString stringWithFormat:@"   %@", [KDecimal decimalNumber:self.tickerModel.v RoundingMode:NSRoundDown scale:2]], @"color":[UIColor mainTextColor], @"font":kFont10};
    
    pricesArray[2] = @{@"string":[NSString stringWithFormat:@"     %@", LocalizedString(@"HIGH")], @"color":[UIColor assistTextColor], @"font":kFont10};
    pricesArray[3] = @{@"string":[NSString stringWithFormat:@"   %@", self.hPriceValueLabel.text], @"color":[UIColor mainTextColor], @"font":kFont10};
    
    pricesArray[4] = @{@"string":[NSString stringWithFormat:@"     %@", LocalizedString(@"LOW")], @"color":[UIColor assistTextColor], @"font":kFont10};
    pricesArray[5] = @{@"string":[NSString stringWithFormat:@"   %@", self.lPriceValueLabel.text], @"color":[UIColor mainTextColor], @"font":kFont10};
    
   
    self.rightLabel.attributedText = [NSString mergeStrings:pricesArray];
}

#pragma mark - 3. 订阅详情
- (void)sendDetailTikerSubscribe {
    self.webModel.params = [NSMutableDictionary dictionary];
    self.webModel.params[@"topic"] = @"realtimes";
    self.webModel.params[@"event"] = @"sub";
    self.webModel.params[@"markets"] = @"";
    self.webModel.params[@"symbol"] = [NSString stringWithFormat:@"%@.%@", KDetail.symbolModel.exchangeId, KDetail.symbolModel.symbolId];
    self.webModel.params[@"params"] = @{@"binary":@(YES)};
    
    self.webModel.httpUrl = @"quote/v1/ticker";
    self.webModel.httpParams = [NSMutableDictionary dictionary];
    self.webModel.httpParams[@"symbol"] = [NSString stringWithFormat:@"%@.%@", KDetail.symbolModel.exchangeId, KDetail.symbolModel.symbolId];
    [KQuoteSocket sendWebSocketSubscribeWithWebSocketModel:self.webModel];
}

#pragma mark - 4. 出现
- (void)show {
    
    // 发送详情24小时行情
    [self sendDetailTikerSubscribe];
}

#pragma mark - 5. 消失
- (void)dismiss {
    
    // 取消订阅
    [KQuoteSocket cancelWebSocketSubscribeWithWebSocketModel:self.webModel];
}

#pragma mark - 6. 清理数据
- (void)cleanData {

     self.nowLabel.text = @"--";
     
     self.nowLabel.textColor = [UIColor increaseColor];
     
     self.moneyLabel.text = @"--";
    
     self.hPriceValueLabel.text = @"--";
     self.lPriceValueLabel.text = @"--";
     self.numberValueLabel.text = @"--";

     // 全屏所用
     self.leftLabel.text = @"--";
     
     // 24量 高 低
     self.rightLabel.text = @"--";
}

#pragma mark - || 懒加载
/** 最新价 */
- (XXLabel *)nowLabel {
    if (_nowLabel == nil) {
        _nowLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 0, K375(260), 35) font:kFontBold(K375(32.0f)) textColor:kGreen100];
    }
    return _nowLabel;
}

- (XXLabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.nowLabel.frame), K375(250), 35) text:@"" font:kFontBold12 textColor:kGreen100];
    }
    return _moneyLabel;
}

/** 最高价 */
- (XXLabel *)hPriceLabel {
    if (_hPriceLabel == nil) {
        _hPriceLabel = [XXLabel labelWithFrame:CGRectMake(kScreen_Width - K375(100), 0, K375(85), 25) text:LocalizedString(@"HIGH") font:kFont12 textColor:[UIColor assistTextColor]];
    }
    return _hPriceLabel;
}

/** 最高价值标签 */
- (XXLabel *)hPriceValueLabel {
    if (_hPriceValueLabel == nil) {
        _hPriceValueLabel = [XXLabel labelWithFrame:self.hPriceLabel.frame text:@"" font:kFont12 textColor:[UIColor mainTextColor]];
        _hPriceValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _hPriceValueLabel;
}

/** 最低价 */
- (XXLabel *)lPriceLabel {
    if (_lPriceLabel == nil) {
        _lPriceLabel = [XXLabel labelWithFrame:CGRectMake(self.hPriceLabel.left, CGRectGetMaxY(self.hPriceLabel.frame), self.hPriceLabel.width, self.hPriceLabel.height) text:LocalizedString(@"LOW") font:kFont12 textColor:[UIColor assistTextColor]];
    }
    return _lPriceLabel;
}

/** 最低价值标签 */
- (XXLabel *)lPriceValueLabel {
    if (_lPriceValueLabel == nil) {
        _lPriceValueLabel = [XXLabel labelWithFrame:self.lPriceLabel.frame text:@"" font:kFont12 textColor:[UIColor mainTextColor]];
        _lPriceValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _lPriceValueLabel;
}

/** 成交量 */
- (XXLabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel = [XXLabel labelWithFrame:CGRectMake(self.hPriceLabel.left, CGRectGetMaxY(self.lPriceLabel.frame), self.hPriceLabel.width, self.hPriceLabel.height) text:@"24H" font:kFont12 textColor:[UIColor assistTextColor]];
    }
    return _numberLabel;
}

/** 成交量值标签 */
- (XXLabel *)numberValueLabel {
    if (_numberValueLabel == nil) {
        _numberValueLabel = [XXLabel labelWithFrame:self.numberLabel.frame text:@"" font:kFont12 textColor:[UIColor mainTextColor]];
        _numberValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numberValueLabel;
}

- (XXLabel *)leftLabel {
    if (_leftLabel == nil) {
        _leftLabel = [[XXLabel alloc] init];
    }
    return _leftLabel;
}

- (XXLabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [XXLabel labelWithFrame:CGRectMake(0, 0, 0, 0) font:kFont12 textColor:kDark50];
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

/** 行情数据模型 */
- (XXTickerModel *)tickerModel {
    if (_tickerModel == nil) {
        _tickerModel = [XXTickerModel new];
    }
    return _tickerModel;
}

- (void)dealloc {
    NSLog(@"==+==币对详情【24小时行情】释放了");
}
@end
