//
//  XXKineView.h
//  iOS
//
//  Created by iOS on 2018/6/13.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXKineView : UIView

/** K线图分类按钮事件
 1. 分时
 2. 1分钟
 3. 5分钟
 4. 15分钟
 5. 30分钟
 6. 1小时
 7. 日线
 8. 周线
 9. 月线
 
 副图
 100. MACD
 101. KDJ
 102. 关闭
 
 主图
 103. MA
 104. EMA
 105. BOLL
 105. 关闭
 */
- (void)kButtonClickIndex:(NSInteger)index;

- (void)reloadUI;
- (void)reloadLineLocation;
- (void)show;
- (void)dismiss;
- (void)cleanData;
@end
