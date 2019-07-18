//
//  CFDeepView.m
//  CCLineChart
//
//  Created by ZM on 2018/9/13.
//  Copyright © 2018年 hexuren. All rights reserved.
//

#import "CFDeepView.h"
#import "CFCursorView.h"
@interface CFDeepView ()
@property (nonatomic, strong) UIView  *contentView;
@property (nonatomic,strong)UIView *lineChartView;
@property (nonatomic, strong) CFCursorView *cursorView;
@property (nonatomic,strong)NSMutableArray *buyPointCenterArr;
@property (nonatomic,strong)NSMutableArray *sellPointCenterArr;

@end


@implementation CFDeepView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        //中间区域
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0,20, self.bounds.size.width, self.bounds.size.height - 20)];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        [self addLineChartView];
        _cursorView = [[CFCursorView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, self.frame.size.height - 40)];
        _cursorView.backgroundColor = [UIColor clearColor];
        _cursorView.hidden = YES;
        [self addSubview:_cursorView];
        self.buyPointCenterArr = [NSMutableArray array];
        self.sellPointCenterArr = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 外部赋值
//外部Y坐标轴赋值
- (void)setDataArrOfY:(NSArray *)dataArrOfY {
    _dataArrOfY = dataArrOfY;
    [self addYAxisViews];
}

//外部X坐标轴赋值
- (void)setDataArrOfX:(NSArray *)dataArrOfX {
    _dataArrOfX = dataArrOfX;
    [self addXAxisViews];
//    [self addLinesView];
}

//买点数据
- (void)setBuyDataArrOfPoint:(NSArray *)dataArrOfPoint {
    _buyDataArrOfPoint = dataArrOfPoint;
    
    [self addBuyPointView];
    [self addBuyBezierLine];
}

//卖点数据
- (void)setSellDataArrOfPoint:(NSArray *)dataArrOfPoint {
    _sellDataArrOfPoint = dataArrOfPoint;
    [self.sellPointCenterArr removeAllObjects];
    [self addSellPointView];
    [self addSellBezierLine];
}

#pragma mark - UI

- (void)addLineChartView {
    _lineChartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height-20)];
    _lineChartView.layer.masksToBounds = YES;
//    _lineChartView.layer.borderWidth = 0.5;
//    _lineChartView.layer.borderColor = [UIColor colorWithRed:216/255.0 green:216/255.0  blue:216/255.0  alpha:1].CGColor;
    _lineChartView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_lineChartView];
}

- (void)addYAxisViews {
    CGFloat height = _lineChartView.bounds.size.height / (_dataArrOfY.count - 1);
    for (int i = 0;i< _dataArrOfY.count ;i++ ) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(_lineChartView.bounds.size.width - 60, height * i - height / 2, 60, height)];
        leftLabel.font = [UIFont systemFontOfSize:10];
        leftLabel.textColor = RGB(136, 143, 158);
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.text = NSStringFormat(@"%@",_dataArrOfY[i]);
        leftLabel.backgroundColor = [UIColor clearColor];
        if (i != (_dataArrOfY.count -1)) {
            [_contentView addSubview:leftLabel];
        }
    }
}

- (void)addXAxisViews {
    CGFloat width = _lineChartView.bounds.size.width /_dataArrOfX.count;
    for (int i = 0;i< _dataArrOfX.count;i++ ){
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*width, _lineChartView.bounds.origin.y + _lineChartView.bounds.size.height, width, 20)];
        leftLabel.tag = 111;
        leftLabel.font = [UIFont systemFontOfSize:10];
        leftLabel.textColor = RGB(136, 143, 158);
        leftLabel.text = NSStringFormat(@"%@",_dataArrOfX[i]);
        if (i ==0 ) {
            leftLabel.textAlignment = NSTextAlignmentLeft;
        }
        else if (i == 1) {
            leftLabel.textAlignment = NSTextAlignmentCenter;
        }
        else if (i == 2) {
            leftLabel.textAlignment = NSTextAlignmentRight;
        }
        leftLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:leftLabel];
    }
    
}

- (void)addLinesView {
    CGFloat white = _lineChartView.bounds.size.height /4;
    CGFloat height = _lineChartView.bounds.size.width /4;
    //横格
    for (int i = 0;i < 4;i++ ) {
        UIView *hengView = [[UIView alloc] initWithFrame:CGRectMake(0, white * (i + 1),_lineChartView.bounds.size.width , 0.5)];
        hengView.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0  blue:216/255.0  alpha:1];
        [_lineChartView addSubview:hengView];
    }
    //竖格
    for (int i = 0;i< 4;i++ ) {
        
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(height * (i + 1), 0, 0.5, _lineChartView.bounds.size.height)];
        shuView.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0  blue:216/255.0  alpha:1];
        [_lineChartView addSubview:shuView];
    }
}

#pragma mark - 点和根据点画贝塞尔曲线
- (void)addBuyPointView {
    [_buyPointCenterArr removeAllObjects];
    //区域高
    CGFloat height = self.lineChartView.bounds.size.height;
    //y轴最大值
    float arrmax = [_dataArrOfY[0] floatValue];
    //区域宽
    CGFloat width = self.lineChartView.bounds.size.width/2;
    //X轴间距
    float Xmargin = width / (_buyDataArrOfPoint.count - 1);
    
    for (int i = 0; i<_buyDataArrOfPoint.count; i++)
    {
        //nowFloat是当前值
        float nowFloat = [[_buyDataArrOfPoint[i] objectForKey:@"Num"] floatValue];
        //点点的x就是(竖着的间距 * i),y坐标就是()
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake((Xmargin)*i, height - nowFloat/arrmax * height - 2 / 2 , 2, 2)];
        NSValue *point = [NSValue valueWithCGPoint:v.center];
        [self.buyPointCenterArr addObject:point];
    }
}

-(void)addBuyBezierLine {
    //取得起点
    CGPoint p1 = [[self.buyPointCenterArr objectAtIndex:0] CGPointValue];
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    //添加线
    for (int i = 0;i<self.buyPointCenterArr.count;i++ )
    {
        if (i != 0)
        {
            CGPoint prePoint = [[self.buyPointCenterArr objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[self.buyPointCenterArr objectAtIndex:i] CGPointValue];
            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
        }
    }
    //显示线
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithRed:43/255.0 green:143/255.0 blue:79/255.0 alpha:1/1.0].CGColor;
    shapeLayer.lineWidth = 2;
    [_lineChartView.layer addSublayer:shapeLayer];
    //设置动画
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration =2.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
//    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    
    //遮罩层相关
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    CGPoint lastPoint;
    for (int i = 0;i<self.buyPointCenterArr.count;i++ ) {
        if (i != 0)
        {
            CGPoint prePoint = [[self.buyPointCenterArr objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[self.buyPointCenterArr objectAtIndex:i] CGPointValue];
            [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            if (i == self.buyPointCenterArr.count-1)
            {
                lastPoint = nowPoint;
            }
        }
    }
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    CGPoint lastPointX1 = CGPointMake(lastPointX,_lineChartView.bounds.size.height);
    [bezier1 addLineToPoint:lastPointX1];
    //回到原点
    [bezier1 addLineToPoint:CGPointMake(p1.x, _lineChartView.bounds.size.height)];
    [bezier1 addLineToPoint:p1];
    
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor colorWithRed:245/255.0 green:166/255.0  blue:35/255.0  alpha:1].CGColor;
    [_lineChartView.layer addSublayer:shadeLayer];
    
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0, _lineChartView.bounds.size.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:24/255.0 green:59/255.0 blue:49/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithRed:24/255.0 green:59/255.0 blue:49/255.0 alpha:0.4].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    [_lineChartView.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 0.0001f;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2*lastPoint.x, _lineChartView.bounds.size.height)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
}

-(void)addSellPointView {
    [_sellPointCenterArr removeAllObjects];
    //区域高
    CGFloat height = self.lineChartView.bounds.size.height;
    //y轴最大值
    float arrmax = [_dataArrOfY[0] floatValue];
    //区域宽
    CGFloat width = self.lineChartView.bounds.size.width/2;
    //X轴间距
    float Xmargin = width / (_sellDataArrOfPoint.count - 1);
    
    for (int i = 0; i<_sellDataArrOfPoint.count; i++) {
        //nowFloat是当前值
        float nowFloat = [[_sellDataArrOfPoint[i] objectForKey:@"Num"] floatValue];
        //点点的x就是(竖着的间距 * i),y坐标就是()
        CGFloat x = i == 0?self.lineChartView.bounds.size.width/2:(Xmargin)*i + self.lineChartView.bounds.size.width/2;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, height - nowFloat/arrmax * height - 2 / 2 , 2, 2)];
        NSValue *point = [NSValue valueWithCGPoint:v.center];
        [self.sellPointCenterArr addObject:point];
    }
}

- (void)addSellBezierLine {
    //取得起点
    CGPoint p1 = [[self.sellPointCenterArr objectAtIndex:0] CGPointValue];
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    //添加线
    for (int i = 0;i<self.sellPointCenterArr.count;i++ ) {
        if (i != 0){
            CGPoint prePoint = [[self.sellPointCenterArr objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[self.sellPointCenterArr objectAtIndex:i] CGPointValue];
            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
        }
    }
    //显示线
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithRed:161/255.0 green:66/255.0 blue:82/255.0 alpha:1/1.0].CGColor;
    shapeLayer.lineWidth = 2;
    [_lineChartView.layer addSublayer:shapeLayer];
    //设置动画
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration =2.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
//    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    
    //遮罩层相关
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    CGPoint lastPoint;
    for (int i = 0;i<self.sellPointCenterArr.count;i++ ) {
        if (i != 0){
            CGPoint prePoint = [[self.sellPointCenterArr objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[self.sellPointCenterArr objectAtIndex:i] CGPointValue];
            [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            if (i == self.sellPointCenterArr.count-1)
            {
                lastPoint = nowPoint;
            }
        }
    }
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    CGPoint lastPointX1 = CGPointMake(lastPointX,_lineChartView.bounds.size.height);
    [bezier1 addLineToPoint:lastPointX1];
    //回到原点
    [bezier1 addLineToPoint:CGPointMake(p1.x, _lineChartView.bounds.size.height)];
    [bezier1 addLineToPoint:p1];
    
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor colorWithRed:245/255.0 green:166/255.0  blue:35/255.0  alpha:1].CGColor;
    [_lineChartView.layer addSublayer:shadeLayer];
    
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 0, _lineChartView.bounds.size.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:52/255.0 green:36/255.0 blue:51/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithRed:52/255.0 green:36/255.0 blue:51/255.0 alpha:0.4].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    [_lineChartView.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 0.0001f;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2*lastPoint.x, _lineChartView.bounds.size.height)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
}

#pragma mark - UITouchBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showTouchView:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showTouchView:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideTouchView];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideTouchView];
}

- (void)hideTouchView {
    [self.cursorView setNeedsDisplay];
    self.cursorView.hidden = YES;
}

- (void)showTouchView:(NSSet<UITouch *> *)touches {
    CGPoint location = [touches.anyObject locationInView:self.contentView];
    if (location.x < 0 || location.x > CGRectGetMaxX(self.contentView.frame)) return;
    if (!self.sellPointCenterArr.count || !self.buyPointCenterArr.count) return;
    CGFloat xInDeepView = location.x;
    NSInteger selectIndex;
    CGPoint targetPoint;
    NSDictionary *targetModel;
    if (location.x > (self.contentView.frame.size.width / 2)){
        selectIndex = [self findPointInArray:self.sellPointCenterArr withPositionX:xInDeepView];
        targetPoint = [self.sellPointCenterArr[selectIndex] CGPointValue];
        targetModel = self.sellDataArrOfPoint[selectIndex];
    } else {
        selectIndex = [self findPointInArray:self.buyPointCenterArr withPositionX:xInDeepView];
        targetPoint = [self.buyPointCenterArr[selectIndex] CGPointValue];
        targetModel = self.buyDataArrOfPoint[selectIndex];
    }
    self.cursorView.selectedPoint = targetPoint;
    self.cursorView.selectModel = targetModel;
    self.cursorView.hidden = NO;
    [self.cursorView setNeedsDisplay];
}

- (NSInteger)findPointInArray:(NSArray *)array withPositionX:(CGFloat)x{
    CGFloat minx = 10000;
    NSInteger selectedIndeX = -1;
    CGPoint targetPoing;
    for (int i = 0; i<array.count; i++) {
        CGPoint point = [array[i] CGPointValue];
        if (ABS(point.x - x) < minx) {
            targetPoing = point;
            minx = ABS(point.x - x);
            selectedIndeX = i;
        }
    }
    return selectedIndeX;
}

@end
