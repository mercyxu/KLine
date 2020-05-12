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
/**
 *  用户 Post
 */
+ (void)user_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

/**
 *  用户 Get
 */
+ (void)user_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

#pragma mark - ++++++++++++ 资产 ++++++++++++++
/**
 *  资产 Post
 */
+ (void)asset_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

/**
 *  资产 Get
 */
+ (void)asset_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

#pragma mark - ++++++++++++ 订单 ++++++++++++++
/**
 *  资产 Post
 */
+ (void)order_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

/**
 *  资产 Get
 */
+ (void)order_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

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
/**
 *  公共Get通用接口
 */
+ (void)basic_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

/**
 *  公共Post接口
 */
+ (void)basic_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

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
/**
 *  2. 上传图片 和 数据
 *
 *  @param aPath  接口名
 *  @param image   图片
 *  @param params 请求体
 *  @param block  返回数据
 */
+(void)postFileWithPath:(NSString *)aPath name:(NSString *)name image:(UIImage *)image params:(NSDictionary *)params andBlock:(void (^)(id data, NSString *msg, NSInteger code))block progress:(void (^)(double progress))progressBlock;

#pragma mark - 3. 上传视频
/**
 *  3. 上传视频
 *
 *  @param aPath  接口名
 *  @param videoData   视频
 *  @param block  返回数据
 */
+(void)postVideoWithPath:(NSString *)aPath videoData:(NSData *)videoData andBlock:(void (^)(id data, NSString *msg, NSInteger code))block progress:(void (^)(double progress))progressBlock;

@end
