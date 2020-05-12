//
//  XXShadowView.m
//  iOS
//
//  Created by iOS on 2018/9/5.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXShadowView.h"

@implementation XXShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGBColor(31, 32, 41);
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.layer.cornerRadius = 2.0;
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        self.layer.shadowRadius = 10.0;
        self.layer.shadowOpacity = 1;
        self.layer.shadowColor = (KBigLine_Color).CGColor;

        self.shadowView = [[UIView alloc] initWithFrame:self.bounds];
        self.shadowView.layer.shadowRadius = 1.0;
        self.shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.shadowView.backgroundColor = RGBColor(31, 32, 41);
        [self addSubview:self.shadowView];
        self.shadowView.layer.cornerRadius = 2.0;
        self.shadowView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        self.shadowView.layer.shadowOpacity = 1;
         self.shadowView.layer.shadowColor = (KRGBA(4,11.5,18,100)).CGColor;

    }
    return self;
}

@end
