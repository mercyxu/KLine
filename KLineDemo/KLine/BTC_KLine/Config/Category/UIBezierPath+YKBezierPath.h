//
//  UIBezierPath+YKBezierPath.h
//  kLineDemo
//
//  Created by duanmu on 2018/8/8.
//  Copyright © 2018年 duanmu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (YKBezierPath)

/**
 生成描述一条线段的路径
 
 @param pointArr 线段坐标点数组
 @return 返回路径
 */
+ (UIBezierPath *)getBezierPathWithPointArr:(NSArray *)pointArr;

@end
