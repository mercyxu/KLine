//
//  Y_VolumeMAView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/3.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_VolumeMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "Y_KLineModel.h"
#import "Y_StockChartGlobalVariable.h"

@interface Y_VolumeMAView ()
@property (strong, nonatomic) UILabel *VolumeMA5Label;

@property (strong, nonatomic) UILabel *VolumeMA10Label;

@property (strong, nonatomic) UILabel *volumeDescLabel;

@end
@implementation Y_VolumeMAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _VolumeMA5Label = [self private_createLabel];
        _VolumeMA10Label = [self private_createLabel];
        _volumeDescLabel = [self private_createLabel];

        _VolumeMA5Label.textColor = [UIColor ma5Color];
        _VolumeMA10Label.textColor = [UIColor ma10Color];
        _volumeDescLabel.textColor = RGBColor(110, 32, 254);
        
        [_volumeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(2);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
        [_VolumeMA5Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_volumeDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            
        }];
        
        [_VolumeMA10Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_VolumeMA5Label.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

+(instancetype)view
{
    Y_VolumeMAView *MAView = [[Y_VolumeMAView alloc]init];
    
    return MAView;
}
-(void)maProfileWithModel:(Y_KLineModel *)model
{
    if (model.Volume == 0) {
        _volumeDescLabel.text = @"--";
    } else {
        _volumeDescLabel.text = [NSString stringWithFormat:@" %@:%@ ",@"VOL", [NSString handValuemeLengthWithAmountStr:[NSString stringWithFormat:@"%.12f", model.Volume]]];
    }
    
    if([Y_StockChartGlobalVariable mainViewLineStatus] == Y_StockChartTargetLineStatusMA) {
        
        if ([model.Volume_MA5 doubleValue] == 0) {
            _VolumeMA5Label.text = @"";
        } else {
            _VolumeMA5Label.text = [NSString stringWithFormat:@"  MA5:%@ ", [NSString handValuemeLengthWithAmountStr:[NSString stringWithFormat:@"%.12f", [model.Volume_MA5 doubleValue]]]];
        }
        
        if ([model.Volume_MA10 doubleValue] == 0) {
            _VolumeMA10Label.text = @"";
        } else {
            _VolumeMA10Label.text = [NSString stringWithFormat:@"  MA10:%@ ", [NSString handValuemeLengthWithAmountStr:[NSString stringWithFormat:@"%.12f", [model.Volume_MA10 doubleValue]]]];
        }
    } else{
        
        if ([model.Volume_MA5 doubleValue] == 0) {
            _VolumeMA5Label.text = @"";
        } else {
            _VolumeMA5Label.text = [NSString stringWithFormat:@"  EMA5:%@ ", [NSString handValuemeLengthWithAmountStr:[NSString stringWithFormat:@"%.12f", [model.Volume_MA5 doubleValue]]]];
        }
        
        if ([model.Volume_MA10 doubleValue] == 0) {
            _VolumeMA10Label.text = @"";
        } else {
           _VolumeMA10Label.text = [NSString stringWithFormat:@"  EMA10:%@ ", [NSString handValuemeLengthWithAmountStr:[NSString stringWithFormat:@"%.12f", [model.Volume_MA10 doubleValue]]]];
        }
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
