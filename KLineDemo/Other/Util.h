//
//  Util.h
//  Car_iOS
//
//  Created by zhmch0329 on 14-8-18.
//  Copyright (c) 2014年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Util : NSObject

/**
 *  获取缓存目录
 *
 *  @return path
 */
+ (NSString *)getCacheContentPath;

/**
 *  获取用户目录
 *
 *  @return path
 */
+ (NSString *)getDocumentContentPath;


/**
 *  计算文本的高度
 *
 *  @param text     字符串
 *  @param font     字体
 *  @param width    文本宽度
 *
 *  @return 文本高度
 */
+ (CGFloat)caculateTextHeight:(NSString *)text font:(UIFont *)font sizeWidth:(CGFloat)width;

/**
 *  计算文本的宽度
 *
 *  @param text   字符串
 *  @param font   字体
 *  @param height 文本高度
 *
 *  @return 文本宽度
 */
+ (CGFloat)caculateTextWidth:(NSString *)text font:(UIFont *)font sizeHeight:(CGFloat)height;

/**
 *  去除字符串中的空格
 *
 *  @param string 字符串对象
 *
 *  @return 去除后的字符串对象
 */
+ (NSString *)trimString:(NSString *)string;

/**
 *  将16进制的颜色字符串转换成颜色对象
 *
 *  @param stringToConvert 16进制的颜色字符
 *
 *  @return 颜色对象
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 *  将16进制的颜色字符串转换成颜色对象
 *
 *  @param stringToConvert 16进制的颜色字符
 *  @param alpha           透明度
 *
 *  @return 颜色对象
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha;

/**
 *  将日期转换成指定格式的字符串
 *
 *  @param regula 格式码
 *  @param date   转换的日期
 *
 *  @return 转换后的字符串
 */
+ (NSString *)formatDateToString:(NSString *)regula date:(NSDate *)date;

/**
 *  将指定格式的字符串转换成日期
 *
 *  @param regula 格式码
 *  @param string 需要转换的字符串
 *
 *  @return 日期
 */
+ (NSDate *)formatStringToDate:(NSString *)regula stringDate:(NSString *)string;

/**
 *  通过日期获得是星期几
 *
 *  @param date 日期
 *
 *  @return 星期
 */
+ (NSString *)weekdayOfDate:(NSDate *)date;

/**
 *  判断是不是电话
 *
 *  @param mobileNum 电话号码字符串对象
 *
 *  @return YES/NO
 */
+ (BOOL)validateMobile:(NSString *)mobileNum;
+ (BOOL)checkPhoneNumValidation:(NSString *)phoneNum;

/**
 *  MD5加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密之后的字符串
 */
+ (NSString *)md5:(NSString *)string;

/**
 *  将string转换成number
 *
 *  @param string string
 *
 *  @return number
 */
+ (NSNumber *)stringToNumber:(NSString *)string;

+ (void)saveCookies;

+ (void)loadCookies;

+ (void)clearCookies;

+ (void)saveTokenWithToken:(NSString *)token;

+ (NSString *)loadToken;

+ (void)clearToken;

+(BOOL)judgePassWordLegal:(NSString *)pass;

+ (NSData *)toJSONData:(id)theData;// 字典 转字符串
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;//字符串转字典
+ (BOOL)validateNumber:(NSString*)number;
+ (void)callFDPhone;
+ (void)callPhone:(NSString *)tel;

// 判断中文
+ (BOOL)checkCHWithStr:(NSString *)str;

+ (UIWindow *)lastWindow;

/**
 时间戳转日期
 
 @param timestamp 时间戳
 @return 日期
 */
+ (NSString *)getDateFormatByTimestamp:(long long)timestamp;

/**
 获取单张图片的实际size
 
 @param singleSize 原始
 @return 结果
 */
+ (CGSize)getSingleSize:(CGSize)singleSize;

+ (double)pricePonitWithCount:(NSInteger)count;

+ (double)depthPriceWithPrice:(CGFloat)price Count:(NSInteger)count;

+ (NSString *)depthStrPriceWithPrice:(CGFloat)price Count:(NSInteger)count;

+ (id)getLocalJsonDataWithFileName:(NSString *)finalPath;

@end
