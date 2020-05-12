//
//  NSObject+BHRequestSetting.h
//  Bhex
//
//  Created by Bhex on 2018/8/16.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BHRequestSetting)


/**
 header userAgent字段

 @return 封装userAgent
 */
- (NSString *)userAgent;

/**
 post 创建一个签名后参数字典
 
 @param params post请求参数字典
 @return 签名后字典
 */
- (NSDictionary *)getPostRequestSignatureDictionary:(NSDictionary *)params;
@end
