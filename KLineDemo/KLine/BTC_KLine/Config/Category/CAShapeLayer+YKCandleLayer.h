//
//  CAShapeLayer+YKCandleLayer.h
//  kLineDemo
//
//  Created by duanmu on 2018/8/8.
//  Copyright © 2018年 duanmu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Y_KLinePositionModel.h"
@interface CAShapeLayer (YKCandleLayer)
/**
 生成蜡烛Layer
 
 @param model 蜡烛坐标模型
 @param candleWidth 宽度
 @return 返回Layer
 */
+ (CAShapeLayer *)fl_getCandleLayerWithPointModel:(Y_KLinePositionModel *)model candleWidth:(CGFloat)candleWidth;
/**
 生成矩形Layer
 
 @param rectangleFrame 矩形Fream
 @param bgColor 矩形颜色
 @return 返回Layer
 */
+ (CAShapeLayer *)fl_getRectangleLayerWithFrame:(CGRect)rectangleFrame backgroundColor:(UIColor *)bgColor;
@end
