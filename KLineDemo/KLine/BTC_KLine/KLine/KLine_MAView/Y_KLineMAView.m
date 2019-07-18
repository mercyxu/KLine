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
@interface Y_KLineMAView ()

@property (strong, nonatomic) UILabel *MA7Label;

@property (strong, nonatomic) UILabel *MA30Label;

@property (strong, nonatomic) UILabel *MA5Label;

@property (strong, nonatomic) UILabel *MA10Label;

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
        _MA7Label = [self private_createLabel];
        _MA30Label = [self private_createLabel];
//        _MA5Label = [self private_createLabel];
//        _MA10Label = [self private_createLabel];
//        _dateDescLabel = [self private_createLabel];
        
//        _openDescLabel = [self private_createLabel];
//        _openDescLabel.text = @"开";
//
//        _closeDescLabel = [self private_createLabel];
//        _closeDescLabel.text = @"收";
//
//        _highDescLabel = [self private_createLabel];
//        _highDescLabel.text = @"高";
//
//        _lowDescLabel = [self private_createLabel];
//        _lowDescLabel.text = @"低";
//
//        _openLabel = [self private_createLabel];
//        _closeLabel = [self private_createLabel];
//        _highLabel = [self private_createLabel];
//        _lowLabel = [self private_createLabel];
        
        
        _MA7Label.textColor = [UIColor ma7Color];
        _MA30Label.textColor = [UIColor ma30Color];
        _MA5Label.textColor = [UIColor ma7Color];
        _MA10Label.textColor = [UIColor ma30Color];
        _openLabel.textColor = [UIColor assistTextColor];
        _highLabel.textColor = [UIColor assistTextColor];
        _lowLabel.textColor = [UIColor assistTextColor];
        _closeLabel.textColor = [UIColor assistTextColor];
        _openLabel.font = [UIFont fontWithName:@"ArialMT" size:11];
        _highLabel.font = [UIFont fontWithName:@"ArialMT" size:11];
        _lowLabel.font = [UIFont fontWithName:@"ArialMT" size:11];
        _closeLabel.font = [UIFont fontWithName:@"ArialMT" size:11];
        
        self.backgroundColor = [UIColor clearColor];
//        NSNumber *labelWidth = [NSNumber numberWithInt:(KScreenWidth - 100) / 4];
        
//        [_dateDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left);
//            make.top.equalTo(@15);
//            make.bottom.equalTo(self.mas_bottom);
//            make.width.equalTo(@95);
//        }];
//
//        [_openDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left);
//            make.top.equalTo(self.mas_top);
//            make.height.equalTo(@10);
//        }];
//
//        [_openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self->_openDescLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//            make.height.equalTo(@10);
//            make.width.equalTo(labelWidth);
//
//        }];
//
//        [_highDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self->_openLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//            make.height.equalTo(@10);
//        }];
//
//        [_highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self->_highDescLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//            make.height.equalTo(@10);
//            make.width.equalTo(labelWidth);
//
//        }];
//
//        [_lowDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self->_highLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//            make.height.equalTo(@10);
//        }];
//
//        [_lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self->_lowDescLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//            make.height.equalTo(@10);
//            make.width.equalTo(labelWidth);
//
//        }];
//
//        [_closeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self->_lowLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//            make.height.equalTo(@10);
//        }];
//
//        [_closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self->_closeDescLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//            make.height.equalTo(@10);
//            make.width.equalTo(labelWidth);
//
//        }];
        
//        [_MA5Label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self->_closeLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//            make.bottom.equalTo(self.mas_bottom);
//
//        }];
        
        [_MA7Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);

        }];
        
//        [_MA10Label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self->_MA5Label.mas_right);
//            make.top.equalTo(self.mas_top);
//            make.bottom.equalTo(self.mas_bottom);
//        }];

        
        [_MA30Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_MA7Label.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
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
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.Date.doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    _dateDescLabel.text = [@" " stringByAppendingString: dateStr];
    
//    UIColor *color = (model.Close.doubleValue - model.Open.doubleValue) >= 0 ? [UIColor increaseColor] :[UIColor decreaseColor];
//    _openLabel.textColor = color;
//    _highLabel.textColor = color;
//    _lowLabel.textColor = color;
//    _closeLabel.textColor = color;
//    _openLabel.text = [CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.Open.doubleValue  afterPoint:model.price];
//    _highLabel.text = [CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.High.doubleValue  afterPoint:model.price];
//    _lowLabel.text = [CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.Low.doubleValue  afterPoint:model.price];
//    _closeLabel.text = [CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.Close.doubleValue  afterPoint:model.price];
 
    _MA7Label.text = [NSString stringWithFormat:@" MA7：%@",[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.MA7.doubleValue  afterPoint:model.coin]];
    _MA30Label.text = [NSString stringWithFormat:@" MA30：%@",[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.MA30.doubleValue  afterPoint:model.coin]];
//    _MA5Label.text = [NSString stringWithFormat:@" MA5：%@",[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.MA5.doubleValue  afterPoint:model.coin]];
//    _MA10Label.text = [NSString stringWithFormat:@" MA10：%@",[CommonMethod calculateWithRoundingMode:NSRoundPlain roundingValue:model.MA10.doubleValue  afterPoint:model.coin]];
}
- (UILabel *)private_createLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = RGB(241, 241, 241);
    [self addSubview:label];
    return label;
}
@end
