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


#pragma mark - ++++++++++++ 资产 ++++++++++++++


#pragma mark - ++++++++++++ 订单 ++++++++++++++



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


#pragma mark - 3. 上传视频

@end
