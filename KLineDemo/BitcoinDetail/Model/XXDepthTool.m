//
//  XXDepthTool.m
//  iOS
//
//  Created by iOS on 2018/9/6.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXDepthTool.h"
#import "XXDepthModel.h"
#import "XXDepthOrderModel.h"
#import "XXDepthMapModel.h"

@implementation XXDepthTool

/**
 1. 盘口列表 【交易】
 leftDict:原始买盘数据
 rightDict:原始卖盘数据
 binds:买盘推送数据
 asks:卖盘推送数据
 priceDigit:价格精度
 amountDigit:数量精度
 retun b:买单模型数组 a:卖单模型 o:平均值
 */
+ (NSDictionary *)depthLeftDict:(NSMutableDictionary *)leftDict
                      rightDict:(NSMutableDictionary *)rightDict
                          binds:(NSArray *)binds
                           asks:(NSArray *)asks
                     priceDigit:(NSInteger)priceDigit
                    amountDigit:(NSInteger)amountDigit {
    // 1. 增删改查买卖盘字典
    for (NSInteger i=0; i < binds.count; i ++) {
        NSArray *array = binds[i];
        NSString *key = array[0]; // 价格
        NSString *value = array[1]; // 数量
        if ([value doubleValue] == 0) {
            [leftDict removeObjectForKey:key];
        } else {
            [leftDict setObject:value forKey:key];
        }
    }

    for (NSInteger i=0; i < asks.count; i ++) {
        NSArray *array = asks[i];
        NSString *key = array[0];
        NSString *value = array[1];
        if ([value doubleValue] == 0) {
            [rightDict removeObjectForKey:key];
        } else {
            [rightDict setObject:value forKey:key];
        }
    }
    
    // 2. 获取买卖判断key数组 【key==price】
    NSArray *leftKeysArray = [NSString sortDropArray:[leftDict allKeys]];
    NSArray *rightKeysArray = [NSString sortRiseArray:[rightDict allKeys]];
    
    // 3. 解析数据到模型
    double leftAmount = 0;
    double rightAmount = 0;
    NSMutableArray *buyModelsArray = [NSMutableArray array];
    NSMutableArray *sellModelsArray = [NSMutableArray array];
    for (NSInteger i=0; i < 10; i ++) {
        if (i < leftKeysArray.count) {
            NSString *key = leftKeysArray[i];
            NSString *value = leftDict[key];
            XXDepthModel *model = [XXDepthModel new];
            model.isBuy = YES;
            model.price = [KDecimal decimalNumber:key RoundingMode:NSRoundDown scale:priceDigit];
            model.number = [KDecimal decimalNumber:value RoundingMode:NSRoundDown scale:amountDigit];
            [buyModelsArray addObject:model];
            
            leftAmount += [model.number doubleValue];
            model.sumNumber = leftAmount;
        }
            
        if (i < rightKeysArray.count) {
            NSString *key = rightKeysArray[i];
            NSString *value = rightDict[key];
            XXDepthModel *model = [XXDepthModel new];
            model.isBuy = NO;
            model.price = [KDecimal decimalNumber:key RoundingMode:NSRoundUp scale:priceDigit];
            model.number = [KDecimal decimalNumber:value RoundingMode:NSRoundDown scale:amountDigit];
            [sellModelsArray addObject:model];
            
            rightAmount += [model.number doubleValue];
            model.sumNumber = rightAmount;
        }
    }
        
    double ordersAverage = leftAmount;
    if (rightAmount > leftAmount) {
        ordersAverage = rightAmount;
    }
    if (isnan(ordersAverage)) {
        ordersAverage = 1.0;
    }
    
    BOOL isSuccess = YES;
    if ([leftKeysArray.firstObject doubleValue] > [rightKeysArray.firstObject doubleValue]) {
        isSuccess = NO;
    }
    return @{
        @"success":@(isSuccess),
        @"b":buyModelsArray,
        @"a":sellModelsArray,
        @"o":@(ordersAverage)};
}

/**
 2. k线盘口绘制 【交易】
 leftDict:原始买盘数据
 rightDict:原始卖盘数据
 binds:买盘推送数据
 asks:卖盘推送数据
 priceDigit:价格精度
 amountDigit:数量精度
 viewWidth:视图宽度
 viewHeight:视图高度
 */
+ (NSDictionary *)klineDepthLeftDict:(NSMutableDictionary *)leftDict
                           rightDict:(NSMutableDictionary *)rightDict
                               Binds:(NSArray *)binds
                                asks:(NSArray *)asks
                          priceDigit:(NSInteger)priceDigit
                         amountDigit:(NSInteger)amountDigit
                         viewWidth:(CGFloat)viewWidth
                          viewHeight:(CGFloat)viewHeight {
    
    // 1. 增删改查买卖盘字典
    for (NSInteger i=0; i < binds.count; i ++) {
        NSArray *array = binds[i];
        NSString *key = array[0]; // 价格
        NSString *value = array[1]; // 数量
        if ([value doubleValue] == 0) {
            [leftDict removeObjectForKey:key];
        } else {
            [leftDict setObject:value forKey:key];
        }
    }
    
    for (NSInteger i=0; i < asks.count; i ++) {
        NSArray *array = asks[i];
        NSString *key = array[0];
        NSString *value = array[1];
        if ([value doubleValue] == 0) {
            [rightDict removeObjectForKey:key];
        } else {
            [rightDict setObject:value forKey:key];
        }
    }
    
    // 2. 获取买卖判断key数组 【key==price】
    NSArray *leftKeysArray = [NSString sortRiseArray:[leftDict allKeys]];
    if (leftKeysArray.count > 100) {
        leftKeysArray = [leftKeysArray subarrayWithRange:NSMakeRange(leftKeysArray.count - 100, 100)];
    }
    
    NSArray *rightKeysArray = [NSString sortRiseArray:[rightDict allKeys]];
    if (rightKeysArray.count > 100) {
        rightKeysArray = [rightKeysArray subarrayWithRange:NSMakeRange(0, 100)];
    }
    
    // 3. 计算买卖盘价格最小值 最大值 及X Y轴刻度
    double leftMidPrice = [[leftKeysArray firstObject] doubleValue];
    double leftMaxPrice = [[leftKeysArray lastObject] doubleValue];
    if (KDetail.symbolModel.type == SymbolTypeCoin && leftMidPrice < leftMaxPrice *0.4f) {
        leftMidPrice = leftMaxPrice *0.4f;
    }

    double rightMidPrice = [[rightKeysArray firstObject] doubleValue];
    double rightMaxPrice = [[rightKeysArray lastObject] doubleValue];
    if (KDetail.symbolModel.type == SymbolTypeCoin && rightMaxPrice > rightMidPrice * 1.6f) {
        rightMaxPrice = rightMidPrice * 1.6f;
    }

    double centerPrice = (leftMaxPrice + rightMidPrice) / 2.0;
    double chengePrice = 0;
    if (centerPrice - leftMidPrice > rightMaxPrice - centerPrice) {
        chengePrice = rightMaxPrice - centerPrice;
    } else {
        chengePrice = centerPrice - leftMidPrice;
    }

    leftMidPrice = [[NSString stringWithFormat:@"%.13f", centerPrice - chengePrice] doubleValue];
    rightMaxPrice = [[NSString stringWithFormat:@"%.13f", centerPrice + chengePrice] doubleValue];
    
    // 4. 数据转换模型
    NSMutableArray *leftModelsArray = [NSMutableArray array];
    double maxOrderNumber = 0;
    CGFloat leftOrderNumber = 0;
    XXDepthMapModel *leftModel = nil;
    for (NSInteger i=leftKeysArray.count - 1; i >= 0; i --) {

        NSString *key = leftKeysArray[i];
        if ([leftModel.priceString isEqualToString:[KDecimal decimalNumber:key RoundingMode:NSRoundDown scale:KDetail.priceDigit]]) {
            leftModel.orderNumber = [leftDict[key] doubleValue] + leftOrderNumber;
            leftModel.orderNumberString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", leftModel.orderNumber] RoundingMode:NSRoundDown scale:KDetail.numberDigit];
            leftModel.currentOrderNumber = [leftDict[key] doubleValue] + leftModel.currentOrderNumber;
            leftModel.currentOrderNumberString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", leftModel.currentOrderNumber] RoundingMode:NSRoundDown scale:KDetail.numberDigit];
            leftOrderNumber = leftModel.orderNumber;
        } else {
            XXDepthMapModel *model = [[XXDepthMapModel alloc] init];
            leftModel = model;
            model.price = [key doubleValue];
            if ([key doubleValue] >= leftMidPrice) {
                
                model.priceString = [KDecimal decimalNumber:key RoundingMode:NSRoundDown scale:KDetail.priceDigit];
                model.orderNumber = [leftDict[key] doubleValue] + leftOrderNumber;
                model.orderNumberString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", model.orderNumber] RoundingMode:NSRoundDown scale:KDetail.numberDigit];
                model.currentOrderNumber = [leftDict[key] doubleValue];
                model.currentOrderNumberString = [KDecimal decimalNumber:leftDict[key] RoundingMode:NSRoundDown scale:KDetail.numberDigit];
                [leftModelsArray insertObject:model atIndex:0];
                leftOrderNumber = model.orderNumber;
                if ([key doubleValue] == leftMidPrice) {
                    break;
                }
            } else {
                model.priceString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", leftMidPrice] RoundingMode:NSRoundDown scale:KDetail.priceDigit];
                model.orderNumber = leftOrderNumber;
                model.orderNumberString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", model.orderNumber] RoundingMode:NSRoundDown scale:KDetail.numberDigit];
                [leftModelsArray insertObject:model atIndex:0];
                leftOrderNumber = model.orderNumber;
                break;
            }
        }
    }

    NSMutableArray *rightModelsArray = [NSMutableArray array];
    CGFloat rightOrderNumber = 0;
    XXDepthMapModel *rightModel = nil;
    for (NSInteger i=0; i < rightKeysArray.count; i ++) {

        NSString *key = rightKeysArray[i];
        if ([rightModel.priceString isEqualToString:[KDecimal decimalNumber:key RoundingMode:NSRoundUp scale:KDetail.priceDigit]]) {
            rightModel.orderNumber = [rightDict[key] doubleValue] + rightOrderNumber;
            rightModel.orderNumberString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", rightModel.orderNumber] RoundingMode:NSRoundDown scale:KDetail.numberDigit];
            rightModel.currentOrderNumber = [rightDict[key] doubleValue] + rightModel.currentOrderNumber;
            rightModel.currentOrderNumberString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", rightModel.currentOrderNumber] RoundingMode:NSRoundDown scale:KDetail.numberDigit];
            rightOrderNumber = rightModel.orderNumber;
        } else {
            XXDepthMapModel *model = [[XXDepthMapModel alloc] init];
            rightModel = model;
            model.price = [key doubleValue];
            if ([key doubleValue] <= rightMaxPrice) {
                model.priceString = [KDecimal decimalNumber:key RoundingMode:NSRoundUp scale:KDetail.priceDigit];
                model.orderNumber = [rightDict[key] doubleValue] + rightOrderNumber;
                model.orderNumberString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", model.orderNumber] RoundingMode:NSRoundDown scale:KDetail.numberDigit];
                model.currentOrderNumber = [rightDict[key] doubleValue];
                model.currentOrderNumberString = [KDecimal decimalNumber:rightDict[key] RoundingMode:NSRoundDown scale:KDetail.numberDigit];
                [rightModelsArray addObject:model];
                rightOrderNumber = model.orderNumber;
                if ([key doubleValue] == rightMaxPrice) {
                    break;
                }
            } else {
                model.orderNumber = rightOrderNumber;
                model.priceString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", rightMaxPrice] RoundingMode:NSRoundDown scale:KDetail.priceDigit];
                model.orderNumberString = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", model.orderNumber] RoundingMode:NSRoundDown scale:KDetail.numberDigit];
                [rightModelsArray addObject:model];
                rightOrderNumber = model.orderNumber;
                break;
            }
        }
    }

    maxOrderNumber = leftOrderNumber;
    if (rightOrderNumber > leftOrderNumber) {
        maxOrderNumber = rightOrderNumber;
    }
    CGFloat xScale = viewWidth / (rightMaxPrice - leftMidPrice);
    CGFloat yScale = viewHeight / maxOrderNumber;
    
    // 5. 画板数据
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    UIBezierPath *leftFullPath = [UIBezierPath bezierPath];
    for (NSInteger i=0; i < leftModelsArray.count; i ++) {
        XXDepthMapModel *model = leftModelsArray[i];
        if (i==0) {

            model.startPoint = CGPointMake(0, viewHeight - model.orderNumber*yScale);
            [leftPath moveToPoint:model.startPoint];
            [leftFullPath moveToPoint:CGPointMake(0, viewHeight)];
            [leftFullPath addLineToPoint:model.startPoint];
            
            if (leftModelsArray.count > 1) {
                XXDepthMapModel *nextModel = leftModelsArray[i+1];
                  
                CGFloat x = (model.price - leftMidPrice)*xScale;
                CGFloat nextX = (nextModel.price - leftMidPrice)*xScale;
                  
                model.endPoint = CGPointMake((nextX + x)/2.0f, viewHeight -  model.orderNumber*yScale);
                nextModel.startPoint = CGPointMake((nextX + x)/2.0f, viewHeight - nextModel.orderNumber*yScale);
                  
                [leftPath addLineToPoint:model.endPoint];
                [leftPath addLineToPoint:nextModel.startPoint];
                  
                [leftFullPath addLineToPoint:model.endPoint];
                [leftFullPath addLineToPoint:nextModel.startPoint];
              }
              
          } else if (i == leftModelsArray.count - 1) {
              
              model.endPoint = CGPointMake((model.price - leftMidPrice)*xScale, model.startPoint.y);
              [leftPath addLineToPoint:model.endPoint];
              [leftFullPath addLineToPoint:model.endPoint];
              [leftFullPath addLineToPoint:CGPointMake(model.endPoint.x, viewHeight)];
          } else {

              XXDepthMapModel *nextModel = leftModelsArray[i+1];
              CGFloat x = (model.price - leftMidPrice)*xScale;
              CGFloat nextX = (nextModel.price - leftMidPrice)*xScale;
              
              model.endPoint = CGPointMake((nextX + x)/2.0f, viewHeight -  model.orderNumber*yScale);
              nextModel.startPoint = CGPointMake((nextX + x)/2.0f, viewHeight -  nextModel.orderNumber*yScale);
              
              [leftPath addLineToPoint:model.endPoint];
              [leftPath addLineToPoint:nextModel.startPoint];
              
              [leftFullPath addLineToPoint:model.endPoint];
              [leftFullPath addLineToPoint:nextModel.startPoint];
          }
      }
      
      
      UIBezierPath *rightPath = [UIBezierPath bezierPath];
      UIBezierPath *rightFullPath = [UIBezierPath bezierPath];
      for (NSInteger i=0; i < rightModelsArray.count; i ++) {
          XXDepthMapModel *model = rightModelsArray[i];
          if (i==0) {

              model.startPoint = CGPointMake((model.price - leftMidPrice)*xScale, viewHeight - model.orderNumber*yScale);
              [rightPath moveToPoint:model.startPoint];
              [rightFullPath moveToPoint:CGPointMake(model.startPoint.x, viewHeight)];
              [rightFullPath addLineToPoint:model.startPoint];
              
              if (rightModelsArray.count > 1) {
                  XXDepthMapModel *nextModel = rightModelsArray[i+1];
                  
                  CGFloat x = (model.price - leftMidPrice)*xScale;
                  CGFloat nextX = (nextModel.price - leftMidPrice)*xScale;
                  
                  model.endPoint = CGPointMake((nextX + x)/2.0f, viewHeight -  model.orderNumber*yScale);
                  
                  nextModel.startPoint = CGPointMake((nextX + x)/2.0f, viewHeight -  nextModel.orderNumber*yScale);
                  
                  [rightPath addLineToPoint:model.endPoint];
                  [rightPath addLineToPoint:nextModel.startPoint];
                  
                  [rightFullPath addLineToPoint:model.endPoint];
                  [rightFullPath addLineToPoint:nextModel.startPoint];
              }
              
          } else if (i == rightModelsArray.count - 1) {
              
              model.endPoint = CGPointMake((model.price - leftMidPrice)*xScale, model.startPoint.y);
              
              [rightPath addLineToPoint:model.endPoint];
              [rightFullPath addLineToPoint:model.endPoint];
              [rightFullPath addLineToPoint:CGPointMake(model.endPoint.x, viewHeight)];
              
          } else {
              
              XXDepthMapModel *nextModel = rightModelsArray[i+1];
              CGFloat x = (model.price - leftMidPrice)*xScale;
              CGFloat nextX = (nextModel.price - leftMidPrice)*xScale;
              
              model.endPoint = CGPointMake((nextX + x)/2.0f, viewHeight -  model.orderNumber*yScale);
              
              nextModel.startPoint = CGPointMake((nextX + x)/2.0f, viewHeight -  nextModel.orderNumber*yScale);
              
              [rightPath addLineToPoint:model.endPoint];
              [rightPath addLineToPoint:nextModel.startPoint];
              
              [rightFullPath addLineToPoint:model.endPoint];
              [rightFullPath addLineToPoint:nextModel.startPoint];
          }
      }
    
    // 6. 盘口列表数据
    double leftSum = 0;
    double rightSum = 0;
    NSMutableArray *orderModelsArray = [NSMutableArray array];
    for (NSInteger i=0; i < 20; i ++) {
        XXDepthOrderModel *orderModel = [XXDepthOrderModel new];
        NSInteger j = leftModelsArray.count - 1 - i;
        if (j >= 0) {
            XXDepthMapModel *lModel = leftModelsArray[j];
            orderModel.leftPrice = lModel.priceString;
            orderModel.leftNumber = lModel.currentOrderNumberString;
            orderModel.leftSumNumber = lModel.orderNumber;
            leftSum = lModel.orderNumber;
        } else {
            orderModel.leftPrice = nil;
        }

        if (i < rightModelsArray.count) {
            XXDepthMapModel *rModel = rightModelsArray[i];
            orderModel.rightPrice = rModel.priceString;
            orderModel.rightNumber = rModel.currentOrderNumberString;
            orderModel.rightSumNumber = rModel.orderNumber;
            rightSum = rModel.orderNumber;
        } else {
            orderModel.rightPrice = nil;
        }
        
        [orderModelsArray addObject:orderModel];
    }
    double ordersAverage = leftSum;
    if (rightSum > leftSum) {
        ordersAverage = rightSum;
    }
    
    BOOL isSuccess = YES;
    if (leftMaxPrice > rightMidPrice) {
        isSuccess = NO;
    }
    
    NSDictionary *dataDict = @{
        @"success":@(isSuccess),
        @"maxOrderNumber":@(maxOrderNumber),
        @"leftMidPrice":@(leftMidPrice),
        @"rightMaxPrice":@(rightMaxPrice),
        @"leftModelsArray":leftModelsArray,
        @"rightModelsArray":rightModelsArray,
        @"leftLinePath":leftPath,
        @"leftFillPath":leftFullPath,
        @"rightLinePath":rightPath,
        @"rightFillPath":rightFullPath,
        @"orderModels":orderModelsArray,
        @"ordersAverage":@(ordersAverage)};
    return dataDict;
}
@end
