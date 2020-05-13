//
//  UIImage+helper.h
//  
//
//  Created by Brian on 15/7/8.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (helper)
/**
 *  用颜色值创建图片
 *
 *  @param color 颜色中
 *
 *  @return 1*1 的图片
 */
+(UIImage*)createImageWithColor:(UIColor*) color;

/**
 *  改变图片的颜色
 *
 *  @param color 需要的图片的颜色
 *
 *  @return 改变颜色后的图片
 */

- (UIImage *)imageWithColor:(UIColor *)color;


/**
 *  主颜色图标
 *
 *  @param name 图标名称
 *
 *  @return 改变颜色后的图片
 */

+ (UIImage *)mainImageName:(NSString *)name;

/**
 *  字体色图标
 *
 *  @param name 图标名称
 *
 *  @return 改变颜色后的图片
 */

+ (UIImage *)textImageName:(NSString *)name;

/**
 *  二级字体色图标
 *
 *  @param name 图标名称
 *
 *  @return 改变颜色后的图片
 */

+ (UIImage *)subTextImageName:(NSString *)name;

- (UIImage *)alpha:(CGFloat)alpha;

+ (UIImage *)getImageViewWithView:(UIView *)view;

+ (UIImage *)composeImg:(UIImage *)maxImage minImage:(UIImage *)minImage;
@end
