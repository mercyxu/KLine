//
//  UIView+tap.m
//  zfbuser
//
//  Created by sansan on 15-9-3.
//  Copyright (c) 2015年 hexuren. All rights reserved.
//

#import "UIView+tap.h"
#import <objc/runtime.h>


@implementation UIView (tap)

static const char * KeyTapGes = "KeyTapGes";
static const char * KeyLongPressGes = "KeyLongPressGes";
static const char * KeyTapBlock = "KeyTapBlock";

-(void)removeAllGesture
{
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIGestureRecognizer *ges = obj;
        [self removeGestureRecognizer:ges];
    }];
}

-(UITapGestureRecognizer *)addTapGesWithTarget:(id)sender action:(SEL)action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = nil;
    tap = (UITapGestureRecognizer*)objc_getAssociatedObject(self, KeyTapGes);
    if (nil == tap) {
//        [self removeAllGesture];
        tap = [[UITapGestureRecognizer alloc] initWithTarget:sender action:action];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.cancelsTouchesInView = YES;
        tap.delaysTouchesBegan = YES;
        tap.delaysTouchesEnded = YES;
        [self addGestureRecognizer:tap];
        tap.enabled = YES;
        objc_setAssociatedObject(self,KeyTapGes, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    };
    return tap;
}

-(UILongPressGestureRecognizer *)addLongPressGesWithTarget:(id)sender action:(SEL)action
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer * longPress = nil;
    longPress = (UILongPressGestureRecognizer *)objc_getAssociatedObject(self, KeyLongPressGes);
    if (nil == longPress) {
//        [self removeAllGesture];
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:sender action:action];
        longPress.minimumPressDuration = 0.8;
        [self addGestureRecognizer:longPress];
        longPress.enabled = YES;
        objc_setAssociatedObject(self,KeyLongPressGes, longPress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    };
    return longPress;
}

-(void)addTapCallBack:(void (^)(void))cb
{
    [self addTapGesWithTarget:self action:@selector(__handleTap:)];
     objc_setAssociatedObject(self,KeyTapBlock, cb, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)__handleTap:(UITapGestureRecognizer *)ges
{
    void (^block )(void) = objc_getAssociatedObject(self, KeyTapBlock);
    if (block) {
        block();
    };
}

@end
