//
//  XXImageView.h
//  Bhex
//
//  Created by BHEX on 2018/6/7.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXImageView : UIImageView

/**
 *  @author xuyiheng
 *
 *  1.【frame、模式】
 *  模式一般为：UIViewContentModeScaleAspectFill
 */
+ (XXImageView *)labelWithFrame:(CGRect)frame
                    contentMode:(UIViewContentMode)contentMode;

/**
 *  @author xuyiheng
 *
 *  2.【frame、图片、模式】
 *  模式一般为：UIViewContentModeScaleAspectFill
 */
+ (XXImageView *)labelWithFrame:(CGRect)frame
                          image:(UIImage *)image
                    contentMode:(UIViewContentMode)contentMode;

@end
