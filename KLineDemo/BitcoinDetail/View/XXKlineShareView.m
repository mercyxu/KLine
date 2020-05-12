//
//  XXKlineShareView.m
//  iOS
//
//  Created by iOS on 2019/5/22.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "XXKlineShareView.h"


@interface XXKlineShareView ()

@end

@implementation XXKlineShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.logoImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.exLabel];
        [self addSubview:self.codeImageView];
        

        
    }
    return self;
}


#pragma mark - || 懒加载
/** logo */
- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
    
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(K375(24), (self.height - 48)/2, 48, 48)];
        _logoImageView.backgroundColor = [UIColor whiteColor];
        _logoImageView.layer.cornerRadius = 7;
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.borderWidth = 1;
        _logoImageView.layer.borderColor = (RGBColor(244, 244, 244)).CGColor;

    }
    return _logoImageView;
}

/** 名称 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 8, self.height/2 - 24, 200, 24) text:@"" font:kFontBold18 textColor:kMainTextColor];
    }
    return _nameLabel;
}

/** 平台 */
- (XXLabel *)exLabel {
    if (_exLabel == nil) {
        _exLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 8, CGRectGetMaxY(self.nameLabel.frame), 200, 24) text:@"" font:kFontBold14 textColor:kMainTextColor];
    }
    return _exLabel;
}

/** 二维码 */
- (UIImageView *)codeImageView {
    if (_codeImageView == nil) {
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 48 - 24, 22, 48, 48)];
    }
    return _codeImageView;
}

- (UIImage *)createCoderImageUrl:(NSString *)imageUrl {
    
    // 1.创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    // 2.还原滤镜默认属性
    [filter setDefaults];

    // 3.设置需要生成二维码的数据到滤镜中
    // OC中要求设置的是一个二进制数据
    NSData *data = [imageUrl dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"InputMessage"];

    // 4.从滤镜从取出生成好的二维码图片
    CIImage *ciImage = [filter outputImage];

    return [self createNonInterpolatedUIImageFormCIImage:ciImage size: 500];
}


- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)ciImage size:(CGFloat)widthAndHeight {
    
    CGRect extentRect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(widthAndHeight / CGRectGetWidth(extentRect), widthAndHeight / CGRectGetHeight(extentRect));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extentRect) * scale;
    size_t height = CGRectGetHeight(extentRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extentRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    //return [UIImage imageWithCGImage:scaledImage]; // 黑白图片
    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
    return [self imageBlackToTransparent:newImage withRed:51 andGreen:117.0f andBlue:224.0f];
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

@end
