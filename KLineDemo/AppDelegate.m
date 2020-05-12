//
//  AppDelegate.m
//  KLineDemo
//
//  Created by iOS on 2019/7/18.
//  Copyright © 2019 www.KlineDemo.com. All rights reserved.
//

#import "AppDelegate.h"
#import "XXTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    // 0. 读取市场数据
    [KMarket readCachedDataOfMarket];

    // 2. 加载汇率数据
    [[RatesManager sharedRatesManager] loadDataOfRates];
    
    self.window.rootViewController = [[XXTabBarController alloc] init];
    return YES;
}

#pragma mark - 4. 程序激活
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
     KSystem.isActive = YES;
    
    // 1. 打开行情长连接
    [KQuoteSocket openWebSocket];

    // 2. 判断是否登录打开用户长连接

    // 3. 刷新币对列表
    [KMarket loadDataOfSymbols];
}

#pragma mark - 5. 程序暂行
- (void)applicationWillResignActive:(UIApplication *)application {
    
    KSystem.isActive = NO;
    
    // 1. 关闭行情长连接
    [KQuoteSocket closeWebSocket];

    // 2. 关闭用户组长连接

    // 3. 取消定时刷新任务
    [KMarket cancelTimer];
}

#pragma mark - 6. 程序意外暂行
- (void)applicationWillTerminate:(UIApplication *)application {
    
     KSystem.isActive = NO;
    
    // 1. 关闭行情长连接
    [KQuoteSocket closeWebSocket];

    // 2. 关闭用户组长连接
    
    // 3. 取消定时刷新任务
    [KMarket cancelTimer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


@end
