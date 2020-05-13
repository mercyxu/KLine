//
//  XXTickerWindow.m
//  iOS
//
//  Created by iOS on 2018/6/29.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXTickerWindow.h"
#import "UIColor+Y_StockChart.h"

@interface XXTickerWindow () {
    
    CGFloat _itemHeight;
}

/** 标签数组 */
@property (strong, nonatomic) NSMutableArray *labelsArray;

/** 项目数组 */
@property (strong, nonatomic) NSMutableArray *itemsArray;

@end

@implementation XXTickerWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderColor = [UIColor assistTextColor].CGColor;
        self.layer.borderWidth = 1;
        
        _itemHeight = 20;
        self.backgroundColor = [UIColor backgroundColor];
        self.labelsArray = [NSMutableArray array];
        for (NSInteger i=0; i < self.itemsArray.count; i ++) {
    
            XXLabel *valueLabel = [XXLabel labelWithFrame:CGRectMake(5, _itemHeight*i, self.width - 10, _itemHeight) text:@"" font:kFont10 textColor:[UIColor mainTextColor]];
            valueLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:valueLabel];
            
            [self.labelsArray addObject:valueLabel];
        }
        
    }
    return self;
}

- (void)setModel:(Y_KLineModel *)model {
    
    _model = model;
    for (NSInteger i=0; i < self.labelsArray.count; i ++) {
        XXLabel *valueLabel = self.labelsArray[i];
        switch (i) {
            case 0:
            {
                NSString *ymdString = [[[NSDate dateStringWithTimeTamp:[_model.Date integerValue]] componentsSeparatedByString:@" "] firstObject];
                NSString *hmsString = [[[NSDate dateStringWithTimeTamp:[_model.Date integerValue]] componentsSeparatedByString:@" "] lastObject];
                if ([model.kLineType isEqualToString:@"1d"] || [model.kLineType isEqualToString:@"1w"]) {
                    valueLabel.text = ymdString;
                } else if ([model.kLineType isEqualToString:@"1M"]) {
                    valueLabel.text = [ymdString substringToIndex:ymdString.length - 3];
                } else {
                    valueLabel.text = [NSString stringWithFormat:@"%@ %@", ymdString, [hmsString substringToIndex:hmsString.length - 3]];
                }
            }
                break;
            case 1:
                valueLabel.text = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [_model.Open doubleValue]] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]];
                valueLabel.text = [NSString stringWithFormat:@"%@：%@", self.itemsArray[1], valueLabel.text];
                break;
            case 2:
                valueLabel.text = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [_model.High doubleValue]] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]];
                valueLabel.text = [NSString stringWithFormat:@"%@：%@", self.itemsArray[2], valueLabel.text];
                break;
            case 3:
                valueLabel.text = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [_model.Low doubleValue]] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]];
                valueLabel.text = [NSString stringWithFormat:@"%@：%@", self.itemsArray[3], valueLabel.text];
                break;
            case 4:
                valueLabel.text = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [_model.Close doubleValue]] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]];
                valueLabel.text = [NSString stringWithFormat:@"%@：%@", self.itemsArray[4], valueLabel.text];
                break;
            case 5:
            {
                double rfValue = [_model.Close doubleValue] - [_model.Open doubleValue];
                valueLabel.text = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", rfValue] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]];
                if (rfValue >= 0) {
                    valueLabel.textColor = kGreen100;
                    valueLabel.text = [NSString stringWithFormat:@"+%@", valueLabel.text];
                } else {
                    valueLabel.textColor = kRed100;
                }
                valueLabel.text = [NSString stringWithFormat:@"%@：%@", self.itemsArray[5], valueLabel.text];
                break;
            }
            case 6:
            {
                CGFloat rfValue = [_model.Close floatValue] - [_model.Open floatValue];
                rfValue = rfValue*100/[_model.Open floatValue];
                valueLabel.text = [NSString riseFallValue:rfValue];
                if (rfValue > 0) {
                    valueLabel.text = [NSString stringWithFormat:@"+%@", valueLabel.text];
                    valueLabel.textColor = kGreen100;
                } else {
                    valueLabel.textColor = kRed100;
                }
                valueLabel.text = [NSString stringWithFormat:@"%@：%@", self.itemsArray[6], valueLabel.text];
                break;
            }
            case 7:
                valueLabel.text = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", _model.Volume] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.basePrecision]];
                valueLabel.text = [NSString stringWithFormat:@"%@：%@", self.itemsArray[7], [NSString handValuemeLengthWithAmountStr:valueLabel.text]];
                break;
                
            default:
                break;
        }
    }
}

- (NSMutableArray *)itemsArray {
    if (_itemsArray == nil) {
        _itemsArray = [NSMutableArray arrayWithObjects:LocalizedString(@"ShiJian"), LocalizedString(@"Open"), LocalizedString(@"HIGH"), LocalizedString(@"LOW"), LocalizedString(@"Close"), LocalizedString(@"ZhangDieE"), LocalizedString(@"ZhangDieFu"), LocalizedString(@"Volume"), nil];
    }
    return _itemsArray;
}

@end
