//
//  XXDepthTool.h
//  iOS
//
//  Created by iOS on 2018/9/6.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXDepthTool : NSObject

/**
 1. 盘口列表 【交易】
 leftDict:原始买盘数据
 rightDict:原始卖盘数据
 binds:买盘推送数据
 asks:卖盘推送数据
 priceDigit:价格精度
 amountDigit:数量精度
 retun b:买单模型数组 a:卖单模型 o:平均值
 */
+ (NSDictionary *)depthLeftDict:(NSMutableDictionary *)leftDict
                      rightDict:(NSMutableDictionary *)rightDict
                          binds:(NSArray *)binds
                           asks:(NSArray *)asks
                     priceDigit:(NSInteger)priceDigit
                    amountDigit:(NSInteger)amountDigit;


/**
 2. k线盘口绘制 【交易】
 leftDict:原始买盘数据
 rightDict:原始卖盘数据
 binds:买盘推送数据
 asks:卖盘推送数据
 priceDigit:价格精度
 amountDigit:数量精度
 viewWidth:视图宽度
 viewHeight:视图高度
 */
+ (NSDictionary *)klineDepthLeftDict:(NSMutableDictionary *)leftDict
                           rightDict:(NSMutableDictionary *)rightDict
                               Binds:(NSArray *)binds
                                asks:(NSArray *)asks
                          priceDigit:(NSInteger)priceDigit
                         amountDigit:(NSInteger)amountDigit
                         viewWidth:(CGFloat)viewWidth
                          viewHeight:(CGFloat)viewHeight;
@end
