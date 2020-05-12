//
//  BHChooseLanguageModel.m
//  iOS
//
//  Created by iOS on 2018/8/15.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BHChooseLanguageModel.h"

@implementation BHChooseLanguageModel

- (instancetype)initWithName:(NSString *)languageName code:(NSString *)languageCode {
    if (self = [super init]) {
        _languageName = languageName;
        _languageCode = languageCode;
    }
    return self;
}

@end
