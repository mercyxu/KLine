//
//  XXSegmentView.m
//  iOS
//
//  Created by iOS on 2019/10/24.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "XXSegmentView.h"

@interface XXSegmentView ()

/** 间隔 */
@property (assign, nonatomic) CGFloat lineWidth;

/** 宽度 */
@property (assign, nonatomic) CGFloat itemWidth;

/** 名称数组 */
@property (strong, nonatomic) NSArray *namesArray;

/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *buttonsArray;

/** 索引视图 */
@property (strong, nonatomic) UIView *indexView;

/** 选中的按钮 */
@property (strong, nonatomic) UIButton *selecedButton;

@end

@implementation XXSegmentView

- (instancetype)initWithFrame:(CGRect)frame items:(nullable NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.namesArray = items;
        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    self.lineWidth = 1.2;
    self.itemWidth = (self.width - self.lineWidth * (self.namesArray.count - 1)) / self.namesArray.count;
    
    self.backgroundColor = kWhite100;
    self.layer.cornerRadius = 3;
    self.layer.borderColor = (kBlue100).CGColor;
    self.layer.borderWidth = self.lineWidth;
    self.layer.masksToBounds = YES;
    
    self.indexView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.itemWidth, self.height)];
    self.indexView.backgroundColor = kBlue100;
    [self addSubview:self.indexView];
    
    self.buttonsArray = [NSMutableArray array];
    for (NSInteger i=0; i < self.namesArray.count; i ++) {
        UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake((self.itemWidth + self.lineWidth) * i, 0, self.itemWidth, self.height)];
        itemButton.backgroundColor = [UIColor clearColor];
        itemButton.titleLabel.font = kFontBold14;
        itemButton.tag = i;
        [itemButton setTitleColor:kBlue100 forState:UIControlStateNormal];
        [itemButton setTitleColor:kMainTextColor forState:UIControlStateSelected];
        [itemButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemButton setTitle:self.namesArray[i] forState:UIControlStateNormal];
        [self addSubview:itemButton];
        [self.buttonsArray addObject:itemButton];
        
        if (i < self.namesArray.count - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(itemButton.frame), 0, self.lineWidth, self.height)];
            lineView.backgroundColor = kBlue100;
            [self addSubview:lineView];
        }
        
        if ( i == 0) {
            itemButton.selected = YES;
            self.selecedButton = itemButton;

        }
    }
}

#pragma mark - 2. 按钮点击事件
- (void)itemButtonClick:(UIButton *)sender {
    
    if (sender.tag == self.selectedSegmentIndex) {
        return;
    }
    
    self.selectedSegmentIndex = sender.tag;
    self.selecedButton.selected = NO;
    self.selecedButton = self.buttonsArray[self.selectedSegmentIndex];
    self.selecedButton.selected = YES;
    [UIView animateWithDuration:0.12 animations:^{
        self.indexView.left = (self.itemWidth + self.lineWidth) * self.selectedSegmentIndex;
    }];
    
    if (self.changeBlock) {
        self.changeBlock();
    }
}

#pragma mark - 3. 改变选项
- (void)setSelectedSegmentIndex:(NSInteger)selectedIndex {
    if (_selectedSegmentIndex == selectedIndex) {
        return;
    }
    _selectedSegmentIndex = selectedIndex;
    
    self.selecedButton.selected = NO;
    self.selecedButton = self.buttonsArray[selectedIndex];
    self.selecedButton.selected = YES;
    [UIView animateWithDuration:0.12 animations:^{
        self.indexView.left = (self.itemWidth + self.lineWidth) * self.selectedSegmentIndex;
    }];
}
@end
