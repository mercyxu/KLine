//
//  XXEntrustmentOrderCell.m
//  iOS
//
//  Created by iOS on 2018/6/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXDepthCell.h"
#import "UIColor+Y_StockChart.h"

#define LeftSpace K375(15)
#define TopSpace K375(0)

@interface XXDepthCell ()

/** 左下版式图 */
@property (strong, nonatomic) UIView *leftLowView;

/** 左上版式图nonatomic,  */
@property (strong, nonatomic) UIView *leftTopView;

/** 右下视图 */
@property (strong, nonatomic) UIView *rightLowView;

/** 右上视图 */
@property (strong, nonatomic) UIView *rightTopView;

/** 左成交数量 */
@property (strong, nonatomic) XXLabel *leftNumberLabel;

/** 左价格标签 */
@property (strong, nonatomic) XXLabel *leftPriceLabel;

/** 右价格标签 */
@property (strong, nonatomic) XXLabel *rightPriceLabel;

/** 右成交量 */
@property (strong, nonatomic) XXLabel *rightNumberLabel;

@end

@implementation XXDepthCell

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
    
    /** 左下版式图 */
    [self.contentView addSubview:self.leftLowView];
    
    /** 左上版式图 */
    [self.leftLowView addSubview:self.leftTopView];
    
    /** 右下视图 */
    [self.contentView addSubview:self.rightLowView];
    
    /** 右上视图 */
    [self.rightLowView addSubview:self.rightTopView];
    
    /** 左成交数量 */
    [self.leftLowView addSubview:self.leftNumberLabel];
    
    /** 左价格标签 */
    [self.leftLowView addSubview:self.leftPriceLabel];
    
    /** 右价格标签 */
    [self.rightLowView addSubview:self.rightPriceLabel];
    
    /** 右成交量 */
    [self.rightLowView addSubview:self.rightNumberLabel];
}

- (void)reloadData {
    if (self.model == nil) {
        
        self.leftTopView.width = self.leftLowView.width;
        self.leftNumberLabel.text = @"--";
        self.leftPriceLabel.text = @"--";
        
        self.rightTopView.width = 0;
        self.rightPriceLabel.text = @"--";
        self.rightNumberLabel.text = @"--";

    } else {
        
        
    }
    
    if (self.model.leftPrice.length <= 12) {
        self.leftPriceLabel.font = kFont(14.0f);
        self.leftNumberLabel.font = kFont(14.0f);
        self.rightPriceLabel.font = kFont(14.0f);
        self.rightNumberLabel.font = kFont(14.0f);
    } else {
        self.leftPriceLabel.font = kFont(12.0f);
        self.leftNumberLabel.font = kFont(12.0f);
        self.rightPriceLabel.font = kFont(12.0f);
        self.rightNumberLabel.font = kFont(12.0f);
    }
    
    if (self.model.leftPrice) {
        
        if (self.isAmount) {
            self.leftNumberLabel.text = [NSString handValuemeLengthWithAmountStr:self.model.leftNumber];
        } else {
            self.leftNumberLabel.text = [NSString handValuemeLengthWithAmountStr:[NSString stringWithFormat:@"%.13f", self.model.leftSumNumber]];
        }
        
        self.leftPriceLabel.text = self.model.leftPrice;
        if (self.ordersAverage == 0) {
            self.ordersAverage = 1;
        }
        
        CGFloat leftValue = self.model.leftSumNumber/self.ordersAverage;
        if (leftValue >= 1.0) {
            self.leftTopView.width = 0;
        } else {
            self.leftTopView.width = (1.0 - leftValue)*self.leftLowView.width;
        }
    } else {
        self.leftTopView.width = self.leftLowView.width;
        self.leftNumberLabel.text = @"--";
        self.leftPriceLabel.text = @"--";
    }
    
    if (self.model.rightPrice) {
        
        self.rightPriceLabel.text = self.model.rightPrice;
        
        if (self.isAmount) {
            self.rightNumberLabel.text = [NSString handValuemeLengthWithAmountStr:self.model.rightNumber];
        } else {
            self.rightNumberLabel.text = [NSString handValuemeLengthWithAmountStr:[NSString stringWithFormat:@"%.13f", self.model.rightSumNumber]];
        }
        
        CGFloat rightValue = self.model.rightSumNumber/self.ordersAverage;
        if (rightValue >= 1.0) {
            self.rightTopView.width = self.rightLowView.width;
        } else {
            self.rightTopView.width = self.rightLowView.width*rightValue;
        }
    } else {
        self.rightTopView.width = 0;
        self.rightPriceLabel.text = @"--";
        self.rightNumberLabel.text = @"--";
    }
}

+ (CGFloat)getCellHeight {
    return 32;
}

#pragma mark - || 懒加载
/** 左下版式图 */
- (UIView *)leftLowView {
    if (_leftLowView == nil) {
        _leftLowView = [[UIView alloc] initWithFrame:CGRectMake(0, TopSpace, kScreen_Width/2 - K375(2), [XXDepthCell getCellHeight] - TopSpace*2)];
        _leftLowView.backgroundColor = kGreen20;
    }
    return _leftLowView;
}

/** 左上版式图 */
- (UIView *)leftTopView {
    if (_leftTopView == nil) {
        _leftTopView = [[UIView alloc] initWithFrame:self.leftLowView.bounds];
        _leftTopView.backgroundColor = [UIColor backgroundColor];
        _leftTopView.userInteractionEnabled = NO;
    }
    return _leftTopView;
}

/** 右下视图 */
- (UIView *)rightLowView {
    if (_rightLowView == nil) {
        _rightLowView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width/2 + K375(2), TopSpace, self.leftLowView.width, self.leftLowView.height)];
    }
    return _rightLowView;
}

/** 右上视图 */
- (UIView *)rightTopView {
    if (_rightTopView == nil) {
        _rightTopView = [[UIView alloc] initWithFrame:self.rightLowView.bounds];
        _rightTopView.backgroundColor = kRed20;
        _rightTopView.width = 0;
        _rightTopView.userInteractionEnabled = NO;
    }
    return _rightTopView;
}

/** 左成交数量 */
- (XXLabel *)leftNumberLabel {
    if (_leftNumberLabel == nil) {
        _leftNumberLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 0, Kscal(200), self.leftLowView.height) font:kFont14 textColor:[UIColor mainTextColor]];
    }
    return _leftNumberLabel;
}

/** 左价格标签 */
- (XXLabel *)leftPriceLabel {
    if (_leftPriceLabel == nil) {
        _leftPriceLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.leftNumberLabel.frame), 0, self.leftLowView.width - CGRectGetMaxX(self.leftNumberLabel.frame), self.leftLowView.height) text:@"" font:kFont14 textColor:kGreen100 alignment:NSTextAlignmentRight];
    }
    return _leftPriceLabel;
}

/** 右价格标签 */
- (XXLabel *)rightPriceLabel {
    if (_rightPriceLabel == nil) {
        _rightPriceLabel = [XXLabel labelWithFrame:CGRectMake(K375(5), 0, Kscal(300), self.rightLowView.height) font:kFont14 textColor:kRed100];
    }
    return _rightPriceLabel;
}

/** 右成交量 */
- (XXLabel *)rightNumberLabel {
    if (_rightNumberLabel == nil) {
        _rightNumberLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.rightPriceLabel.frame), 0, self.rightLowView.width - CGRectGetMaxX(self.rightPriceLabel.frame) - KSpacing, self.rightLowView.height) text:@"" font:kFont14 textColor:[UIColor mainTextColor] alignment:NSTextAlignmentRight];
    }
    return _rightNumberLabel;
}

@end
