//
//  XXKlineActionView.h
//  iOS
//
//  Created by iOS on 2018/6/28.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXKlineActionView : UIView

/** k线按钮数组 */
@property (strong, nonatomic) NSMutableArray *kButtonsArray;
@property (strong, nonatomic) NSMutableArray *kMainButtonsArray;

/** 主图按钮数组 */
@property (strong, nonatomic) NSMutableArray *mainButtonsArray;

/** 副图按钮数组 */
@property (strong, nonatomic) NSMutableArray *fButtonsArray;

/** 分钟按钮 */
@property (strong, nonatomic) XXButton *minuteButton;

/** 是否处于显示状态 */
@property (assign, nonatomic) BOOL isShow;

- (void)show;

- (void)dismiss;

- (void)reloadUI;

/** 按钮回调 */
@property (strong, nonatomic) void(^kActionBlock)(NSInteger index);

@end
