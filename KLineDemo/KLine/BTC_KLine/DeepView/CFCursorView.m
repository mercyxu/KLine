//
//  CFCursorView.m
//  CCLineChart
//
//  Created by ZM on 2018/9/14.
//  Copyright © 2018年 hexuren. All rights reserved.
//

#import "CFCursorView.h"

@implementation CFCursorView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat radius = 10;
    
    CGFloat arcX = self.selectedPoint.x  > radius ? self.selectedPoint.x : radius;
    
    if (radius > self.selectedPoint.x ) {
        arcX = radius;
    }
    CGFloat arcY = self.selectedPoint.y > radius ? self.selectedPoint.y : radius;
    
    
    //画圆。
    CGContextAddArc(ctx, arcX, arcY, 10, 0, 4 * M_PI, 0);
    //    64,75,107  404B6B
    [[UIColor colorWithRed:64/255.0 green:75/255.0 blue:107/255.0 alpha:1] set];
    //填充(沿着矩形内围填充出指定大小的圆)
    CGContextFillPath(ctx);
    CGContextAddArc(ctx, arcX, arcY , 5, 0, 4 * M_PI, 0);
    CGContextSetLineWidth(ctx, 5);
    
    [[UIColor colorWithRed:123/255.0 green:154/255.0 blue:244/255.0 alpha:1] set];
    CGContextFillPath(ctx);
    
    // 画提示框
    CGContextSetStrokeColorWithColor(ctx,  [UIColor colorWithRed:38/255.0 green:43/255.0 blue:65/255.0 alpha:1].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGFloat originX = arcX - 110;
    CGFloat originY = arcY - radius;
    
    if (originX < 0) {
        originX = 2*radius + self.selectedPoint.x ;
    }
    
//    if (originY < 50) {
//        originY = 60;
//
//    }
    CGContextStrokeRect(ctx, CGRectMake(originX, originY, 110, 50));
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:38/255.0 green:43/255.0 blue:65/255.0 alpha:1].CGColor);
    CGContextFillRect(ctx, CGRectMake(originX, originY, 110, 50));
    
    
    
    NSString *priceString = [NSString stringWithFormat:@"委托价:%f",[[self.selectModel objectForKey:@"Price"] doubleValue]];
    NSString *volumeString = [NSString stringWithFormat:@"累计:%f",[[self.selectModel objectForKey:@"Num"] doubleValue]];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor colorWithRed:96/255.0 green:103/255.0 blue:135/255.0 alpha:1.0f]};
    
    CGSize priceSize = [self rectOfNSString:priceString attribute:attribute].size;
    CGSize volumeSize = [self rectOfNSString:volumeString attribute:attribute].size;
    
    CGFloat stringY = (50 - priceSize.height - volumeSize.height - 5)/2 + originY;
    CGFloat priceStringX = (110 - priceSize.width)/2 + originX;
    CGFloat volumeStringX = (110 - volumeSize.width)/2 + originX;
    [priceString drawAtPoint:CGPointMake(priceStringX , stringY) withAttributes:attribute];
    [volumeString drawAtPoint:CGPointMake(volumeStringX, stringY + priceSize.height + 5) withAttributes:attribute];
    
    
}


- (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

- (UIColor *)colorWithHex:(UInt32)hex {
    return [self colorWithHex:hex alpha:1.f];
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

@end
