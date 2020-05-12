//
//  UIView+VJQ.m
//  CarManager
//
//  Created by Heaven Wang on 11/14/14.
//  Copyright (c) 2014 Heaven Wang. All rights reserved.
//

#import "UIView+VJQ.h"
#import <objc/runtime.h>
@implementation UIView (VJQ)

static NSInteger badgeLabelKey;//类似于一个中转站,参考

- (void)setSize:(CGSize)size;
{
    CGPoint origin = self.frame.origin;
    
    self.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
}

- (CGSize)size;
{
    return self.frame.size;
}

- (CGFloat)left;
{
    return CGRectGetMinX(self.frame);
}

- (void)setLeft:(CGFloat)x;
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top;
{
    return CGRectGetMinY(self.frame);
}

- (void)setTop:(CGFloat)y;
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right;
{
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right;
{
    CGRect frame = self.frame;
    frame.origin.x = right - CGRectGetWidth(frame);
    
    self.frame = frame;
}

- (CGFloat)bottom;
{
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom;
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - CGRectGetHeight(frame);
    
    self.frame = frame;
}

- (CGFloat)centerX;
{
    return [self center].x;
}

- (void)setCenterX:(CGFloat)centerX;
{
    if (isnan(centerX)) {
        centerX = 0;
    }
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY;
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY;
{
    if (isnan(centerY)) {
        centerY = 0;
    }
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width;
{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width;
{
    CGRect frame = self.frame;
    frame.size.width = width;
    
    self.frame = CGRectStandardize(frame);
}

- (CGFloat)height;
{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height;
{
    CGRect frame = self.frame;
    frame.size.height = height;
    
    self.frame = CGRectStandardize(frame);
}

/*!
 @brief     移除该view下所有subview
 */
- (void)removeAllSubviews
{
    while (self.subviews.count)
        [(UIView *)self.subviews.lastObject removeFromSuperview];
}


#pragma mark - 解决手势冲突
//在单击和双击手势时,由于手势的触发条件会有重合,有些情况下会产生冲突,无法达到满意的效果,利用 requireGestureRecognizerToFail 的方法指定某个手势确定失效之后才会触发本次手势，即使本次手势的触发条件已经满足
static inline void requireSingleTapsRecognizer(UIGestureRecognizer *recognizer,UIView *target)
{
    for (UIGestureRecognizer *gesture in target.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gesture;
            if (tap.numberOfTouchesRequired==1&tap.numberOfTapsRequired == 1) {
                [tap requireGestureRecognizerToFail:recognizer];
            }
        }
    }
}

static inline void requireDoubleTapsRecognizer(UIGestureRecognizer *recognizer,UIView *target)
{
    for (UIGestureRecognizer *gesture in target.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gesture;
            if (tap.numberOfTapsRequired == 2&tap.numberOfTouchesRequired == 1) {
                [tap requireGestureRecognizerToFail:recognizer];
            }
        }
    }
}


static inline void requireLongPressTecognizer(UIGestureRecognizer *recognizer,UIView *target)
{
    for (UIGestureRecognizer *gesture in target.gestureRecognizers){
        if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
            UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)gesture;
            [longPress requireGestureRecognizerToFail:recognizer];
        }
    }
}

//关键字为void*指针（任意类型指针）,每一个关联的关键字必须是唯一的，通常采用静态变量来作为关键字
static char CCSingleTapBlockKey;
static char CCDoubleTapBlockKey;
static char CCDoubleFingerTapBlockKey;
static char CCTouchDownTapBlockKey;
static char CCTouchUpTapBlcokKey;
static char CCLongPressBlockKey;

#pragma mark - 添加block属性
//获取关联对象
- (void)makeBlockForkey:(void *)key
{
    CCTappedBlock block = objc_getAssociatedObject(self, key);
    if (block) block();
}

//创建关联
- (void)setBlockForKey:(void *)key block:(CCTappedBlock)block
{
    self.userInteractionEnabled = YES;
    objc_setAssociatedObject(self, key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - CallBacks
- (void)singleTap
{
    [self makeBlockForkey:&CCSingleTapBlockKey];
}

- (void)doubleTap
{
    [self makeBlockForkey:&CCDoubleTapBlockKey];
}

- (void)doubleFingerTap
{
    [self makeBlockForkey:&CCDoubleFingerTapBlockKey];
}

- (void)longPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)[self makeBlockForkey:&CCLongPressBlockKey];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self makeBlockForkey:&CCTouchDownTapBlockKey];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self makeBlockForkey:&CCTouchUpTapBlcokKey];
}

#pragma mark -Taps
- (void)whenTapped:(CCTappedBlock)block
{
    UITapGestureRecognizer *tap = [self addTapRecognizerWithTaps:1 touches:1 sel:@selector(singleTap)];
    requireDoubleTapsRecognizer(tap,self);
    requireLongPressTecognizer(tap,self);
    [self setBlockForKey:&CCSingleTapBlockKey block:block];
}

- (void)whenDoubleTapped:(CCTappedBlock)block
{
    UITapGestureRecognizer *tap = [self addTapRecognizerWithTaps:2 touches:1 sel:@selector(doubleTap)];
    requireSingleTapsRecognizer(tap,self);
    [self setBlockForKey:&CCDoubleTapBlockKey block:block];
}

- (void)whenDoubleFingerTapped:(CCTappedBlock)block
{
    [self addTapRecognizerWithTaps:1 touches:2 sel:@selector(doubleFingerTap)];
    [self setBlockForKey:&CCDoubleFingerTapBlockKey block:block];
}

- (void)whenLongPress:(CCTappedBlock)block
{
    [self addLongPressRecognizerWithTouches:1 sel:@selector(longPress:)];
    [self setBlockForKey:&CCLongPressBlockKey block:block];
}

- (void)whenTouchDown:(CCTappedBlock)block
{
    [self setBlockForKey:&CCTouchDownTapBlockKey block:block];
}

- (void)whenTouchUp:(CCTappedBlock)block
{
    [self setBlockForKey:&CCTouchUpTapBlcokKey block:block];
}

#pragma mark - 添加手势
- (UITapGestureRecognizer *)addTapRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches sel:(SEL)sel
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:sel];
    tapGr.delegate = self;
    tapGr.numberOfTapsRequired = taps;
    tapGr.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGr];
    return tapGr;
}

- (UILongPressGestureRecognizer *)addLongPressRecognizerWithTouches:(NSUInteger)touches sel:(SEL)sel
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:sel];
    longPress.numberOfTouchesRequired = touches;
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
    return longPress;
}

#pragma mark - UIGestureRecognizerDelegate

#pragma mark - badge
/**
 *  添加badge
 */
- (void)addBadgeTip:(NSString *)badgeValue {

    if ( [badgeValue integerValue] > 0 ) {
        
        if ( self.badgeLabel ) {
            
            self.badgeLabel.hidden = NO;
            
            [self setBadgeNumber:badgeValue];
            
        } else {
        
            [self createBadgeLabel];
            
            [self setBadgeNumber:badgeValue];
        }
        
    } else {
    
        if ( self.badgeLabel ) {
            
            self.badgeLabel.hidden = YES;
        }
    }
}

/**
 *  创建 badgeLabel 标签
 */
- (void)createBadgeLabel {
    
    self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 + 2, 5, 15, 15)];
    self.badgeLabel.backgroundColor = [UIColor redColor];
    self.badgeLabel.layer.cornerRadius = self.badgeLabel.height / 2;
    self.badgeLabel.layer.masksToBounds = YES;
    self.badgeLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeLabel.font = [UIFont boldSystemFontOfSize:9];
    self.badgeLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.badgeLabel];
}

/**
 *  设置数值
 */
- (void)setBadgeNumber:(NSString *)badgeValue {

    self.badgeLabel.text = [NSString stringWithFormat:@"%@", badgeValue];
    
    [self.badgeLabel sizeToFit];
    self.badgeLabel.height = 15;
    self.badgeLabel.width += 5;
    if ( self.badgeLabel.width < 15 ) {
        self.badgeLabel.width = 15;
    }
}

- (void)setBadgeLabel:(UILabel *)badgeLabel {

    objc_setAssociatedObject(self, &badgeLabelKey, badgeLabel, OBJC_ASSOCIATION_RETAIN);
    
}

- (UILabel *)badgeLabel {
    
    return objc_getAssociatedObject(self, &badgeLabelKey);
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (void)animationAlertView {
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 0.3)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];

    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}
@end
