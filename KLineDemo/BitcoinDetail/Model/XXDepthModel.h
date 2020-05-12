//
//  XXDepthModel.h
//  iOS
//
//  Created by iOS on 2018/7/17.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXDepthModel : NSObject

/** 成交量 */
@property (strong, nonatomic) NSString *number;

/** 成交价 */
@property (strong, nonatomic) NSString *price;

/** 累计数量 */
@property (assign, nonatomic) double sumNumber;

/** 是否有点 */
@property (assign, nonatomic) BOOL isHavePoint;

/** 是否是买家 */
@property (assign, nonatomic) BOOL isBuy;

@end
