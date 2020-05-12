//
//  XXWebSocket.h
//  Bhex
//
//  Created by Bhex on 2018/8/22.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "SRWebSocket.h"

@interface XXWebSocket : SRWebSocket

/** 心跳字符串 */
@property (strong, nonatomic) NSString *pingString;

/** 1. 发送心跳 */
- (void)sendHeartbeat;

/** 2. 取消定时心跳 */
- (void)cancelSendHeartbeat;
@end
