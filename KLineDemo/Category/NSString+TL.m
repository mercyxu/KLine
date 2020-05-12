//
//  NSString+TL.m
//  WanRenHui
//
//  Created by 徐义恒 on 17/3/14.
//  Copyright © 2017年 gansbat. All rights reserved.
//

#import "NSString+TL.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (TL)

- (NSString *)trimmingCharacters{

    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)phonetic:(NSString*)sourceString {
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}
+(BOOL)isContainsEmoji:(NSString *)string {
    
    __block BOOL isEomji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar hs = [substring characterAtIndex:0];
        
        // surrogate pair
        
        if (0xd800 <= hs && hs <= 0xdbff) {
            
            if (substring.length > 1) {
                
                const unichar ls = [substring characterAtIndex:1];
                
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    
                    isEomji = YES;
                    
                }
                
            }
            
        } else if (substring.length > 1) {
            
            const unichar ls = [substring characterAtIndex:1];
            
            if (ls == 0x20e3) {
                
                isEomji = YES;
                
            }
            
            
            
        } else {
            
            // non surrogate
            
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                
                isEomji = YES;
                
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                
                isEomji = YES;
                
            } else if (0x2934 <= hs && hs <= 0x2935) {
                
                isEomji = YES;
                
            } else if (0x3297 <= hs && hs <= 0x3299) {
                
                isEomji = YES;
                
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030|| hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs ==0x231a ) {
                
                isEomji = YES;
                
            }
            
        }
        
    }];
    
    return isEomji;
    
}

+(NSString *)md5:(NSString *)string{
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [string UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}

#pragma mark - 5.0 将时间戳转换成时间
+ (NSString *)dateStringFromTimestampWithTimeTamp:(long long)time {
    
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time/1000.0];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss yyyy/MM/dd"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

#pragma mark - 5.1 将时间戳转换成时间
+ (NSString *)timeFromTimestampWithTimeTamp:(long long)time {
    
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time/1000.0];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss MM/dd"];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

#pragma mark - 6. 将时间戳转换成【时分 日/月】
+ (NSString *)dateHHMMMonthDayStringFromTimestampWithTimeTamp:(long long)time {
    
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time/1000.0];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"HH:mm MM/dd"];
    
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

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
+ (NSMutableAttributedString *)mergeStrings:(NSMutableArray *)items {
    
    NSString *sumString = @"";
    for (NSInteger i=0; i < items.count; i ++) {
        NSDictionary *dict = items[i];
        sumString = [NSString stringWithFormat:@"%@%@", sumString, dict[@"string"]];
    }
    
    NSMutableAttributedString *sumAttributedString = [[NSMutableAttributedString alloc]initWithString:sumString];
    NSInteger startCount = 0;
    for (NSInteger i=0; i < items.count; i ++) {
        NSDictionary *dict = items[i];
        NSString *itemString = dict[@"string"];
        NSRange rangel = NSMakeRange(startCount, itemString.length);
        [sumAttributedString addAttribute:NSForegroundColorAttributeName value:dict[@"color"] range:rangel];
        [sumAttributedString addAttribute:NSFontAttributeName value:dict[@"font"] range:rangel];
        startCount += itemString.length;
    }
    return sumAttributedString;
}

/** 升序 */
+ (NSMutableArray *)sortRiseArray:(NSArray *)itemsArray {
  
    if (itemsArray.count < 2) {
        return [NSMutableArray arrayWithArray:itemsArray];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:itemsArray];
    for (NSInteger i=0; i < array.count - 1; i ++) {
        NSString *valueI = array[i];
        for (NSInteger j=i+1; j < array.count; j ++) {
            NSString *valueJ = array[j];
            if ([valueI doubleValue] > [valueJ doubleValue]) {
                array[i] = valueJ;
                array[j] = valueI;
                valueI = array[i];
            }
        }
    }
    return array;
}

/** 降序 */
+ (NSMutableArray *)sortDropArray:(NSArray *)itemsArray {
    
    if (itemsArray.count < 2) {
        return [NSMutableArray arrayWithArray:itemsArray];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:itemsArray];
    for (NSInteger i=0; i < array.count - 1; i ++) {
        NSString *valueI = array[i];
        for (NSInteger j=i+1; j < array.count; j ++) {
            NSString *valueJ = array[j];
            if ([valueI doubleValue] < [valueJ doubleValue]) {
                array[i] = valueJ;
                array[j] = valueI;
                valueI = array[i];
            }
        }
    }
    return array;
}

/** 处理盘口数量长度 */
+ (NSString *)handValuemeLengthWithAmountStr:(NSString *)AmountStr {
    if (!AmountStr) {
        return @"0";
    } else {
        CGFloat amount = 0.0;
        NSString *unit = @"";
        NSString *resultAmount = AmountStr;
        if ([AmountStr doubleValue] >= 1000000000.0) {
            amount = [AmountStr doubleValue] / 1000000000.0;
            unit = @"B";
        } else if ([AmountStr doubleValue] >= 1000000.0) {
            amount = [AmountStr doubleValue] / 1000000.0;
            unit = @"M";
        } else if ([AmountStr doubleValue] >= 100000.0) {
            amount = [AmountStr doubleValue] / 1000.0;
            unit = @"k";
        } else {
            amount = [AmountStr doubleValue];
        }
        
        if (amount >= 10000.0) {
            resultAmount = [NSString stringWithFormat:@"%.0f%@", amount, unit];
        } else if (amount >= 1000.0) {
            resultAmount = [NSString stringWithFormat:@"%.1f%@", amount, unit];
        } else if (amount >= 100.0) {
            resultAmount = [NSString stringWithFormat:@"%.2f%@", amount, unit];
        } else if (amount >= 10.0) {
            resultAmount = [NSString stringWithFormat:@"%.3f%@", amount, unit];
        } else if (amount >= 1.0) {
            resultAmount = [NSString stringWithFormat:@"%.4f%@", amount, unit];
        } else if (amount >= 0.1) {
            resultAmount = [NSString stringWithFormat:@"%.5f%@", amount, unit];
        } else if (amount >= 0.01)  {
            resultAmount = [NSString stringWithFormat:@"%.6f%@", amount, unit];
        }
        
        return resultAmount;
    }
}

+ (CGFloat)widthWithText:(NSString *)text font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:CGSizeMake(kScreen_Width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

+ (CGFloat)heightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
}

+ (NSString *)riseFallValue:(double)value {
    if (isinf(value) || isnan(value)) {
        value = 0.0;
    }
    NSString *riseString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", value] RoundingMode:NSRoundDown scale:2];
    return [NSString stringWithFormat:@"%@%@", riseString, @"%"];
}

-(BOOL)isValidPasswordString {
    BOOL result = NO;
    BOOL isHaveNumber = NO;
    BOOL isHaveChinese = NO;
    BOOL isHaveUppercase = NO;
    BOOL isHaveLowercase = NO;
    if ([self length] >= 8 && [self length] <= 20){
        
        for (int i = 0; i < self.length; i++) {
            char commitChar = [self characterAtIndex:i];
            NSString *temp = [self substringWithRange:NSMakeRange(i,1)];
            const char *u8Temp = [temp UTF8String];
            if (3==strlen(u8Temp)){ // 字符串中含有中文
                isHaveChinese = YES;
            }else if((commitChar>64)&&(commitChar<91)){ // 字符串中含有大写英文字母
                isHaveUppercase = YES;
            }else if((commitChar>96)&&(commitChar<123)){ // 字符串中含有小写英文字母
                isHaveLowercase = YES;
            }else if((commitChar>47)&&(commitChar<58)){ // 字符串中含有数字
                isHaveNumber = YES;
            }else{ // 字符串中含有非法字符
                
            }
        }
        if (isHaveNumber == YES && isHaveChinese == NO && isHaveUppercase == YES && isHaveLowercase == YES) {
            result = YES;
        }
    }
    return result;
}

/** 获取交割时间 */
+ (NSString *)getDeliveryTime:(long)timestamp {

    NSString *timeString = LocalizedString(@"Delivered");
    long deliveryTime = timestamp;

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    long currentTime = [dat timeIntervalSince1970];
    long time = deliveryTime - currentTime;
    long datTime = 24*60*60;
    long hTime = 60*60;
    long mTime = 60;
    if (time > datTime) { // 天
        NSInteger count = time / datTime;
        time = time % datTime;
        NSInteger hhh = time / hTime;
        NSInteger mmm = (time % hTime) / mTime;
        NSInteger sss = (time % 60);
        timeString = [NSString stringWithFormat:@"%02zd%@%02zd:%02zd:%02zd", count, LocalizedString(@"Day"), hhh, mmm, sss];
        
    } else if (time > 0) {
        
        NSInteger hhh = time / hTime;
        NSInteger mmm = (time % hTime) / mTime;
        NSInteger sss = (time % 60);
        timeString = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", hhh, mmm, sss];
    }
    return timeString;
}

/** 获取结算时间 */
+ (NSString *)getExpirationSettlementTime:(long)timestamp {
    
    NSString *timeString = @"--";
    long deliveryTime = timestamp;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    long currentTime = [dat timeIntervalSince1970];
    long time = deliveryTime - currentTime;
    long datTime = 24*60*60;
    long hTime = 60*60;
    long mTime = 60;
    if (time > datTime) { // 天
        NSInteger count = time / datTime;
        timeString = [NSString stringWithFormat:@"%zd%@", count, LocalizedString(@"Day")];
    } else if (time > 0) {
        
        NSInteger hhh = time / hTime;
        NSInteger mmm = (time % hTime) / mTime;
        NSInteger sss = (time % 60);
        timeString = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", hhh, mmm, sss];
    }
    return timeString;
}

/** 获取当前年月日时间 MM-YY-DD */
+ (NSString *)getCurrentTimeOfMMYYDD {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

#pragma mark - 法币长度
+ (NSString *)getLengthMoney:(double)money {

    short effectiveCount = 4;
    short digit = 0;
    if (money >= 10.0) {
        digit = effectiveCount - 2;
    } else if (money >= 1) {
        digit = effectiveCount - 1;
    } else if (money >= 0.1) {
        digit = effectiveCount;
    } else if (money >= 0.01) {
        digit = effectiveCount - -1;
    } else if (money >= 0.001) {
         digit = effectiveCount - -2;
    } else if (money >= 0.0001) {
         digit = effectiveCount - -3;
    } else if (money >= 0.00001) {
         digit = effectiveCount - -4;
    } else if (money >= 0.000001) {
         digit = effectiveCount - -5;
    } else if (money == 0) {
        return @"0.00";
    } else {
        digit = 10;
    }
    return [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", money] RoundingMode:NSRoundDown scale:digit];
}

/**
 *数字以逗号隔开 例：123，321.11
 */
- (NSString *)ld_numberSplitWithComma{
    if ([self private_isNumber]) {
        NSMutableString *muString = [NSMutableString stringWithString:self];
        return [self private_insert:muString withPunctuation:@","];
    }else{
        return self;
    }
}
- (NSString *)ld_numberSplitWithPunctutaion:(NSString *)puctutation{
    if ([self private_isNumber]) {
        NSMutableString *muString = [NSMutableString stringWithString:self];
        return [self private_insert:muString withPunctuation:puctutation];
    }else{
        return self;
    }
}
- (NSMutableString *)private_insert:(NSMutableString *)string withPunctuation:(NSString *)punctuation{
    NSUInteger maxLength = string.length;
    if ([string containsString:punctuation]) {
        maxLength = [string rangeOfString:punctuation].location;
    }else if ([string containsString:@"."]){
        maxLength = [string rangeOfString:@"."].location;
    }
    if (maxLength-([string containsString:@"-"]?1:0)>3) {
        [string insertString:punctuation atIndex:(maxLength-3)];
        [self private_insert:string withPunctuation:punctuation];
    }else{
        return string;
    }
    return string;
}
- (Boolean)private_isNumber{
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[-0-9.]*$"];
    if ([predicate evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}
@end
