//
//  XXDepthMapData.m
//  iOS
//
//  Created by iOS on 2018/6/13.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXDepthMapData.h"
#import "XXDepthTool.h"

@interface XXDepthMapData () {
    dispatch_queue_t serialQueue;
}

/** 元数据数组 */
@property (strong, nonatomic, nullable) NSMutableArray *dataArray;

@property (strong, nonatomic) XXWebQuoteModel *webModel;

/** 原始数据 */
@property (strong, nonatomic) NSMutableDictionary *leftDictionary;

/** 原始右边数据 */
@property (strong, nonatomic) NSMutableDictionary *rightDictionary;

@end

@implementation XXDepthMapData

- (instancetype)init
{
    self = [super init];
    if (self) {
        serialQueue = dispatch_queue_create("com.detailDepth.symbol", DISPATCH_QUEUE_SERIAL);
        
        self.dataArray = [NSMutableArray array];
        self.leftDictionary = [NSMutableDictionary dictionary];
        self.rightDictionary = [NSMutableDictionary dictionary];
        
        [self initWebModel];

    }
    return self;
}

#pragma mark - 1. 初始化WebModel
- (void)initWebModel {
    
    KWeakSelf
    self.webModel = [[XXWebQuoteModel alloc] init];
    
    self.webModel.successBlock = ^(NSArray *data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            [weakSelf reciveDepthData:(NSDictionary *)data];
        } else {
            [weakSelf reciveDepthData:[data firstObject]];
        }
    };
    
    self.webModel.failureBlock = ^{
        
    };
}

#pragma mark - 2.1 收到深度数据
- (void)reciveDepthData:(NSDictionary *)data {
    
    if (self.webModel.isRed) {
        [self.dataArray removeAllObjects];
        [self.leftDictionary removeAllObjects];
        [self.rightDictionary removeAllObjects];
    }
    [self.dataArray addObject:data];
    dispatch_async(serialQueue, ^{
        @synchronized(self) {
            [self setVauesWithBids:data[@"b"] asks:data[@"a"]];
        }
    });
}

#pragma mark - 3. 处理数据
- (void)setVauesWithBids:(NSArray *)binds asks:(NSArray *)asks {
    
    NSDictionary *dataDict = [XXDepthTool klineDepthLeftDict:self.leftDictionary rightDict:self.rightDictionary Binds:binds asks:asks priceDigit:KDetail.priceDigit amountDigit:KDetail.numberDigit viewWidth:kScreen_Width viewHeight:self.height];
    
    BOOL success = [dataDict[@"success"] boolValue];
    if (success) {
        self.maxOrderNumber = [dataDict[@"maxOrderNumber"] doubleValue];
        self.leftMidPrice = [dataDict[@"leftMidPrice"] doubleValue];
        self.rightMaxPrice = [dataDict[@"rightMaxPrice"] doubleValue];
        self.leftModelsArray = dataDict[@"leftModelsArray"];
        self.rightModelsArray = dataDict[@"rightModelsArray"];
        self.leftFillPath = dataDict[@"leftFillPath"];
        self.leftLinePath = dataDict[@"leftLinePath"];
        self.rightLinePath = dataDict[@"rightLinePath"];
        self.rightFillPath = dataDict[@"rightFillPath"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (KDetail.blockList) {
                KDetail.blockList(dataDict[@"orderModels"], [dataDict[@"ordersAverage"] doubleValue]);
            }
            if (self.reloadDataFinish) {
                self.reloadDataFinish();
            }
        });
    } else {
       dispatch_async(dispatch_get_main_queue(), ^{
           [self dismiss];
           [self show];
        });
    }
}

#pragma mark - 5. 查找相应的数据模型
- (XXDepthMapModel *)getDepthModelWithLocation:(CGPoint)point {
    
    if (point.x < kScreen_Width/2) {
        for (NSInteger i=0; i < self.leftModelsArray.count; i ++) {
            XXDepthMapModel *model = self.leftModelsArray[i];
            if (point.x >= model.startPoint.x && point.x <= model.endPoint.x) {
                return model;
            }
        }
    } else if (point.x > kScreen_Width/2) {
        for (NSInteger i=0; i < self.rightModelsArray.count; i ++) {
            XXDepthMapModel *model = self.rightModelsArray[i];
            if (point.x >= model.startPoint.x && point.x <= model.endPoint.x) {
                return model;
            }
        }
    }
    return nil;
}

#pragma mark - 6. 打开盘口长连接
- (void)show {

    self.webModel.params = [NSMutableDictionary dictionary];
    self.webModel.params[@"topic"] = @"diffMergedDepth";
    self.webModel.params[@"event"] = @"sub";
    self.webModel.params[@"symbol"] = [NSString stringWithFormat:@"%@.%@", KDetail.symbolModel.exchangeId, KDetail.symbolModel.symbolId];
    self.webModel.params[@"params"] = @{@"dumpScale":@"18", @"binary":@(YES)};
    
    self.webModel.httpUrl = @"quote/v1/depth";
    self.webModel.httpParams = [NSMutableDictionary dictionary];
    self.webModel.httpParams[@"symbol"] = [NSString stringWithFormat:@"%@.%@", KDetail.symbolModel.exchangeId, KDetail.symbolModel.symbolId];
    self.webModel.httpParams[@"dumpScale"] = @"18";
    self.webModel.httpParams[@"limit"] = @(100);
    
    [KQuoteSocket sendWebSocketSubscribeWithWebSocketModel:self.webModel];
}

#pragma mark - 7. 消失
- (void)dismiss {
    [KQuoteSocket cancelWebSocketSubscribeWithWebSocketModel:self.webModel];
}

- (void)dealloc {
    NSLog(@"==+==币对详情【深度数据】释放了");
}

@end
