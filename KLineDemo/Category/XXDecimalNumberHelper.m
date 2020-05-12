//
//  XXDecimalNumberHelper.m
//  iOS
//
//  Created by iOS on 2020/02/07.
//  Copyright © 2020 iOS. All rights reserved.
//

#import "XXDecimalNumberHelper.h"

@implementation XXDecimalNumberHelper

+ (NSString *)decimalNumber:(NSString *)number RoundingMode:(NSRoundingMode)roundModel scale:(short)scale {
    
    if (IsEmpty(number)) {
        return @"--";
    }
    
    // 负数需要反过来
    if ([number doubleValue] < 0) {
        if (roundModel == NSRoundDown) {
            roundModel = NSRoundUp;
        } else {
            roundModel = NSRoundDown;
        }
    }
    
    if (scale < 0) {
        scale += 1;
    }
    NSDecimalNumber *decimalNum = [NSDecimalNumber decimalNumberWithString:number];
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundModel scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *roundedNumber = [decimalNum decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    if (scale > 0) {
        NSString *scaleString = [NSString stringWithFormat:@"%%.%df",scale];
        return [NSString stringWithFormat:scaleString, roundedNumber.doubleValue];
    } else {
        return [NSString stringWithFormat:@"%lld",roundedNumber.longLongValue];
    }
}

+ (short)scale:(NSString *)number {
    if ([number containsString:@"."]) {
        NSArray *separatedArray = [number componentsSeparatedByString:@"."];
        NSString *numberStr = separatedArray.lastObject;
        return numberStr.length;
    } else {
        return -number.length;
    }
}

+ (void)test {
    //    short scale = -2;
    NSArray *testArr = @[@"1113.141",@"1113.000001",@"1113.0000",@"1",@"100",@"10.00"];
    for (NSString *testNum in testArr) {
        //        NSString *result = [self decimalNumber:testNum RoundingMode:NSRoundDown scale:scale];
        short result = [self scale:testNum];
        NSLog(@"%@========%d",testNum,result);
    }
}

@end
