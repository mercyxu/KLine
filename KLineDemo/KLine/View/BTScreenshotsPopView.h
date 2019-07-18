//
//  BTScreenshotsPopView.h
//  Bitbt
//
//  Created by iOS on 2019/6/24.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SelectSheetType) {
    WeiXinSelectSheetType,
    WeiXinCircleSelectSheetType,
    SaveSelectSheetType,
};
typedef void (^ActionSheetDidSelectSheetBlock)(SelectSheetType type);
typedef void (^ActionSheetDidHiddenBlock)(void);

@interface BTScreenshotsPopView : UIView

@property (nonatomic, copy) ActionSheetDidHiddenBlock hiddenBlock;

+(instancetype)initWithScreenShots:(UIImage *)shotsImage selectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock;

-(void)show;

@end

NS_ASSUME_NONNULL_END
