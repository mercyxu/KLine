//
//  XXReqWebModel.m
//  Bhex
//
//  Created by Bhex on 2018/9/19.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXReqWebModel.h"

@implementation XXReqWebModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        KWeakSelf
        self.httpBlock = ^{
            [weakSelf loadData];
        };
    }
    return self;
}

- (void)loadData {
    
    if (self.isLoading) {
        return;
    } else {
        self.isLoading = YES;
    }
    
    KWeakSelf
    [HttpManager getWithPath:self.httpUrl params:self.httpParams andBlock:^(id data, NSString *msg, NSInteger code) {
        
        self.isLoading = NO;
        if (code == 0) {
            if (weakSelf.successBlock) {
                weakSelf.successBlock(data);
            }
        } else {
            if (weakSelf.failureBlock) {
                weakSelf.failureBlock();
            }
        }
    }];

}
@end
