//
//  MainTabBtn.m
//  Tourist
//
//  Created by Lvka on 16/11/30.
//  Copyright © 2016年 HG_hupfei. All rights reserved.
//

#import "MainTabBtn.h"

#define kImageWith 24

@interface MainTabBtn ()

@end

@implementation MainTabBtn


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = kFont12;
    }

    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.imageView.frame = CGRectMake((self.frame.size.width - kImageWith)*0.5, 7, kImageWith, kImageWith);

    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.imageView.frame));
}


@end
