//
//  HttpTool.h
//  WanRenHui
//
//  Created by 徐义恒 on 17/3/11.
//  Copyright © 2017年 gansbat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject

+ (instancetype)sharedHttpManager;


#pragma mark - ++++++++++++ 用户 Post Or Get ++++++++++++++

#pragma mark - ++++++++++++ 资产 ++++++++++++++


#pragma mark - ++++++++++++ 订单 ++++++++++++++



#pragma mark - ++++++++++++ 行情 ++++++++++++++
/**
 *  行情Get通用接口
 */
+ (void)quote_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

/**
 *  行情Post接口
 */
+ (void)quote_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

#pragma mark - ++++++++++++ 公共 ++++++++++++++


#pragma mark - ++++++++++++ 通用接口 ++++++++++++++
/**
 *  Get通用接口
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

/**
 *  Post通用接口
 */
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

#pragma mark - ++++++++++++ 静态请求 ++++++++++++++
+ (void)ms_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

+ (void)ms_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

#pragma mark - 2. 上传单张图片


#pragma mark - 3. 上传视频


@end
