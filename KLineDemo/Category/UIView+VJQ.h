//
//  UIView+VJQ.h
//  CarManager
//
//  Created by Heaven Wang on 11/14/14.
//  Copyright (c) 2014 Heaven Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

// CGRect 的上下左右 中心
#define kCGleft(x) CGRectGetMinX(x)
#define kCGRight(x) CGRectGetMaxX(x)
#define kCGTop(x) CGRectGetMinY(x)
#define kCGBottom(x) CGRectGetMaxY(x)
#define kCGCenterX(x) CGRectGetMidX(x)
#define kCGCenterY(x) CGRectGetMidY(x)
#define kCGWidth(x) x.size.width
#define kCGHight(x) x.size.height
#define kCGPoint(x)  CGPoint(CGRectGetMidX(x),CGRectGetMidY(x))
#define kCGPaddingY(x,y)   (x.bounds.size.height-y)*0.5

@interface UIView (VJQ)<UIGestureRecognizerDelegate>

/*!
 @brief UIView快速设置和获取
 */
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;



/*!
 @brief     移除该view下所有subview
 */
- (void)removeAllSubviews;

typedef void (^CCTappedBlock)();

- (void)whenTapped:(CCTappedBlock)block;            //单击
- (void)whenDoubleTapped:(CCTappedBlock)block;      //双击
- (void)whenDoubleFingerTapped:(CCTappedBlock)block;//两根手指点击
- (void)whenLongPress:(CCTappedBlock)block;         //长按
- (void)whenTouchDown:(CCTappedBlock)block;         //开始点击时
- (void)whenTouchUp:(CCTappedBlock)block;           //结束点击时


#pragma mark - badge
/**
 * badge
 */
@property (strong, nonatomic) UILabel *badgeLabel;

/**
 *  添加badge
 */
- (void)addBadgeTip:(NSString *)badgeValue;

- (UIViewController *)viewController;

/** 动画弹框 */
- (void)animationAlertView;

@end
