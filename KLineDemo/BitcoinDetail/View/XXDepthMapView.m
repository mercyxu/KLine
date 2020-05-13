//
//  XXDepthMapView.m
//  iOS
//
//  Created by iOS on 2018/6/12.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXDepthMapView.h"
#import "XXDepthMapModel.h"
#import "XXDepthMapData.h"
#import "UIColor+Y_StockChart.h"

#define TopHeight 45
#define LowHeight 25
#define DepthMapLabelFont [UIFont systemFontOfSize:10]

@interface XXDepthMapView ()

/**  数据 */
@property (strong, nonatomic) XXDepthMapData *mapData;

/** 渐变阴影 */
@property (strong, nonatomic, nullable) CAGradientLayer * gradientLayer;

/** 版式图 */
@property (strong, nonatomic, nullable) UIView *banView;

/** 左 */
@property (strong, nonatomic) CAShapeLayer *leftLayer;

/** 左填充 */
@property (strong, nonatomic) CAShapeLayer *leftFillLayer;

/** 右 */
@property (strong, nonatomic) CAShapeLayer *rightLayer;

/** 右填充 */
@property (strong, nonatomic) CAShapeLayer *rightFillLayer;

/** 圆点视图 */
@property (strong, nonatomic, nullable) UIView *pointView;

/** 中心视图 */
@property (strong, nonatomic, nullable) UIView *centerView;

/** 选中的点 */
@property (assign, nonatomic) CGPoint selectPoint;

/** 左侧标签数组 */
@property (strong, nonatomic) NSMutableArray *leftLabels;

/** 下测标签数组 */
@property (strong, nonatomic) NSMutableArray *lowLabels;

/** 左标签 */
@property (strong, nonatomic) XXLabel *leftLabel;

/** 右标签 */
@property (strong, nonatomic) XXLabel *rightLabel;

/** 长按手势 */
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;

@end

@implementation XXDepthMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor backgroundColor];
        self.layer.masksToBounds = YES;
        
        // 1. 初始化UI
        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    // 1. 添加渐变阴影
    [self.layer addSublayer:self.gradientLayer];
    
    // 2. 添加网格
    [self setupGrid];
    
    // 3. 添加版式图
    [self addSubview:self.banView];
    
    // 2. 左侧买单
    [self.banView.layer addSublayer:self.leftLayer];
    [self.banView.layer addSublayer:self.leftFillLayer];
    
    // 3. 右侧卖单
    [self.banView.layer addSublayer:self.rightLayer];
    [self.banView.layer addSublayer:self.rightFillLayer];
    
    // 4. 添加长按手势
    [self addGestureRecognizer:self.longPress];
    
    // 5. 添加十字线
    [self addSubview:self.pointView];
    [self.pointView addSubview:self.centerView];
    
    // 6. 添加左侧标签
    self.leftLabels = [NSMutableArray array];
    CGFloat rowHeight = (self.height - LowHeight - TopHeight) / 4;
    for (NSInteger i=0; i < 4; i ++) {
        XXLabel *label = [XXLabel labelWithFrame:CGRectMake(kScreen_Width - 105, TopHeight + i*rowHeight - 15, 100, 15) font:kFont10 textColor:[UIColor assistTextColor]];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        [self.leftLabels addObject:label];
    }
    
    // 7. 添加下部标签
    self.lowLabels = [NSMutableArray array];
    CGFloat lowWidth = (kScreen_Width - 4)/3;
    for (NSInteger i=0; i < 3; i ++) {
        CGFloat labelX = 2 + i*lowWidth;
        XXLabel *lowLabel = [XXLabel labelWithFrame:CGRectMake(labelX, self.height - LowHeight, lowWidth, LowHeight) font:kFont10 textColor:[UIColor assistTextColor]];
        if (i==0) {
            lowLabel.textAlignment = NSTextAlignmentLeft;
        } else if (i==2) {
            lowLabel.textAlignment = NSTextAlignmentRight;
        } else {
            lowLabel.textAlignment = NSTextAlignmentCenter;
        }
        [self addSubview:lowLabel];
        [self.lowLabels addObject:lowLabel];
    }
    
    // 8. 左标签
    [self addSubview:self.leftLabel];
    
    // 9. 下标签
    [self addSubview:self.rightLabel];
}

#pragma mark - 2. 初始化网格
- (void)setupGrid {
    
    CGFloat rowHeight = (self.height - LowHeight - TopHeight) / 4;
    CGFloat rowWidth = self.width/4;
    for (NSInteger i=0; i < 5; i ++) {
        CAShapeLayer *xLayer = [CAShapeLayer new];
        xLayer.lineWidth = 1;
        xLayer.strokeColor = [UIColor lineColor].CGColor;
        xLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:xLayer];

        
        UIBezierPath *xPath = [UIBezierPath bezierPath];
        [xPath moveToPoint:CGPointMake(0, TopHeight + i*rowHeight)];
        [xPath addLineToPoint:CGPointMake(kScreen_Width, TopHeight + i*rowHeight)];
        xLayer.path = [xPath CGPath];
        
        CAShapeLayer *yLayer = [CAShapeLayer new];
        yLayer.lineWidth = 1;
        yLayer.strokeColor = [UIColor lineColor].CGColor;
        yLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:yLayer];
        
        UIBezierPath *yPath = [UIBezierPath bezierPath];
        [yPath moveToPoint:CGPointMake(i*rowWidth, 0)];
        [yPath addLineToPoint:CGPointMake(i*rowWidth, self.height - LowHeight)];

        yLayer.path = [yPath CGPath];
    }
    
    UIView *leftImage = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 - 16, (TopHeight - 8) / 2, 8, 8)];
    leftImage.backgroundColor = kGreen100;
    [self addSubview:leftImage];
    
    XXLabel *leftNameLabel = [XXLabel labelWithFrame:CGRectMake(self.width * 0.25, 0, self.width * 0.25 - 20, TopHeight) text:LocalizedString(@"Binds") font:kFont10 textColor:[UIColor assistTextColor] alignment:NSTextAlignmentRight];
    [self addSubview:leftNameLabel];
    
    UIView *rightImage = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 + 8, (TopHeight - 8) / 2, 8, 8)];
    rightImage.backgroundColor = kRed100;
    [self addSubview:rightImage];
    
    XXLabel *rightNameLabel = [XXLabel labelWithFrame:CGRectMake(self.width * 0.5 + 20, 0, self.width * 0.25 - 20, TopHeight) text:LocalizedString(@"Asks") font:kFont10 textColor:[UIColor assistTextColor] alignment:NSTextAlignmentLeft];
    [self addSubview:rightNameLabel];
}

#pragma mark - 3. 刷新数据
- (void)refreshData {
    
    // 左图绘制
    self.leftLayer.path = [self.mapData.leftLinePath CGPath];
    self.leftFillLayer.path = [self.mapData.leftFillPath CGPath];
    
    // 右图绘制
    self.rightLayer.path = [self.mapData.rightLinePath CGPath];
    self.rightFillLayer.path = [self.mapData.rightFillPath CGPath];
    
    // y轴赋值
    for (NSInteger i=0; i < self.leftLabels.count; i ++) {
        XXLabel *yLabel = self.leftLabels[i];
        yLabel.text = [NSString handValuemeLengthWithAmountStr:[NSString stringWithFormat:@"%.10f", self.mapData.maxOrderNumber*(4 - i)/4.0f]];
    }
    
    // x轴复制
    NSArray *values = @[
        [KDecimal decimalNumber:[NSString stringWithFormat:@"%.10f", self.mapData.leftMidPrice] RoundingMode:NSRoundDown scale:KDetail.priceDigit],
        [KDecimal decimalNumber:[NSString stringWithFormat:@"%.10f", (self.mapData.leftMidPrice + self.mapData.rightMaxPrice)/2.0] RoundingMode:NSRoundDown scale:KDetail.priceDigit],
        [KDecimal decimalNumber:[NSString stringWithFormat:@"%.10f", self.mapData.rightMaxPrice] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
    for (NSInteger i=0; i < self.lowLabels.count; i ++) {
        XXLabel *xLabel = self.lowLabels[i];
        xLabel.text = values[i];
    }
    
    if (self.pointView.hidden == NO) {
        [self updateLoction:self.selectPoint];
    }
}

#pragma mark - 4. 长按手势方法
- (void)longPressGestureRecognized:(id)sender {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self];
    switch (state) {
        case UIGestureRecognizerStateBegan: // 已经开始按下
        {
            self.selectPoint = location;
            [self updateLoction:location];
            break;
        }
        case UIGestureRecognizerStateChanged:// 移动过程中
        {
            self.selectPoint = location;
            [self updateLoction:location];
            break;
        }
        default: // 长按手势取消状态
        {
            break;
        }
    }
}

#pragma mark - 5. 点击手势执行方法
- (void)tapGestureMethod:(UITapGestureRecognizer *)longPress {
    if (self.centerView.hidden == NO) {
        self.pointView.hidden = YES;
        self.leftLabel.hidden = YES;
        self.rightLabel.hidden = YES;
    }
}

#pragma mark - 6. 长按位置更新
- (void)updateLoction:(CGPoint)point {
    XXDepthMapModel *model = [self.mapData getDepthModelWithLocation:point];
    if (model) {
    
        self.pointView.hidden = NO;
        self.leftLabel.hidden = NO;
        self.rightLabel.hidden = NO;
        
        self.leftLabel.text = [NSString handValuemeLengthWithAmountStr:model.orderNumberString];
        self.rightLabel.text = model.priceString;
        [self.leftLabel sizeToFit];
        self.leftLabel.width += 10;
        self.leftLabel.height = 20;
        [self.rightLabel sizeToFit];
        self.rightLabel.width += 10;
        self.rightLabel.height = 20;
        self.rightLabel.top = self.height - LowHeight + (LowHeight - 20.0f)/2;
        
        self.leftLabel.centerY = model.startPoint.y + TopHeight;
        self.leftLabel.left = kScreen_Width - self.leftLabel.width;
        self.rightLabel.centerX = point.x;
        
        if (self.rightLabel.centerX > kScreen_Width - self.rightLabel.width/2) {
            self.rightLabel.centerX = kScreen_Width - self.rightLabel.width/2;
        }
        
        if (self.rightLabel.centerX < self.rightLabel.width/2) {
            self.rightLabel.centerX = self.rightLabel.width/2;
        }
        
        if (point.x < kScreen_Width/2) {
            self.pointView.layer.borderColor = (kGreen100).CGColor;
            self.centerView.backgroundColor = kGreen100;
        } else {
            self.pointView.layer.borderColor = (kRed100).CGColor;
            self.centerView.backgroundColor = kRed100;
        }
        
        self.pointView.center = CGPointMake(point.x, model.startPoint.y + TopHeight);
        
    } else {
        self.pointView.hidden = YES;
        self.leftLabel.hidden = YES;
        self.rightLabel.hidden = YES;
        
    }
}

#pragma mark - 7. 出现
- (void)show {
  
    [self.mapData show];
}

#pragma mark - 8. 消失
- (void)dismiss {
    [self.mapData dismiss];
}

#pragma mark - 9. 清理数据
- (void)cleanData {
    
    // 左图绘制
    self.leftLayer.path = [[UIBezierPath bezierPath] CGPath];
    self.leftFillLayer.path = [[UIBezierPath bezierPath] CGPath];
    
    // 右图绘制
    self.rightLayer.path = [[UIBezierPath bezierPath] CGPath];
    self.rightFillLayer.path = [[UIBezierPath bezierPath] CGPath];
    
    // y轴赋值
    for (NSInteger i=0; i < self.leftLabels.count; i ++) {
        XXLabel *yLabel = self.leftLabels[i];
        yLabel.text = @"";
    }
    
    // x轴复制
    for (NSInteger i=0; i < self.lowLabels.count; i ++) {
        XXLabel *xLabel = self.lowLabels[i];
        xLabel.text = @"";
    }
}

#pragma mark - || 懒加载
- (XXDepthMapData *)mapData {
    if (_mapData == nil) {
        _mapData = [[XXDepthMapData alloc] init];
        _mapData.height = self.banView.height;
        KWeakSelf
        _mapData.reloadDataFinish = ^{
            [weakSelf refreshData];
        };
    }
    return _mapData;
}

- (CAGradientLayer *)gradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(__bridge id)[UIColor assistBackgroundColor].CGColor,(__bridge id)[UIColor backgroundColor].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        _gradientLayer.locations = @[@0,@1];
    }
    return _gradientLayer;
}

/** 版式图 */
- (UIView *)banView {
    if (_banView == nil) {
        _banView = [[UIView alloc] initWithFrame:CGRectMake(0, TopHeight, self.width, self.height - TopHeight - LowHeight)];
        _banView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureMethod:)];
        [_banView addGestureRecognizer:tapGesture];
    }
    return _banView;
}

- (CAShapeLayer *)leftLayer {
    if (_leftLayer == nil) {
        _leftLayer = [CAShapeLayer new];
        _leftLayer.lineWidth = DepthMapLineWidth;
        _leftLayer.strokeColor = (kGreen100).CGColor;
        _leftLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _leftLayer;
}

- (CAShapeLayer *)leftFillLayer {
    if (_leftFillLayer == nil) {
        _leftFillLayer = [CAShapeLayer new];
        _leftFillLayer.lineWidth = DepthMapLineWidth;
        _leftFillLayer.strokeColor = [UIColor clearColor].CGColor;
        _leftFillLayer.fillColor = (kGreen20).CGColor;
    }
    return _leftFillLayer;
}

- (CAShapeLayer *)rightLayer {
    if (_rightLayer == nil) {
        _rightLayer = [CAShapeLayer new];
        _rightLayer.lineWidth = 1;
        _rightLayer.strokeColor = (kRed100).CGColor;
        _rightLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _rightLayer;
}

- (CAShapeLayer *)rightFillLayer {
    if (_rightFillLayer == nil) {
        _rightFillLayer = [CAShapeLayer new];
        _rightFillLayer.lineWidth = 1;
        _rightFillLayer.strokeColor = [UIColor clearColor].CGColor;
        _rightFillLayer.fillColor = (kRed20).CGColor;
    }
    return _rightFillLayer;
}

- (UILongPressGestureRecognizer *)longPress {
    
    if (_longPress == nil) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        _longPress.minimumPressDuration = 0.4;
    }
    return _longPress;
}

/** 圆点 */
- (UIView *)pointView {
    if (_pointView == nil) {
        _pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        _pointView.backgroundColor = [UIColor clearColor];
        _pointView.layer.borderWidth = 1;
        _pointView.layer.cornerRadius = _pointView.width / 2.0f;
        _pointView.layer.masksToBounds = YES;
        _pointView.hidden = YES;
    }
    return _pointView;
}

/** 中心视图 */
- (UIView *)centerView {
    if (_centerView == nil) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake((self.pointView.height - 5)/2.0f, (self.pointView.width - 5)/2.0f, 5, 5)];
        _centerView.layer.cornerRadius = _centerView.height / 2.0f;
        _centerView.layer.masksToBounds = YES;
    }
    return _centerView;
}

/** 左标签 */
- (XXLabel *)leftLabel {
    if (_leftLabel == nil) {
        _leftLabel = [XXLabel labelWithFrame:CGRectMake(0, 0, 40, LowHeight) text:@"" font:DepthMapLabelFont textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        _leftLabel.backgroundColor = [UIColor assistBackgroundColor];
        _leftLabel.layer.borderColor = [UIColor assistTextColor].CGColor;
        _leftLabel.layer.borderWidth = 1;
        _leftLabel.hidden = YES;
    }
    return _leftLabel;
}

/** 右标签 */
- (XXLabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [XXLabel labelWithFrame:CGRectMake(0, self.height - LowHeight, 40, LowHeight) text:@"" font:DepthMapLabelFont textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        _rightLabel.backgroundColor = [UIColor assistBackgroundColor];
        _rightLabel.layer.borderColor = [UIColor assistTextColor].CGColor;
        _rightLabel.layer.borderWidth = 1;
        _rightLabel.hidden = YES;
    }
    return _rightLabel;
}

- (void)dealloc {
    NSLog(@"深度View==释放了");
}
@end
