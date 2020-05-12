//
//  Y_AccessoryMAView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/4.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_AccessoryMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "Y_KLineModel.h"

@interface Y_AccessoryMAView()

@property (strong, nonatomic) UILabel *accessoryDescLabel;

@property (strong, nonatomic) UILabel *DIFLabel;

@property (strong, nonatomic) UILabel *DEALabel;

@property (strong, nonatomic) UILabel *MACDLabel;

@end
@implementation Y_AccessoryMAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _DIFLabel = [self private_createLabel];
        _DEALabel = [self private_createLabel];
        _MACDLabel = [self private_createLabel];
        _accessoryDescLabel = [self private_createLabel];
        
        
        
        _DIFLabel.textColor = [UIColor ma7Color];
        _DEALabel.textColor = [UIColor ma30Color];
        _MACDLabel.textColor = [UIColor clearColor];

        
        [_accessoryDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
        [_DIFLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.accessoryDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            
        }];
        
        [_DEALabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.DIFLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [_MACDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.DEALabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

+(instancetype)view
{
    Y_AccessoryMAView *MAView = [[Y_AccessoryMAView alloc]init];
    
    return MAView;
}
-(void)maProfileWithModel:(Y_KLineModel *)model
{
    
    if(self.targetLineStatus != Y_StockChartTargetLineStatusKDJ && self.targetLineStatus != Y_StockChartTargetLineStatusRSI && self.targetLineStatus != Y_StockChartTargetLineStatusWR)
    {
        _accessoryDescLabel.text = @" MACD(12,26,9)";
        _DIFLabel.text = [NSString stringWithFormat:@"  DIF：%@",[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.DIF.doubleValue  afterPoint:model.price]];
        _DEALabel.text = [NSString stringWithFormat:@"  DEA：%@",[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.DEA.doubleValue  afterPoint:model.price]];
        _MACDLabel.text = [NSString stringWithFormat:@"  MACD：%@",[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.MACD.doubleValue  afterPoint:model.price]];
    }else if (self.targetLineStatus == Y_StockChartTargetLineStatusRSI){
        _accessoryDescLabel.text = @" RSI(6,12,24)";
        _DIFLabel.text = [NSString stringWithFormat:@"  RSI1：%.8f ",model.RSI_6.floatValue];
        _DEALabel.text = [NSString stringWithFormat:@"  RSI2：%.8f",model.RSI_12.floatValue];
        _MACDLabel.text = [NSString stringWithFormat:@"  RSI3：%.8f",model.RSI_24.floatValue];
    }else if (self.targetLineStatus == Y_StockChartTargetLineStatusKDJ){
        _accessoryDescLabel.text = @" KDJ(9,3,3)";
        _DIFLabel.text = [NSString stringWithFormat:@"  K：%.8f ",model.KDJ_K.doubleValue];
        _DEALabel.text = [NSString stringWithFormat:@"  D：%.8f",model.KDJ_D.doubleValue];
        _MACDLabel.text = [NSString stringWithFormat:@"  J：%.8f",model.KDJ_J.doubleValue];
    }else{
        _accessoryDescLabel.text = [NSString stringWithFormat:@"WR(14)：%@ ",[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.WR.doubleValue afterPoint:model.price]];
        _DIFLabel.text = @"";
        _DEALabel.text = @"";
        _MACDLabel.text = @"";
    }
}

- (UILabel *)private_createLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor assistTextColor];
    [self addSubview:label];
    return label;
}

@end
