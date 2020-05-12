//
//  XYHFloadtTextField.h
//  WanRenHui
//
//  Created by 徐义恒 on 17/3/25.
//  Copyright © 2017年 gansbat. All rights reserved.
//

#import "XXTextField.h"

@interface XXFloadtTextField : XXTextField

/** 控制精度 */
@property (assign, nonatomic) BOOL isPrecision;

/** 控制精度范围 */
@property (assign, nonatomic) NSInteger count;

@end
