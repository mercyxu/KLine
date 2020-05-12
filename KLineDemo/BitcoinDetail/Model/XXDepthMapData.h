//
//  XXDepthMapData.h
//  iOS
//
//  Created by iOS on 2018/6/13.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXDepthMapModel.h"

@interface XXDepthMapData : NSObject

/**  视图所在高度 */
@property (assign, nonatomic) double height;

/** 挂单量最大值 */
@property (assign, nonatomic) double maxOrderNumber;

/** 左侧买单最低价 */
@property (assign, nonatomic) double leftMidPrice;

/** 左侧买单最高价 */
@property (assign, nonatomic) double leftMaxPrice;

/** 右侧买单最低价 */
@property (assign, nonatomic) double rightMidPrice;

/** 右侧买单最高价 */
@property (assign, nonatomic) double rightMaxPrice;

/** Y轴比例尺 */
@property (assign, nonatomic) double yScale;

/** X轴比例尺 */
@property (assign, nonatomic) double xScale;

/** 左侧模型数组 */
@property (strong, nonatomic) NSMutableArray *leftModelsArray;

/** 右侧模型数组 */
@property (strong, nonatomic) NSMutableArray *rightModelsArray;

/** 左侧填充path */
@property (strong) UIBezierPath *leftFillPath;

/** 左侧线path */
@property (strong) UIBezierPath *leftLinePath;

/** 右侧填充path */
@property (strong) UIBezierPath *rightFillPath;

/** 右侧线path */
@property (strong) UIBezierPath *rightLinePath;

/**  刷新数据 */
@property (strong, nonatomic) void(^reloadDataFinish)(void);

/**
 *  1. 打开长连接
 */
- (void)show;
- (void)dismiss;

/**
 *  2. 查找相应的数据模型
 */
- (XXDepthMapModel *)getDepthModelWithLocation:(CGPoint)point;
@end
