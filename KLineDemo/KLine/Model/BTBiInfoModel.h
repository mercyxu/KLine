//
//  BTBiInfoModel.h
//  Bitbt
//
//  Created by iOS on 2019/5/14.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTBiInfoModel : NSObject

@property (nonatomic, copy) NSString *Description;//简介

@property (nonatomic, copy) NSString *PushTime; //发行时间

@property (nonatomic, copy) NSString *CoinFullName;

@property (nonatomic, copy) NSString *PublishNum;//发行总量

@property (nonatomic, copy) NSString *MarketNum;//流通总量

@property (nonatomic, assign) CGFloat CrowdFundingPrice;//众筹价格

@property (nonatomic, copy) NSString *WhitePaper; //白皮书

@property (nonatomic, copy) NSString *Website;//官网

@property (nonatomic, copy) NSString *BlockTheQuery;//区块查询

@property (nonatomic, assign) CGFloat desCellHeight;

@end

NS_ASSUME_NONNULL_END
