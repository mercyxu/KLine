//
//  Util.m
//  Car_iOS
//
//  Created by zhmch0329 on 14-8-18.
//  Copyright (c) 2014年 zhmch0329. All rights reserved.
//

#import "Util.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Util

+ (NSString *)getCacheContentPath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    return path;
}

+ (NSString *)getDocumentContentPath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    return path;
}

+(NSString *)trimString:(NSString *)string
{
    NSString *ss = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *sss = [ss stringByReplacingOccurrencesOfString:@" " withString:@""];
    return sss;
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    return [self colorWithHexString:stringToConvert alpha:1.0f];
}

+ (NSString *)formatDateToString:(NSString *)regula date:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:regula];
    return [formatter stringFromDate:date];
}

+ (NSDate *)formatStringToDate:(NSString *)regula stringDate:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:regula];
    NSDate *date = [formatter dateFromString:string];
    return date;
}


+ (CGFloat)caculateTextHeight:(NSString *)text font:(UIFont *)font sizeWidth:(CGFloat)width
{
    CGSize size = CGSizeZero;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *attributes = @{NSFontAttributeName: font};
        size = [text boundingRectWithSize:CGSizeMake(width, width) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
        size = [text boundingRectWithSize:CGSizeMake(width, width) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;;
    }
    return size.height;
}

+ (CGFloat)caculateTextWidth:(NSString *)text font:(UIFont *)font sizeHeight:(CGFloat)height
{
    CGSize size = CGSizeZero;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *attributes = @{NSFontAttributeName: font};
        size = [text boundingRectWithSize:CGSizeMake(KScreenWidth, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
        size = [text boundingRectWithSize:CGSizeMake(KScreenWidth, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    return size.width;
}

+ (BOOL)validateMobile:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)checkPhoneNumValidation:(NSString *)phoneNum
{
    // Fixed Phone Number
    if ([phoneNum hasPrefix:@"0"])
    {
        if (phoneNum.length == 10)
        {
            return YES;
        }
        if (phoneNum.length == 11)
        {
            return YES;
        }
        if (phoneNum.length == 12)
        {
            return YES;
        }
    }
    // Mobile Phone Number
    else if ([phoneNum hasPrefix:@"1"])
    {
        if (phoneNum.length == 11)
        {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString *)md5:(NSString *)string
{
    const char *cString = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}

+ (NSNumber *)stringToNumber:(NSString *)string
{
    if ([string isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)string;
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    if ([numberFormatter numberFromString:string]) {
        return [NSNumber numberWithInteger:[string integerValue]];
    }
    return nil;
}



+ (NSData *)toJSONData:(id)theData
{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

+ (BOOL)checkCHWithStr:(NSString *)str
{
    if (str.length<=0) {
        return NO;
    }
    unichar ch =  [str characterAtIndex:0];
    if (0x4e00 < ch  && ch < 0x9fff)
    {
        return YES;
    }else{
        return NO;
    }
}

+ (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) {
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark - 时间戳转换
+ (NSString *)getDateFormatByTimestamp:(long long)timestamp
{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowTimestamp = [dat timeIntervalSince1970] ;
    long long int timeDifference = (nowTimestamp * 1000) - timestamp;
    long long int secondTime = timeDifference/1000;
    long long int minuteTime = secondTime/60;
    long long int hoursTime = minuteTime/60;
    long long int dayTime = hoursTime/24;
    long long int monthTime = dayTime/30;
    long long int yearTime = monthTime/12;
    
    if (1 <= yearTime) {
        return [NSString stringWithFormat:@"%lld年前",yearTime];
    }
    else if(1 <= monthTime) {
        return [NSString stringWithFormat:@"%lld月前",monthTime];
    }
    else if(1 <= dayTime) {
        return [NSString stringWithFormat:@"%lld天前",dayTime];
    }
    else if(1 <= hoursTime) {
        return [NSString stringWithFormat:@"%lld小时前",hoursTime];
    }
    else if(1 <= minuteTime) {
        return [NSString stringWithFormat:@"%lld分钟前",minuteTime];
    }
    else if(1 <= secondTime) {
        return [NSString stringWithFormat:@"%lld秒前",secondTime];
    }
    else {
        return @"刚刚";
    }
}

/**
*
*  判断用户输入的密码是否符合规范，符合规范的密码要求：
1. 长度大于8位
2. 密码中必须同时包含数字和字母
*/
+(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 8){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}

#pragma mark - 获取单张图片的实际size
+ (CGSize)getSingleSize:(CGSize)singleSize
{
    CGFloat max_width = KScreenWidth - 150;
    CGFloat max_height = KScreenWidth - 130;
    CGFloat image_width = singleSize.width;
    CGFloat image_height = singleSize.height;
    
    CGFloat result_width = 0;
    CGFloat result_height = 0;
    if (image_height/image_width > 3.0) {
        result_height = max_height;
        result_width = result_height/2;
    }  else  {
        result_width = max_width;
        result_height = max_width*image_height/image_width;
        if (result_height > max_height) {
            result_height = max_height;
            result_width = max_height*image_width/image_height;
        }
    }
    return CGSizeMake(result_width, result_height);
}

+ (double)pricePonitWithCount:(NSInteger)count
{
    switch (count) {
        case 0:
            return 1;
            break;
        case 1:
            return 0.1;
            break;
        case 2:
            return 0.01;
            break;
        case 3:
            return 0.001;
            break;
        case 4:
            return 0.0001;
            break;
        case 5:
            return 0.00001;
            break;
        case 6:
            return 0.000001;
            break;
        case 7:
            return 0.0000001;
            break;
        case 8:
            return 0.000000001;
            break;
        case 9:
            return 0.000000001;
            break;
        case 10:
            return 0.0000000001;
            break;
        case 11:
            return 0.00000000001;
            break;
        default:
            return 1;
            break;
    }
}

+ (double)depthPriceWithPrice:(CGFloat)price Count:(NSInteger)count
{
    switch (count) {
        case 1:
            return [NSStringFormat(@"%.1f",price) doubleValue];
            break;
        case 2:
            return [NSStringFormat(@"%.2f",price) doubleValue];
            break;
        case 3:
            return [NSStringFormat(@"%.3f",price) doubleValue];
            break;
        case 4:
            return [NSStringFormat(@"%.4f",price) doubleValue];
            break;
        case 5:
            return [NSStringFormat(@"%.5f",price) doubleValue];
            break;
        case 6:
            return [NSStringFormat(@"%.6f",price) doubleValue];
            break;
        default:
            return [NSStringFormat(@"%.f",price) doubleValue];
            break;
    }
}

+ (NSString *)depthStrPriceWithPrice:(CGFloat)price Count:(NSInteger)count
{
    switch (count) {
        case 1:
            return NSStringFormat(@"%.1f",price);
            break;
        case 2:
            return NSStringFormat(@"%.2f",price);
            break;
        case 3:
            return NSStringFormat(@"%.3f",price);
            break;
        case 4:
            return NSStringFormat(@"%.4f",price);
            break;
        case 5:
            return NSStringFormat(@"%.5f",price);
            break;
        case 6:
            return NSStringFormat(@"%.6f",price);
            break;
        default:
            return NSStringFormat(@"%.f",price);
            break;
    }
}

@end
