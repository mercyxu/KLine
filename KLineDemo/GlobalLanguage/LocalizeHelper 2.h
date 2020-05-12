//
//  LocalizeHelper.h
//  Bhex
//
//  Created by Bhex on 2018/8/9.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LocalizedString(key) [[LocalizeHelper sharedLocalSystem] localizedStringForKey:(key)]
#define LocalizationSetLanguage(key) [[LocalizeHelper sharedLocalSystem] setLanguage:(key)]
#define NSLocalizedFormatString(fmt, ...) [NSString stringWithFormat:LocalizedString(fmt), __VA_ARGS__]

@interface LocalizeHelper : NSObject

+ (LocalizeHelper *)sharedLocalSystem;

- (NSString *)localizedStringForKey:(NSString *)key;

- (void)setLanguage:(NSString *)language;

/**
 得到语言code  例如：en
 */
- (NSString *)getLanguageCode;
/**
 得到语言name  例如：英语
 */
- (NSString *)getLanguageName;


/**
 得到request header language code
 */
- (NSString *)getRequestHeaderLanguageCode;
@end
