//
//  NetAPIClient.m
//  Tourist
//
//  Created by HG_hupfei on 15/11/18.
//  Copyright © 2015年 HG_hupfei. All rights reserved.
//

#define kNetworkMethodName @[@"Get", @"Post"]
#import "NetAPIClient.h"
#import "NSObject+BHRequestSetting.h"
#import "XXHttpInfo.h"

@implementation NetAPIClient

static NetAPIClient *_sharedClient = nil;
static dispatch_once_t onceToken;

+ (NetAPIClient *)sharedJsonClient {
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        [_sharedClient.requestSerializer setTimeoutInterval:15];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
//    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
//    //如果是需要验证自建证书，需要设置为YES
//    self.securityPolicy.allowInvalidCertificates = YES;
//
    // 是否验证域名 Defaults to `YES`.
//    self.securityPolicy.validatesDomainName = NO;
    
    return self;
}

//
/**
 设置请求 header
 */
- (void)setHttpHeader {


}

#pragma mark - 1. Post 或 get 网络请求
/**
 *  1. Post 或 get 网络请求
 *
 *  @param aPath  接口名
 *  @param params 请求体
 *  @param method 请求方式
 *  @param block  返回数据
 */
- (void)requestHttpWithPath:(NSString *)aPath withParams:(NSDictionary *)params withMethodType:(NetworkMethod)method andBlock:(void (^)(id data, NSString *msg, NSInteger code))block {
    
    if (!aPath || aPath.length <= 0) {
        return;
    }
    
    aPath = [aPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"\n===========数据请求===========\nmethod:%@\naPath:%@\nparams%@", kNetworkMethodName[method], aPath, params);
    [self.requestSerializer setTimeoutInterval:15];
    
    [self setHttpHeader];
    
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", (CGFloat)[[NSDate date] timeIntervalSince1970]*1000];
    
    //发起请求
    switch (method) {
        case Get:{
            [self GET:aPath parameters:[self getPostRequestSignatureDictionary:params] progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSDictionary class]]) {
                    [[XXHttpInfo sharedXXHttpInfo] endSuccessTTPURLResponse:(NSHTTPURLResponse *)task.response timestamp:timestamp];
                    block(data, @"网络请求正常！", 0);
                } else {
                    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
                    [[XXHttpInfo sharedXXHttpInfo] endNoJsonDataSuccessTTPURLResponse:(NSHTTPURLResponse *)task.response timestamp:timestamp content:responseStr];
                    block(data, @"数据异常！", -1001);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self umFailureTask:task error:error];
                [[XXHttpInfo sharedXXHttpInfo] endFailureTask:task timestamp:timestamp error:error];
                
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                NSInteger statusCode = response.statusCode;
                //如果响应头http状态码是400了则进一步查下原因
                if (statusCode == 400) {
                    NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
                    NSLog(@"错误信息=%@", [dataDic mj_JSONString]);
                    block(nil, KString(dataDic[@"msg"]), [dataDic[@"code"] integerValue]);
                    if ([dataDic[@"code"] integerValue] == 30000) {
                        NSLog(@"ERRO=%@", error);
                        [self loginOut:task];
                        [NotificationManager postLoginOutSuccessNotification];
                    }
                } else if (statusCode == 500) {
                    NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
                    NSLog(@"错误信息=%@", [dataDic mj_JSONString]);
                    block(nil, KString(dataDic[@"msg"]), [dataDic[@"code"] integerValue]);
                    if ([dataDic[@"code"] integerValue] == 30000) {
                        NSLog(@"ERRO=%@", error);
                        [self loginOut:task];
                        [NotificationManager postLoginOutSuccessNotification];
                    }
                } else if (statusCode == -1202) {
                    NSLog(@"证书无效！");
                } else {
                    
                    NSLog(@"错误=%@", error);
                    NSString *errorMsg = error.localizedDescription;
                    if (!IsEmpty(errorMsg)) {
                        block(nil, errorMsg, 10000);
                    } else {
                        block(nil, LocalizedString(@"NoNetworking"), 10000);
                    }
                }
            }];
            break;
        }
        case Post:{
            [self POST:aPath parameters:[self getPostRequestSignatureDictionary:params] progress:^(NSProgress * _Nonnull uploadProgress) {


            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [[XXHttpInfo sharedXXHttpInfo] endSuccessTTPURLResponse:(NSHTTPURLResponse *)task.response timestamp:timestamp];
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                NSDictionary *dataDict = [response.allHeaderFields mj_JSONObject];
                if (dataDict[@"Set-Cookie"]) {
                    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
                        if ([cookie.name isEqualToString:@"au_token"] && [kServerUrl containsString:cookie.domain]) {
                            NSLog(@"autoken=====================================%@",cookie.value);
   
                        }
                    }
                }
                
                id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSDictionary class]]) {
                    [[XXHttpInfo sharedXXHttpInfo] endSuccessTTPURLResponse:(NSHTTPURLResponse *)task.response timestamp:timestamp];
                    block(data, @"网络请求正常！", 0);
                } else {
                    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
                    [[XXHttpInfo sharedXXHttpInfo] endNoJsonDataSuccessTTPURLResponse:(NSHTTPURLResponse *)task.response timestamp:timestamp content:responseStr];
                    block(data, @"数据异常！", -1001);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self umFailureTask:task error:error];
                [[XXHttpInfo sharedXXHttpInfo] endFailureTask:task timestamp:timestamp error:error];
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                NSInteger statusCode = response.statusCode;
                //如果响应头http状态码是400了则进一步查下原因
                if (statusCode == 400) {
                    NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
                    NSLog(@"错误信息=%@", [dataDic mj_JSONString]);
                    block(nil, KString(dataDic[@"msg"]), [dataDic[@"code"] integerValue]);
                    if ([dataDic[@"code"] integerValue] == 30000) {
                        NSLog(@"ERRO=%@", error);
                        [self loginOut:task];
                        [NotificationManager postLoginOutSuccessNotification];
                    }
                } else if (statusCode == 500) {
                    NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
                    NSLog(@"错误信息=%@", [dataDic mj_JSONString]);
                    block(nil, KString(dataDic[@"msg"]), [dataDic[@"code"] integerValue]);
                    if ([dataDic[@"code"] integerValue] == 30000) {
                        NSLog(@"ERRO=%@", error);
                        [self loginOut:task];
                        [NotificationManager postLoginOutSuccessNotification];
                    }
                } else if (statusCode == -1202) {
                    NSLog(@"证书无效！");
                } else {
                    
                    
                    NSLog(@"错误=%@", error);
                    NSString *errorMsg = error.localizedDescription;
                    if (!IsEmpty(errorMsg)) {
                        block(nil, errorMsg, 10000);
                    } else {
                        block(nil, LocalizedString(@"NoNetworking"), 10000);
                    }
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (void)loginOut:(NSURLSessionDataTask *)task {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSURLRequest *request = task.currentRequest;
    NSLog(@"\nrequestAllHeaders=%@\nresponseAllHeaders=%@", [[request allHTTPHeaderFields] mj_JSONString], [response.allHeaderFields mj_JSONString]);
}


#pragma mark - 2. 外部调用Post 或 get 网络请求
/**
 *  1. Post 或 get 网络请求
 *
 *  @param aPath  接口名
 *  @param params 请求体
 *  @param method 请求方式
 *  @param block  返回数据
 */
- (void)externalRequestHttpWithPath:(NSString *)aPath
                 withParams:(NSDictionary*)params
             withMethodType:(NetworkMethod)method
                           andBlock:(void (^)(id data, NSString *msg, NSInteger code))block {
    if (!aPath || aPath.length <= 0) {
        return;
    }
        
    aPath = [aPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"\n=======【外部】数据请求===========\nmethod:%@\naPath:%@\nparams%@", kNetworkMethodName[method], aPath, params);
    [self.requestSerializer setTimeoutInterval:15];
  
        
    //发起请求
    switch (method) {
        case Get:{
            [self GET:aPath parameters:[self getPostRequestSignatureDictionary:params] progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                block(data, @"网络请求正常！", 0);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString *errorMsg = error.localizedDescription;
                if (!IsEmpty(errorMsg)) {
                    block(nil, errorMsg, 10000);
                } else {
                    block(nil, LocalizedString(@"NoNetworking"), 10000);
                }
            }];
            break;
        }
        case Post:{
            [self POST:aPath parameters:[self getPostRequestSignatureDictionary:params] progress:^(NSProgress * _Nonnull uploadProgress) {


            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                block(data, @"网络请求正常！", 0);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"错误=%@", error);
                NSString *errorMsg = error.localizedDescription;
                if (!IsEmpty(errorMsg)) {
                    block(nil, errorMsg, 10000);
                } else {
                    block(nil, LocalizedString(@"NoNetworking"), 10000);
                }
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 3. 上传单张图片
/**
 *  3. 上传图片 和 数据
 *
 *  @param aPath  接口名
 *  @param image   图片
 *  @param params 请求体
 *  @param block  返回数据
 */
-(void)requestUpFileWithPath:(NSString *)aPath name:(NSString *)name image:(UIImage *)image params:(NSDictionary *)params andBlock:(void (^)(id data, NSString *msg, NSInteger code))block progress:(void (^)(double progress))progressBlock {
    aPath = [aPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [self setHttpHeader];
    [self.requestSerializer setTimeoutInterval:30];
    [self POST:aPath parameters:[self getPostRequestSignatureDictionary:nil] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if ((float)data.length/1024 > 200) {
            data = UIImageJPEGRepresentation(image, 1024*200.0/(float)data.length);
        }
//        [formData appendPartWithFileData:data name:name fileName:@"photo.png" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:data name:name fileName:@"photo.png" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progressBlock(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(data, @"success", 0);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = response.statusCode;
        NSLog(@"statusCode = %zd, \n上传失败=%@", statusCode, error);
        block(nil, LocalizedString(@"NoNetworking"), 10000);
        [self umFailureTask:task error:error];
    }];
}

#pragma mark - 4. 上传视频
/**
 *  4. 上传视频数据
 *
 *  @param aPath  接口名
 *  @param videoData   视频
 *  @param block  返回数据
 */
-(void)requestUpFileWithPath:(NSString *)aPath videoData:(NSData *)videoData andBlock:(void (^)(id data, NSString *msg, NSInteger code))block progress:(void (^)(double progress))progressBlock {
    
    [self setHttpHeader];
    [self.requestSerializer setTimeoutInterval:300];
    
    [self POST:aPath parameters:[self getPostRequestSignatureDictionary:nil] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       
        [formData appendPartWithFileData:videoData name:@"upload_video_file" fileName:@"video.mp4" mimeType:@"video/mp4"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progressBlock(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        block(data, @"success", 0);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = response.statusCode;
        //如果响应头http状态码是400了则进一步查下原因
        if (statusCode == 400) {
            NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
            NSLog(@"错误信息=%@", [dataDic mj_JSONString]);
            block(nil, KString(dataDic[@"msg"]), [dataDic[@"code"] integerValue]);
        } else if (statusCode == 500) {
            NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
            NSLog(@"错误信息=%@", [dataDic mj_JSONString]);
            block(nil, KString(dataDic[@"msg"]), [dataDic[@"code"] integerValue]);
        } else if (statusCode == -1202) {
            block(nil, LocalizedString(@"NoNetworking"), 10000);
        } else {
            NSLog(@"错误=%@", error);
            NSString *errorMsg = error.localizedDescription;
            if (!IsEmpty(errorMsg)) {
                block(nil, errorMsg, 10000);
            } else {
                block(nil, LocalizedString(@"NoNetworking"), 10000);
            }
        }

        [self umFailureTask:task error:error];
    }];
}

- (void)umFailureTask:(NSURLSessionDataTask *)task error:(NSError *)error {
    

}
@end
