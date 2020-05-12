//
//  Y_KLineAccessoryView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/3.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineAccessoryView.h"
#import "Y_KLineModel.h"

#import "UIColor+Y_StockChart.h"
#import "Y_KLineVolumePositionModel.h"
#import "Y_KLinePositionModel.h"

#import "CAShapeLayer+YKLineLayer.h"
#import "CAShapeLayer+YKCandleLayer.h"
#import "Y_StockChartGlobalVariable.h"
@interface Y_KLineAccessoryView()

/**
 *  需要绘制的Volume_MACD位置模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineAccessoryPositionModels;

/**
 最大值
 */
@property (nonatomic, assign) CGFloat accessoryMaxValue;
/**
 最小值
 */
@property (nonatomic, assign) CGFloat accessoryMinValue;

/**
 *  Volume_DIF位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_DIFPositions;

/**
 *  Volume_DEA位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_DEAPositions;

/**
 *  KDJ_K位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_KDJ_KPositions;

/**
 *  KDJ_D位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_KDJ_DPositions;

/**
 *  KDJ_J位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_KDJ_JPositions;

/**
 *  RSI_6位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_RSI_6Positions;

/**
 *  RSI_12位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_RSI_12Positions;

/**
 *  RSI_24位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_RSI_24Positions;

/**
 *  WR位置数组
 */
@property (nonatomic, strong) NSMutableArray *Accessory_WRPositions;

@property (nonatomic, strong) CAShapeLayer *difLayer;//画DIF线
@property (nonatomic, strong) CAShapeLayer *dealLineLayer;// //画DEA线

@property (nonatomic, strong) CAShapeLayer *kdjkLayer;//画DIF线
@property (nonatomic, strong) CAShapeLayer *kdjdLineLayer;// //画DEA线
@property (nonatomic, strong) CAShapeLayer *kdjjLayer;//画DIF线

@property (nonatomic, strong) CAShapeLayer *rsi6Layer;//画rsi6线
@property (nonatomic, strong) CAShapeLayer *rsi12LineLayer;// //画rsi线
@property (nonatomic, strong) CAShapeLayer *rsi24Layer;//画rsi线

@property (nonatomic, strong) CAShapeLayer *WRLayer;//画WR线

@property (nonatomic, strong) CAShapeLayer *macdLayer;//MACDLayer
@end

@implementation Y_KLineAccessoryView
#pragma mark - Lazy
- (CAShapeLayer *)macdLayer {
    if (!_macdLayer) {
        _macdLayer = [CAShapeLayer layer];
    }
    return _macdLayer;
}

- (CAShapeLayer *)difLayer {
    if (!_difLayer) {
        _difLayer = [CAShapeLayer layer];
    }
    return _difLayer;
}

- (CAShapeLayer *)dealLineLayer {
    if (!_dealLineLayer) {
        _dealLineLayer = [CAShapeLayer layer];
    }
    return _dealLineLayer;
}
- (CAShapeLayer *)kdjkLayer {
    if (!_kdjkLayer) {
        _kdjkLayer = [CAShapeLayer layer];
    }
    return _kdjkLayer;
}
- (CAShapeLayer *)kdjdLineLayer {
    if (!_kdjdLineLayer) {
        _kdjdLineLayer = [CAShapeLayer layer];
    }
    return _kdjdLineLayer;
}
- (CAShapeLayer *)kdjjLayer {
    if (!_kdjjLayer) {
        _kdjjLayer = [CAShapeLayer layer];
    }
    return _kdjjLayer;
}

- (CAShapeLayer *)rsi6Layer {
    if (!_rsi6Layer) {
        _rsi6Layer = [CAShapeLayer layer];
    }
    return _rsi6Layer;
}
- (CAShapeLayer *)rsi12LineLayer {
    if (!_rsi12LineLayer) {
        _rsi12LineLayer = [CAShapeLayer layer];
    }
    return _rsi12LineLayer;
}
- (CAShapeLayer *)rsi24Layer {
    if (!_rsi24Layer) {
        _rsi24Layer = [CAShapeLayer layer];
    }
    return _rsi24Layer;
}

- (CAShapeLayer *)WRLayer
{
    if (!_WRLayer) {
        _WRLayer = [CAShapeLayer layer];
    }
    return _WRLayer;
}

/**
 清理图层
 */
- (void)clearLayer {
    
    if (_macdLayer) {
        [self.macdLayer removeFromSuperlayer];
        self.macdLayer = nil;
    }
    
    if (_difLayer) {
        [self.difLayer removeFromSuperlayer];
        self.difLayer = nil;
    }
    if(_dealLineLayer) {
        [self.dealLineLayer removeFromSuperlayer];
        self.dealLineLayer = nil;  
    }
    if (_kdjkLayer) {
        [self.kdjkLayer removeFromSuperlayer];
        self.kdjkLayer = nil;
    }
    if (_kdjdLineLayer) {
        [self.kdjdLineLayer removeFromSuperlayer];
        self.kdjdLineLayer = nil;
    }
    if (_kdjjLayer) {
        [self.kdjjLayer removeFromSuperlayer];
        self.kdjjLayer = nil;
    }
    
    if (_rsi6Layer) {
        [self.rsi6Layer removeFromSuperlayer];
        self.rsi6Layer = nil;
    }
    if (_rsi12LineLayer) {
        [self.rsi12LineLayer removeFromSuperlayer];
        self.rsi12LineLayer = nil;
    }
    if (_rsi24Layer) {
        [self.rsi24Layer removeFromSuperlayer];
        self.rsi24Layer = nil;
    }
    if (_WRLayer) {
        [self.WRLayer removeFromSuperlayer];
        self.WRLayer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.Accessory_DIFPositions = @[].mutableCopy;
        self.Accessory_DEAPositions = @[].mutableCopy;
        self.Accessory_KDJ_KPositions = @[].mutableCopy;
        self.Accessory_KDJ_DPositions = @[].mutableCopy;
        self.Accessory_KDJ_JPositions = @[].mutableCopy;
        self.Accessory_RSI_6Positions = @[].mutableCopy;
        self.Accessory_RSI_12Positions = @[].mutableCopy;
        self.Accessory_RSI_24Positions = @[].mutableCopy;
        self.Accessory_WRPositions = @[].mutableCopy;
    }
    return self;
}

#pragma mark drawRect方法

- (void)drawRectAccessory
{
    [self clearLayer];
    if(!self.needDrawKLineAccessoryPositionModels)
    {
        return;
    }
    
    /**
     *  副图，需要区分是MACD线还是KDJ线，进而选择不同的数据源和绘制方法
     */
    if(self.targetLineStatus != Y_StockChartTargetLineStatusKDJ && self.targetLineStatus != Y_StockChartTargetLineStatusRSI && self.targetLineStatus != Y_StockChartTargetLineStatusWR){
        /**
         MACD
         */
        [self.needDrawKLineAccessoryPositionModels enumerateObjectsUsingBlock:^(Y_KLineVolumePositionModel * _Nonnull volumePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
           //判断涨跌颜色
            CGFloat MACD_EndH = volumePositionModel.EndPoint.y - volumePositionModel.StartPoint.y ;
            UIColor *macdColor = (MACD_EndH >= 0) ? [UIColor increaseColor] : [UIColor decreaseColor];
            CGRect macdFrame = CGRectMake(volumePositionModel.StartPoint.x - 3, volumePositionModel.StartPoint.y,  [Y_StockChartGlobalVariable kLineWidth], volumePositionModel.EndPoint.y - volumePositionModel.StartPoint.y );
            CAShapeLayer *layer = [CAShapeLayer fl_getRectangleLayerWithFrame:macdFrame backgroundColor:macdColor];
            [self.macdLayer addSublayer:layer];
            
        }];
        [self.layer addSublayer:self.macdLayer];
  
        //画MA7线
        CAShapeLayer *difshaLayer = [CAShapeLayer getSingleLineLayerWithPointArray:self.Accessory_DIFPositions lineColor:[UIColor ma7Color]];
        [self.difLayer addSublayer:difshaLayer];
        //画MA5线
//        CAShapeLayer *difshaLayer1 = [CAShapeLayer getSingleLineLayerWithPointArray:self.Accessory_DIFPositions lineColor:[UIColor ma7Color]];
//        [self.difLayer addSublayer:difshaLayer1];
        //画MA10线
//        CAShapeLayer *dealshaLineLayer1 = [CAShapeLayer getSingleLineLayerWithPointArray:self.Accessory_DEAPositions lineColor:[UIColor ma30Color]];
//        [self.dealLineLayer addSublayer:dealshaLineLayer1];
        //画MA30线
        CAShapeLayer *dealshaLineLayer = [CAShapeLayer getSingleLineLayerWithPointArray:self.Accessory_DEAPositions lineColor:[UIColor ma30Color]];
        [self.dealLineLayer addSublayer:dealshaLineLayer];
        
        [self.layer addSublayer:self.difLayer];
        [self.layer addSublayer:self.dealLineLayer];
        
    }else if (self.targetLineStatus == Y_StockChartTargetLineStatusRSI){
        /**
         RSI
         */
        //画RSI_6线
        CAShapeLayer *kLine = [CAShapeLayer getSingleLineLayerWithPointArray:self.Accessory_RSI_6Positions lineColor:[UIColor ma7Color]];
        [self.rsi6Layer addSublayer:kLine];
        [self.layer addSublayer:self.rsi6Layer];
        
        //画RSI_12线
        CAShapeLayer *dLine = [CAShapeLayer getSingleLineLayerWithPointArray:self.Accessory_RSI_12Positions lineColor:[UIColor ma30Color]];
        [self.rsi12LineLayer addSublayer:dLine];
        [self.layer addSublayer:self.rsi12LineLayer];
        
        //画RSI_24线
        CAShapeLayer *jLine = [CAShapeLayer getSingleLineLayerWithPointArray:self.Accessory_RSI_24Positions lineColor:[UIColor mainTextColor]];
        [self.rsi24Layer addSublayer:jLine];
        [self.layer addSublayer:self.rsi24Layer];
        
    } else if (self.targetLineStatus == Y_StockChartTargetLineStatusKDJ) {
        /**
        KDJ
         */
        //画KDJ_K线
        CAShapeLayer *kLine = [CAShapeLayer getSingleLineLayerWithPointArray:self.Accessory_KDJ_KPositions lineColor:[UIColor ma7Color]];
        [self.kdjkLayer addSublayer:kLine];
        [self.layer addSublayer:self.kdjkLayer];
        
        //画KDJ_D线
        CAShapeLayer *dLine = [CAShapeLayer getSingleLineLayerWithPointArray:self.Accessory_KDJ_DPositions lineColor:[UIColor ma30Color]];
        [self.kdjdLineLayer addSublayer:dLine];
        [self.layer addSublayer:self.kdjdLineLayer];

        //画KDJ_J线
        CAShapeLayer *jLine = [CAShapeLayer getSingleLineLayerWithPointArray:self.Accessory_KDJ_JPositions lineColor:[UIColor mainTextColor]];
        [self.kdjjLayer addSublayer:jLine];
        [self.layer addSublayer:self.kdjjLayer];
    }else{
        /**
         WR
         */
        //画WR线
        CAShapeLayer *kLine = [CAShapeLayer getSingleLineLayerWithPointArray:self.Accessory_WRPositions lineColor:[UIColor ma7Color]];
        [self.WRLayer addSublayer:kLine];
        [self.layer addSublayer:self.WRLayer];
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
    self.needDrawKLineAccessoryPositionModels = [self private_convertToKLinePositionModelWithKLineModels:self.needDrawKLineModels];
    [self drawRectAccessory];
}

#pragma mark - 私有方法
#pragma mark 根据KLineModel转换成Position数组
- (NSArray *)private_convertToKLinePositionModelWithKLineModels:(NSArray *)kLineModels
{
    CGFloat minY = Y_StockChartKLineAccessoryViewMinY;
    CGFloat maxY = Y_StockChartKLineAccessoryViewMaxY;
    
    __block CGFloat minValue = CGFLOAT_MAX;
    __block CGFloat maxValue = CGFLOAT_MIN;
    
    NSMutableArray *volumePositionModels = @[].mutableCopy;

    if(self.targetLineStatus != Y_StockChartTargetLineStatusKDJ && self.targetLineStatus != Y_StockChartTargetLineStatusRSI && self.targetLineStatus != Y_StockChartTargetLineStatusWR)
    {
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(model.DIF)
            {
                if(model.DIF.doubleValue < minValue) {
                    minValue = model.DIF.doubleValue;
                }
                if(model.DIF.doubleValue > maxValue) {
                    maxValue = model.DIF.doubleValue;
                }
            }
            
            if(model.DEA)
            {
                if (minValue > model.DEA.doubleValue) {
                    minValue = model.DEA.doubleValue;
                }
                if (maxValue < model.DEA.doubleValue) {
                    maxValue = model.DEA.doubleValue;
                }
            }
            if(model.MACD)
            {
                if (minValue > model.MACD.doubleValue) {
                    minValue = model.MACD.doubleValue;
                }
                if (maxValue < model.MACD.doubleValue) {
                    maxValue = model.MACD.doubleValue;
                }
            }
        }];
        
        CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
        
        [self.Accessory_DIFPositions removeAllObjects];
        [self.Accessory_DEAPositions removeAllObjects];
        
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
            CGFloat xPosition = kLinePositionModel.HighPoint.x;
            
            
            CGFloat yPosition = -(model.MACD.doubleValue - 0)/unitValue + Y_StockChartKLineAccessoryViewMiddleY;
            
//            CGFloat yPosition = ABS(minY + (model.MACD.doubleValue - minValue)/unitValue);
            
            CGPoint startPoint = CGPointMake(xPosition, yPosition);
            
            CGPoint endPoint = CGPointMake(xPosition,Y_StockChartKLineAccessoryViewMiddleY);
            Y_KLineVolumePositionModel *volumePositionModel = [Y_KLineVolumePositionModel modelWithStartPoint:startPoint endPoint:endPoint];
            [volumePositionModels addObject:volumePositionModel];
            
            //MA坐标转换
            CGFloat DIFY = maxY;
            CGFloat DEAY = maxY;
            if(unitValue > 0.0000001){
                if(model.DIF){
                    DIFY = -(model.DIF.doubleValue - 0)/unitValue + Y_StockChartKLineAccessoryViewMiddleY;
//                    DIFY = maxY - (model.DIF.doubleValue - minValue)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001){
                if(model.DEA){
                    DEAY = -(model.DEA.doubleValue - 0)/unitValue + Y_StockChartKLineAccessoryViewMiddleY;
//                    DEAY = maxY - (model.DEA.doubleValue - minValue)/unitValue;
                }
            }
            
            NSAssert(!isnan(DIFY) && !isnan(DEAY), @"出现NAN值");
            
            CGPoint DIFPoint = CGPointMake(xPosition, DIFY);
            CGPoint DEAPoint = CGPointMake(xPosition, DEAY);
            
            if(model.DIF){
                [self.Accessory_DIFPositions addObject: [NSValue valueWithCGPoint: DIFPoint]];
            }
            if(model.DEA){
                [self.Accessory_DEAPositions addObject: [NSValue valueWithCGPoint: DEAPoint]];
            }
        }];
    }else if (self.targetLineStatus == Y_StockChartTargetLineStatusRSI){
        
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(model.RSI_6)
            {
                if (minValue > model.RSI_6.floatValue) {
                    minValue = model.RSI_6.floatValue;
                }
                if (maxValue < model.RSI_6.floatValue) {
                    maxValue = model.RSI_6.floatValue;
                }
            }
            
            if(model.RSI_12)
            {
                if (minValue > model.RSI_12.floatValue) {
                    minValue = model.RSI_12.floatValue;
                }
                if (maxValue < model.RSI_12.floatValue) {
                    maxValue = model.RSI_12.floatValue;
                }
            }
            if(model.RSI_24)
            {
                if (minValue > model.RSI_24.floatValue) {
                    minValue = model.RSI_24.floatValue;
                }
                if (maxValue < model.RSI_24.floatValue) {
                    maxValue = model.RSI_24.floatValue;
                }
            }
        }];
        
        CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
        
        [self.Accessory_RSI_6Positions removeAllObjects];
        [self.Accessory_RSI_12Positions removeAllObjects];
        [self.Accessory_RSI_24Positions removeAllObjects];
        
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
            CGFloat xPosition = kLinePositionModel.HighPoint.x;
            
            //MA坐标转换
            CGFloat RSI_6_Y = maxY;
            CGFloat RSI_12_Y = maxY;
            CGFloat RSI_24_Y = maxY;
            
            if(unitValue > 0.0000001)
            {
                if(model.RSI_6)
                {
                    RSI_6_Y = maxY - (model.RSI_6.floatValue - minValue)/unitValue;
                }
            }
            if(unitValue > 0.0000001)
            {
                if(model.RSI_12)
                {
                    RSI_12_Y = maxY - (model.RSI_12.floatValue - minValue)/unitValue;
                }
            }
            if(unitValue > 0.0000001)
            {
                if(model.RSI_24)
                {
                    RSI_24_Y = maxY - (model.RSI_24.floatValue - minValue)/unitValue;
                }
            }
            
            NSAssert(!isnan(RSI_6_Y) && !isnan(RSI_12_Y) && !isnan(RSI_24_Y), @"出现NAN值");
            
            CGPoint RSI_6Point = CGPointMake(xPosition, RSI_6_Y);
            CGPoint RSI_12Point = CGPointMake(xPosition, RSI_12_Y);
            CGPoint RSI_24Point = CGPointMake(xPosition, RSI_24_Y);
            
            
            if(model.RSI_6)
            {
                [self.Accessory_RSI_6Positions addObject: [NSValue valueWithCGPoint:RSI_6Point]];
            }
            if(model.RSI_12)
            {
                [self.Accessory_RSI_12Positions addObject: [NSValue valueWithCGPoint:RSI_12Point]];
            }
            if(model.RSI_24)
            {
                [self.Accessory_RSI_24Positions addObject: [NSValue valueWithCGPoint:RSI_24Point]];
            }
        }];
        
    }else if(self.targetLineStatus == Y_StockChartTargetLineStatusKDJ) {
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(model.KDJ_K){
                if (minValue > model.KDJ_K.doubleValue) {
                    minValue = model.KDJ_K.doubleValue;
                }
                if (maxValue < model.KDJ_K.doubleValue) {
                    maxValue = model.KDJ_K.doubleValue;
                }
            }
            
            if(model.KDJ_D){
                if (minValue > model.KDJ_D.doubleValue) {
                    minValue = model.KDJ_D.doubleValue;
                }
                if (maxValue < model.KDJ_D.doubleValue) {
                    maxValue = model.KDJ_D.doubleValue;
                }
            }
            if(model.KDJ_J){
                if (minValue > model.KDJ_J.doubleValue) {
                    minValue = model.KDJ_J.doubleValue;
                }
                if (maxValue < model.KDJ_J.doubleValue) {
                    maxValue = model.KDJ_J.doubleValue;
                }
            }
        }];
        
        CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
        
        [self.Accessory_KDJ_KPositions removeAllObjects];
        [self.Accessory_KDJ_DPositions removeAllObjects];
        [self.Accessory_KDJ_JPositions removeAllObjects];
        
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
            CGFloat xPosition = kLinePositionModel.HighPoint.x;
            
            //MA坐标转换
            CGFloat KDJ_K_Y = maxY;
            CGFloat KDJ_D_Y = maxY;
            CGFloat KDJ_J_Y = maxY;
            if(unitValue > 0.0000001){
                if(model.KDJ_K){
                    KDJ_K_Y = maxY - (model.KDJ_K.doubleValue - minValue)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001){
                if(model.KDJ_D){
                    KDJ_D_Y = maxY - (model.KDJ_D.doubleValue - minValue)/unitValue;
                }
            }
            if(unitValue > 0.0000001){
                if(model.KDJ_J){
                    KDJ_J_Y = maxY - (model.KDJ_J.doubleValue - minValue)/unitValue;
                }
            }
            
            NSAssert(!isnan(KDJ_K_Y) && !isnan(KDJ_D_Y) && !isnan(KDJ_J_Y), @"出现NAN值");
            
            CGPoint KDJ_KPoint = CGPointMake(xPosition, KDJ_K_Y);
            CGPoint KDJ_DPoint = CGPointMake(xPosition, KDJ_D_Y);
            CGPoint KDJ_JPoint = CGPointMake(xPosition, KDJ_J_Y);

            
            if(model.KDJ_K){
                [self.Accessory_KDJ_KPositions addObject: [NSValue valueWithCGPoint: KDJ_KPoint]];
            }
            if(model.KDJ_D){
                [self.Accessory_KDJ_DPositions addObject: [NSValue valueWithCGPoint: KDJ_DPoint]];
            }
            if(model.KDJ_J){
                [self.Accessory_KDJ_JPositions addObject: [NSValue valueWithCGPoint: KDJ_JPoint]];
            }
        }];
    }else{
        
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if(model.WR)
            {
                if (minValue > model.WR.floatValue) {
                    minValue = model.WR.floatValue;
                }
                if (maxValue < model.WR.floatValue) {
                    maxValue = model.WR.floatValue;
                }
            }

        }];
        
        CGFloat unitValue = (maxValue - minValue) / (maxY - minY);
        
        [self.Accessory_WRPositions removeAllObjects];
        
        [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
            CGFloat xPosition = kLinePositionModel.HighPoint.x;
            
            //MA坐标转换
            CGFloat WR_Y = maxY;
            
            if(unitValue > 0.0000001)
            {
                if(model.WR)
                {
                    WR_Y = maxY - (model.WR.floatValue - minValue)/unitValue;
                }
            }

            NSAssert(!isnan(WR_Y), @"出现NAN值");
            
            CGPoint WRPoint = CGPointMake(xPosition, WR_Y);

            
            if(model.WR)
            {
                [self.Accessory_WRPositions addObject: [NSValue valueWithCGPoint:WRPoint]];
            }
        }];
        
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(kLineAccessoryViewCurrentMaxValue:minValue:)]){
        [self.delegate kLineAccessoryViewCurrentMaxValue:maxValue minValue:minValue];
    }
    return volumePositionModels;
}
@end
