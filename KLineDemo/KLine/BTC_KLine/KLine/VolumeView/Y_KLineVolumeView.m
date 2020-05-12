//
//  Y_KLineVolumeView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/3.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineVolumeView.h"
#import "Y_KLineModel.h"
#import "Y_StockChartConstant.h"
#import "UIColor+Y_StockChart.h"
#import "Y_KLineVolumePositionModel.h"
#import "Y_KLinePositionModel.h"

#import "CAShapeLayer+YKLineLayer.h"
#import "CAShapeLayer+YKCandleLayer.h"
#import "Y_StockChartGlobalVariable.h"
@interface Y_KLineVolumeView()

/**
 *  需要绘制的成交量的位置模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineVolumePositionModels;

/**
 *  Volume_MA7位置数组
 */
@property (nonatomic, strong) NSMutableArray *Volume_MA7Positions;

/**
 *  Volume_MA5位置数组
 */
@property (nonatomic, strong) NSMutableArray *Volume_MA5Positions;

/**
 *  Volume_MA10位置数组
 */
@property (nonatomic, strong) NSMutableArray *Volume_MA10Positions;

/**
 *  Volume_MA7位置数组
 */
@property (nonatomic, strong) NSMutableArray *Volume_MA30Positions;
/**
 成交量Layer
 */
@property (nonatomic, strong) CAShapeLayer *volumeLayer;
@property (nonatomic, strong) CAShapeLayer *ma7lLineLayer;//画MA7线
@property (nonatomic, strong) CAShapeLayer *ma30LineLayer;//画MA30线
@property (nonatomic, strong) CAShapeLayer *ma5lLineLayer;//画MA5线
@property (nonatomic, strong) CAShapeLayer *ma10LineLayer;//画MA10线

@end

@implementation Y_KLineVolumeView
#pragma mark - Lazy
- (CAShapeLayer *)volumeLayer {
    if (!_volumeLayer) {
        _volumeLayer = [CAShapeLayer layer];
    }
    return _volumeLayer;
}

- (CAShapeLayer *)ma7lLineLayer {
    if (!_ma7lLineLayer) {
        _ma7lLineLayer = [CAShapeLayer layer];
    }
    return _ma7lLineLayer;
}
- (CAShapeLayer *)ma30LineLayer {
    if (!_ma30LineLayer) {
        _ma30LineLayer = [CAShapeLayer layer];
    }
    return _ma30LineLayer;
}
- (CAShapeLayer *)ma5lLineLayer {
    if (!_ma5lLineLayer) {
        _ma5lLineLayer = [CAShapeLayer layer];
    }
    return _ma5lLineLayer;
}
- (CAShapeLayer *)ma10LineLayer {
    if (!_ma10LineLayer) {
        _ma10LineLayer = [CAShapeLayer layer];
    }
    return _ma10LineLayer;
}
/**
 清理图层
 */
- (void)clearLayer {
    
    if (_ma7lLineLayer) {
        [self.ma7lLineLayer removeFromSuperlayer];
        self.ma7lLineLayer = nil;
    }
    
    if(_ma30LineLayer) {
        [self.ma30LineLayer removeFromSuperlayer];
        self.ma30LineLayer = nil;  
    }
    
    if (_ma5lLineLayer) {
        [self.ma5lLineLayer removeFromSuperlayer];
        self.ma5lLineLayer = nil;
    }
    
    if(_ma10LineLayer) {
        [self.ma10LineLayer removeFromSuperlayer];
        self.ma10LineLayer = nil;
    }
   
    if (_volumeLayer) {
        [self.volumeLayer removeFromSuperlayer];
        self.volumeLayer = nil;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor backgroundColor];
        self.Volume_MA7Positions = @[].mutableCopy;
        self.Volume_MA30Positions = @[].mutableCopy;
        self.Volume_MA5Positions = @[].mutableCopy;
        self.Volume_MA10Positions = @[].mutableCopy;
    }
    return self;
}

#pragma mark drawRect方法
/**
 绘制成交量
 */
- (void)drawVolumeLine
{
    [self clearLayer];
    if(!self.needDrawKLineVolumePositionModels)
    {
        return;
    }
    
    [self.needDrawKLineVolumePositionModels enumerateObjectsUsingBlock:^(Y_KLineVolumePositionModel * _Nonnull volumePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIColor *volumeColor = self.kLineColors[idx];
        CGRect volumeFrame = CGRectMake(volumePositionModel.StartPoint.x-3, volumePositionModel.StartPoint.y,  [Y_StockChartGlobalVariable kLineWidth], CGRectGetHeight(self.frame) - volumePositionModel.StartPoint.y);
        CAShapeLayer *layer = [CAShapeLayer fl_getRectangleLayerWithFrame:volumeFrame backgroundColor:volumeColor];
        [self.volumeLayer addSublayer:layer];
    }];
    
    [self.layer addSublayer:self.volumeLayer];
    
   if(self.targetLineStatus != Y_StockChartTargetLineStatusCloseMA){
     
       //画MA7线
       CAShapeLayer *layer0 = [CAShapeLayer getSingleLineLayerWithPointArray:self.Volume_MA7Positions lineColor:[UIColor ma7Color]];
       [self.ma7lLineLayer addSublayer:layer0];
       //画MA30线
       CAShapeLayer *layer1 = [CAShapeLayer getSingleLineLayerWithPointArray:self.Volume_MA30Positions lineColor:[UIColor ma30Color]];
       [self.ma30LineLayer addSublayer:layer1];

       [self.layer addSublayer:self.ma7lLineLayer];
       [self.layer addSublayer:self.ma30LineLayer];
//       //画MA5线
//       CAShapeLayer *layer01 = [CAShapeLayer getSingleLineLayerWithPointArray:self.Volume_MA5Positions lineColor:[UIColor ma7Color]];
//       [self.ma5lLineLayer addSublayer:layer01];
//       //画MA10线
//       CAShapeLayer *layer11 = [CAShapeLayer getSingleLineLayerWithPointArray:self.Volume_MA10Positions lineColor:[UIColor ma30Color]];
//       [self.ma10LineLayer addSublayer:layer11];
//
//       [self.layer addSublayer:self.ma5lLineLayer];
//       [self.layer addSublayer:self.ma10LineLayer];
   }
}

#pragma mark - 公有方法
#pragma mark 绘制volume方法
- (void)draw
{
    NSInteger kLineModelcount = self.needDrawKLineModels.count;
    NSInteger kLinePositionModelCount = self.needDrawKLinePositionModels.count;
    NSInteger kLineColorCount = self.kLineColors.count;
    NSAssert(self.needDrawKLineModels && self.needDrawKLinePositionModels && self.kLineColors && kLineColorCount == kLineModelcount && kLinePositionModelCount == kLineModelcount, @"数据异常，无法绘制Volume");
    self.needDrawKLineVolumePositionModels = [self private_convertToKLinePositionModelWithKLineModels:self.needDrawKLineModels];
    
    
    [self drawVolumeLine];
}

#pragma mark - 私有方法
#pragma mark 根据KLineModel转换成Position数组
- (NSArray *)private_convertToKLinePositionModelWithKLineModels:(NSArray *)kLineModels
{
    CGFloat minY = Y_StockChartKLineVolumeViewMinY;
    CGFloat maxY = Y_StockChartKLineVolumeViewMaxY;
    
    Y_KLineModel *firstModel = kLineModels.firstObject;
    
    __block CGFloat minVolume = firstModel.Volume;
    __block CGFloat maxVolume = firstModel.Volume;
    
    [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(model.Volume < minVolume)
        {
            minVolume = model.Volume;
        }
        
        if(model.Volume > maxVolume)
        {
            maxVolume = model.Volume;
        }
        if(model.Volume_MA7)
        {
            if (minVolume > model.Volume_MA7.doubleValue) {
                minVolume = model.Volume_MA7.doubleValue;
            }
            if (maxVolume < model.Volume_MA7.doubleValue) {
                maxVolume = model.Volume_MA7.doubleValue;
            }
        }
        if(model.Volume_MA30)
        {
            if (minVolume > model.Volume_MA30.doubleValue) {
                minVolume = model.Volume_MA30.doubleValue;
            }
            if (maxVolume < model.Volume_MA30.doubleValue) {
                maxVolume = model.Volume_MA30.doubleValue;
            }
        }
//        if(model.Volume_MA5)
//        {
//            if (minVolume > model.Volume_MA5.doubleValue) {
//                minVolume = model.Volume_MA5.doubleValue;
//            }
//            if (maxVolume < model.Volume_MA5.doubleValue) {
//                maxVolume = model.Volume_MA5.doubleValue;
//            }
//        }
//        if(model.Volume_MA10)
//        {
//            if (minVolume > model.Volume_MA10.doubleValue) {
//                minVolume = model.Volume_MA10.doubleValue;
//            }
//            if (maxVolume < model.Volume_MA10.doubleValue) {
//                maxVolume = model.Volume_MA10.doubleValue;
//            }
//        }
    }];

    CGFloat unitValue = (maxVolume - minVolume) / (maxY - minY);
    
    NSMutableArray *volumePositionModels = @[].mutableCopy;
    [self.Volume_MA7Positions removeAllObjects];
    [self.Volume_MA30Positions removeAllObjects];
//    [self.Volume_MA5Positions removeAllObjects];
//    [self.Volume_MA10Positions removeAllObjects];
    
    [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
        CGFloat xPosition = kLinePositionModel.HighPoint.x;
        CGFloat yPosition = ABS(maxY - (model.Volume - minVolume)/unitValue);
        if(ABS(yPosition - Y_StockChartKLineVolumeViewMaxY) < 0.5)
        {
            yPosition = Y_StockChartKLineVolumeViewMaxY - 1;
        }
        CGPoint startPoint = CGPointMake(xPosition, yPosition);
        CGPoint endPoint = CGPointMake(xPosition, Y_StockChartKLineVolumeViewMaxY);
        Y_KLineVolumePositionModel *volumePositionModel = [Y_KLineVolumePositionModel modelWithStartPoint:startPoint endPoint:endPoint];
        [volumePositionModels addObject:volumePositionModel];
        
        //MA坐标转换
        CGFloat ma7Y = maxY;
        CGFloat ma30Y = maxY;
//        CGFloat ma5Y = maxY;
//        CGFloat ma10Y = maxY;
        if(unitValue > 0.0000001)
        {
            if(model.Volume_MA7)
            {
                ma7Y = maxY - (model.Volume_MA7.doubleValue - minVolume)/unitValue;
            }
//            if(model.Volume_MA5)
//            {
//                ma5Y = maxY - (model.Volume_MA5.doubleValue - minVolume)/unitValue;
//            }
//
        }
        if(unitValue > 0.0000001)
        {
            if(model.Volume_MA30)
            {
                ma30Y = maxY - (model.Volume_MA30.doubleValue - minVolume)/unitValue;
            }
//            if(model.Volume_MA30)
//            {
//                ma10Y = maxY - (model.Volume_MA30.doubleValue - minVolume)/unitValue;
//            }
        }
        
        NSAssert(!isnan(ma7Y) && !isnan(ma30Y), @"出现NAN值");
        
        CGPoint ma7Point = CGPointMake(xPosition, ma7Y);
        CGPoint ma30Point = CGPointMake(xPosition, ma30Y);
//        CGPoint ma5Point = CGPointMake(xPosition, ma5Y);
//        CGPoint ma10Point = CGPointMake(xPosition, ma10Y);
        
        if(model.Volume_MA7)
        {
            [self.Volume_MA7Positions addObject: [NSValue valueWithCGPoint: ma7Point]];
        }
        if(model.Volume_MA30)
        {
            [self.Volume_MA30Positions addObject: [NSValue valueWithCGPoint: ma30Point]];
        }
//        if(model.Volume_MA5)
//        {
//            [self.Volume_MA5Positions addObject: [NSValue valueWithCGPoint: ma5Point]];
//        }
//        if(model.Volume_MA10)
//        {
//            [self.Volume_MA10Positions addObject: [NSValue valueWithCGPoint: ma10Point]];
//        }
    }];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(kLineVolumeViewCurrentMaxVolume:minVolume:)])
    {
        [self.delegate kLineVolumeViewCurrentMaxVolume:maxVolume minVolume:minVolume];
    }
    return volumePositionModels;
}
@end
