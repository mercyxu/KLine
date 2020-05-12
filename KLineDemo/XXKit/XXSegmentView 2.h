//
//  XXSegmentView.h
//  Bhex
//
//  Created by Bhex on 2019/10/24.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXSegmentView : UIView

/** 选中索引 */
@property (assign, nonatomic) NSInteger selectedSegmentIndex;

/** 改变值回调 */
@property (strong, nonatomic) void(^changeBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame items:(nullable NSArray *)items;
@end

NS_ASSUME_NONNULL_END
