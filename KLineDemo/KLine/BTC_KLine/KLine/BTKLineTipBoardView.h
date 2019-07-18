//
//  BTKLineTipBoardView.h
//  Bitbt
//
//  Created by iOS on 2019/6/21.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTKLineTipBoardView : UIView

@property (nonatomic, strong) UIColor *strockColor;

@property (nonatomic, strong) UIColor *fillColor;

/**
 *  圆角弧度
 */
@property (nonatomic, assign) CGFloat radius;

/**
 *  字体， 默认系统字体，大小 10
 */
@property (nonatomic, strong) UIFont *font;

/**
 *  隐藏时间, 默认3s
 */
@property (nonatomic, assign) CGFloat hideDuration;

/**
 *  画背景图
 */
- (void)drawInContext;

- (void)showWithTipPoint:(CGPoint)point isFullScreen:(BOOL)isFullScreen;

- (void)hide;

/**
 *  开盘价
 */
@property (nonatomic, copy) NSString *open;

/**
 *  收盘价
 */
@property (nonatomic, copy) NSString *close;

/**
 *  最高价
 */
@property (nonatomic, copy) NSString *high;

/**
 *  最低价
 */
@property (nonatomic, copy) NSString *low;

/**
 *  时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  涨跌额
 */
@property (nonatomic, copy) NSString *riseDrop;

/**
 *  涨跌幅
 */
@property (nonatomic, copy) NSString *percent;

/**
 *  成交量
 */
@property (nonatomic, copy) NSString *vol;

/**************************************************/
/*                     字体颜色                    */
/**************************************************/
//提供不一样的字体颜色可供选择， 默认都｛白色｝

/**
 *  开盘价颜色
 */
@property (nonatomic, strong) UIColor *openColor;

/**
 *  收盘价颜色
 */
@property (nonatomic, strong) UIColor *closeColor;

/**
 *  最高价颜色
 */
@property (nonatomic, strong) UIColor *highColor;

/**
 *  最低价颜色
 */
@property (nonatomic, strong) UIColor *lowColor;

/**
 *  时间
 */
@property (nonatomic, strong) UIColor *timeColor;
/**
 *  涨跌额
 */
@property (nonatomic, strong) UIColor *riseDropColor;

/**
 *  涨跌幅
 */
@property (nonatomic, strong) UIColor *percentColor;

/**
 *  成交量
 */
@property (nonatomic, strong) UIColor *volColor;

@end

NS_ASSUME_NONNULL_END
