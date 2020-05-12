//
//  XXReqWebModel.h
//  Bhex
//
//  Created by Bhex on 2018/9/19.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXReqWebModel : NSObject

/** 请求参数 */
@property (strong, nonatomic) NSMutableDictionary *reqParams;

/** 类型 1. 币币资产 2. 币币当前委托订单 3. 期权当前持仓 4. 期权资产余额 5. 缱绻当前委托 */
@property (assign, nonatomic) NSInteger index;

/** httpUrl */
@property (strong, nonatomic) NSString *httpUrl;

/** http参数 */
@property (strong, nonatomic) NSMutableDictionary *httpParams;

/** 是否处于http加载中 */
@property (assign, nonatomic) BOOL isLoading;

/** 成功回调 */
@property (strong, nonatomic) void(^successBlock)(id data);

/** 加载http回调 */
@property (strong, nonatomic) void(^httpBlock)(void);

/** 失败回调 */
@property (strong, nonatomic) void(^failureBlock)(void);

@end
