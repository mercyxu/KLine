//
//  BTTargetView.m
//  Bitbt
//
//  Created by Ruiec on 2019/7/1.
//  Copyright © 2019 www.ruiec.cn. All rights reserved.
//

#import "BTTargetView.h"

@interface BTTargetView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *Table;

@property (strong, nonatomic) UIView *headerView_0;
@property (strong, nonatomic) UIView *headerView_1;
@property (strong, nonatomic) UIView *footerView_0;
@property (strong, nonatomic) UIView *footerView_1;

@property (strong, nonatomic) NSMutableArray *array;
@property (assign, nonatomic) NSInteger selectRow_0;
@property (assign, nonatomic) NSInteger selectRow_1;
@property (strong, nonatomic) UIButton *hiddenBtn_0;
@property (strong, nonatomic) UIButton *hiddenBtn_1;

@end

#pragma mark - BTTargetView
@implementation BTTargetView

+ (BTTargetView *)GetTargetView_Frame:(CGRect)frame
{
    BTTargetView *view = [[BTTargetView alloc] initWithFrame:frame];
    [view initialize];
    
    return view;
}

#pragma mark - initialize
- (void)initialize
{
    self.backgroundColor = RGBA(0.05, 0.09, 0.14, 1);//R:0.05 G:0.09 B:0.14 A:1
    self.array = [NSMutableArray array];
    [self.array addObject:@[@"MA",@"EMA",@"BOLL"]];
    [self.array addObject:@[@"MACD",@"KDJ",@"RSI",@"WR"]];
    self.selectRow_0 = 0;
    self.selectRow_1 = 0;
    
    self.Table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 32) style:UITableViewStyleGrouped];
    [self addSubview:self.Table];
    self.Table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.Table.backgroundColor = [UIColor clearColor];
    self.Table.delegate = self;
    self.Table.dataSource = self;
    [self.Table registerClass:[BTTargetViewCell class] forCellReuseIdentifier:@"BTTargetViewCell"];
    
    [self.Table reloadData];
    
    UIButton *image = [UIButton new];
    [image setImage:IMAGE_NAMED(@"kline_more") forState:UIControlStateNormal];
    [self addSubview:image];
    image.backgroundColor = self.backgroundColor;
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.Table.mas_bottom);
    }];
}

-(UIView *)headerView_0
{
    if (!_headerView_0) {
        _headerView_0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        UIView *view = _headerView_0;
        UILabel *label = [[UILabel alloc] init];
        label.font = FONT_WITH_SIZE(12);
        [_headerView_0 addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGB(23,100,178);
        label.text = BTLanguage(@"主图");
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(view);
        }];
    }
    return _headerView_0;
}

-(UIView *)headerView_1
{
    if (!_headerView_1) {
        _headerView_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        UIView *view = _headerView_1;
        UILabel *label = [[UILabel alloc] init];
        label.font = FONT_WITH_SIZE(12);
        [_headerView_1 addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = RGB(23,100,178);
        label.text = BTLanguage(@"副图");
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(view);
        }];
    }
    return _headerView_1;
}

-(UIView *)footerView_0
{
    if (!_footerView_0) {
        _footerView_0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        UIView *view = _footerView_0;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerView_0 addSubview:btn];
        [btn setImage:IMAGE_NAMED(@"line_see") forState:UIControlStateNormal];
        [btn setImage:IMAGE_NAMED(@"line_seeNot") forState:UIControlStateSelected];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(view);
        }];

        self.hiddenBtn_0 = btn;
    }
    return _footerView_0;
}

-(UIView *)footerView_1
{
    if (!_footerView_1) {
        _footerView_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        UIView *view = _footerView_1;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerView_1 addSubview:btn];
        [btn setImage:IMAGE_NAMED(@"line_see") forState:UIControlStateNormal];
        [btn setImage:IMAGE_NAMED(@"line_seeNot") forState:UIControlStateSelected];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(view);
        }];

        [btn addTapBlock:^(UIButton *btn) {
            [btn setSelected:YES];
            [self hiddenClick_1:btn.isSelected];
        }];
        self.hiddenBtn_1 = btn;
    }
    return _footerView_1;
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.headerView_0.frame.size.height;
    }else if (section == 1){
        return self.headerView_1.frame.size.height;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.headerView_0;
    }else if (section == 1){
        return self.headerView_1;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return self.footerView_0.frame.size.height;
    }else if (section == 1){
        return self.footerView_0.frame.size.height;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return self.footerView_0;
    }else if (section == 1){
        return self.footerView_1;
    }
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.array[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTTargetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTTargetViewCell"];
    NSArray *arr = self.array[indexPath.section];
    NSString *title = arr[indexPath.row];
    [cell.titleBtn setTitle:title forState:UIControlStateNormal];
    [cell.titleBtn setTitle:title forState:UIControlStateSelected];
    if (indexPath.section == 0) {
        if (indexPath.row == self.selectRow_0) {
            [cell.titleBtn setSelected:YES];
        }else{
            [cell.titleBtn setSelected:NO];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == self.selectRow_1) {
            [cell.titleBtn setSelected:YES];
        }else{
            [cell.titleBtn setSelected:NO];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    if (indexPath.section == 0) {
        self.selectRow_0 = indexPath.row;
        [self.hiddenBtn_0 setSelected:NO];
    }else if (indexPath.section == 1){
        self.selectRow_1 = indexPath.row;
        [self.hiddenBtn_1 setSelected:NO];
    }
    
    [tableView reloadData];
    
    [self update_Section:indexPath.section Row:indexPath.row];
}

- (void)hiddenClick_0:(BOOL)isHidden
{
    self.selectRow_0 = -1;
    [self.Table reloadData];
    [self update_Section:0 Row:self.selectRow_0];
}

- (void)hiddenClick_1:(BOOL)isHidden
{
    self.selectRow_1 = -1;
    [self.Table reloadData];
    [self update_Section:1 Row:self.selectRow_1];
}

- (void)update_Section:(NSInteger)section Row:(NSInteger)row
{
//    ZK_LOG_Integer(self.selectRow_0);
//    ZK_LOG_Integer(self.selectRow_1);
//    ZK_LOG_Bool(self.hiddenBtn_0.isSelected);
//    ZK_LOG_Bool(self.hiddenBtn_1.isSelected);
    if (self.selectBlock) {
        self.selectBlock(section, row, @"");
    }
}

@end

#pragma mark - BTTargetViewCell
@interface BTTargetViewCell ()

@end

@implementation BTTargetViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = FONT_WITH_SIZE(10);
        [self addSubview:btn];
        self.titleBtn = btn;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(23,100,178) forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
    }
    
    return self;
}

@end
