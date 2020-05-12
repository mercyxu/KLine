//
//  XXImageView.m
//  Bhex
//
//  Created by BHEX on 2018/6/7.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXImageView.h"

@implementation XXImageView

+ (XXImageView *)labelWithFrame:(CGRect)frame
                    contentMode:(UIViewContentMode)contentMode {
    
    XXImageView *imageView = [[XXImageView alloc] initWithFrame:frame];
    imageView.contentMode = contentMode;
    
    return imageView;
}

+ (XXImageView *)labelWithFrame:(CGRect)frame
                          image:(UIImage *)image
                    contentMode:(UIViewContentMode)contentMode {
    XXImageView *imageView = [[XXImageView alloc] initWithFrame:frame];
    imageView.contentMode = contentMode;
    if (image) {
        imageView.image = image;
    }
    return imageView;
    
}
@end
