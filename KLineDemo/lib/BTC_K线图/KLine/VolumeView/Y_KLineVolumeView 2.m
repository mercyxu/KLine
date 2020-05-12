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
#import "Y_KLineVolume.h"
#import "Y_KLineVolumePositionModel.h"
#import "Y_KLinePositionModel.h"
#import "Y_MALine.h"
@interface Y_KLineVolumeView()

/**
 *  需要绘制的成交量的位置模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineVolumePositionModels;

/**
 *  Volume_MA5位置数组
 */
@property (nonatomic, strong) NSMutableArray *Volume_MA5Positions;


/**
 *  Volume_MA10位置数组
 */
@property (nonatomic, strong) NSMutableArray *Volume_MA10Positions;

@end

@implementation Y_KLineVolumeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.Volume_MA5Positions = @[].mutableCopy;
        self.Volume_MA10Positions = @[].mutableCopy;
    }
    return self;
}

#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if(!self.needDrawKLineVolumePositionModels)
    {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    Y_KLineVolume *kLineVolume = [[Y_KLineVolume alloc]initWithContext:context];
    
    [self.needDrawKLineVolumePositionModels enumerateObjectsUsingBlock:^(Y_KLineVolumePositionModel * _Nonnull volumePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        kLineVolume.positionModel = volumePositionModel;
        kLineVolume.kLineModel = self.needDrawKLineModels[idx];
        kLineVolume.lineColor = self.kLineColors[idx];
        [kLineVolume draw];
    }];
    
   if(self.targetLineStatus != Y_StockChartTargetLineStatusCloseMA){
        Y_MALine *MALine = [[Y_MALine alloc]initWithContext:context];
        
        //画MA7线
        MALine.MAType = Y_MA5Type;
        MALine.MAPositions = self.Volume_MA5Positions;
        [MALine draw];
        
        //画MA30线
        MALine.MAType = Y_MA10Type;
        MALine.MAPositions = self.Volume_MA10Positions;
        [MALine draw];
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
    [self setNeedsDisplay];
}

#pragma mark - 私有方法
#pragma mark 根据KLineModel转换成Position数组
- (NSArray *)private_convertToKLinePositionModelWithKLineModels:(NSArray *)kLineModels
{
    double minY = Y_StockChartKLineVolumeViewMinY;
    double maxY = Y_StockChartKLineVolumeViewMaxY;
    
    Y_KLineModel *firstModel = kLineModels.firstObject;
    
    __block double minVolume = firstModel.Volume;
    __block double maxVolume = firstModel.Volume;
    
    [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(model.Volume < minVolume)
        {
            minVolume = model.Volume;
        }
        
        if(model.Volume > maxVolume)
        {
            maxVolume = model.Volume;
        }
        if(model.Volume_MA5)
        {
            if (minVolume > model.Volume_MA5.doubleValue) {
                minVolume = model.Volume_MA5.doubleValue;
            }
            if (maxVolume < model.Volume_MA5.doubleValue) {
                maxVolume = model.Volume_MA5.doubleValue;
            }
        }
        if(model.Volume_MA10)
        {
            if (minVolume > model.Volume_MA10.doubleValue) {
                minVolume = model.Volume_MA10.doubleValue;
            }
            if (maxVolume < model.Volume_MA10.doubleValue) {
                maxVolume = model.Volume_MA10.doubleValue;
            }
        }
    }];

    double unitValue = (maxVolume - minVolume) / (maxY - minY);
    
    NSMutableArray *volumePositionModels = @[].mutableCopy;
    [self.Volume_MA5Positions removeAllObjects];
    [self.Volume_MA10Positions removeAllObjects];
    
    [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
        double xPosition = kLinePositionModel.HighPoint.x;
        double yPosition = ABS(maxY - (model.Volume - minVolume)/unitValue);
        if(ABS(yPosition - Y_StockChartKLineVolumeViewMaxY) < 0.5)
        {
            yPosition = Y_StockChartKLineVolumeViewMaxY - 1;
        }
        CGPoint startPoint = CGPointMake(xPosition, yPosition);
        CGPoint endPoint = CGPointMake(xPosition, Y_StockChartKLineVolumeViewMaxY);
        Y_KLineVolumePositionModel *volumePositionModel = [Y_KLineVolumePositionModel modelWithStartPoint:startPoint endPoint:endPoint];
        [volumePositionModels addObject:volumePositionModel];
        
        //MA坐标转换
        double ma5Y = maxY;
        double ma10Y = maxY;
        if(unitValue > 0)
        {
            if(model.Volume_MA5)
            {
                ma5Y = maxY - (model.Volume_MA5.doubleValue - minVolume)/unitValue;
            }
            
        }
        if(unitValue > 0)
        {
            if(model.Volume_MA10)
            {
                ma10Y = maxY - (model.Volume_MA10.doubleValue - minVolume)/unitValue;
            }
        }
        
        NSAssert(!isnan(ma5Y) && !isnan(ma10Y), @"出现NAN值");
        
        CGPoint ma5Point = CGPointMake(xPosition, ma5Y);
        CGPoint ma10Point = CGPointMake(xPosition, ma10Y);
        
        if(model.Volume_MA5)
        {
            [self.Volume_MA5Positions addObject: [NSValue valueWithCGPoint: ma5Point]];
        }
        if(model.Volume_MA10)
        {
            [self.Volume_MA10Positions addObject: [NSValue valueWithCGPoint: ma10Point]];
        }
    }];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(kLineVolumeViewCurrentMaxVolume:minVolume:)])
    {
        [self.delegate kLineVolumeViewCurrentMaxVolume:maxVolume minVolume:minVolume];
    }
    return volumePositionModels;
}
@end
