//
//  NSString+TL.h
//  WanRenHui
//
//  Created by 徐义恒 on 17/3/14.
//  Copyright © 2017年 gansbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TL)

/**
 *  修剪空格
 */
- (NSString *)trimmingCharacters;

/**
 *  汉字转拼音
 */
+ (NSString *)phonetic:(NSString*)sourceString;

/**
 判断 emoji

 @param string <#string description#>
 @return <#return value description#>
 */
+(BOOL)isContainsEmoji:(NSString *)string;

/**
 md5加密
 
 @param string 需要加密的字符串
 @return 密文
 */
+(NSString *)md5:(NSString *)string;

/**
 将时间戳转换成时间
 */
+ (NSString *)dateStringFromTimestampWithTimeTamp:(long long)time;

/**
 将时间戳转换成时间  HH:mm YY/DD
 */
+ (NSString *)timeFromTimestampWithTimeTamp:(long long)time;

/**
 将时间戳转换成【时分 日/月】
 */
+ (NSString *)dateHHMMMonthDayStringFromTimestampWithTimeTamp:(long long)time;

/** 合并不同字体颜色的字符串
 *
 *  items: [
 {
 @"string":@"第一截",
 @"color":[UIColor whiteColor],
 @"font":[UIFont systemFontOfSize:12]
 },
 
 {
 @"string":@"第二截",
 @"color":[UIColor redColor],
 @"font":[UIFont systemFontOfSize:15]
 },
 ]
 */
+ (NSMutableAttributedString *)mergeStrings:(NSMutableArray *)items;

/** 升序 */
+ (NSMutableArray *)sortRiseArray:(NSArray *)itemsArray;

/** 降序 */
+ (NSMutableArray *)sortDropArray:(NSArray *)itemsArray;

/** 处理盘口数量长度 */
+ (NSString *)handValuemeLengthWithAmountStr:(NSString *)AmountStr;

/** 涨跌幅 */
+ (NSString *)riseFallValue:(double)value;

/** 根据字体字号大小和字体label计算label宽度 */
+ (CGFloat)widthWithText:(NSString *)text font:(UIFont *)font;
+ (CGFloat)heightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

/** 判断密码的有效性 */
-(BOOL)isValidPasswordString;

/** 获取交割时间 */
+ (NSString *)getDeliveryTime:(long)timestamp;

/** 获取当前年月日时间 MM-YY-DD */
+ (NSString *)getCurrentTimeOfMMYYDD;

/** 获取结算时间 timestamp：下次结算时间  */
+ (NSString *)getExpirationSettlementTime:(long)timestamp;

/** 法币长度 */
+ (NSString *)getLengthMoney:(double)money;

/** 保留有效值 lenght有效值的长度 */
//+ (NSString *)getLength:(double)value lenght:(int)lenght;

/**
 *数字以逗号隔开 例：123，321.11
 */
- (NSString *)ld_numberSplitWithComma;
@end
