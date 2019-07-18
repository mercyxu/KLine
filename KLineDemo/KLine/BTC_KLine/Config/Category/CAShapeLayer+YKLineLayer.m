//
//  CAShapeLayer+YKLineLayer.m
//  kLineDemo
//
//  Created by duanmu on 2018/8/8.
//  Copyright © 2018年 duanmu. All rights reserved.
//

#import "CAShapeLayer+YKLineLayer.h"
#import "UIBezierPath+YKBezierPath.h"


@implementation CAShapeLayer (YKLineLayer)


/**
 生成单条线

 @param pointArr 坐标点数组
 @param lineColor 线颜色
 @return 返回线段图层
 */
+ (CAShapeLayer *)getSingleLineLayerWithPointArray:(NSArray *)pointArr
                                         lineColor:(UIColor *)lineColor
{
    UIBezierPath *path = [UIBezierPath getBezierPathWithPointArr:pointArr];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1.f;
    layer.strokeColor = lineColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    return layer;
}


/**
 生成包含多条线的线段

 @param pointArr 坐标点数组
 @param lineColor 线颜色
 @return 返回线段图层
 */
+ (CAShapeLayer *)getMultipleLineLayerWithPointArray:(NSArray *)pointArr
                                           lineColor:(UIColor *)lineColor
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int idxX=0; idxX<pointArr.count; idxX++)
    {
        NSArray *idxXArr = pointArr[idxX];
        
        [path moveToPoint:[[idxXArr firstObject] CGPointValue]];
        for (int idxY=1; idxY<idxXArr.count; idxY++)
        {
            [path addLineToPoint:[idxXArr[idxY] CGPointValue]];
        }
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = 1.f;
    layer.strokeColor = lineColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    return layer;
}



@end
