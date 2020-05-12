//
//  BHLocalizedBundle.m
//  Bhex
//
//  Created by Bhex on 2019/08/26.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "BHLocalizedBundle.h"
#import "LocalizeHelper.h"

@implementation BHLocalizedBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value
                              table:(NSString *)tableName {
    NSBundle *chatBundle = [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: @"ZDCChatStrings" ofType: @"bundle"]];
    chatBundle = [NSBundle bundleWithPath:[chatBundle pathForResource:[LocalizeHelper sharedLocalSystem].getLanguageCode ofType:@"lproj"]];
    return NSLocalizedStringFromTableInBundle(key, tableName, chatBundle, key);
}

+ (void)loadBundle
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSBundle *bundle = [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: @"ZDCChatStrings" ofType: @"bundle"]];
        object_setClass(bundle, [BHLocalizedBundle class]);
    });
}

@end
