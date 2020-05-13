//
//  XXDetailTradesListView.m
//  iOS
//
//  Created by iOS on 2018/8/30.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "XXDetailTradesListView.h"
#import "XXTradeCell.h"
#import "UIColor+Y_StockChart.h"

@interface XXDetailTradesListView () <UITableViewDataSource, UITableViewDelegate> {
    dispatch_queue_t serialQueue;
}

@property (strong, nonatomic) XXWebQuoteModel *webModel;

/** 模型数组 */
@property (strong, nonatomic) NSMutableArray *modelsArray;

/** 头视图 */
@property (strong, nonatomic) UIView *headerView;

/** 日期标签 */
@property (strong, nonatomic) XXLabel *dateLabel;

/** 类型标签 */
@property (strong, nonatomic) XXLabel *typeLabel;

/** 价格标签 */
@property (strong, nonatomic) XXLabel *priceLabel;

/** 数量标签 */
@property (strong, nonatomic) XXLabel *amountLabel;

/** 表示图 */
@property (strong, nonatomic) UITableView *tableView;

/** cell数组 */
@property (strong, nonatomic) NSMutableArray *cellsArray;

@end

@implementation XXDetailTradesListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setupUI];

        serialQueue = dispatch_queue_create("com.detailTrades.symbol", DISPATCH_QUEUE_SERIAL);

        self.webModel = [[XXWebQuoteModel alloc] init];

        KWeakSelf
        // 订阅成功回调
        self.webModel.successBlock = ^(id data) {
            [weakSelf receiveData:data];
        };

        // 失败回调
        self.webModel.failureBlock = ^{

        };
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.dateLabel];
    [self.headerView addSubview:self.typeLabel];
    [self.headerView addSubview:self.priceLabel];
    [self.headerView addSubview:self.amountLabel];
    self.height = 50 + 20*[XXTradeCell getCellHeight];
    [self cellsArray];
}

#pragma mark - 2. 表示图代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXTradeCell getCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXTradeCell *cell = self.cellsArray[indexPath.row];
    return cell;
}

#pragma mark - 4. 收到消息
- (void)receiveData:(NSMutableArray *)data {

    dispatch_async(serialQueue, ^{
        [self reloadData:data];
    });
}

- (void)reloadData:(NSMutableArray *)data {
    if (![data isKindOfClass:[NSArray class]]) {
        return;
    }
    if (data.count > 20) {
        data = (NSMutableArray *)[data subarrayWithRange:NSMakeRange(data.count - 20, 20)];
    }
    for (NSInteger i=0; i < data.count; i ++) {
        XXTradeModel *model = [XXTradeModel mj_objectWithKeyValues:data[i]];
        [self.modelsArray insertObject:model atIndex:0];
    }
    if (self.modelsArray.count > 20) {
        self.modelsArray = [NSMutableArray arrayWithArray:[self.modelsArray subarrayWithRange:NSMakeRange(0, 20)]];
    }
    for (NSInteger i=0; i < self.cellsArray.count; i ++) {
        XXTradeCell *cell = self.cellsArray[i];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (i < self.modelsArray.count) {
                cell.hidden = NO;
                cell.model = self.modelsArray[i];
            } else {
                cell.hidden = YES;
            }
        });
    }
}

#pragma mark - 5. 出现
- (void)show {
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@(%@)", LocalizedString(@"Price"), KDetail.symbolModel.quoteTokenName];
    self.amountLabel.text = [NSString stringWithFormat:@"%@(%@)", LocalizedString(@"Amount"), KDetail.symbolModel.type == SymbolTypeCoin ? KDetail.symbolModel.baseTokenName : LocalizedString(@"Paper")];
    
    self.webModel.params = [NSMutableDictionary dictionary];
    self.webModel.params[@"topic"] = @"trade";
    self.webModel.params[@"event"] = @"sub";
    self.webModel.params[@"symbol"] = [NSString stringWithFormat:@"%@.%@", KDetail.symbolModel.exchangeId, KDetail.symbolModel.symbolId];
    self.webModel.params[@"params"] = @{@"binary":@(YES)};

    self.webModel.httpUrl = @"quote/v1/trades";
    self.webModel.httpParams = [NSMutableDictionary dictionary];
    self.webModel.httpParams[@"symbol"] = [NSString stringWithFormat:@"%@.%@", KDetail.symbolModel.exchangeId, KDetail.symbolModel.symbolId];
    self.webModel.httpParams[@"limit"] = @(20);

    [KQuoteSocket sendWebSocketSubscribeWithWebSocketModel:self.webModel];
}

#pragma mark - 6. 消失
- (void)dismiss {
    
    // 取消订阅
    [KQuoteSocket cancelWebSocketSubscribeWithWebSocketModel:self.webModel];
}

#pragma mark - 7. 清理数据
- (void)cleanData {
    for (NSInteger i=0; i < self.cellsArray.count; i ++) {
        XXTradeCell *cell = self.cellsArray[i];
        cell.hidden = YES;
    }
}

#pragma mark - || 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40 + 20*[XXTradeCell getCellHeight]) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor backgroundColor];
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
- (XXLabel *)dateLabel {
    if (_dateLabel == nil) {
        CGFloat width = (kScreen_Width - KSpacing*2)/4;
        _dateLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 16, width, 16) text:LocalizedString(@"Date") font:kFont12 textColor:[UIColor assistTextColor]];
    }
    return _dateLabel;
}

- (XXLabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.dateLabel.frame), 16, self.dateLabel.width * 0.8, 16) text:LocalizedString(@"Type") font:kFont12 textColor:[UIColor assistTextColor] alignment:NSTextAlignmentCenter];
    }
    return _typeLabel;
}

- (XXLabel *)priceLabel {
    if (_priceLabel == nil) {
        NSString *name = [NSString stringWithFormat:@"%@(%@)", LocalizedString(@"Price"), KDetail.symbolModel.quoteTokenName];
        _priceLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame), 16, self.dateLabel.width * 1.2, 16) text:name font:kFont12 textColor:[UIColor assistTextColor] alignment:NSTextAlignmentCenter];
    }
    return _priceLabel;
}

- (XXLabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame), 16, self.dateLabel.width, 16) text:[NSString stringWithFormat:@"%@(%@)", LocalizedString(@"Amount"), KDetail.symbolModel.type == SymbolTypeCoin ? KDetail.symbolModel.baseTokenName : LocalizedString(@"Paper")] font:kFont12 textColor:[UIColor assistTextColor]];
        _amountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _amountLabel;
}

/** 最新成交cell数组 */
- (NSMutableArray *)cellsArray {
    if (_cellsArray == nil) {
        _cellsArray = [NSMutableArray array];
        for (NSInteger i=0; i < 20; i ++) {
            XXTradeCell *cell = [[XXTradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.priceDigit = [KDecimal scale:KDetail.symbolModel.minPricePrecision];
            cell.numberDigit = KDetail.numberDigit;
            [_cellsArray addObject:cell];
        }
    }
    return _cellsArray;
}

- (NSMutableArray *)modelsArray {
    if (_modelsArray == nil) {
        _modelsArray = [NSMutableArray array];
    }
    return _modelsArray;
}

- (void)dealloc {
    NSLog(@"==+==币对详情最新成交释放了");
    [KQuoteSocket cancelWebSocketSubscribeWithWebSocketModel:self.webModel];
}
@end
