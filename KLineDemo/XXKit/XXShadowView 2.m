//
//  XXShadowView.m
//  Bhex
//
//  Created by Bhex on 2018/9/5.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXShadowView.h"

@implementation XXShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kViewBackgroundColor;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.layer.cornerRadius = 2.0;
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.layer.shadowRadius = 10.0;
        self.layer.shadowOpacity = 1;
        
        if (KUser.isNightType) {
            self.layer.shadowColor = (KBigLine_Color).CGColor;
        } else {
            self.layer.shadowColor = (kDark5).CGColor;
        }

        self.shadowView = [[UIView alloc] initWithFrame:self.bounds];
        self.shadowView.layer.shadowRadius = 1.0;
        self.shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.shadowView.backgroundColor = kViewBackgroundColor;
        [self addSubview:self.shadowView];
        self.shadowView.layer.cornerRadius = 2.0;
        self.shadowView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        self.shadowView.layer.shadowOpacity = 1;
        
        if (KUser.isNightType) {
            self.shadowView.layer.shadowColor = (KRGBA(4,11.5,18,100)).CGColor;
        } else {
            self.shadowView.layer.shadowColor = (kDark10).CGColor;
        }
    }
    return self;
}

@end
