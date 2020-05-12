//
//  XXFullView.h
//  iOS
//
//  Created by iOS on 2018/7/29.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXKineView.h"

@interface XXFullView : UIView

/** 中心点 */
@property (assign, nonatomic) CGRect klineFrame;

/** 左标签 */
@property (strong, nonatomic) XXLabel *leftLabel;

/** 右标签 */
@property (strong, nonatomic) XXLabel *rightLabel;

/** k线按钮数组 */
@property (strong, nonatomic) NSMutableArray *kButtonsArray;

/** 主图按钮数组 */
@property (strong, nonatomic) NSMutableArray *mainButtonsArray;

/** 副图按钮数组 */
@property (strong, nonatomic) NSMutableArray *fButtonsArray;

/** k线图 */
@property (strong, nonatomic) XXKineView *klineView;

/** 分钟按钮 */
@property (strong, nonatomic) XXButton *minuteButton;

/** 关闭回调 */
@property (strong, nonatomic) void(^outFullViewBlock)(void);

/** 显示 */
- (void)show;
@end
