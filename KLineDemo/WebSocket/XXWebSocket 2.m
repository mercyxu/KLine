//
//  XXWebSocket.m
//  Bhex
//
//  Created by Bhex on 2018/8/22.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXWebSocket.h"

@implementation XXWebSocket

- (void)setPingString:(NSString *)pingString {
    _pingString = pingString;
}

#pragma mark - 1. 发送心跳
- (void)sendHeartbeat {
    self.pingString = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
    NSDictionary *ping = @{@"ping":self.pingString};
    if (self.readyState == SR_OPEN) {
        [self send:[ping mj_JSONString]];
        [self performSelector:@selector(sendHeartbeat) withObject:nil afterDelay:8];
    }
}

#pragma mark - 2. 取消定时心跳
- (void)cancelSendHeartbeat {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
@end
