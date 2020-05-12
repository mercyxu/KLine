//
//  XXTokenModel.m
//  iOS
//
//  Created by iOS on 2018/9/29.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXQuoteTokenModel.h"

@implementation XXQuoteTokenModel

#pragma mark - 1. 订阅
- (void)openWebsocket {
    
    self.webModel.params = [NSMutableDictionary dictionary];
    self.webModel.params[@"topic"] = @"realtimes";
    self.webModel.params[@"event"] = @"sub";
    self.webModel.params[@"markets"] = @"";
    self.webModel.params[@"symbol"] = self.idsString;
    self.webModel.params[@"params"] = @{@"binary":@(YES)};
    
    self.webModel.httpUrl = @"quote/v1/ticker";
    self.webModel.httpParams = [NSMutableDictionary dictionary];
    self.webModel.httpParams[@"symbol"] = self.idsString;
    [KQuoteSocket sendWebSocketSubscribeWithWebSocketModel:self.webModel];
}

#pragma mark - 2. 取消订阅
- (void)closeWebsocket {
    [KQuoteSocket cancelWebSocketSubscribeWithWebSocketModel:self.webModel];
}

#pragma mark - 3. 更新行情并排序
- (void)updateQuoteAndSortWithQuote:(NSDictionary *)quoteDict {
    
    if (!ISDictionary(quoteDict)) {
        return;
    }
    NSString *symbolId = quoteDict[@"s"];
    for (NSInteger i=0; i < self.symbolsArray.count; i ++) {
        XXSymbolModel *model = self.symbolsArray[i];
        if ([model.symbolId isEqualToString:symbolId]) {
            model.quote.time = quoteDict[@"t"];
            model.quote.close = quoteDict[@"c"];
            model.quote.high = quoteDict[@"h"];
            model.quote.low = quoteDict[@"l"];
            model.quote.open = quoteDict[@"o"];
            model.quote.volume = quoteDict[@"v"];
            [model.quote initSortData];
            break;
        }
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"quote.sortChangedRate" ascending:NO];
    [self.symbolsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
}


#pragma mark - || 懒加载
- (XXWebQuoteModel *)webModel {
    if (_webModel == nil) {
        _webModel = [[XXWebQuoteModel alloc] init];
        KWeakSelf
        _webModel.successBlock = ^(id data) {
            if (weakSelf.successBlock) {
                if (weakSelf.webModel.isRed) {
                    weakSelf.webModel.isRed = NO;
                    NSArray *models = data;
                    for (NSInteger i=0; i < models.count; i ++) {
                        id model = models[i];
                        weakSelf.successBlock([NSMutableArray arrayWithObjects:model, nil]);
                    }
                } else {
                    weakSelf.successBlock(data);
                }
            }
        };
        
        _webModel.failureBlock = ^{
            if (weakSelf.failureBlock) {
                weakSelf.failureBlock();
            }
        };
    }
    return _webModel;
}

@end
