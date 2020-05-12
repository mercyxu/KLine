//
//  XXCoinInfoView.h
//  iOS
//
//  Created by iOS on 2019/9/23.
//  Copyright © 2019 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXCoinInfoView : UIView

/** <#mark#> */
@property (strong, nonatomic) void(^reloadMainUI)(void);

#pragma mark - 1. 加载币种信息
- (void)loadDataOfCoin;

- (void)cleanData;
@end

NS_ASSUME_NONNULL_END
