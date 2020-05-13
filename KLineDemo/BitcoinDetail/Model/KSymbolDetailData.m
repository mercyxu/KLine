//
//  KSymbolDetailData.m
//  iOS
//
//  Created by YiHeng on 2020/2/4.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "KSymbolDetailData.h"

@implementation KSymbolDetailData
singleton_implementation(KSymbolDetailData)

- (void)setSymbolModel:(XXSymbolModel *)symbolModel {
    
    _symbolModel = symbolModel;
    NSArray *digitMergeArray = [_symbolModel.digitMerge componentsSeparatedByString:@","];
    self.priceDigit = [KDecimal scale:[digitMergeArray lastObject]];
    self.numberDigit = [KDecimal scale:_symbolModel.basePrecision];
}

- (void)setKlineIndex:(NSString *)klineIndex {
    [KDetail saveValeu:klineIndex forKey:@"klineIndexKey"];
}

- (void)setKlineMainIndex:(NSString *)klineMainIndex {
    [KDetail saveValeu:klineMainIndex forKey:@"klineMainIndexKey"];
}

- (void)setKlineAccessoryIndex:(NSString *)klineAccessoryIndex {
    [KDetail saveValeu:klineAccessoryIndex forKey:@"klineAccessoryIndexKey"];
}

- (NSString *)klineIndex {
    NSInteger klineValue = [[KDetail getValueForKey:@"klineIndexKey"] integerValue];
    if (klineValue == 0) {
        return @"4";
    } else {
        return [KDetail getValueForKey:@"klineIndexKey"];
    }
}

- (NSString *)klineMainIndex {
    NSInteger index = [[KDetail getValueForKey:@"klineMainIndexKey"] integerValue];
    if (index == 0) {
        return @"103";
    } else {
        return [KDetail getValueForKey:@"klineMainIndexKey"];
    }
}

- (NSString *)klineAccessoryIndex {
    NSInteger index = [[KDetail getValueForKey:@"klineAccessoryIndexKey"] integerValue];
    if (index == 0) {
        return @"102";
    } else {
        return [KDetail getValueForKey:@"klineAccessoryIndexKey"];
    }
}

#pragma mark 存取方法
-(id)getValueForKey:(NSString*)key{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}
-(void)saveValeu:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
