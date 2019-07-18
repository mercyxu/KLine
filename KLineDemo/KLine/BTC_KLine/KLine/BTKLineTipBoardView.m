//
//  BTKLineTipBoardView.m
//  Bitbt
//
//  Created by iOS on 2019/6/21.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

#import "BTKLineTipBoardView.h"

#define kBorderOffset       0.5f

@interface BTKLineTipBoardView ()

@property (nonatomic) CGPoint tipPoint;

@end

@implementation BTKLineTipBoardView

#pragma mark - public methods

- (void)drawInContext {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*画矩形*/
    CGContextStrokeRect(context,CGRectMake(0.5, 0.5, self.bounds.size.width, self.bounds.size.height));//画方框
//    CGContextFillRect(context,CGRectMake(0.5, 0.5, self.bounds.size.width, self.bounds.size.height));//填充框
    //矩形，并填弃颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
//    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);//填充颜色
//    CGContextSetStrokeColorWithColor(context, RGB(193, 197, 222).CGColor);//线框颜色
    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
}

- (void)showWithTipPoint:(CGPoint)point isFullScreen:(BOOL)isFullScreen{
    self.hidden = NO;
    [self.layer removeAllAnimations];

    if ((CGPointEqualToPoint(self.tipPoint, point))) {
        return;
    }
    CGRect frame = self.frame;

    if (isFullScreen) {
        if (point.x > KScreenHeight/2.0) {
            frame.origin.x = 10+SafeAreaTopHeight;
        }else {
            frame.origin.x = KScreenHeight-self.width-10-50-SafeAreaBottomHeight; //减去指标宽度
        }
    }else{
        if (point.x > KScreenWidth/2.0) {
            frame.origin.x = 10;
        }
        else {
            frame.origin.x = KScreenWidth-self.width-10;
        }
    }
    
    frame.origin.y = point.y;
    self.tipPoint = point;
    self.frame = frame;
    [self setNeedsDisplay];
}

- (void)hide {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = self.hideDuration;
    animation.startProgress = 0.0;
    animation.endProgress = 0.35;
    [self.layer addAnimation:animation forKey:nil];
    self.hidden = YES;
}

#pragma mark - getters

- (UIColor *)fillColor {
    return !_fillColor ? [UIColor redColor] : _fillColor;
}

- (UIColor *)strockColor {
    return _strockColor ? _strockColor : RGB(193, 197, 222);
}

#pragma mark - life cycle

- (id)init {
    if (self = [super init]) {
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    //填充色
    self.strockColor = RGB(193, 197, 222);
    self.radius = 4.0;
    self.hideDuration = 2.5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = RGB(97, 123, 157).CGColor;
    self.time = @"--";
    self.open = @"--";
    self.close = @"--";
    self.high = @"--";
    self.low = @"--";
    self.riseDrop = @"--";
    self.percent = @"--";
    self.vol = @"--";
    
    self.timeColor = RGB(193, 197, 222);
    self.openColor = RGB(193, 197, 222);
    self.closeColor = RGB(193, 197, 222);
    self.highColor = RGB(193, 197, 222);
    self.lowColor = RGB(193, 197, 222);
    self.riseDropColor = RGB(193, 197, 222);
    self.percentColor = RGB(193, 197, 222);
    self.volColor = RGB(193, 197, 222);
    
    self.font = [UIFont systemFontOfSize:10.0f];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawInContext];
    
    [self drawText];
}

- (void)drawText {
    
    //画字
    NSArray *titles = @[@"时间",@"开",@"高",@"低",@"收",@"涨跌额",@"涨跌幅",@"成交量"];
    CGFloat padding = 5;
    
    for (int i = 0; i < titles.count; i ++) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:titles[i] attributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:RGB(193, 197, 222)}];
        CGFloat originY = 5 + i * (padding + self.font.lineHeight);
        CGFloat originX = 5;
        [attString drawInRect:CGRectMake(originX, originY, self.frame.size.width, self.font.lineHeight)];
    }
    
    if ((self.open.doubleValue - self.close.doubleValue) > 0) {
        self.riseDropColor = RGB(222, 52, 91);
        self.percentColor = RGB(222, 52, 91);
        self.riseDrop = [CommonMethod deleteFloatAllZero:NSStringFormat(@"%f",self.close.doubleValue - self.open.doubleValue)];
        self.percent = NSStringFormat(@"%.2f%%",self.riseDrop.doubleValue / self.open.doubleValue *100.0);
    }else{
         self.riseDropColor = RGB(3, 173, 143);
        self.percentColor = RGB(3, 173, 143);
        self.riseDrop = [CommonMethod deleteFloatAllZero:NSStringFormat(@"+%f",self.close.doubleValue - self.open.doubleValue)];
        self.percent = NSStringFormat(@"+%.2f%%",self.riseDrop.doubleValue / self.open.doubleValue *100.0);
    }
    
    NSArray *contents = @[self.time,self.open,self.high,self.low,self.close,self.riseDrop,self.percent,self.vol];
    NSArray<UIColor *> *contentColor = @[self.timeColor,self.openColor,self.highColor ,self.lowColor,self.closeColor,self.riseDropColor,self.percentColor,self.volColor];

    for (int i = 0; i < contents.count; i ++) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:contents[i] attributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:contentColor[i]}];
        CGFloat originY = 5 + i * (padding + self.font.lineHeight);
        CGFloat titleW = [CommonMethod computeTextSizeWithString:contents[i] andFontSize:FONT_WITH_SIZE(10)].width;
        [attString drawInRect:CGRectMake(self.width-titleW-padding, originY, self.width, self.font.lineHeight)];
    }
}

@end
