//
//  CATextLayer+DateTextLayer.h
//  BTC-Kline
//
//  Created by duanmu on 2018/8/17.
//  Copyright © 2018年 yate1996. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface CATextLayer (DateTextLayer)
/**
 绘制文字
 
 @param text 字符串
 @param textColor 文字颜色
 @param bgColor 背景颜色
 @param frame 文字frame
 @return 返回CATextLayer
 */
+ (CATextLayer *)fl_getTextLayerWithString:(NSString *)text
                                 textColor:(UIColor *)textColor
                                  fontSize:(CGFloat)fontSize
                           backgroundColor:(UIColor *)bgColor
                                     frame:(CGRect)frame;
@end
