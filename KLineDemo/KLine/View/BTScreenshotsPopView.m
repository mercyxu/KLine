//
//  BTScreenshotsPopView.m
//  Bitbt
//
//  Created by iOS on 2019/6/24.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

static const float RealSrceenHight =  667.0;
static const float RealSrceenWidth =  375.0;
#define DPAdaptationH(x) x/RealSrceenHight*[[UIScreen mainScreen]bounds].size.height
#define DPAdaptationW(x) x/RealSrceenWidth*[[UIScreen mainScreen]bounds].size.width
//适配iOS10字体变大的缘故
#define IOS_VERSION_10_OR_LATER (([[[UIDevice currentDevice]systemVersion]floatValue]>=10.0)? (YES):(NO))

#define DPAdapationLabelFont(n) (IOS_VERSION_10_OR_LATER?((n-1)*([[UIScreen mainScreen]bounds].size.width/375.0f)):(n*([[UIScreen mainScreen]bounds].size.width/375.0f)))

#import "BTScreenshotsPopView.h"

@interface BTScreenshotsPopView ()

@property (nonatomic, copy) ActionSheetDidSelectSheetBlock selectSheetBlock;

@property (nonatomic,strong) UIImage *shotsImage;

@property (nonatomic,strong) UIButton *maskView;

@property (nonatomic,strong) UIImageView *shotsImageView;

@property (nonatomic,strong) UIView *bottomView;

@end

@implementation BTScreenshotsPopView

-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [UIButton buttonWithType:UIButtonTypeCustom];
        _maskView.frame = [UIScreen mainScreen].bounds;
        _maskView.backgroundColor = [UIColor blackColor];
        [_maskView addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskView;
}

-(UIImageView *)shotsImageView{
    if (_shotsImageView == nil) {
        _shotsImageView = [[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth-DPAdaptationW(274))/2, kTopHeight, DPAdaptationW(274), DPAdaptationH(474))];
        _shotsImageView.transform = CGAffineTransformMakeScale(0, 0);
 
    }
    return _shotsImageView;
}

-(UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, DPAdaptationH(160)+SafeAreaBottomHeight)];
        _bottomView.backgroundColor = RGB(19, 30, 48);
    }
    return _bottomView;
}

+(instancetype)initWithScreenShots:(UIImage *)shotsImage selectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock{
    
    return [[self alloc]initWithScreenShots:shotsImage selectSheetBlock:selectSheetBlock];
}

-(instancetype)initWithScreenShots:(UIImage *)shotsImage selectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _selectSheetBlock = selectSheetBlock;
        _shotsImage = shotsImage;
        [self addSubview:self.maskView];
        [self addSubview:self.shotsImageView];
        [self addSubview:self.bottomView];
    }
    return self;
}

-(void)show{

    self.shotsImageView.image = _shotsImage;
    [self layoutBottomSubViews];
    
    self.maskView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.maskView.alpha = 0.5;
    }];

    [UIView animateWithDuration:0.6 animations:^{
        self.shotsImageView.transform = CGAffineTransformIdentity;
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -160-SafeAreaBottomHeight);
    }];
}
-(void)hiddenView{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shotsImageView.frame = CGRectMake((KScreenWidth-DPAdaptationW(274))/2, DPAdaptationH(120), DPAdaptationW(274), DPAdaptationH(474));
        self.maskView.alpha = 0.0;
        self.bottomView.alpha = 0.0;
        self.shotsImageView.alpha = 0.0;
    }];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
        if (self.hiddenBlock) {
            self.hiddenBlock();
        }
    });
}

#pragma mark-添加底部视图的子视图
-(void)layoutBottomSubViews{

    CGFloat btnW = DPAdaptationW(58);
    CGFloat btnH = DPAdaptationH(70);
    CGFloat margin = 25;
    
    UIButton *WeiXinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [WeiXinButton setImage:[UIImage imageNamed:@"share_wechat"] forState:UIControlStateNormal];
    [WeiXinButton setTitleColor:RGB(102, 113, 138) forState:UIControlStateNormal];;
    WeiXinButton.frame = CGRectMake(margin, DPAdaptationH(15), btnW, btnH);
    WeiXinButton.titleLabel.font = [UIFont systemFontOfSize:DPAdapationLabelFont(12)];
    [WeiXinButton setTitle:BTLanguage(@"微信好友") forState:UIControlStateNormal];
    WeiXinButton.tag = WeiXinSelectSheetType;
    [WeiXinButton addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [WeiXinButton layoutButtonWithEdgeInsetsStyle:ZMButtonEdgeInsetsStyleTop imageTitleSpace:15];
    [self.bottomView addSubview:WeiXinButton];
    
    UIButton *WeiXinCircleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [WeiXinCircleButton setImage:[UIImage imageNamed:@"share_timeline"] forState:UIControlStateNormal];
    WeiXinCircleButton.frame = CGRectMake(margin*2+btnW, DPAdaptationH(15), btnW, btnH);
    WeiXinCircleButton.titleLabel.font = [UIFont systemFontOfSize:DPAdapationLabelFont(12)];
    WeiXinCircleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [WeiXinCircleButton setTitle:BTLanguage(@"朋友圈") forState:UIControlStateNormal];
    [WeiXinCircleButton setTitleColor:RGB(102, 113, 138) forState:UIControlStateNormal];
    WeiXinCircleButton.tag = WeiXinCircleSelectSheetType;
    [WeiXinCircleButton addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [WeiXinCircleButton layoutButtonWithEdgeInsetsStyle:ZMButtonEdgeInsetsStyleTop imageTitleSpace:15];
    [self.bottomView addSubview:WeiXinCircleButton];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setImage:[UIImage imageNamed:@"share_save"] forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(margin*3+btnW*2, DPAdaptationH(15), btnW, btnH);
    saveButton.titleLabel.font=[UIFont systemFontOfSize:DPAdapationLabelFont(12)];
    saveButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [saveButton setTitle:BTLanguage(@"保存图片") forState:UIControlStateNormal];
    [saveButton setTitleColor:RGB(102, 113, 138) forState:UIControlStateNormal];
    saveButton.tag = SaveSelectSheetType;
    [saveButton addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton layoutButtonWithEdgeInsetsStyle:ZMButtonEdgeInsetsStyleTop imageTitleSpace:15];
    [self.bottomView addSubview:saveButton];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, DPAdaptationH(110)-SafeKLineBottomHeight, KScreenWidth, 50)];
    [btn setTitle:BTLanguage(@"取消") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = RGB(23, 100, 178);
    [self.bottomView addSubview:btn];
    
}

-(void)btnDidClick:(UIButton *)sender{
    if (_selectSheetBlock) {
        _selectSheetBlock(sender.tag);
    }
    [self hiddenView];
}

@end
