//
//  XXListTableViewController.h
//  Bhex
//
//  Created by Bhex on 2018/9/10.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "BaseViewController.h"

@interface XXListTableViewController : BaseViewController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/**
 1. 表示图滚动事件
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end
