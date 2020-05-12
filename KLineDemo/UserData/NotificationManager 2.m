//
//  NotificationManager.m
//  Bhex
//
//  Created by BHEX on 2018/7/15.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager

/**
 0. 发送券商id更细通知
 */
+ (void)postOrgIdChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:OrgIdChange_NotificationName object:nil];
}

#pragma mark - 1. 发送登录成功通知
+ (void)postLoginInSuccessNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:Login_In_NotificationName object:nil];
}

#pragma mark - 2. 发送退出登录成功通知
+ (void)postLoginOutSuccessNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:Login_Out_NotificationName object:nil];
}

#pragma mark - 3. 发送切换币对通知
+ (void)postSwitchTradeSymbolNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:Switch_TradeSymbol_NotificationName object:nil];
}

#pragma mark - 4. 发送来网通知
+ (void)postComeNetNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:ComeNet_NotificationName object:nil];
}

 #pragma mark - 5. 发送app从后台进入前台通知
+ (void)postApplicationEnterForegroundNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationEnterForegroundNotificationName object:nil];
}

#pragma mark - 6. 发送从无到有交易币对通知
+ (void)postHaveTradeSymbolNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:Have_TradeSymbol_NotificationName object:nil];
}

#pragma mark - 7. 币对列表需要更新通知
+ (void)postSymbolListNeedUpdateNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:SymbolList_NeedUpdate_NotificationName object:nil];
}

#pragma mark - 8. 发送期权交易切换币对通知
+ (void)postSwitchOptionTradeSymbolNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:Switch_OptionTradeSymbol_NotificationName object:nil];
}

#pragma mark - 9. 发送期权交易币对从无到有通知
+ (void)postHaveOptionTradeSymbolNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:Have_OptionTradeSymbol_NotificationName object:nil];
}

#pragma mark - 10. 期权币对列表需要更新通知
+ (void)postOptionSymbolListNeedUpdateNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:OptionSymbolList_NeedUpdate_NotificationName object:nil];
}

/**
 11. 【合约】交易切换币对通知
 */
+ (void)postSwitchContractTradeSymbolNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:Switch_ContractTradeSymbol_NotificationName object:nil];
}

/**
 12. 【合约】交易币对从无到有通知
 */
+ (void)postHaveContractTradeSymbolNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:Have_ContractTradeSymbol_NotificationName object:nil];
}

/**
 13. 【合约】币对列表需要更新通知
 */
+ (void)postContractSymbolListNeedUpdateNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:ContractSymbolList_NeedUpdate_NotificationName object:nil];
}
@end
