//
//  CAShapeLayer+YKLineLayer.h
//  kLineDemo
//
//  Created by duanmu on 2018/8/8.
//  Copyright © 2018年 duanmu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#include <UIKit/UIKit.h>

@interface CAShapeLayer (YKLineLayer)

/**
 生成单条线
 
 @param pointArr 坐标点数组
 @param lineColor 线颜色
 @return 返回线段图层
 */
+ (CAShapeLayer *)getSingleLineLayerWithPointArray:(NSArray *)pointArr
                                         lineColor:(UIColor *)lineColor;

/**
 生成包含多条线的线段
 
 @param pointArr 坐标点数组
 @param lineColor 线颜色
 @return 返回线段图层
 */
+ (CAShapeLayer *)getMultipleLineLayerWithPointArray:(NSArray *)pointArr
                                           lineColor:(UIColor *)lineColor;

@end
