//
//  NotificationManager.h
//  iOS
//
//  Created by iOS on 2018/7/15.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

// 0. 券商id变化通知
#define OrgIdChange_NotificationName @"OrgIdChange_NotificationKey"

// 1.1 切换币币交易币对
#define Switch_TradeSymbol_NotificationName @"SwitchTradeSymbolNotificationKey"

// 1.2 币币交易比对从无到有
#define Have_TradeSymbol_NotificationName @"HaveTradeSymbolNotificationKey"

// 1.3 币对列表需要更新通知
#define SymbolList_NeedUpdate_NotificationName @"SymbolListNeedUpdateNotificationKey"

// 2.1 切换期权交易币对
#define Switch_OptionTradeSymbol_NotificationName @"SwitchOptionTradeSymbolNotificationKey"

// 2.2 期权交易比对从无到有
#define Have_OptionTradeSymbol_NotificationName @"HaveOptionTradeSymbolNotificationKey"

// 2.3 期权币对列表需要更新通知
#define OptionSymbolList_NeedUpdate_NotificationName @"OptionSymbolListNeedUpdateNotificationKey"

// 3.1 【合约】切换交易币对
#define Switch_ContractTradeSymbol_NotificationName @"SwitchContractTradeSymbolNotificationKey"

// 3.2 【合约】交易比对从无到有
#define Have_ContractTradeSymbol_NotificationName @"HaveContractTradeSymbolNotificationKey"

// 3.3 【合约】币对列表需要更新通知
#define ContractSymbolList_NeedUpdate_NotificationName @"ContractSymbolListNeedUpdateNotificationKey"


// 登录
#define Login_In_NotificationName @"loginInNotificationKey"

// 退出
#define Login_Out_NotificationName @"loginOutNotificationKey"

#define ComeNet_NotificationName @"ComeNetNotificationKey" // 来网通知

// app进入前台通知
#define ApplicationEnterForegroundNotificationName @"applicationWillEnterForeground"


@interface NotificationManager : NSObject

/**
 0. 发送登录成功通知
 */
+ (void)postOrgIdChangeNotification;

/**
 1. 发送登录成功通知
 */
+ (void)postLoginInSuccessNotification;

/**
 2. 发送退出登录成功通知
 */
+ (void)postLoginOutSuccessNotification;

/**
 3. 发送交易切换币对通知
 */
+ (void)postSwitchTradeSymbolNotification;

/**
 4. 发送来网通知
 */
+ (void)postComeNetNotification;

/**
 5. 发送app从后台进入前台通知
 */
+ (void)postApplicationEnterForegroundNotification;


/**
 6. 发送从无到有交易币对通知
 */
+ (void)postHaveTradeSymbolNotification;

/**
 7. 币对列表需要更新通知
 */
+ (void)postSymbolListNeedUpdateNotification;

/**
 8. 期权交易切换币对通知
 */
+ (void)postSwitchOptionTradeSymbolNotification;

/**
 9. 期权交易币对从无到有通知
 */
+ (void)postHaveOptionTradeSymbolNotification;

/**
 10. 期权币对列表需要更新通知
 */
+ (void)postOptionSymbolListNeedUpdateNotification;

/**
 11. 【合约】交易切换币对通知
 */
+ (void)postSwitchContractTradeSymbolNotification;

/**
 12. 【合约交易币对从无到有通知
 */
+ (void)postHaveContractTradeSymbolNotification;

/**
 13. 【合约币对列表需要更新通知
 */
+ (void)postContractSymbolListNeedUpdateNotification;
@end
