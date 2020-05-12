//
//  AppDelegate+Category.h
//  iOS
//
//  Created by iOS on 2018/10/19.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Category)
- (BaseViewController *)TopVC;
+ (AppDelegate *)appDelegate;
@end

NS_ASSUME_NONNULL_END
