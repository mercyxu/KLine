//
//  XXFullPopButton.h
//  iOS
//
//  Created by iOS on 2018/7/30.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXFullPopButton : UIButton

/** 按钮数组 */
@property (strong, nonatomic) NSArray *buttonsArray;


/** 是否处于显示状态 */
@property (assign, nonatomic) BOOL isShowing;

- (void)show;

- (void)dismiss;
@end
