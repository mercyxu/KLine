//
//  Y_KLineMainView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineMainView.h"
#import "UIColor+Y_StockChart.h"

#import "Y_KLine.h"
#import "Y_MALine.h"
#import "Y_KLinePositionModel.h"
#import "Y_StockChartGlobalVariable.h"
#import "Masonry.h"
@interface Y_KLineMainView()

/** 最高模型 */
@property (strong, nonatomic) Y_KLine *heightKLine;

/** 最低模型 */
@property (strong, nonatomic) Y_KLine *lowKLine;

/** 最后模型 */
@property (strong, nonatomic) Y_KLine *lastLine;

/**
 *  需要绘制的model数组
 */
@property (nonatomic, strong) NSMutableArray <Y_KLineModel *> *needDrawKLineModels;

/**
 *  Index开始X的值
 */
@property (nonatomic, assign) NSInteger startXPosition;

/**
 *  旧的contentoffset值
 */
@property (nonatomic, assign) double oldContentOffsetX;

/**
 *  旧的缩放值
 */
@property (nonatomic, assign) double oldScale;

/**
 *  MA5位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA5Positions;


/**
 *  MA10位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA10Positions;

/**
 *  MA30位置数组
 */
@property (nonatomic, strong) NSMutableArray *MA30Positions;

/**
 *  BOLL_MB位置数组
 */
@property (nonatomic, strong) NSMutableArray *BOLL_MBPositions;

/**
 *  BOLL_UP位置数组
 */
@property (nonatomic, strong) NSMutableArray *BOLL_UPPositions;

/**
 *  BOLL_DN位置数组
 */
@property (nonatomic, strong) NSMutableArray *BOLL_DNPositions;

@end

@implementation Y_KLineMainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.needDrawKLineModels = @[].mutableCopy;
        self.needDrawKLinePositionModels = @[].mutableCopy;
        self.MA5Positions = @[].mutableCopy;
        self.MA10Positions = @[].mutableCopy;
        self.MA30Positions = @[].mutableCopy;
        
        self.BOLL_UPPositions = @[].mutableCopy;
        self.BOLL_DNPositions = @[].mutableCopy;
        self.BOLL_MBPositions = @[].mutableCopy;
        
        _needDrawStartIndex = 0;
        self.oldContentOffsetX = 0;
        self.oldScale = 0;
    }
    return self;
}

#pragma mark - 绘图相关方法

#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //如果数组为空，则不进行绘制，直接设置本view为背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(!self.kLineModels)
    {
        CGContextClearRect(context, rect);
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, rect);
        return;
    }
    
    //设置View的背景颜色
    NSMutableArray *kLineColors = @[].mutableCopy;
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    Y_MALine *MALine = [[Y_MALine alloc]initWithContext:context];
    
    if(self.MainViewType == Y_StockChartcenterViewTypeKline)
    {
        Y_KLine *kLine = [[Y_KLine alloc]initWithContext:context];
        kLine.maxY = Y_StockChartKLineMainViewMaxY;
        
        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(Y_KLinePositionModel * _Nonnull kLinePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            kLine.kLinePositionModel = kLinePositionModel;
            kLine.kLineModel = self.needDrawKLineModels[idx];
            UIColor *kLineColor = [kLine draw];
            [kLineColors addObject:kLineColor];
        }];
    } else {
        __block NSMutableArray *positions = @[].mutableCopy;
        [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(Y_KLinePositionModel * _Nonnull positionModel, NSUInteger idx, BOOL * _Nonnull stop) {
            UIColor *strokeColor = positionModel.OpenPoint.y < positionModel.ClosePoint.y ? [UIColor increaseColor] : [UIColor decreaseColor];
            [kLineColors addObject:strokeColor];
            [positions addObject:[NSValue valueWithCGPoint:positionModel.ClosePoint]];
        }];
        MALine.MAPositions = positions;
        MALine.MAType = -1;
        [MALine draw];
    }
    
    if (self.targetLineStatus == Y_StockChartTargetLineStatusBOLL) {
        // 画BOLL MB线 标准线
        MALine.MAType = Y_BOLL_MB;
        MALine.BOLLPositions = self.BOLL_MBPositions;
        [MALine draw];
        
        // 画BOLL UP 上浮线
        MALine.MAType = Y_BOLL_UP;
        MALine.BOLLPositions = self.BOLL_UPPositions;
        [MALine draw];
        
        // 画BOLL DN下浮线
        MALine.MAType = Y_BOLL_DN;
        MALine.BOLLPositions = self.BOLL_DNPositions;
        [MALine draw];
        
    } else if ( self.targetLineStatus != Y_StockChartTargetLineStatusCloseMA){

        //画MA5线
        MALine.MAType = Y_MA5Type;
        MALine.MAPositions = self.MA5Positions;
        [MALine draw];
        
        //画MA10线
        MALine.MAType = Y_MA10Type;
        MALine.MAPositions = self.MA10Positions;
        [MALine draw];
        
        //画MA30线
        MALine.MAType = Y_MA30Type;
        MALine.MAPositions = self.MA30Positions;
        [MALine draw];
        
    }
    
    if(self.MainViewType == Y_StockChartcenterViewTypeKline || self.MainViewType ==  Y_StockChartcenterViewTypeTimeLine)
    {
        if (self.heightKLine && self.MainViewType == Y_StockChartcenterViewTypeKline) {

            NSString *hPrice = nil;
            double movie = 0;
            if (self.heightKLine.kLineModel.isRight) {
                hPrice = [NSString stringWithFormat:@"%@→", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [self.heightKLine.kLineModel.High doubleValue]] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]]];

                movie = [NSString widthWithText:hPrice font:kFontBold10];
            } else {
                hPrice = [NSString stringWithFormat:@"←%@", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [self.heightKLine.kLineModel.High doubleValue]] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]]];
            }

            CGPoint point = CGPointMake(self.heightKLine.kLinePositionModel.HighPoint.x - movie, self.heightKLine.kLinePositionModel.HighPoint.y - 6);
            [hPrice drawAtPoint:point withAttributes:@{NSFontAttributeName : kFontBold10,NSForegroundColorAttributeName : [UIColor mainTextColor]}];
        }

        if (self.lowKLine && self.MainViewType == Y_StockChartcenterViewTypeKline) {

            NSString *lPrice = nil;
            double movie = 0;
            if (self.lowKLine.kLineModel.isRight) {
                lPrice = [NSString stringWithFormat:@"%@→", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [self.lowKLine.kLineModel.Low doubleValue]] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]]];
                movie = [NSString widthWithText:lPrice font:kFontBold10];
            } else {

                lPrice = [NSString stringWithFormat:@"←%@", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [self.lowKLine.kLineModel.Low doubleValue]] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]]];
            }

            CGPoint point = CGPointMake(self.lowKLine.kLinePositionModel.LowPoint.x - movie, self.lowKLine.kLinePositionModel.LowPoint.y - 6);
            [lPrice drawAtPoint:point withAttributes:@{NSFontAttributeName : kFontBold10,NSForegroundColorAttributeName : [UIColor mainTextColor]}];
        }
        
        Y_KLineModel *lastModel = self.needDrawKLineModels.lastObject;
        Y_KLinePositionModel *lastLine = self.needDrawKLinePositionModels.lastObject;
        if (isnan(lastLine.ClosePoint.y) || isinf(lastLine.ClosePoint.y)) {
            lastLine.ClosePoint = CGPointMake(lastLine.ClosePoint.x, 0);
        }
        
        if ( self.needDrawKLineModels.lastObject == self.kLineModels.lastObject ) {
            NSString *closeString = [KDecimal decimalNumber:[NSString stringWithFormat:@" %.12f", [lastModel.Close doubleValue]] RoundingMode:NSRoundDown scale:[KDecimal scale:KDetail.symbolModel.minPricePrecision]];
            double stringWidt = [NSString widthWithText:closeString font:kFont10] + 7;
            self.lineView.hidden = NO;
            self.closeLabel.hidden = NO;
            self.closeLabel.backgroundColor = [UIColor backgroundColor];
            BOOL isNoAnimate = (self.closeLabel.top == 0);
            self.lineView.width = self.parentScrollView.width;
            self.closeLabel.text = closeString;
            self.closeLabel.width = stringWidt;
            self.closeLabel.left = self.parentScrollView.width - self.closeLabel.width;
            self.lineView.startX = lastLine.ClosePoint.x;
            self.lineView.endX = self.closeLabel.left;
            //间接调用drawRect方法
            [self.lineView setNeedsDisplay];
            
            if (isNoAnimate) {
                self.closeLabel.centerY = lastLine.ClosePoint.y;
                self.lineView.centerY = lastLine.ClosePoint.y;
            } else {
                [UIView animateWithDuration:0.075f animations:^{
                    self.closeLabel.centerY = lastLine.ClosePoint.y;
                    self.lineView.centerY = lastLine.ClosePoint.y;
                }];
            }
//            [self drawLineWithToX:self.width - stringWidt + 10];

        } else {
            self.lineView.hidden = YES;
            self.closeLabel.hidden = YES;
        }
    } else {
        self.lineView.hidden = YES;
        self.closeLabel.hidden = YES;
    }
    
    if(self.delegate && kLineColors.count > 0)
    {
        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLineColors:)])
        {
            [self.delegate kLineMainViewCurrentNeedDrawKLineColors:kLineColors];
        }
    }
}

#pragma mark 使用默认context进行绘图
- (void)drawLineWithToX:(double)x
{
    Y_KLinePositionModel *lastLine = self.needDrawKLinePositionModels.lastObject;

    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //设置虚线颜色
    CGContextSetStrokeColorWithColor(currentContext, (kBlue100).CGColor);
    
    //设置虚线宽度
    CGContextSetLineWidth(currentContext, 0.5);
    
    //设置虚线绘制起点
    CGContextMoveToPoint(currentContext, lastLine.ClosePoint.x, lastLine.ClosePoint.y);
    
    //设置虚线绘制终点
    CGContextAddLineToPoint(currentContext, x - 8, lastLine.ClosePoint.y);
    
    //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
    CGFloat arr[] = {10,3};
    
    //下面最后一个参数“2”代表排列的个数。
    CGContextSetLineDash(currentContext, 0, arr, 2);
    CGContextDrawPath(currentContext, kCGPathStroke);
}

#pragma mark - 公有方法

#pragma mark 重新设置相关数据，然后重绘
- (void)drawMainView{
    
    NSAssert(self.kLineModels, @"kLineModels不能为空");
    
    //提取需要的kLineModel
    [self private_extractNeedDrawModels];
    
    //转换model为坐标model
    [self private_convertToKLinePositionModelWithKLineModels];
    
    //间接调用drawRect方法
    [self setNeedsDisplay];
}

/**
 *  更新MainView的宽度
 */
- (void)updateMainViewWidth{
    
    double lineGap = [Y_StockChartGlobalVariable kLineGap];
    double lineWidth = [Y_StockChartGlobalVariable kLineWidth];
    
    NSInteger count = self.parentScrollView.frame.size.width / (lineWidth + lineGap);
    double addWidth = (lineWidth + lineGap) * (count/4);
    double yuWidth = self.parentScrollView.frame.size.width - count*(lineWidth + lineGap);
    
    //根据stockModels的个数和间隔和K线的宽度计算出self的宽度，并设置contentsize
    double kLineViewWidth = self.kLineModels.count * [Y_StockChartGlobalVariable kLineWidth] + (self.kLineModels.count + 1) * [Y_StockChartGlobalVariable kLineGap] + addWidth + yuWidth;
    if (kLineViewWidth < self.parentScrollView.width) {
        kLineViewWidth = self.parentScrollView.width;
    }
    if (self.pinchStartIndex)
    {
        double new_x = self.pinchStartIndex * ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]) + [Y_StockChartGlobalVariable kLineGap];
        [self.parentScrollView setContentOffset:CGPointMake(new_x, 0) animated:NO];
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kLineViewWidth));
        make.left.equalTo(self.parentScrollView).offset(self.parentScrollView.contentOffset.x);
    }];
    
    [self layoutIfNeeded];
    
    //更新scrollview的contentsize
    self.parentScrollView.contentSize = CGSizeMake(kLineViewWidth, self.parentScrollView.contentSize.height);
}

/**
 *  长按的时候根据原始的x位置获得精确的x的位置
 */
- (CGPoint)getExactXPositionWithOriginXPosition:(double)originXPosition{
    double xPositoinInMainView = originXPosition;
    NSInteger startIndex = (NSInteger)((xPositoinInMainView - self.startXPosition) / ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]));
    NSInteger arrCount = self.needDrawKLinePositionModels.count;
    
    if (startIndex >= arrCount) {
        Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels.lastObject;
        if(self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewLongPressKLinePositionModel:kLineModel:)])
        {
            [self.delegate kLineMainViewLongPressKLinePositionModel:self.needDrawKLinePositionModels.lastObject kLineModel:self.needDrawKLineModels.lastObject];
        }
        return kLinePositionModel.ClosePoint;
    }
    
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        Y_KLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[index];
        
        double minX = kLinePositionModel.HighPoint.x - ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]/2);
        double maxX = kLinePositionModel.HighPoint.x + ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]/2);
        
        if(xPositoinInMainView > minX && xPositoinInMainView < maxX)
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewLongPressKLinePositionModel:kLineModel:)])
            {
                [self.delegate kLineMainViewLongPressKLinePositionModel:self.needDrawKLinePositionModels[index] kLineModel:self.needDrawKLineModels[index]];
            }
            return kLinePositionModel.ClosePoint;
        }
        
    }
    return CGPointMake(0.0f, 0.0f);
}

#pragma mark 私有方法
//提取需要绘制的数组
- (NSArray *)private_extractNeedDrawModels{
    double lineGap = [Y_StockChartGlobalVariable kLineGap];
    double lineWidth = [Y_StockChartGlobalVariable kLineWidth];
    
    //数组个数
    double scrollViewWidth = self.parentScrollView.frame.size.width;
    NSInteger needDrawKLineCount = (scrollViewWidth - lineGap)/(lineGap+lineWidth);
    
    //起始位置
    NSInteger needDrawKLineStartIndex ;
    
    if(self.pinchStartIndex > 0) {
        needDrawKLineStartIndex = self.pinchStartIndex;
        _needDrawStartIndex = self.pinchStartIndex;
        self.pinchStartIndex = -1;
    } else {
        needDrawKLineStartIndex = [self getNeedDrawStartIndexWithScroll:YES];
    }
    
//    NSLog(@"这是模型开始的index-----------%lu",needDrawKLineStartIndex);
    [self.needDrawKLineModels removeAllObjects];
    
    //赋值数组
    if(needDrawKLineStartIndex < self.kLineModels.count)
    {
        if(needDrawKLineStartIndex + needDrawKLineCount < self.kLineModels.count)
        {
            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
        } else{
            [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.kLineModels.count - needDrawKLineStartIndex)]];
        }
    }
    //响应代理
    if(self.delegate && [self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLineModels:)])
    {
        [self.delegate kLineMainViewCurrentNeedDrawKLineModels:self.needDrawKLineModels];
    }
    return self.needDrawKLineModels;
}

#pragma mark 将model转化为Position模型
- (NSArray *)private_convertToKLinePositionModelWithKLineModels {
    if(!self.needDrawKLineModels)
    {
        return nil;
    }
    
    NSArray *kLineModels = self.needDrawKLineModels;
    
    //计算最小单位
    Y_KLineModel *firstModel = kLineModels.firstObject;
    __block double minAssert = firstModel.Low.doubleValue;
    __block double maxAssert = firstModel.High.doubleValue;

    self.heightKLine = nil;
    self.lowKLine = nil;
    __block double heightPrice = firstModel.Low.doubleValue;
    __block double lowPrice = firstModel.High.doubleValue;
    __block NSInteger heightIndex = 0;
    __block NSInteger lowIndex = 0;
    
    double lineGap = [Y_StockChartGlobalVariable kLineGap];
    double lineWidth = [Y_StockChartGlobalVariable kLineWidth];
    
    //数组个数
    NSInteger kLineCount = self.parentScrollView.frame.size.width/(lineGap+lineWidth);
    kLineCount = kLineCount / 2;
    
    [kLineModels enumerateObjectsUsingBlock:^(Y_KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        kLineModel.isHeight = NO;
        kLineModel.isLow = NO;
        kLineModel.isRight = (idx > kLineCount);
        
        if(kLineModel.High.doubleValue > maxAssert)
        {
            maxAssert = kLineModel.High.doubleValue;
        }
        if(kLineModel.Low.doubleValue < minAssert)
        {
            minAssert = kLineModel.Low.doubleValue;
        }
        
        if(kLineModel.High.doubleValue > heightPrice)
        {
            heightIndex = idx;
            heightPrice = kLineModel.High.doubleValue;
        }
        
        if(kLineModel.Low.doubleValue < lowPrice)
        {
            lowIndex = idx;
            lowPrice = kLineModel.Low.doubleValue;
        }
        
        if (_targetLineStatus == Y_StockChartTargetLineStatusBOLL) {
            
            if(kLineModel.BOLL_MB)
            {
                if (minAssert > kLineModel.BOLL_MB.doubleValue) {
                    minAssert = kLineModel.BOLL_MB.doubleValue;
                }
                if (maxAssert < kLineModel.BOLL_MB.doubleValue) {
                    maxAssert = kLineModel.BOLL_MB.doubleValue;
                }
            }
            if(kLineModel.BOLL_UP)
            {
                if (minAssert > kLineModel.BOLL_UP.doubleValue) {
                    minAssert = kLineModel.BOLL_UP.doubleValue;
                }
                if (maxAssert < kLineModel.BOLL_UP.doubleValue) {
                    maxAssert = kLineModel.BOLL_UP.doubleValue;
                }
            }
            
            if(kLineModel.BOLL_DN)
            {
                if (minAssert > kLineModel.BOLL_DN.doubleValue) {
                    minAssert = kLineModel.BOLL_DN.doubleValue;
                }
                if (maxAssert < kLineModel.BOLL_DN.doubleValue) {
                    maxAssert = kLineModel.BOLL_DN.doubleValue;
                }
            }
            
            
            
        } else {
            
            
            if(kLineModel.MA5)
            {
                if (minAssert > kLineModel.MA5.doubleValue) {
                    minAssert = kLineModel.MA5.doubleValue;
                }
                if (maxAssert < kLineModel.MA5.doubleValue) {
                    maxAssert = kLineModel.MA5.doubleValue;
                }
            }
            
            if(kLineModel.MA10)
            {
                if (minAssert > kLineModel.MA10.doubleValue) {
                    minAssert = kLineModel.MA10.doubleValue;
                }
                if (maxAssert < kLineModel.MA10.doubleValue) {
                    maxAssert = kLineModel.MA10.doubleValue;
                }
            }
            
            if(kLineModel.MA30)
            {
                if (minAssert > kLineModel.MA30.doubleValue) {
                    minAssert = kLineModel.MA30.doubleValue;
                }
                if (maxAssert < kLineModel.MA30.doubleValue) {
                    maxAssert = kLineModel.MA30.doubleValue;
                }
            }
            
            
        }
        
        
        
    }];
    
    Y_KLineModel *heightModel = kLineModels[heightIndex];
    heightModel.isHeight = YES;
    
    Y_KLineModel *lowModel = kLineModels[lowIndex];
    lowModel.isLow = YES;
    
    double minY = Y_StockChartKLineMainViewMinY;
    double maxY = self.parentScrollView.frame.size.height * [Y_StockChartGlobalVariable kLineMainViewRadio] - 15;
    double unitValue = (maxAssert - minAssert)/(maxY - minY);
    
    /** 顶部Y坐标 */
    self.minY = minY;

    /** 底部Y坐标 */
    self.maxY = maxY;

    /** 刻度 */
    self.unitValue = unitValue;

    /** 最高价格 */
    self.maxAssert = maxAssert;

    /** 最低价格 */
    self.minAssert = minAssert;

    [self.needDrawKLinePositionModels removeAllObjects];
    [self.MA5Positions removeAllObjects];
    [self.MA10Positions removeAllObjects];
    [self.MA30Positions removeAllObjects];
    
    [self.BOLL_MBPositions removeAllObjects];
    [self.BOLL_UPPositions removeAllObjects];
    [self.BOLL_DNPositions removeAllObjects];
    
    NSInteger kLineModelsCount = kLineModels.count;
    for (NSInteger idx = 0 ; idx < kLineModelsCount; ++idx)
    {
        //K线坐标转换
        Y_KLineModel *kLineModel = kLineModels[idx];
        
        double xPosition = self.startXPosition + idx * ([Y_StockChartGlobalVariable kLineWidth] + [Y_StockChartGlobalVariable kLineGap]) + [Y_StockChartGlobalVariable kLineWidth] * 0.5f;
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.Open.doubleValue - minAssert)/unitValue));
        double closePointY = ABS(maxY - (kLineModel.Close.doubleValue - minAssert)/unitValue);
        if(ABS(closePointY - openPoint.y) < Y_StockChartKLineMinWidth)
        {
            if(openPoint.y > closePointY)
            {
                openPoint.y = closePointY + Y_StockChartKLineMinWidth;
            } else if(openPoint.y < closePointY)
            {
                closePointY = openPoint.y + Y_StockChartKLineMinWidth;
            } else {
                if(idx > 0)
                {
                    Y_KLineModel *preKLineModel = kLineModels[idx-1];
                    if(kLineModel.Open.doubleValue > preKLineModel.Close.doubleValue)
                    {
                        openPoint.y = closePointY + Y_StockChartKLineMinWidth;
                    } else {
                        closePointY = openPoint.y + Y_StockChartKLineMinWidth;
                    }
                } else if(idx+1 < kLineModelsCount){
                    
                    //idx==0即第一个时
                    Y_KLineModel *subKLineModel = kLineModels[idx+1];
                    if(kLineModel.Close.doubleValue < subKLineModel.Open.doubleValue)
                    {
                        openPoint.y = closePointY + Y_StockChartKLineMinWidth;
                    } else {
                        closePointY = openPoint.y + Y_StockChartKLineMinWidth;
                    }
                }
            }
        }
        
        CGPoint closePoint = CGPointMake(xPosition, closePointY);
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.High.doubleValue - minAssert)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.Low.doubleValue - minAssert)/unitValue));
        if (isnan(closePoint.y)) {
            closePoint.y = 0;
        }
        Y_KLinePositionModel *kLinePositionModel = [Y_KLinePositionModel modelWithOpen:openPoint close:closePoint high:highPoint low:lowPoint];
        [self.needDrawKLinePositionModels addObject:kLinePositionModel];
        
        if (kLineModel.isHeight) {
            self.heightKLine = [Y_KLine new];
            self.heightKLine.kLineModel = kLineModel;
            self.heightKLine.kLinePositionModel = kLinePositionModel;
        }
        
        if (kLineModel.isLow) {
            self.lowKLine = [Y_KLine new];
            self.lowKLine.kLineModel = kLineModel;
            self.lowKLine.kLinePositionModel = kLinePositionModel;
        }
        
        //MA坐标转换
        double ma5Y = maxY;
        double ma10Y = maxY;
        double ma30Y = maxY;
        if(unitValue > 0)
        {
            if(kLineModel.MA5)
            {
                ma5Y = maxY - (kLineModel.MA5.doubleValue - minAssert)/unitValue;
            }
            
        }
        
        if (unitValue > 0) {
            if (kLineModel.MA10) {
                ma10Y = maxY - (kLineModel.MA10.doubleValue - minAssert)/unitValue;
            }
        }
        
        if(unitValue > 0)
        {
            if(kLineModel.MA30)
            {
                ma30Y = maxY - (kLineModel.MA30.doubleValue - minAssert)/unitValue;
            }
        }
        
        NSAssert(!isnan(ma5Y) && !isnan(ma10Y) && !isnan(ma30Y), @"出现NAN值");
        
        CGPoint ma5Point = CGPointMake(xPosition, ma5Y);
        CGPoint ma10Point = CGPointMake(xPosition, ma10Y);
        CGPoint ma30Point = CGPointMake(xPosition, ma30Y);
        if(kLineModel.MA5)
        {
            [self.MA5Positions addObject: [NSValue valueWithCGPoint: ma5Point]];
        }
        if(kLineModel.MA10)
        {
            [self.MA10Positions addObject: [NSValue valueWithCGPoint: ma10Point]];
        }
        if(kLineModel.MA30)
        {
            [self.MA30Positions addObject: [NSValue valueWithCGPoint: ma30Point]];
        }
        
        
        if(_targetLineStatus == Y_StockChartTargetLineStatusBOLL){
            
            
            //BOLL坐标转换
            double boll_mbY = maxY;
            double boll_upY = maxY;
            double boll_dnY = maxY;
            
            NSLog(@"position：\n上: %@ \n中: %@ \n下: %@",kLineModel.BOLL_UP,kLineModel.BOLL_MB,kLineModel.BOLL_DN);
            
            
            if(unitValue > 0.0000001)
            {
                
                if(kLineModel.BOLL_MB)
                {
                    boll_mbY = maxY - (kLineModel.BOLL_MB.doubleValue - minAssert)/unitValue;
                }
                
            }
            if(unitValue > 0.0000001)
            {
                if(kLineModel.BOLL_DN)
                {
                    boll_dnY = maxY - (kLineModel.BOLL_DN.doubleValue - minAssert)/unitValue ;
                }
            }
            
            if(unitValue > 0.0000001)
            {
                if(kLineModel.BOLL_UP)
                {
                    boll_upY = maxY - (kLineModel.BOLL_UP.doubleValue - minAssert)/unitValue;
                }
            }
            
            NSAssert(!isnan(boll_mbY) && !isnan(boll_upY) && !isnan(boll_dnY), @"出现BOLL值");
            
            CGPoint boll_mbPoint = CGPointMake(xPosition, boll_mbY);
            CGPoint boll_upPoint = CGPointMake(xPosition, boll_upY);
            CGPoint boll_dnPoint = CGPointMake(xPosition, boll_dnY);
            
            
            if (kLineModel.BOLL_MB) {
                [self.BOLL_MBPositions addObject:[NSValue valueWithCGPoint:boll_mbPoint]];
            }
            
            if (kLineModel.BOLL_UP) {
                [self.BOLL_UPPositions addObject:[NSValue valueWithCGPoint:boll_upPoint]];
            }
            if (kLineModel.BOLL_DN) {
                [self.BOLL_DNPositions addObject:[NSValue valueWithCGPoint:boll_dnPoint]];
            }
            
        }
        
    }
    
    //响应代理方法
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentMaxPrice:minPrice:)])
        {
            [self.delegate kLineMainViewCurrentMaxPrice:maxAssert minPrice:minAssert];
        }
        if([self.delegate respondsToSelector:@selector(kLineMainViewCurrentNeedDrawKLinePositionModels:)])
        {
            [self.delegate kLineMainViewCurrentNeedDrawKLinePositionModels:self.needDrawKLinePositionModels];
        }
    }
    return self.needDrawKLinePositionModels;
}

static char *observerContext = NULL;
#pragma mark 添加所有事件监听的方法
- (void)private_addAllEventListener{
    //KVO监听scrollview的状态变化
    [_parentScrollView addObserver:self forKeyPath:Y_StockChartContentOffsetKey options:NSKeyValueObservingOptionNew context:observerContext];
}
#pragma mark - setter,getter方法
- (NSInteger)startXPosition{
    return 0;
}

- (NSInteger)needDrawStartIndex{
    double scrollViewOffsetX = self.parentScrollView.contentOffset.x < 0 ? 0 : self.parentScrollView.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffsetX - [Y_StockChartGlobalVariable kLineGap]) / ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]);
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}

- (NSInteger)getNeedDrawStartIndexWithScroll:(BOOL)scorll
{
    if (scorll)
    {
        double scrollViewOffsetX = self.parentScrollView.contentOffset.x < 0 ? 0 : self.parentScrollView.contentOffset.x;
        NSUInteger leftArrCount = ABS(scrollViewOffsetX - [Y_StockChartGlobalVariable kLineGap]) / ([Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth]);
        
        _needDrawStartIndex = leftArrCount;
    }
    
    return _needDrawStartIndex;
}

- (void)setKLineModels:(NSArray *)kLineModels{
    _kLineModels = kLineModels;
    [self updateMainViewWidth];
}

#pragma mark - 系统方法
#pragma mark 已经添加到父view的方法,设置父scrollview
- (void)didMoveToSuperview{
    _parentScrollView = (UIScrollView *)self.superview;
    [self private_addAllEventListener];
    [super didMoveToSuperview];
}

#pragma mark KVO监听实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if([keyPath isEqualToString:Y_StockChartContentOffsetKey])
    {
        double difValue = ABS(self.parentScrollView.contentOffset.x - self.oldContentOffsetX);
        if(difValue >= [Y_StockChartGlobalVariable kLineGap] + [Y_StockChartGlobalVariable kLineWidth])
        {
            self.oldContentOffsetX = self.parentScrollView.contentOffset.x;
            [self drawMainView];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.parentScrollView).offset(self.parentScrollView.contentOffset.x);
                make.width.equalTo(self.parentScrollView);
            }];
        }
    }
}

#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 移除所有监听
- (void)removeAllObserver{
    [_parentScrollView removeObserver:self forKeyPath:Y_StockChartContentOffsetKey context:observerContext];
}

@end
