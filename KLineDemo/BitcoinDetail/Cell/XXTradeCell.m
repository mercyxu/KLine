//
//  XXBDetailCell.m
//  iOS
//
//  Created by iOS on 2018/6/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXTradeCell.h"
#import "UIColor+Y_StockChart.h"

@interface XXTradeCell ()

/** 成交时间 */
@property (strong, nonatomic) XXLabel *dateLabel;

/** 方向标签 */
@property (strong, nonatomic) XXLabel *typeLabel;

/** 价格标签 */
@property (strong, nonatomic) XXLabel *priceLabel;

/** 成交量 */
@property (strong, nonatomic) XXLabel *amountLabel;



@end

@implementation XXTradeCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor backgroundColor];
        
        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 创建主界面
- (void)setupUI {
    
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.amountLabel];
}

#pragma mark - 2. 数据模型赋值
- (void)setModel:(XXTradeModel *)model {
    
    _model = model;
    self.dateLabel.text = [[[NSString dateStringFromTimestampWithTimeTamp:model.t] componentsSeparatedByString:@" "] firstObject];
    self.priceLabel.text = [KDecimal decimalNumber:KString(model.p) RoundingMode:NSRoundDown scale:self.priceDigit];
    self.amountLabel.text = [KDecimal decimalNumber:KString(model.q) RoundingMode:NSRoundDown scale:self.numberDigit];
    if (model.m) {
        self.typeLabel.textColor = kGreen100;
        self.typeLabel.text = LocalizedString(@"Buy");
    } else {
        self.typeLabel.textColor = kRed100;
        self.typeLabel.text = LocalizedString(@"Sell");
    }
}

#pragma mark - || 懒加载
- (XXLabel *)dateLabel {
    if (_dateLabel == nil) {
        CGFloat width = (kScreen_Width - KSpacing*2)/4;
        _dateLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 0, width, [XXTradeCell getCellHeight]) text:@"" font:kFont14 textColor:[UIColor mainTextColor]];
    }
    return _dateLabel;
}

- (XXLabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.dateLabel.frame), 0, self.dateLabel.width * 0.8, [XXTradeCell getCellHeight]) text:@"" font:kFontBold14 textColor:kGreen100];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLabel;
}

- (XXLabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame), 0, self.dateLabel.width * 1.2, [XXTradeCell getCellHeight]) text:@"" font:kFont14 textColor:[UIColor mainTextColor]];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

- (XXLabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame), 0, self.dateLabel.width, [XXTradeCell getCellHeight]) text:@"" font:kFont14 textColor:[UIColor mainTextColor]];
        _amountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _amountLabel;
}

+ (CGFloat)getCellHeight {
    return 32;
}

@end
