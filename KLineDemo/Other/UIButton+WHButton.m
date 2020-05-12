//
//  UIButton+WHButton.m
//  
//
//  Created by chejingji on 2017/6/1.
//  Copyright © 2017年 chejingji. All rights reserved.
//

#import "UIButton+WHButton.h"
#import <objc/runtime.h>

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;
@implementation UIButton (WHButton)

-(void)setBlock:(void(^)(UIButton*))block
{
    objc_setAssociatedObject(self,@selector(block), block,OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTarget:self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside]; 
}

-(void(^)(UIButton*))block

{
    return objc_getAssociatedObject(self,@selector(block));
    
}

-(void)addTapBlock:(void(^)(UIButton*))block

{
    
    self.block= block;
    
    [self addTarget:self action:@selector(click:)forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)click:(UIButton*)btn

{
    
    if(self.block) {
        
        self.block(btn);
        
    }
    
}

- (void)verticalImageAndTitle:(CGFloat)spacing
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}

- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor title:(NSString *)title {
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = frame;
    button.backgroundColor = backgroundColor;
    
    if (title.length) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        
    }
    if (titleFont) {
        button.titleLabel.font = titleFont;
    }
    
    if (imageName.length) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        if (title.length) {
            
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        }
    }
    
    if (cornerRadius > 0) {
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = cornerRadius;
    }
    button.layer.borderWidth = borderWidth;
    button.layer.borderColor = borderColor.CGColor;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)backgroundColor title:(NSString *)title {
    return [UIButton fd_buttonWithTarget:target action:action frame:frame imageName:imageName titleColor:titleColor titleFont:titleFont backgroundColor:backgroundColor cornerRadius:0 borderWidth:0 borderColor:nil title:title];
}

+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont title:(NSString *)title {
    return [UIButton fd_buttonWithTarget:target action:action frame:frame imageName:imageName titleColor:titleColor titleFont:titleFont backgroundColor:nil cornerRadius:0 borderWidth:0 borderColor:nil title:title];
}

+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont title:(NSString *)title {
    return [UIButton fd_buttonWithTarget:target action:action frame:frame imageName:nil titleColor:titleColor titleFont:titleFont backgroundColor:nil cornerRadius:0 borderWidth:0 borderColor:nil title:title];
}

+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont backgroundColor:(UIColor *)backgroundColor title:(NSString *)title {
    return [UIButton fd_buttonWithTarget:target action:action frame:frame imageName:nil titleColor:titleColor titleFont:titleFont backgroundColor:backgroundColor cornerRadius:0 borderWidth:0 borderColor:nil title:title];
}

+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    return [UIButton fd_buttonWithTarget:target action:action frame:frame imageName:imageName titleColor:nil titleFont:0 backgroundColor:nil cornerRadius:cornerRadius borderWidth:borderWidth borderColor:borderColor title:nil];
}

+ (UIButton *)fd_buttonWithTarget:(id)target action:(SEL)action frame:(CGRect)frame imageName:(NSString *)imageName {
    return [UIButton fd_buttonWithTarget:target action:action frame:frame imageName:imageName titleColor:nil titleFont:0 backgroundColor:nil cornerRadius:0 borderWidth:0 borderColor:nil title:nil];
}

@end
