//
//  BTTargetView.h
//  Bitbt
//
//  Created by Ruiec on 2019/7/1.
//  Copyright © 2019 www.ruiec.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BTTargetViewBlock)(NSInteger section, NSInteger row, id _Nullable data);

NS_ASSUME_NONNULL_BEGIN

@interface BTTargetView : UIView

@property (copy, nonatomic) BTTargetViewBlock selectBlock;

+ (BTTargetView *)GetTargetView_Frame:(CGRect)frame;

@end


@interface BTTargetViewCell : UITableViewCell

@property (strong, nonatomic) UIButton *titleBtn;

@end

NS_ASSUME_NONNULL_END
