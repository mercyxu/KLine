//
//  CFKLineFullScreenViewController.h
//
//  Created by Zhimi on 2018/9/3.
//  Copyright © 2018年 hexuren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTBiModel,BTMarketModel;
@interface LineKFullScreenViewController : UIViewController

@property (copy, nonatomic) void (^ onClickBackButton)(LineKFullScreenViewController *controller);

@property (nonatomic, strong) BTBiModel *biModel;

//当前交易币信息
@property (nonatomic, strong) BTMarketModel *marketModel;

@end
