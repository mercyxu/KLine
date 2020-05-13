//
//  XXWebSocketModel.m
//  iOS
//
//  Created by iOS on 2018/9/5.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXWebQuoteModel.h"

@implementation XXWebQuoteModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        KWeakSelf
        self.httpBlock = ^{
            [weakSelf loadDataOfNetworking];
        };
    }
    return self;
}

#pragma mark - 1. 网络加载数据
- (void)loadDataOfNetworking {
    
    if (!self.httpUrl) {
        return;
    }
    
    if (self.isLoading) {
        return;
    } else {
        self.isLoading = YES;
    }

    KWeakSelf
    [HttpManager quote_GetWithPath:self.httpUrl params:(NSDictionary *)self.httpParams andBlock:^(id data, NSString *msg, NSInteger code) {
        self.isLoading = NO;
        if (code == 0) {
            if (KQuoteSocket.webSocket.readyState != SR_OPEN) {
                if (weakSelf.successBlock) {
                    weakSelf.isRed = YES;
                    if ([data[@"data"] isKindOfClass:[NSArray class]]) {
                        weakSelf.successBlock(data[@"data"]);
                    }
                }
            }
        } else {
            if (weakSelf.failureBlock) {
                weakSelf.failureBlock();
            }
        }
    }];
}
@end
