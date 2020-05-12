//
//  XXHttpInfo.m
//  iOS
//
//  Created by iOS on 2019/3/21.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import "XXHttpInfo.h"
#import "NetAPIClient.h"
#import "NSObject+BHRequestSetting.h"


@interface XXHttpInfo ()

/** 字典数据 */
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation XXHttpInfo
singleton_implementation(XXHttpInfo)

#pragma mark - 2. 请求成功
- (void)endSuccessTTPURLResponse:(NSHTTPURLResponse *)response timestamp:(NSString *)timestamp {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = timestamp;

    // 1. url
    NSString *url = [NSString stringWithFormat:@"%@://%@%@", response.URL.scheme, response.URL.host, response.URL.path];

    // 2. 网络耗时
    long nowTime = (long)([[NSDate date] timeIntervalSince1970]*1000.0f);
    long intervalTime = nowTime - (long)[timestamp longLongValue];
    if (intervalTime < 0) {
        intervalTime = 1;
    }

    // 3. 网络请求状态码
    NSString *httpCode = [NSString stringWithFormat:@"%zd", response.statusCode];
    
    dict[@"request_url"] = url;
    dict[@"cost"] = [NSString stringWithFormat:@"%ld", intervalTime];
    dict[@"http_code"] = httpCode;
    dict[@"error_code"] = @"";
    dict[@"error_message"] = @"";
    dict[@"remote_server"] = KString(KMarket.remoteDomain);
    dict[@"remote_address"] = KString(KMarket.remoteAddress);
    dict[@"dns_duration"] = KString(KMarket.dnsDuration);
    dict[@"success"] = @(YES);
    [self.dataArray addObject:dict];
    [self nextStep];
}

- (void)endNoJsonDataSuccessTTPURLResponse:(NSHTTPURLResponse *)response timestamp:(NSString *)timestamp content:(NSString *)contentStr {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = timestamp;

    // 1. url
    NSString *url = [NSString stringWithFormat:@"%@://%@%@", response.URL.scheme, response.URL.host, response.URL.path];

    // 2. 网络耗时
    long nowTime = (long)([[NSDate date] timeIntervalSince1970]*1000.0f);
    long intervalTime = nowTime - (long)[timestamp longLongValue];
    if (intervalTime < 0) {
        intervalTime = 1;
    }

    // 3. 网络请求状态码
    NSString *httpCode = [NSString stringWithFormat:@"%zd", response.statusCode];

    dict[@"request_url"] = url;
    dict[@"cost"] = [NSString stringWithFormat:@"%ld", intervalTime];
    dict[@"http_code"] = httpCode;
    dict[@"error_code"] = @"3840";
    dict[@"error_message"] = @"非Json数据";
    dict[@"error_content"] = KString(contentStr);
    dict[@"remote_server"] = KString(KMarket.remoteDomain);
    dict[@"remote_address"] = KString(KMarket.remoteAddress);
    dict[@"dns_duration"] = KString(KMarket.dnsDuration);
    dict[@"success"] = @(NO);
    [self.dataArray addObject:dict];
    [self nextStep];
}

#pragma mark - 3. 请求失败
- (void)endFailureTask:(NSURLSessionDataTask *)task timestamp:(NSString *)timestamp error:(NSError *)error {

    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = timestamp;

    // 1. url
    NSURL *htUrl = response.URL;
    if (!htUrl) {
        htUrl = error.userInfo[@"NSErrorFailingURLKey"];
    }
    NSString *url = [NSString stringWithFormat:@"%@://%@%@", htUrl.scheme, htUrl.host, htUrl.path];


    // 2. 网络耗时
    long nowTime = (long)([[NSDate date] timeIntervalSince1970]*1000.0f);

    long intervalTime = nowTime - [timestamp longLongValue];
    if (intervalTime < 0) {
        intervalTime = 1;
    }

    // 3. 网络请求状态码
    NSString *httpCode = [NSString stringWithFormat:@"%zd", response.statusCode];

    // 4. 判断状态
    NSString *errorCode = @"";
    NSString *errorMessage = @"";
    if (response.statusCode == 400 || response.statusCode == 500) {
        NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
        errorCode = KString(dataDic[@"code"]);
        errorMessage = KString(dataDic[@"msg"]);
        if ([errorCode isEqualToString:@"30000"]) {
            dict[@"originalRequestAllHTTPHeaderFields"] = [task.originalRequest.allHTTPHeaderFields mj_JSONString];
            dict[@"currentRequestAllHTTPHeaderFields"] = [task.currentRequest.allHTTPHeaderFields mj_JSONString];
            dict[@"responseAllHeaderFields"] = [response.allHeaderFields mj_JSONString];
        }
    } else {
        errorCode = [NSString stringWithFormat:@"%zd", error.code];
        errorMessage = KString(error.localizedDescription);
        if ([errorCode integerValue] == 3840) {
            NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
            dict[@"error_content"] = [dataDic mj_JSONString];
        }
    }

    dict[@"request_url"] = url;
    dict[@"cost"] = [NSString stringWithFormat:@"%ld", intervalTime];
    dict[@"http_code"] = httpCode;
    dict[@"error_code"] = errorCode;
    dict[@"error_message"] = errorMessage;
    dict[@"remote_server"] = KString(KMarket.remoteDomain);
    dict[@"remote_address"] = KString(KMarket.remoteAddress);
    dict[@"dns_duration"] = KString(KMarket.dnsDuration);
    dict[@"success"] = @(NO);
    [self.dataArray addObject:dict];
    [self nextStep];

}

#pragma mark - 4. 检测数据
- (void)nextStep {

    if (self.dataArray.count >= 20) {
        NSData *data = [[self.dataArray mj_JSONString] dataUsingEncoding:NSUTF8StringEncoding];
        [self.dataArray removeAllObjects];
        [self postWithUrl:@"https://analyze.bhfastime.com/mobile" body:data];
    }
}

#pragma mark - 5. 提交日志
- (void)postWithUrl:(NSString *)url body:(NSData *)body
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    request.timeoutInterval= 15;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self setHttpHeader:request];
    // 设置body
    [request setHTTPBody:body];

    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",
                                                 @"text/json",
                                                 @"text/javascript",
                                                 @"text/plain",
                                                 nil];
    manager.responseSerializer = responseSerializer;

    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (!error) {

        } else {

        }
    }] resume];
}

/**
 设置请求 header
 */
- (void)setHttpHeader:(NSMutableURLRequest *)request {

}

#pragma mark - || 懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
