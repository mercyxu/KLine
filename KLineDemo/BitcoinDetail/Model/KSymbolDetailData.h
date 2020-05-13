//
//  KSymbolDetailData.h
//  iOS
//
//  Created by YiHeng on 2020/2/4.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSymbolDetailData : NSObject
singleton_interface(KSymbolDetailData)

#pragma mark - 5. 币对详情模型
/** 币对详情模型 */
@property (strong, nonatomic) XXSymbolModel *symbolModel;

/** 价格精度位数 */
@property (assign, nonatomic) NSInteger priceDigit;

/** 数量精度位数 */
@property (assign, nonatomic) NSInteger numberDigit;

/** 是否可以刷新k线图 */
@property (assign, nonatomic) BOOL isReloadKlineUI;

/** 索引k线类型 */
@property (strong, nonatomic) NSString *klineIndex;

/** 主图索引 */
@property (strong, nonatomic, nullable) NSString *klineMainIndex;

/** 副图索引 */
@property (strong, nonatomic, nullable) NSString *klineAccessoryIndex;

/** 回调深度列表 */
@property (strong, nonatomic, nullable) void(^blockList)(NSMutableArray *modelsArray, double ordersAverage);

#pragma mark 存取方法
-(id)getValueForKey:(NSString*)key;
-(void)saveValeu:(id)value forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
