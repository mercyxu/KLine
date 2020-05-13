//
//  Y_KLineMAView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/2.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "Y_KLineModel.h"
#import "Y_StockChartGlobalVariable.h"

@interface Y_KLineMAView ()

@property (strong, nonatomic) UILabel *MA5Label;
@property (strong, nonatomic) UILabel *MA10Label;
@property (strong, nonatomic) UILabel *MA30Label;

@property (strong, nonatomic) UILabel *dateDescLabel;

@property (strong, nonatomic) UILabel *openDescLabel;

@property (strong, nonatomic) UILabel *closeDescLabel;

@property (strong, nonatomic) UILabel *highDescLabel;

@property (strong, nonatomic) UILabel *lowDescLabel;

@property (strong, nonatomic) UILabel *openLabel;

@property (strong, nonatomic) UILabel *closeLabel;

@property (strong, nonatomic) UILabel *highLabel;

@property (strong, nonatomic) UILabel *lowLabel;

@end

@implementation Y_KLineMAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _MA5Label = [self private_createLabel];
        _MA30Label = [self private_createLabel];
        _dateDescLabel = [self private_createLabel];
        _openDescLabel = [self private_createLabel];
        _openDescLabel.text = @" 开:";

        _closeDescLabel = [self private_createLabel];
        _closeDescLabel.text = @" 收:";

        _highDescLabel = [self private_createLabel];
        _highDescLabel.text = @" 高:";

        _lowDescLabel = [self private_createLabel];
        _lowDescLabel.text = @" 低:";

        _openLabel = [self private_createLabel];
        _closeLabel = [self private_createLabel];
        _highLabel = [self private_createLabel];
        _lowLabel = [self private_createLabel];
        
        
        _MA5Label.textColor = [UIColor ma5Color];
        _MA30Label.textColor = [UIColor ma30Color];
        _openLabel.textColor = [UIColor whiteColor];
        _highLabel.textColor = [UIColor whiteColor];
        _lowLabel.textColor = [UIColor whiteColor];
        _closeLabel.textColor = [UIColor whiteColor];

        NSNumber *labelWidth = [NSNumber numberWithInt:47];
        
        [_dateDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(@100);

        }];

        [_openDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];

        [_openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_openDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(labelWidth);

        }];

        [_highDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_openLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];

        [_highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_highDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(labelWidth);

        }];

        [_lowDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_highLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];

        [_lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lowDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(labelWidth);

        }];

        [_closeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_lowLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];

        [_closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_closeDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(labelWidth);

        }];

        [_MA5Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_closeLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);

        }];

        [_MA30Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_MA5Label.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

- (instancetype)initSamall
{
    self = [super init];
    if (self) {
        _MA5Label = [self private_createLabel];
        _MA10Label = [self private_createLabel];
        _MA30Label = [self private_createLabel];

        _MA5Label.textColor = [UIColor ma5Color];
        _MA10Label.textColor = [UIColor ma10Color];
        _MA30Label.textColor = [UIColor ma30Color];
  
        _MA5Label.frame = CGRectMake(K375(10), 2, 10, 10);
        _MA10Label.frame = CGRectMake(K375(10), 2, 10, 10);
        _MA30Label.frame = CGRectMake(K375(10), 2, 10, 10);
        
    }
    return self;
}

+(instancetype)view
{
    Y_KLineMAView *MAView = [[Y_KLineMAView alloc]init];

    return MAView;
}
-(void)maProfileWithModel:(Y_KLineModel *)model
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.Date.doubleValue/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    _dateDescLabel.text = [@" " stringByAppendingString: dateStr];
    
    _openLabel.text = [NSString stringWithFormat:@"%.2f",model.Open.doubleValue];
    _highLabel.text = [NSString stringWithFormat:@"%.2f",model.High.doubleValue];
    _lowLabel.text = [NSString stringWithFormat:@"%.2f",model.Low.doubleValue];
    _closeLabel.text = [NSString stringWithFormat:@"%.2f",model.Close.doubleValue];
    /*
     #pragma mark BOLL_MB的颜色
     +(UIColor *)BOLL_MBColor
     {
         return RGBColor(243, 217, 145);
     }

     #pragma mark BOLL_UP的颜色
     +(UIColor *)BOLL_UPColor
     {
         return RGBColor(96, 207, 190);
     }

     #pragma mark BOLL_DN的颜色
     +(UIColor *)BOLL_DNColor
     {
         return RGBColor(201, 145, 252);
     }
     */
    if (self.MainViewType == Y_StockChartcenterViewTypeTimeLine || [Y_StockChartGlobalVariable mainViewLineStatus] == Y_StockChartTargetLineStatusCloseMA) {
        _MA5Label.text = @"";
        _MA10Label.text = @"";
        _MA30Label.text = @"";
    } else if ([Y_StockChartGlobalVariable mainViewLineStatus] == Y_StockChartTargetLineStatusBOLL) {
        
        if ([model.BOLL_MB doubleValue] == 0) {
            _MA5Label.text = @"";
        } else {
            _MA5Label.text = [NSString stringWithFormat:@" BOLL:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.BOLL_MB doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        }
        
        if ([model.BOLL_UP doubleValue] == 0) {
            _MA10Label.text = @"";
        } else {
            _MA10Label.text = [NSString stringWithFormat:@" UP:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.BOLL_UP doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        }
        
        if ([model.BOLL_DN doubleValue] == 0) {
            _MA30Label.text = @"";
        } else {
            _MA30Label.text = [NSString stringWithFormat:@" DN:%@",[KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.BOLL_DN doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        }
        
    } else if([Y_StockChartGlobalVariable mainViewLineStatus] == Y_StockChartTargetLineStatusMA) {
        
        if ([model.MA5 doubleValue] == 0) {
            _MA5Label.text = @"";
        } else {
            _MA5Label.text = [NSString stringWithFormat:@" MA5:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.MA5 doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        }
    
        if ([model.MA10 doubleValue] == 0) {
            _MA10Label.text = @"";
        } else {
            _MA10Label.text = [NSString stringWithFormat:@" MA10:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.MA10 doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        }
        
        if ([model.MA30 doubleValue] == 0) {
            _MA30Label.text = @"";
        } else {
            _MA30Label.text = [NSString stringWithFormat:@" MA30:%@",[KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.MA30 doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        }
    } else if ([Y_StockChartGlobalVariable mainViewLineStatus] == Y_StockChartTargetLineStatusEMA) {
        
        if ([model.MA5 doubleValue] == 0) {
            _MA5Label.text = @"";
        } else {
            _MA5Label.text = [NSString stringWithFormat:@" EMA5:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.MA5 doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        }
        
        if ([model.MA10 doubleValue] == 0) {
            _MA10Label.text = @"";
        } else {
            _MA10Label.text = [NSString stringWithFormat:@" EMA10:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.MA10 doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        }

        if ([model.MA30 doubleValue] == 0) {
            _MA30Label.text = @"";
        } else {
            _MA30Label.text = [NSString stringWithFormat:@" EMA30:%@",[KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.MA30 doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        }
    }
    
    
    [_MA5Label sizeToFit];
    _MA5Label.height = _MA30Label.height;
    _MA5Label.left = 2;
    
    [_MA10Label sizeToFit];
    _MA10Label.height = _MA5Label.height;
    _MA10Label.left = CGRectGetMaxX(_MA5Label.frame) + K375(5);
    
    [_MA30Label sizeToFit];
    _MA30Label.height = _MA5Label.height;
    _MA30Label.left = CGRectGetMaxX(_MA10Label.frame) + K375(5);
}
- (UILabel *)private_createLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor assistTextColor];
    [self addSubview:label];
    return label;
}

//- (void)setMainViewType:(Y_StockChartCenterViewType)MainViewType {
//    _MainViewType = MainViewType;
//    if (MainViewType == Y_StockChartcenterViewTypeTimeLine) {
//        self.MA5Label.hidden = YES;
//        self.MA10Label.hidden = YES;
//        self.MA30Label.hidden = YES;
//    } else {
//        self.MA5Label.hidden = NO;
//        self.MA10Label.hidden = NO;
//        self.MA30Label.hidden = NO;
//    }
//}
@end
