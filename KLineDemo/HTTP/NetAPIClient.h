//
//  NetAPIClient.h
//  Tourist
//
//  Created by HG_hupfei on 15/11/18.
//  Copyright © 2015年 HG_hupfei. All rights reserved.
//

#import "AFHTTPSessionManager.h"


@interface NetAPIClient : AFHTTPSessionManager

+ (id)sharedJsonClient;


#pragma mark - 1. Post 或 get 网络请求
/**
 *  1. Post 或 get 网络请求
 *
 *  @param aPath  接口名
 *  @param params 请求体
 *  @param method 请求方式
 *  @param block  返回数据
 */
- (void)requestHttpWithPath:(NSString *)aPath
                 withParams:(NSDictionary*)params
             withMethodType:(NetworkMethod)method
                   andBlock:(void (^)(id data, NSString *msg, NSInteger code))block;

#pragma mark - 2. 外部调用Post 或 get 网络请求
/**
 *  2. Post 或 get 网络请求
 *
 *  @param aPath  接口名
 *  @param params 请求体
 *  @param method 请求方式
 *  @param block  返回数据
 */
- (void)externalRequestHttpWithPath:(NSString *)aPath
                 withParams:(NSDictionary*)params
             withMethodType:(NetworkMethod)method
                   andBlock:(void (^)(id data, NSString *msg, NSInteger code))block;

#pragma mark - 3. 上传单张图片
/**
 *  3. 上传图片 和 数据
 *
 *  @param aPath  接口名
 *  @param image   图片
 *  @param params 请求体
 *  @param block  返回数据
 */
-(void)requestUpFileWithPath:(NSString *)aPath name:(NSString *)name image:(UIImage *)image params:(NSDictionary *)params andBlock:(void (^)(id data, NSString *msg, NSInteger code))block progress:(void (^)(double progress))progressBlock;



#pragma mark - 4. 上传视频
/**
 *  4. 上传视频数据
 *
 *  @param aPath  接口名
 *  @param videoData   视频
 *  @param block  返回数据
 */
-(void)requestUpFileWithPath:(NSString *)aPath videoData:(NSData *)videoData andBlock:(void (^)(id data, NSString *msg, NSInteger code))block progress:(void (^)(double progress))progressBlock;
@end
