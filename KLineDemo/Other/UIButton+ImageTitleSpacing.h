//
//  UIButton+ImageTitleSpacing.h
//
//  Created by Zhimi on 2018/8/25.
//  Copyright © 2018年 hexuren. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ZMButtonEdgeInsetsStyle) {
    ZMButtonEdgeInsetsStyleTop, // image在上，label在下
    ZMButtonEdgeInsetsStyleLeft, // image在左，label在右
    ZMButtonEdgeInsetsStyleBottom, // image在下，label在上
    ZMButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (ImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(ZMButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
