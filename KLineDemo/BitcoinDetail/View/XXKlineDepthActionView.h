//
//  XXKlineDepthActionView.h
//  iOS
//
//  Created by iOS on 2018/6/28.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XXKlineDepthActionViewDelegate <NSObject>

@optional
/**
 index: 1. 更多  2. 全屏 3. 深度图 
 */
- (void)klineDepthActionViewDidselctIndex:(NSInteger)index;

@end

@interface XXKlineDepthActionView : UIView

/** 索引分时按钮 */
@property (assign, nonatomic) NSInteger indexBtn;

/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *kMainbuttonsArray;

/** 3. 代理 */
@property (weak, nonatomic) id <XXKlineDepthActionViewDelegate>delegate;
@end
