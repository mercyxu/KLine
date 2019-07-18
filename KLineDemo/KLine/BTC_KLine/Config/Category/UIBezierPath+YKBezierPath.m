//
//  UIBezierPath+YKBezierPath.m
//  kLineDemo
//
//  Created by duanmu on 2018/8/8.
//  Copyright © 2018年 duanmu. All rights reserved.
//

#import "UIBezierPath+YKBezierPath.h"

@implementation UIBezierPath (YKBezierPath)


/**
 生成描述一条线段的路径

 @param pointArr 线段坐标点数组
 @return 返回路径
 */
+ (UIBezierPath *)getBezierPathWithPointArr:(NSArray *)pointArr
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint firstPoint = [[pointArr firstObject] CGPointValue];
    [path moveToPoint:firstPoint];
    
    for (int idx = 1; idx < pointArr.count; idx++)
    {
        [path addLineToPoint:[pointArr[idx] CGPointValue]];
    }
    
    return path;
}

@end
