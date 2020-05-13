//
//  XXTokenModel.h
//  iOS
//
//  Created by iOS on 2018/9/29.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXQuoteTokenModel : NSObject

/** 行情名称 */
@property (strong, nonatomic) NSString *tokenName;

/** id */
@property (strong, nonatomic) NSString *id;

/** exchangeId.symbolId 多个逗号隔开 */
@property (strong, nonatomic) NSString *idsString;

/** 比对列表 */
@property (strong, nonatomic) NSMutableArray *symbolsArray;

/** 是否是自选 */
@property (assign, nonatomic) BOOL isFavorite;

/** webSocket */
@property (strong, nonatomic) XXWebQuoteModel *webModel;

@property (strong, nonatomic) void(^successBlock)(id data);
@property (strong, nonatomic) void(^failureBlock)(void);

- (void)openWebsocket;
- (void)closeWebsocket;

- (void)updateQuoteAndSortWithQuote:(NSDictionary *)quoteDict;

@end
