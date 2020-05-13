//
//  XXOrderModel.h
//  iOS
//
//  Created by iOS on 2018/6/22.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXDepthOrderModel : NSObject

/** 左成交量 */
@property (strong, nonatomic, nullable) NSString *leftNumber;

/** 左成交价 */
@property (strong, nonatomic, nullable) NSString *leftPrice;

/** 左成交量累计 */
@property (assign, nonatomic) double leftSumNumber;

/** 右成交量 */
@property (strong, nonatomic, nullable) NSString *rightNumber;

/** 右成交价 */
@property (strong, nonatomic, nullable) NSString *rightPrice;

/** 右成交量累计 */
@property (assign, nonatomic) double rightSumNumber;

@end
