//
//  XXDetailDepthListView.m
//  iOS
//
//  Created by iOS on 2018/8/30.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXDetailDepthListView.h"
#import "XXDepthCell.h"
#import "XXDepthTool.h"
#import "UIColor+Y_StockChart.h"

@interface XXDetailDepthListView ()<UITableViewDataSource, UITableViewDelegate> {
    dispatch_queue_t _serialQueue; // 串行队列
}

@property (assign, nonatomic) BOOL isAmount;

/** 盘口平均值 */
@property (assign, nonatomic) double ordersAverage;

/** 模型数组 */
@property (strong, nonatomic) NSMutableArray *modelsArray;

/** 头视图 */
@property (strong, nonatomic) UIView *headerView;

/** 买盘数量 */
@property (strong, nonatomic) XXButton *buyButton;

/** 价格标签 */
@property (strong, nonatomic) XXLabel *priceLabel;

/** 卖盘标签 */
@property (strong, nonatomic) XXButton *sellButton;

/** 表示图 */
@property (strong, nonatomic) UITableView *tableView;

/** cell数组 */
@property (strong, nonatomic) NSMutableArray *cellsArray;
@end

@implementation XXDetailDepthListView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        // 1. 初始化页面
        [self setupUI];
        
        KWeakSelf
        KDetail.blockList = ^(NSMutableArray * _Nonnull modelsArray, double ordersAverage) {
            weakSelf.modelsArray = modelsArray;
            weakSelf.ordersAverage  = ordersAverage;
            [weakSelf reloadDataOfDepth];
        };
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.buyButton];
    [self.headerView addSubview:self.priceLabel];
    [self.headerView addSubview:self.sellButton];

    self.height = self.tableView.height;
}

#pragma mark - 2. 表示图代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXDepthCell getCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXDepthCell *cell = self.cellsArray[indexPath.row];
    return cell;
}

#pragma mark - 4.3 刷新数据5
- (void)reloadDataOfDepth {
    
    [UIView animateWithDuration:0.2 animations:^{
        for (NSInteger i=0; i < self.cellsArray.count; i ++) {
            XXDepthCell *cell = self.cellsArray[i];
            cell.ordersAverage = self.ordersAverage;
            cell.model = self.modelsArray[i];
            cell.isAmount = self.isAmount;
            [cell reloadData];
        }
    }];
    
}

#pragma mark - 5. 出现
- (void)show {
    
    // 刷新标签
    [self reloadLabelsValue];
}

#pragma mark - 6. 消失
- (void)dismiss {
    
}

#pragma mark - 7. 清理数据
- (void)cleanData {
    [self.modelsArray removeAllObjects];
    [self reloadDataOfDepth];
}

#pragma mark - 8. 刷新标签
- (void)reloadLabelsValue {
    NSString *buyStrinng = [NSString stringWithFormat:@"%@(%@)", LocalizedString(self.isAmount ? @"Amount" : @"Cumulative"), KDetail.symbolModel.type == SymbolTypeCoin ? KDetail.symbolModel.baseTokenName : LocalizedString(@"Paper")];
    [self.buyButton setTitle:buyStrinng forState:UIControlStateNormal];
    [self.buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.buyButton.imageView.image.size.width, 0, self.buyButton.imageView.image.size.width)];
    [self.buyButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.buyButton.titleLabel.bounds.size.width + 5, 0, -self.buyButton.titleLabel.bounds.size.width - 5)];
    self.buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    NSString *priceString = [NSString stringWithFormat:@"%@(%@)", LocalizedString(@"Price"), KDetail.symbolModel.quoteTokenName];
    self.priceLabel.text = priceString;
    
    NSString *sellString = [NSString stringWithFormat:@"%@(%@)", LocalizedString(self.isAmount ? @"Amount" : @"Cumulative"), KDetail.symbolModel.type == SymbolTypeCoin ? KDetail.symbolModel.baseTokenName : LocalizedString(@"Paper")];
    [self.sellButton setTitle:sellString forState:UIControlStateNormal];
    [self.sellButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.sellButton.imageView.image.size.width, 0, self.sellButton.imageView.image.size.width)];
    [self.sellButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.sellButton.titleLabel.bounds.size.width + 5, 0, -self.sellButton.titleLabel.bounds.size.width - 5)];
    self.sellButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

#pragma mark - 9. 数量类型按钮点击事件
- (void)amountButtonClick {
//    KWeakSelf
//    [XYHPickerView showPickerViewWithNamesArray:@[LocalizedString(@"Cumulative"), LocalizedString(@"Amount")] selectIndex:self.isAmount Block:^(NSString *title, NSInteger index) {
//        if (weakSelf.isAmount != index) {
//            weakSelf.isAmount = index;
//            [weakSelf reloadLabelsValue];
//            [weakSelf reloadDataOfDepth];
//        }
//    }];
}

#pragma mark - || 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40 + 20*[XXDepthCell getCellHeight]) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    }
    return _headerView;
}

- (XXButton *)buyButton {
    if (_buyButton == nil) {
        KWeakSelf
        _buyButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, 8, (kScreen_Width - KSpacing*2)/3.0, 32) title:[NSString stringWithFormat:@"%@(%@)", LocalizedString(@"Amount"), KDetail.symbolModel.type == SymbolTypeCoin ? KDetail.symbolModel.baseTokenName : LocalizedString(@"Paper")] font:kFont12 titleColor:[UIColor assistTextColor] block:^(UIButton *button) {
            [weakSelf amountButtonClick];
        }];
        [_buyButton setImage:[[UIImage imageNamed:@"arrowdown_trade"] imageWithColor:[UIColor assistTextColor]] forState:UIControlStateNormal];
        _buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _buyButton;
}

- (XXLabel *)priceLabel {
    if (_priceLabel == nil) {
        NSString *name = [NSString stringWithFormat:@"%@(%@)", LocalizedString(@"Price"), KDetail.symbolModel.quoteTokenName];
        _priceLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.buyButton.frame), self.buyButton.top, self.buyButton.width, self.buyButton.height) text:name font:kFont12 textColor:[UIColor assistTextColor]];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

- (XXButton *)sellButton {
    if (_sellButton == nil) {
        KWeakSelf
        _sellButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame), self.buyButton.top, self.buyButton.width, self.buyButton.height) title:[NSString stringWithFormat:@"%@(%@)", LocalizedString(@"Amount"), KDetail.symbolModel.type == SymbolTypeCoin ? KDetail.symbolModel.baseTokenName : LocalizedString(@"Paper")] font:kFont12 titleColor:[UIColor assistTextColor] block:^(UIButton *button) {
            [weakSelf amountButtonClick];
        }];
        [_sellButton setImage:[[UIImage imageNamed:@"arrowdown_trade"] imageWithColor:[UIColor assistTextColor]]  forState:UIControlStateNormal];
        _sellButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _sellButton;
}

/** cell数组 */
- (NSMutableArray *)cellsArray {
    if (_cellsArray == nil) {
        _cellsArray = [NSMutableArray array];
        for (NSInteger i=0; i < 20; i ++) {
            XXDepthCell *cell = [[XXDepthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [_cellsArray addObject:cell];
        }
    }
    return _cellsArray;
}

- (void)dealloc {
    NSLog(@"==+==币对详情【深度列表】释放了");
}

@end
