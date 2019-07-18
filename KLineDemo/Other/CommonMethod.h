//
//  CommonMethod.h
//  CustomUIView
//
//  Created by hexuren on 15/12/3.
//  Copyright © 2015年 hexuren. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SingletonCheckNetWork.h"


@interface CommonMethod : UIView

/**
 *  获取当前网络连接状态
 *
 *  @return
 */
//+(NetworkStatus)getCurrentNetworkStatus;

/**
 *  通过UserDefaults从Plist文件读取数据
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
+(id)readFromUserDefaults:(NSString *)key;

/**
 *  通过UserDefaults将数据写入Plist文件
 *
 *  @param obj 要存储的数据
 *  @param key 存plist的key
 */
+(void)writeToUserDefaults:(id)obj withKey:(NSString *)key;



/**
 *  通过UserDefaults从Plist文件删除数据
 *
 *
 */
+(void)removeFromUserDefaults:(NSString *)key;




/**
 *  给定文本及字体，计算文本宽度、高度
 *
 *  @param string   <#string description#>
 *  @param fontSize <#fontSize description#>
 *
 */
+(CGSize)computeTextSizeWithString:(NSString *)string andFontSize:(UIFont *)fontSize;


/**
 *  计算文本高度
 *
 *  @param string   要计算的文本
 *  @param width    单行文本的宽度
 *  @param fontSize 文本的字体size
 *
 *  @return 返回文本高度
 */
+(CGFloat)computeTextHeightWithString:(NSString *)string andWidth:(CGFloat)width andFontSize:(UIFont *)fontSize;

/**
 *  去除末尾的0
 *
 *  @param string   格式化字符
 *
 *  @return 格式化后的字符串
 */
+(NSString *)deleteFloatAllZero:(NSString*)string;

/**
 *  获得对应位数精度的值
 *
 *  @param roundingMode   四舍五入、只舍不入、向上取证
 *  @param roundingValue  要计算的值
 *  @param position 精度位数
 *
 *  @return 返回计算后的值
 */
+ (NSString *)calculateWithRoundingMode:(NSRoundingMode )roundingMode roundingValue:(double)roundingValue afterPoint:(int)position;

/**
 *  判断输入字符是否都为字母
 *
 *  @param string 传人要判断的字符串
 *
 *  @return 如果字符串包含非字母，则返回NO，反之返回YES
 */
+(BOOL)isAllEnglish:(NSString *)string;

/**
 *  判断输入字符是否都为数字
 *
 *  @param string 传人要判断的字符串
 *
 *  @return 如果字符串包含非数字，则返回NO，反之返回YES
 */
+(BOOL)isAllInterger:(NSString *)string;


/**
 *  判断输入字符是否都为字母或数字
 *
 *  @param string 传人要判断的字符串
 *
 *  @return 如果字符串包含非字母、数字，则返回NO，反之返回YES
 */
+(BOOL)isAllEnglishOrInterger:(NSString *)string;


/**
 *  JSON解析（序列化）NSData对象数据，返回id对象数据
 *
 *  @param data NSData数据
 *
 *  @return 返回id对象数据
 */
+(id)serializeDataToJsonObj:(NSData *)data;


/**
 *  生成带删除线的字符串
 *
 *  @param str 传人需要加删除线的字符串
 *
 *  @return 返回带删除线的字符串
 */
+(NSAttributedString *)genarateAttributedString:(NSString *)str;



/**
 *  去除字符串里面的空格
 *
 *  @param str 需要去空格的字符串
 *
 *  @return 返回不包含空格的字符串
 */
+(NSString *)removeSpace:(NSString *)str;


/**
 *  验证邮箱格式是否正确
 *
 *  @param email 需要验证的邮箱地址
 *
 *  @return 返回是否符合邮箱格式标识
 */
+(BOOL)isValidateEmail:(NSString *)email;



/**
 *  计算指定文件夹下所有文件的大小总和
 *
 *  @param folderPath 文件夹路径
 *
 *  @return 返回总的文件大小
 */
+(CGFloat)computeFileSizeForDir:(NSString*)folderPath;


/**
 *  删除指定文件夹下的所有文件
 *
 *  @param folderPath 需要清理文件的文件夹
 *
 */
+(BOOL)deleteFileFromFolderPath:(NSString*)folderPath;



/**
 *  弹出自定义的提示框
 *
 *  @param alertString 提示文本
 *  @param duration    持续时间
 */
+(void)showAlertViewWithString:(NSString *)alertString andDurationTime:(NSTimeInterval)duration;


/**
 *  获取字符串的首字符(大写)，如果首字符为数字，则返回#号
 *
 *  @param string <#string description#>
 */
+(NSString *)getFirstLetterFromString:(NSString *)string;



/**
 *  时间戳转时间
 *
 *  @param timestamp <#timestamp description#>
 */
+(NSString *)convertTimestampToString:(long long)timestamp;


/**
 *  获取系统当前的时间戳
 */
+(long long)getCurrentTimestamp;


/**
 *  获取当前时间：小时（按24小时计算）
 *
 */
+(int)getCurrentHour;



/**
 *  将图片保存到应用的沙盒中，返回图片所在的沙盒路径
 *
 *  @param data         <#data description#>
 *  @param imageNameStr <#imageNameStr description#>
 *
 *  @return 返回图片所在的沙盒路径
 */
+(NSString *)saveImageToSandbox:(NSData *)data andImageName:(NSString *)imageNameStr;



/**
 *  返回一个带有背景色的图片
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+(UIImage *)imageWithBgColor:(UIColor *)color;



/**
 *  将服务器服务的数据中，NSNull对象替换为@""(空字符串)
 *
 *  @param obj <#obj description#>
 *
 *  @return <#return value description#>
 */
+(id)replaceNSNullToStringWithId:(id)obj;




@end
