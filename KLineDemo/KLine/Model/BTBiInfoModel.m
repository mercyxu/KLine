//
//  BTBiInfoModel.m
//  Bitbt
//
//  Created by iOS on 2019/5/14.
//  Copyright © 2019年 www.ruiec.cn. All rights reserved.
//

#import "BTBiInfoModel.h"

@implementation BTBiInfoModel

- (CGFloat)desCellHeight
{
    _desCellHeight = 65;
    
    CGFloat maxW = KScreenWidth - 30;
    CGSize maxsize = CGSizeMake(maxW, MAXFLOAT);
    CGSize size = [self.Description boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONT_WITH_SIZE(12)} context:nil].size;
    
    _desCellHeight += size.height;
    
    return _desCellHeight;
}

@end
