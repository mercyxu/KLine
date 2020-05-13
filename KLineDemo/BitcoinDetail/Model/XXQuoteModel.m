//
//  XXQuoteModel.m
//  iOS
//
//  Created by iOS on 2018/6/26.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXQuoteModel.h"

@implementation XXQuoteModel

- (void)initSortData {
    
    self.sortClose = [self.close doubleValue];
    self.sortVolume = [self.volume doubleValue];
    
    double close = [self.close doubleValue];
    double open = [self.open doubleValue];
    if (open == 0) {
        self.sortChangedRate = 0;
    } else {
        self.sortChangedRate = (close - open) * 100.0 / open;
    }
}

@end
