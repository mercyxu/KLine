//
//  UIView+tap.h
//  zfbuser
//
//  Created by sansan on 15-9-3.
//  Copyright (c) 2015年 hexuren. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  为 UIView 提供快速添加 点击手势 的功能
 */
@interface UIView (tap)

/**
 *  快速为UIView添加一个Tap 手势
 *
 *  @param sender 手势响应对象
 *  @param action 手势响应对象调用的函数
 *
 *  @return 手势
 */
-(UITapGestureRecognizer *)addTapGesWithTarget:(id)sender action:(SEL)action;

-(UILongPressGestureRecognizer *)addLongPressGesWithTarget:(id)sender action:(SEL)action;

/**
 *  快速为UIView 添加一个点击block 回调
 */
-(void)addTapCallBack:(void (^)(void)) cb;


/**
 *  移除所有手势
 */
-(void)removeAllGesture;

@end
