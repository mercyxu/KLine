//
//  XXWebSocketModel.h
//  Bhex
//
//  Created by Bhex on 2018/9/5.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HttpType) {
    HQuoteType = 0,
    HBasicType
};

@interface XXWebQuoteModel : NSObject

#pragma mark - 1.1 市场行情列表监听

/** web参数 */
@property (strong, nonatomic) NSMutableDictionary *params;

/** 是否请求订阅 */
@property (assign, nonatomic) BOOL isRed;

/** httpUrl */
@property (strong, nonatomic) NSString *httpUrl;

/** http参数 */
@property (strong, nonatomic) NSMutableDictionary *httpParams;

/** 是否处于http加载中 */
@property (assign, nonatomic) BOOL isLoading;

/** 成功回调 */
@property (strong, nonatomic) void(^successBlock)(id data);

/** 二级请求回调 */
@property (strong, nonatomic) void(^httpBlock)(void);

/** 失败回调 */
@property (strong, nonatomic) void(^failureBlock)(void);


@end
