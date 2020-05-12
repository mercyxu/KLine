//
//  KLineTransverseLine.h
//  Bhex
//
//  Created by YiHeng on 2020/3/22.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLineTransverseLine : UIView

#pragma mark - 1. 设置最新价
- (void)setPointPrice:(NSString *)pointPrice centerX:(CGFloat)centerX isRight:(BOOL)isRight;

@end

NS_ASSUME_NONNULL_END
