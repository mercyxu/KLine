//
//  XXKlineShareView.h
//  iOS
//
//  Created by iOS on 2019/5/22.
//  Copyright © 2019 iOS. All rights reserved.
//

//#import "XXShadowView.h"
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface XXKlineShareView : XXShadowView

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXKlineShareView : UIView

/** logo */
@property (strong, nonatomic) UIImageView *logoImageView;

/** 名称 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 平台 */
@property (strong, nonatomic) XXLabel *exLabel;

/** 二维码 */
@property (strong, nonatomic) UIImageView *codeImageView;

@end

NS_ASSUME_NONNULL_END
