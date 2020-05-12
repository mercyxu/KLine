//
//  LocalizeHelper.m
//  Bhex
//
//  Created by Bhex on 2018/8/9.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "LocalizeHelper.h"
static NSBundle *_localBundle = nil;
static LocalizeHelper *_sharedManager = nil;
@implementation LocalizeHelper

+ (LocalizeHelper *)sharedLocalSystem {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[LocalizeHelper alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[self getLanguageCode] ofType:@"lproj"];
        _localBundle = [NSBundle bundleWithPath:path];
        if (path == nil) {
            _localBundle = [NSBundle mainBundle];
        }
    }
    return self;
}

- (NSString *)localizedStringForKey:(NSString *)key {
    return [_localBundle localizedStringForKey:key value:@"" table:nil];
}

- (void)setLanguage:(NSString *)language {
    NSString *defaultLanguage = [BHUserDefaults objectForKey:@"BHLocalLanguage"];
    if (language && defaultLanguage && [language isEqualToString:defaultLanguage]) {
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    _localBundle = [NSBundle bundleWithPath:path];
    if (path == nil) {
        _localBundle = [NSBundle mainBundle];
    }
    [BHUserDefaults setObject:language forKey:@"BHLocalLanguage"];
    [BHUserDefaults synchronize];
}

- (NSString *)getLanguageCode {
    NSString *defaultLanguage = [BHUserDefaults objectForKey:@"BHLocalLanguage"];
    if (defaultLanguage) {
        return defaultLanguage;
    }
    NSArray *Localizations = [[NSBundle mainBundle] preferredLocalizations];
    return [Localizations firstObject];
}

- (NSString *)getLanguageName {
   NSString *code = [self getLanguageCode];
    if ([code isEqualToString:@"zh-Hans"] || [code isEqualToString:@"zh-Hant"]) {
        return @"简体中文";
    } else if ([code isEqualToString:@"ko"]) {
        return @"한국어";
    } else if ([code isEqualToString:@"vi-VN"]) {
        return @"Tiếng Việt";
    } else if ([code isEqualToString:@"ja"]) {
        return @"日本語";
    } else if ([code isEqualToString:@"tr"]) {
           return @"Türkçe";
    } else {
        return @"English";
    }
}

- (NSString *)getRequestHeaderLanguageCode {
    NSString *code = [self getLanguageCode];
    if ([code isEqualToString:@"zh-Hans"] || [code isEqualToString:@"zh-Hant"]) {
        return @"zh-CN";
    } else if ([code isEqualToString:@"ko"]) {
        return @"ko-kr";
    } else if ([code isEqualToString:@"vi-VN"]) {
        return @"vi-VN";
    } else if ([code isEqualToString:@"ja"]) {
        return @"ja-jp";
    } else if ([code isEqualToString:@"tr"]) {
        return @"tr";
    } else {
        return @"en-US";
    }
}

@end
