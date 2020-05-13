//
//  UIImage+helper.m
//  
//
//  Created by Brian on 15/7/8.
//
//

#import "UIImage+helper.h"
//#import "NSString+HBExt.h"
//#import "constants.h"
//#import "UIColor+helper.h"
//#import "HBThemeManager.h"
@implementation UIImage (helper)

+(UIImage*) createImageWithColor:(UIColor*) color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (UIImage *)imageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  主颜色图标
 *
 *  @param name 图标名称
 *
 *  @return 改变颜色后的图片
 */

+ (UIImage *)mainImageName:(NSString *)name {
    UIImage *image = [[UIImage imageNamed:name] imageWithColor:kBlue100];
    return image;
}

/**
 *  字体色图标
 *
 *  @param name 图标名称
 *
 *  @return 改变颜色后的图片
 */

+ (UIImage *)textImageName:(NSString *)name {
    UIImage *image = [[UIImage imageNamed:name] imageWithColor:kDark100];
    return image;
}

/**
 *  二级字体色图标
 *
 *  @param name 图标名称
 *
 *  @return 改变颜色后的图片
 */

+ (UIImage *)subTextImageName:(NSString *)name {
    UIImage *image = [[UIImage imageNamed:name] imageWithColor:kDark50];
    return image;
}

- (UIImage *)alpha:(CGFloat)alpha {
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (UIImage *)getImageViewWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,[UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)composeImg:(UIImage *)maxImage minImage:(UIImage *)minImage  {
    CGImageRef imgRef = minImage.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    //以1.png的图大小为底图
    CGImageRef imgRef1 = maxImage.CGImage;
    CGFloat w1 = CGImageGetWidth(imgRef1);
    CGFloat h1 = CGImageGetHeight(imgRef1);
    
    //以1.png的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(w1, h1));
    [maxImage drawInRect:CGRectMake(0, 0, w1, h1)];//先把1.png 画到上下文中
    [minImage drawInRect:CGRectMake(0, h1 - h, w, h)];//再把小图放在上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    
    return resultImg;
}
@end
