//
//  XXQuoteSocket.h
//  Bhex
//
//  Created by Bhex on 2018/8/29.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XXWebQuoteModel.h"
#import "XXWebSocket.h"

@interface XXQuoteSocket : NSObject
singleton_interface(XXQuoteSocket)

/** webSocket */
@property (strong, nonatomic) XXWebSocket *webSocket;

/** 建立长连接 */
- (void)openWebSocket;

//** 关闭长连接 */
- (void)closeWebSocket;

/** 1. 订阅 */
- (void)sendWebSocketSubscribeWithWebSocketModel:(XXWebQuoteModel *)model;

/** 2. 取消订阅*/
- (void)cancelWebSocketSubscribeWithWebSocketModel:(XXWebQuoteModel *)model;



@end
