//
//  XXBDetailSectionHeaderView.h
//  iOS
//
//  Created by iOS on 2018/6/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXBDetailSectionHeaderView : UIView


/** 索引 0. 委托单 1. 最新成交 2. 币种简介 */
@property (assign, nonatomic) NSInteger index;

/** 回调block
 index: 0. 委托订单 1. 最新成交 2. 币种简介
 */
@property (strong, nonatomic) void(^headActionBlock)(NSInteger index);

/** 1. 初始化UI */
- (void)setupUI;
@end
