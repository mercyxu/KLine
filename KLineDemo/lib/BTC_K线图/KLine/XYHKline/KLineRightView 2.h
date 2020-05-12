//
//  KLineRightView.h
//  Bhex
//
//  Created by YiHeng on 2020/3/22.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KLineRightView : UIView

/** 最新价 */
@property (strong, nonatomic, nullable) NSString *closePrice;

/** <#备注#> */
@property (assign, nonatomic) CGFloat startX;
@property (assign, nonatomic) CGFloat endX;
@end

NS_ASSUME_NONNULL_END
