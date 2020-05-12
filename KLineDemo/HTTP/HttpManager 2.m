//
//  HttpTool.m
//  WanRenHui
//
//  Created by 徐义恒 on 17/3/11.
//  Copyright © 2017年 gansbat. All rights reserved.
//

#import "HttpManager.h"
#import "NetAPIClient.h"

@implementation HttpManager

+ (instancetype)sharedHttpManager {
    static HttpManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

#pragma mark - ++++++++++++ 用户 ++++++++++++++
/**
 *  用户 Post
 */
+ (void)user_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", path]  withParams:params withMethodType:Post andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

/**
 *  用户 Get
 */
+ (void)user_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", path] withParams:params withMethodType:Get andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

#pragma mark - ++++++++++++ 资产 ++++++++++++++
/**
 *  资产 Post
 */
+ (void)asset_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", path]  withParams:params withMethodType:Post andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

/**
 *  资产 Get
 */
+ (void)asset_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", path] withParams:params withMethodType:Get andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
    
}

#pragma mark - ++++++++++++ 订单 ++++++++++++++
/**
 *  订单 Post
 */
+ (void)order_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", path]  withParams:params withMethodType:Post andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

/**
 *  订单 Get
 */
+ (void)order_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", path] withParams:params withMethodType:Get andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
    
}

#pragma mark - ++++++++++++ 行情 ++++++++++++++
+ (void)quote_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {

    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"api/", path] withParams:params withMethodType:Get andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

+ (void)quote_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {

    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"api/", path] withParams:params withMethodType:Post andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

#pragma mark - ++++++++++++ 公共 ++++++++++++++
+ (void)basic_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {

    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", path] withParams:params withMethodType:Get andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

+ (void)basic_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", path] withParams:params withMethodType:Post andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

#pragma mark - ++++++++++++ 通用接口 ++++++++++++++
/**
 *  Get通用接口
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", path] withParams:params withMethodType:Get andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

/**
 *  Post通用接口
 */
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", path] withParams:params withMethodType:Post andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

#pragma mark - ++++++++++++ 静态请求 ++++++++++++++
+ (void)ms_PostWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"ms_api/", path]  withParams:params withMethodType:Post andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

+ (void)ms_GetWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {

    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"ms_api/", path] withParams:params withMethodType:Get andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

#pragma mark - 2. 上传单张图片
/**
 *  2. 上传图片 和 数据
 *
 *  @param aPath  接口名
 *  @param image   图片
 *  @param params 请求体
 *  @param block  返回数据
 */
+ (void)postFileWithPath:(NSString *)aPath name:(NSString *)name image:(UIImage *)image params:(NSDictionary *)params andBlock:(void (^)(id data, NSString *msg, NSInteger code))block progress:(void (^)(double progress))progressBlock {
    [[NetAPIClient sharedJsonClient] requestUpFileWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", aPath] name:name image:image params:params andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    } progress:^(double progress) {
        progressBlock(progress);
    }];
}

#pragma mark - 3. 上传视频
/**
 *  3. 上传视频
 *
 *  @param aPath  接口名
 *  @param videoData   视频
 *  @param block  返回数据
 */
+(void)postVideoWithPath:(NSString *)aPath videoData:(NSData *)videoData andBlock:(void (^)(id data, NSString *msg, NSInteger code))block progress:(void (^)(double progress))progressBlock {
    [[NetAPIClient sharedJsonClient] requestUpFileWithPath:[NSString stringWithFormat:@"%@%@%@", kServerUrl, @"mapi/", aPath] videoData:videoData andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    } progress:^(double progress) {
        progressBlock(progress);
    }];
}
@end
