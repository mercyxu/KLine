//
//  XXDepthMapModel.h
//  iOS
//
//  Created by iOS on 2018/6/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXDepthMapModel : NSObject

/** 累计总量 */
@property (assign, nonatomic) double orderNumber;

/**  当前挂单量 */
@property (assign, nonatomic) double currentOrderNumber;

/** 单价 */
@property (assign, nonatomic) double price;

/** 单价 */
@property (strong, nonatomic, nullable) NSString *priceString;

/** 累计总量 */
@property (strong, nonatomic, nullable) NSString *orderNumberString;

/** 当前挂单量 */
@property (strong, nonatomic, nullable) NSString *currentOrderNumberString;

/** 起点 */
@property (assign, nonatomic) CGPoint startPoint;

/** 终点 */
@property (assign, nonatomic) CGPoint endPoint;


@end
