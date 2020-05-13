

#import <Foundation/Foundation.h>

@interface NSDate (Common)

- (BOOL)isSameDay:(NSDate*)anotherDate;

- (NSInteger)secondsAgo;
- (NSInteger)minutesAgo;
- (NSInteger)hoursAgo;
- (NSInteger)monthsAgo;
- (NSInteger)yearsAgo;
- (NSInteger)leftDayCount;


- (NSString *)string_yyyy_MM_dd_EEE;//@"yyyy-MM-dd EEE" + (今天/昨天)
- (NSString *)string_yyyy_MM_dd;//@"yyyy-MM-dd"
- (NSString *)stringDisplay_HHmm;//n秒前 / 今天 HH:mm
- (NSString *)stringDisplay_MMdd;//n庙前 / 今天 / MM/dd
- (NSString *)string_yyyy_MM_dd_HHmm;
- (NSString *)string_yyyy_MM_dd_hhmm;

- (NSString *)string_yyyy_MM_dd_HHmmss;

- (NSString *)stringToyyyyMMddHHmmss;

+ (NSString *)convertStr_yyyy_MM_ddToDisplay:(NSString *)str_yyyy_MM_dd;//(今天、明天) / MM月dd日 / yyyy年MM月dd日

- (NSString *)stringTimesAgo;//更新时间

+ (BOOL)isDuringMidAutumn;

#pragma mark - 5. 将时间戳转换成时间字符串
+ (NSString *)dateStringWithTimeTamp:(long)timeTamp;
@end
