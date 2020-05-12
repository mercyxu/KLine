//
//  XXQuoteSocket.m
//  iOS
//
//  Created by iOS on 2018/8/29.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXQuoteSocket.h"
#import <zlib.h>

@interface XXQuoteSocket () <SRWebSocketDelegate>

/** 索引id */
@property (assign, nonatomic) NSInteger indexId;

/** 所有订阅模型 */
@property (strong, nonatomic) NSMutableDictionary *dataDictionary;

@end

@implementation XXQuoteSocket
singleton_implementation(XXQuoteSocket)

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 1. 来网通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveComeNetNotificationName) name:ComeNet_NotificationName object:nil];
        
    }
    return self;
}

#pragma mark - 1.3 接收到来网通知
- (void)didReceiveComeNetNotificationName {
    [self openWebSocket];
}


#pragma mark - 1.1 建立长连接
- (void)openWebSocket {
    
    [self.webSocket cancelSendHeartbeat];
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;

    if (!KSystem.isActive) {
        return;
    }

    self.webSocket = [[XXWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kSocketQuoteUrl]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

#pragma mark - 1.2 关闭长连接
- (void)closeWebSocket {
 
    [self.webSocket cancelSendHeartbeat];
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;
}

#pragma mark - 2.0 长连接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    
    [self.webSocket sendHeartbeat];
    NSArray *keysArray = [self.dataDictionary allKeys];
    for (NSInteger i=0; i < keysArray.count; i ++) {
        NSString *keyString = keysArray[i];
        XXWebQuoteModel *model = self.dataDictionary[keyString];
        if (self.webSocket.readyState == SR_OPEN) {
            [self.webSocket send:[model.params mj_JSONString]];
        }
    }
}

#pragma mark - 2.1 长连接失败
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {

    [self umFailureError:error];
    
//    [XYHAlertView showAlertViewWithTitle:@"Quote-长连接异常断开！" message:nil titlesArray:nil andBlock:^(NSInteger index) {
//
//    }];
    
    if (KSystem.isActive == NO) {
        return;
    }
    
    NSArray *keysArray = [self.dataDictionary allKeys];
    for (NSInteger i=0; i < keysArray.count; i ++) {
        XXWebQuoteModel *model = self.dataDictionary[keysArray[i]];
        if (model.httpBlock) {
            model.httpBlock();
        }
    }
    
    // 断开连接后每过1s重新建立一次连接
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openWebSocket];
    });
}

#pragma mark - 2.2 长连接收到消息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    if (![message isKindOfClass:[NSString class]]) {
        NSData *dataInflate =  [self gzipInflate:message];
        message = [[NSString alloc] initWithData:dataInflate encoding:NSUTF8StringEncoding];
    }

    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[message mj_JSONObject]];
    NSString *keyId = dataDict[@"id"];
    NSString *ping = dataDict[@"ping"];
    NSString *pong = dataDict[@"pong"];
  
    if (ping) {
        NSDictionary *pong = @{@"pong":[NSString stringWithFormat:@"%@", ping]};
        if (self.webSocket.readyState == SR_OPEN) {
            [self.webSocket send:[pong mj_JSONString]];
        }
    } else if (pong) {
        
    } else {
        
        XXWebQuoteModel *model = self.dataDictionary[KString(keyId)];

        if (model && model.successBlock) {
            if ([dataDict[@"topic"] isEqualToString:@"diffMergedDepth"]) {
                model.isRed = [dataDict[@"f"] boolValue];
            }
            
            // 过滤k线
            if ([dataDict[@"topic"] isEqualToString:@"kline"]) {
                NSString *klineType = [NSString stringWithFormat:@"kline_%@", dataDict[@"params"][@"klineType"]];
                if (![model.params[@"topic"] isEqualToString:klineType]) {
                    return;
                } else {
//                    NSLog(@"k线=%@", message);
                }
            }
            if ([dataDict[@"data"] isKindOfClass:[NSArray class]]) {
                model.successBlock(dataDict[@"data"]);
            }
        }
    }
}

#pragma mark - 2.3 长连接正常关闭
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
//    [XYHAlertView showAlertViewWithTitle:@"Quote-长连接正常断开！" message:nil titlesArray:nil andBlock:^(NSInteger index) {
//
//    }];
    
    if (!KSystem.isActive) {
        return;
    }
    
    NSArray *keysArray = [self.dataDictionary allKeys];
    for (NSInteger i=0; i < keysArray.count; i ++) {
        XXWebQuoteModel *model = self.dataDictionary[keysArray[i]];
        if (model.failureBlock) {
            model.failureBlock();
        }
    }
    
    // 断开连接后每过1s重新建立一次连接
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openWebSocket];
    });
}

#pragma mark - 3.0 订阅
- (void)sendWebSocketSubscribeWithWebSocketModel:(XXWebQuoteModel *)model {
    
    // 有相同的订阅直接关闭
    NSArray *keysArray = [self.dataDictionary allKeys];
    for (NSInteger i=0; i < keysArray.count; i ++) {
        NSString *key = keysArray[i];
        XXWebQuoteModel *webModel = self.dataDictionary[key];
        if ([webModel.params[@"topic"] isEqualToString:model.params[@"topic"]]) {
            [self cancelWebSocketSubscribeWithWebSocketModel:webModel];
        }
    }
    
    // 添加新的订阅
    self.indexId ++;
    NSString *keyId = [NSString stringWithFormat:@"%zd", self.indexId];
    model.params[@"id"] = keyId;
    model.params[@"event"] = @"sub";
    self.dataDictionary[keyId] = model;
    
    if (self.webSocket.readyState == SR_OPEN) {
        [self.webSocket send:[model.params mj_JSONString]];
        NSLog(@"订阅--->%@", [model.params mj_JSONString]);
    } else if (model.httpBlock) {
        NSLog(@"订阅--->%@", [model.params mj_JSONString]);
        model.httpBlock();
    }
}

#pragma mark - 3.1 取消订阅*/
- (void)cancelWebSocketSubscribeWithWebSocketModel:(XXWebQuoteModel *)model {
    
    NSString *keyId = model.params[@"id"];
    if (IsEmpty(keyId)) {
        return;
    }
    XXWebQuoteModel *webModel = self.dataDictionary[keyId];
    if (webModel) {
        webModel.params[@"event"] = @"cancel";
        [self.dataDictionary removeObjectForKey:keyId];
        
        if (self.webSocket.readyState == SR_OPEN) {
            [self.webSocket send:[webModel.params mj_JSONString]];
            NSLog(@"取消--->%@", [webModel.params mj_JSONString]);
        } else {
            NSLog(@"取消--->%@", [webModel.params mj_JSONString]);
        }
    }
}

#pragma mark - 4. 解压缩
- (NSData *)gzipInflate:(NSData*)data {
    if ([data length] == 0) {
        return data;
    }
    
    unsigned long full_length = [data length];
    unsigned long  half_length = [data length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[data bytes];
    strm.avail_in = (uInt)[data length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) {
        return nil;
    }
    
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy: half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK) {
        return nil;
    }
    
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}
- (void)umFailureError:(NSError *)error {
    
//    if ([KUser.netWorkStatus isEqualToString:@"WWAN"] || [KUser.netWorkStatus isEqualToString:@"WiFi"]) {
//        NSURL *url = [NSURL URLWithString:kSocketQuoteUrl];
//        NSString *event = [NSString stringWithFormat:@"%@_ResponseError", url.host];
//        NSString *valueString = [NSString stringWithFormat:@"%@%@__code+%zd", url.host, url.path, error.code];
//        [MobClick event:event attributes:@{@"ResponseError":valueString}];
//    }
}

- (NSMutableDictionary *)dataDictionary {
    if (_dataDictionary == nil) {
        _dataDictionary = [NSMutableDictionary dictionary];
    }
    return _dataDictionary;
}

@end
