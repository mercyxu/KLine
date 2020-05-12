//
//  BHChooseLanguageModel.m
//  Bhex
//
//  Created by Bhex on 2018/8/15.
//  Copyright © 2018年 Bhex. All rights reserved.
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
