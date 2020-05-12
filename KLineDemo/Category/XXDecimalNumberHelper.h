//
//  XXDecimalNumberHelper.h
//  iOS
//
//  Created by iOS on 2020/02/07.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXDecimalNumberHelper : NSObject
/**
 * 取舍运算
 * @param number 要取舍的数
 * @param roundModel 规则  NSRoundDown 向下取舍   NSRoundUp：向上取舍
 * @param scale  位数  1：小数点后一位     0 和 -1：个位  -2：十位
 */
+ (NSString *)decimalNumber:(NSString *)number RoundingMode:(NSRoundingMode)roundModel scale:(short)scale;

/**
* 获取精度位数运算
* @param number 要获取的数字字符串
*/
+ (short)scale:(NSString *)number;

+ (void)test;

@end

NS_ASSUME_NONNULL_END
