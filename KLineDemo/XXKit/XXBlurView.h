//
//  XXBlurView.h
//  iOS
//
//  Created by iOS on 2018/9/4.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXBlurView : UIView

- (instancetype)initWithFrame:(CGRect)frame effectAlpha:(CGFloat)alpha;

@property (nonatomic, assign) CGFloat blurAlpha;

@end
