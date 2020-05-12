//
//  ZendeskSupportBundle.m
//  iOS
//
//  Created by iOS on 2019/08/27.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "ZendeskSupportBundle.h"

@implementation ZendeskSupportBundle
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value
                              table:(NSString *)tableName {
    NSBundle *supportBundle = [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: @"ZendeskSDKStrings" ofType: @"bundle"]];
    supportBundle = [NSBundle bundleWithPath:[supportBundle pathForResource:[LocalizeHelper sharedLocalSystem].getLanguageCode ofType:@"lproj"]];
    return NSLocalizedStringFromTableInBundle(key, tableName, supportBundle, key);
}

+ (void)loadBundle
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSBundle *bundle = [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: @"ZendeskSDKStrings" ofType: @"bundle"]];
        object_setClass(bundle, [ZendeskSupportBundle class]);
    });
}

@end
