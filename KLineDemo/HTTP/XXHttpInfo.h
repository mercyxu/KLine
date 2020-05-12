//
//  XXHttpInfo.h
//  iOS
//
//  Created by iOS on 2019/3/21.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXHttpInfo : NSObject
singleton_interface(XXHttpInfo)

- (void)endSuccessTTPURLResponse:(NSHTTPURLResponse *)response timestamp:(NSString *)timestamp;

- (void)endNoJsonDataSuccessTTPURLResponse:(NSHTTPURLResponse *)response timestamp:(NSString *)timestamp content:(NSString *)contentStr;

- (void)endFailureTask:(NSURLSessionDataTask *)task timestamp:(NSString *)timestamp error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
