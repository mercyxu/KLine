//
//  NSObject+BHRequestSetting.m
//  iOS
//
//  Created by iOS on 2018/8/16.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "NSObject+BHRequestSetting.h"

@implementation NSObject (BHRequestSetting)


- (NSString *)userAgent {
    return [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
}

- (NSDictionary *)getPostRequestSignatureDictionary:(NSDictionary *)params {
    NSString *time = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [returnDic setObject:time forKey:@"time"];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        if ([cookie.name isEqualToString:@"c_token"]) {
            [returnDic setObject:cookie.value forKey:@"c_token"];
        }
    }
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1, NSString *obj2) {
        NSRange range = NSMakeRange(0, obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *resultArray = [returnDic.allKeys sortedArrayUsingComparator:sort];
    NSMutableString *paramsString = [[NSMutableString alloc] init];
    for (int i = 0; i < resultArray.count; i ++) {
        NSString *key = resultArray[i];
        NSString *value = returnDic[key];
        NSString *addStr = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramsString appendString:addStr];
    }
    [paramsString appendString:@"iOS.com"];
    NSString *sigStr = [NSString md5:paramsString];
    [returnDic setObject:sigStr forKey:@"sig"];
    return returnDic;
}

@end
