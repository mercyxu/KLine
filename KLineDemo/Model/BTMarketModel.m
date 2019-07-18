//
//  BTMarketModel.m
//  Bitbt
//
//  Created by iOS on 2019/5/9.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

#import "BTMarketModel.h"
#import "BTBiModel.h"
#import "BTDealMarketModel.h"

@implementation BTMarketModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"ProTradeDataReportList" : [BTBiModel class]};
}


@end
