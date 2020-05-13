//
//  XXKineView.m
//  iOS
//
//  Created by iOS on 2018/6/13.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXKineView.h"
#import "Y_SmallKLineView.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "Masonry.h"
#import "Y_StockChartGlobalVariable.h"
#import "Y_KLineModel.h"
#import <SDWebImageManager.h>

#define KTimeHeight 15

@interface XXKineView ()<Y_StockChartViewDataSource, Y_SmallKLineViewDelegate> {
    dispatch_queue_t _serialQueue; // 串行队列
}

/** <#备注#> */
@property (assign, nonatomic) BOOL isFirstReq;

/** 是否显示副图 */
@property (assign, nonatomic) BOOL isShowAccessory;

/** 总数组 */
@property (strong, nonatomic) NSMutableArray *sumArray;

@property (strong, nonatomic) XXWebQuoteModel *webModel;

@property (nonatomic, strong) Y_SmallKLineView *stockChartView;

@property (nonatomic, strong) Y_KLineGroupModel *groupModel;

/** x线数组 */
@property (strong, nonatomic) NSMutableArray *xLayersArray;

/** y线数组 */
@property (strong, nonatomic) NSMutableArray *yLayersArray;

/** 时间视图 */
@property (strong, nonatomic) UIView *timeView;

@property (strong, nonatomic) UIImageView *logoImageView;

/** 时间标签数组 */
@property (strong, nonatomic) NSMutableArray *timesLabelsArray;

@property (nonatomic, copy) NSString *type;

/** 索引 */
@property (assign, nonatomic) NSInteger currentIndex;

@property (assign, nonatomic) CFAbsoluteTime lastRefreshTime;

/** 渐变阴影 */
@property (strong, nonatomic, nullable) CAGradientLayer * gradientLayer;
@end

@implementation XXKineView

- (void)layoutSubviews{
    [super layoutSubviews];

    self.gradientLayer.frame = self.bounds;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _isFirstReq = YES;
        [Y_StockChartGlobalVariable setMainViewLineStatus:[KDetail.klineMainIndex integerValue]];
        
        _serialQueue = dispatch_queue_create("com.depth.symbol", DISPATCH_QUEUE_SERIAL);
        
        self.backgroundColor = [UIColor backgroundColor];
        
        {
            self.gradientLayer = [CAGradientLayer layer];
            self.gradientLayer.frame = self.bounds;
            self.gradientLayer.colors = @[(__bridge id)[UIColor assistBackgroundColor].CGColor,(__bridge id)[UIColor backgroundColor].CGColor];
            self.gradientLayer.startPoint = CGPointMake(0, 0);
            self.gradientLayer.endPoint = CGPointMake(0, 1);
            self.gradientLayer.locations = @[@0,@1];
            [self.layer addSublayer:self.gradientLayer];
        }
        
        [self setupGrid];
        [self addSubview:self.logoImageView];
        [self reloadWatermarkLogoPosition];
        [self loadWatermarkImage];

        self.layer.masksToBounds = YES;
        self.stockChartView.backgroundColor = [UIColor clearColor];
        self.timeView.backgroundColor = [UIColor backgroundColor];
    }
    return self;
}

#pragma mark - 1. 初始化网格
- (void)setupGrid {
    
    CGFloat rowHeight = (self.height - KTimeHeight) / 5;
    CGFloat rowWidth = self.width/4;
    for (NSInteger i=1; i < 6; i ++) {
        CAShapeLayer *xLayer = self.xLayersArray[i - 1];
        UIBezierPath *xPath = [UIBezierPath bezierPath];
        [xPath moveToPoint:CGPointMake(0, i*rowHeight)];
        [xPath addLineToPoint:CGPointMake(self.width, i*rowHeight)];
        xLayer.path = [xPath CGPath];
        
        if (i <= self.yLayersArray.count) {
            CAShapeLayer *yLayer = self.yLayersArray[i - 1];
            UIBezierPath *yPath = [UIBezierPath bezierPath];
            [yPath moveToPoint:CGPointMake(i*rowWidth, 0)];
            [yPath addLineToPoint:CGPointMake(i*rowWidth, self.height - 1 - KTimeHeight)];
            yLayer.path = [yPath CGPath];
        }
    }
}

#pragma mark - 1.2 加载水印图片
- (void)loadWatermarkImage {
    self.logoImageView.image = [UIImage imageNamed:@"kline_logo"];

}

#pragma mark - 2. K线图 items事件回调
- (void)kButtonClickIndex:(NSInteger)index {
    
    if (index >= 103) {
        KDetail.klineMainIndex = [NSString stringWithFormat:@"%zd", index];
    } else if (index >= 100) {
        KDetail.klineAccessoryIndex = [NSString stringWithFormat:@"%zd", index];
    }
    
    if (index == 100 || index == 101) {
        self.isShowAccessory = YES;
        [self reloadWatermarkLogoPosition];
    } else if (index == 102) {
        self.isShowAccessory = NO;
        [self reloadWatermarkLogoPosition];
    }
    
    if (index >= 100) {
        if (self.groupModel) {
            [self.stockChartView clickSegmentButtonIndex:index];
        }
    } else {
        self.currentIndex = index;
        NSString *type;
        switch (index) {
            case 1:
            {
                type = @"1m";
            }
                break;
            case 2:
            {
                type = @"1m";
            }
                break;
            case 3:
            {
                type = @"5m";
            }
                break;
            case 4:
            {
                type = @"15m";
            }
                break;
            case 5:
            {
                type = @"30m";
            }
                break;
            case 6:
            {
                type = @"1h";
            }
                break;
            case 7:
            {
                type = @"2h";
            }
                break;
            case 8:
            {
                type = @"4h";
            }
                break;
            case 9:
            {
                type = @"6h";
            }
                break;
            case 10:
            {
                type = @"12h";
            }
                break;
            case 11:
            {
                type = @"1d";
            }
                break;
            case 12:
            {
                type = @"1w";
                
            }
                break;
            case 13:
            {
                type = @"1M";
            }
                break;
            default:
                break;
        }
        self.type = type;
        
        // 订阅
        [self webSocketDataOfKline];
    }
}

#pragma mark - 3. <Y_StockChartViewDataSource>
-(id)stockDatasWithIndex:(NSInteger)index {
    return self.groupModel.models;
}

#pragma mark - 4. 订阅k线
- (void)webSocketDataOfKline {
    
    _isFirstReq = YES;
    
    KWeakSelf
    if (self.webModel) {
        [KQuoteSocket cancelWebSocketSubscribeWithWebSocketModel:self.webModel];
    }
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    self.webModel = nil;
    self.webModel = [[XXWebQuoteModel alloc] init];
    self.webModel.isRed = YES;
    self.webModel.successBlock = ^(id data) {
        [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
        [weakSelf receiveKlineData:data];
    };
    
    self.webModel.failureBlock = ^{
       [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
    };
    
    self.webModel.params = [NSMutableDictionary dictionary];
    self.webModel.params[@"topic"] = [NSString stringWithFormat:@"kline_%@", self.type];
    self.webModel.params[@"event"] = @"sub";
    self.webModel.params[@"params"] = @{@"limit":@"500",@"binary":@(YES)};
    self.webModel.params[@"symbol"] = [NSString stringWithFormat:@"%@.%@", KDetail.symbolModel.exchangeId, KDetail.symbolModel.symbolId];

    self.webModel.httpUrl = @"quote/v1/klines";
    self.webModel.httpParams = [NSMutableDictionary dictionary];
    self.webModel.httpParams[@"symbol"] = [NSString stringWithFormat:@"%@.%@", KDetail.symbolModel.exchangeId, KDetail.symbolModel.symbolId];
    self.webModel.httpParams[@"interval"] = self.type;
    self.webModel.httpParams[@"limit"] = @"500";
    
    [KQuoteSocket sendWebSocketSubscribeWithWebSocketModel:self.webModel];
}

#pragma mark - 6.0 数据进行处理
- (void)receiveKlineData:(NSMutableArray *)data {
    
    if (self.webModel.isRed) {
        self.webModel.isRed = NO;
        dispatch_async(_serialQueue, ^{
            @synchronized(self) {
                [self receiveAllKlineData:data];
            }
        });
    } else {
        dispatch_async(_serialQueue, ^{
            @synchronized(self) {
                [self receiveAddKlineData:data];
            }
        });
    }
}

#pragma mark - 6.1 收到全量k线数据
- (void)receiveAllKlineData:(NSMutableArray *)data{
    
    if (data.count == 0) {
        return;
    }
    
    self.sumArray = [NSMutableArray arrayWithArray:data];
    Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:self.sumArray kLineType:self.type];
    self.groupModel = groupModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.stockChartView clickSegmentButtonIndex:self.currentIndex];
        if (([KDetail.klineAccessoryIndex integerValue] == 100 || [KDetail.klineAccessoryIndex integerValue] == 101) && self.isShowAccessory == NO) {
            [self kButtonClickIndex:[KDetail.klineAccessoryIndex integerValue]];
        }
    });
}

#pragma mark - 6.2 收到新增k线数据
- (void)receiveAddKlineData:(NSMutableArray *)data{
    
    if (data.count == 0) {
        return;
    }
    
    // 1. 判断时间是否相等boo
    BOOL isAddkLine = NO;
    for (NSInteger i=0; i < data.count; i ++) {
        NSDictionary *dict = data[i];
        if (self.sumArray.count > 0) {
            NSDictionary *lastData = [self.sumArray lastObject];
            if ([dict[@"t"] longLongValue] > [lastData[@"t"] longLongValue]) {
                isAddkLine = YES;
                [self.sumArray addObject:dict];
            } else if ([dict[@"t"] longLongValue] == [lastData[@"t"] longLongValue]) {
                isAddkLine = NO;
                self.sumArray[self.sumArray.count - 1] = dict;
            }
        } else {
            isAddkLine = YES;
            [self.sumArray addObject:dict];
        }
    }
    
    
    // 2. 转换数据重新绘制
    Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:self.sumArray kLineType:self.type];
    self.groupModel = groupModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isAddkLine) {
            [self.stockChartView addkLineData:groupModel.models];
        } else {
            [self.stockChartView updateLineData:groupModel.models];
        }
    });
}

- (void)reloadUI {
    
    [self reloadWatermarkLogoPosition];
    [self setupGrid];
    if (self.groupModel.models.count > 0) {
        [self.stockChartView addkLineData:self.groupModel.models];
    } else {
       [self.stockChartView clickSegmentButtonIndex:self.currentIndex];
    }
}

- (void)reloadLineLocation {
    [self.stockChartView reloadLineLocation];
}

#pragma mark - 7. <Y_SmallKLineViewDelegate>
- (void)currentNeedDrawKLineModels:(NSArray *)needDrawKLineModels {
    
    NSMutableArray *modelsArray = [NSMutableArray arrayWithArray:needDrawKLineModels];
    NSInteger sumCount = self.width / ([Y_StockChartGlobalVariable kLineWidth] + [Y_StockChartGlobalVariable kLineGap]);
    NSInteger yu = (sumCount - 5)%4;
    NSInteger jianGe = (sumCount - 5)/4;
    NSInteger index = 0;
    CGFloat labelWidth = (self.width)/4;
    for (NSInteger i = 0; i < self.timesLabelsArray.count; i ++) {
        
        XXLabel *label = self.timesLabelsArray[i];
        
        if (needDrawKLineModels.count > index) {
            Y_KLineModel *ymodel = modelsArray[index];
            
            label.text = [self getDateStringTimeTamp:[ymodel.Date longLongValue]];
            if (i==0) {
                label.left = 4;
                label.width = labelWidth/2 - 4;
                if ([label.text componentsSeparatedByString:@" "].count == 2) {
                    label.text = [[label.text componentsSeparatedByString:@" "] lastObject];
                }
            } else if (i==4) {
                label.width = labelWidth/2 - 4;
                label.left = self.width - labelWidth/2;
                if ([label.text componentsSeparatedByString:@" "].count == 2) {
                    label.text = [[label.text componentsSeparatedByString:@" "] firstObject];
                }
            } else {
                label.width = labelWidth;
                label.left = labelWidth*i - labelWidth/2;
            }
    
        } else {
            label.text = @"";
        }
        
        index = index + jianGe + 1;
        if (yu > i) {
            index = index + 1;
        }
    }
    
}

- (NSString *)getDateStringTimeTamp:(long)timeTamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeTamp/1000];
    NSDateFormatter *formatter = [NSDateFormatter new];
    
    formatter.dateFormat = @"MM-dd HH:mm";
    if ([self.type isEqualToString:@"1m"]) {
        formatter.dateFormat = @"HH:mm";
    } else if ([self.type isEqualToString:@"1d"] || [self.type isEqualToString:@"1w"]) {
        formatter.dateFormat = @"MM-dd";
    } else if ([self.type isEqualToString:@"1M"]) {
        formatter.dateFormat = @"yyyy-MM";
    }
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

#pragma mark - 8. 出现
- (void)show {
    
    // K线图
    [self kButtonClickIndex:[KDetail.klineIndex integerValue]];
}

#pragma mark - 9. 消失
- (void)dismiss {
    
    // 取消订阅
    [KQuoteSocket cancelWebSocketSubscribeWithWebSocketModel:self.webModel];
}

#pragma mark - 10. 清理数据
- (void)cleanData {
    NSArray *array = @[@{@"c":@"0", @"h":@"0", @"l":@"0", @"o":@"0", @"t":@"0", @"v":@"0", }];
    Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:[NSMutableArray arrayWithArray:array] kLineType:self.type];
    self.groupModel = groupModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.stockChartView clickSegmentButtonIndex:self.currentIndex];
    });
}

#pragma mark - 11. 刷新水印位置
- (void)reloadWatermarkLogoPosition {
    CGFloat rowHeight = (self.height - KTimeHeight) / 5;
    if (self.isShowAccessory) {
        self.logoImageView.bottom = rowHeight * 3 - 10;
    } else {
        self.logoImageView.bottom = rowHeight * 4 - 10;
    }
}

#pragma mark - || 懒加载
- (Y_SmallKLineView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [Y_SmallKLineView new];
        _stockChartView.dataSource = self;
        _stockChartView.delegate = self;
        [self addSubview:_stockChartView];
        [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@(2.5));
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-KTimeHeight);
        }];
    }
    return _stockChartView;
}

/** x线数组 */
- (NSMutableArray *)xLayersArray {
    if (_xLayersArray == nil) {
        _xLayersArray = [NSMutableArray array];
        for (NSInteger i=0; i < 5; i ++) {
            CAShapeLayer *xLayer = [CAShapeLayer new];
            xLayer.lineWidth = 1;
            xLayer.strokeColor = [UIColor lineColor].CGColor;
            xLayer.fillColor = [UIColor clearColor].CGColor;
            [self.layer addSublayer:xLayer];
            [_xLayersArray addObject:xLayer];
        }
    }
    return _xLayersArray;
}

/** y线数组 */
- (NSMutableArray *)yLayersArray {
    if (_yLayersArray == nil) {
        _yLayersArray = [NSMutableArray array];
        for (NSInteger i=0; i < 3; i ++) {
           
            CAShapeLayer *yLayer = [CAShapeLayer new];
            yLayer.lineWidth = 1;
            yLayer.strokeColor = [UIColor lineColor].CGColor;
            yLayer.fillColor = [UIColor clearColor].CGColor;
            [self.layer addSublayer:yLayer];
            [_yLayersArray addObject:yLayer];
        }
    }
    return _yLayersArray;
}

/** 时间视图 */
- (UIView *)timeView {
    if (_timeView == nil) {
        _timeView = [UIView new];
        _timeView.backgroundColor = [UIColor clearColor];

        [self addSubview:_timeView];
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.stockChartView.mas_bottom).offset(0.5);
        }];
    }
    return _timeView;
}

/** 时间标签数组 */
- (NSMutableArray *)timesLabelsArray {
    if (_timesLabelsArray == nil) {
        _timesLabelsArray = [NSMutableArray array];
        for (NSInteger i=0; i < 5; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.width - 8)/5, KTimeHeight)];
            label.textColor = [UIColor assistTextColor];
            label.font = kFont10;
            if (i==0) {
                label.textAlignment = NSTextAlignmentLeft;
            } else if (i == 4) {
                label.textAlignment = NSTextAlignmentRight;
            } else {
                label.textAlignment = NSTextAlignmentCenter;
            }
            [self.timeView addSubview:label];
            [_timesLabelsArray addObject:label];
        }
    }
    return _timesLabelsArray;
}

- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 18, 80, 24)];
    }
    return _logoImageView;
}

- (void)dealloc {
    NSLog(@"K线图释放了！");
}

@end
