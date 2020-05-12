//
//  XXListTableViewController.m
//  Bhex
//
//  Created by Bhex on 2018/9/10.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXListTableViewController.h"
//frame layout
static CGFloat const TitleLabelHeight = 56;

@interface XXListTableViewController ()

@end

@implementation XXListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)createNavigation {
    
    [super createNavigation];
    self.navView.height = kNavBigHeight;
    
    self.titleLabel.frame = CGRectMake(K375(24), kStatusBarHeight + 63, K375(300), TitleLabelHeight);
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:24];
    
    self.navLineView.frame = CGRectMake(K375(24), self.navView.height - 1, kScreen_Width - K375(24), 1);
    self.navLineView.hidden = NO;
    
    [self.view addSubview:self.tableView];
}

#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float offetY = scrollView.contentOffset.y + kNavBigHeight;
    if (offetY >= 51) {
        self.titleLabel.left = K375(64);
        self.titleLabel.top = kStatusBarHeight + 12;
        self.titleLabel.font = kFontBold18;
        self.navView.height = kStatusBarHeight + 68;
    } else if (offetY >= 0) {
        self.titleLabel.left = K375(24) + K375(64 - 24)*(offetY/51);
        self.titleLabel.top = kStatusBarHeight + 63 - offetY;
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:24.0 - 6.0*(offetY/51)];
        self.navView.height = kStatusBarHeight + 68 + (kNavBigHeight - kStatusBarHeight - 68)*(1 -offetY/51);
    } else {
        self.titleLabel.left = K375(24);
        self.titleLabel.top = kStatusBarHeight + 63;
        self.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:24.0];
        self.navView.height = kNavBigHeight;
    }
    self.navLineView.top = self.navView.height - 1;
    if (offetY > kNavShadowHeight) {
        self.navLineView.alpha = 0;
        self.navView.layer.shadowOpacity = 1;
    } else {
        self.navView.layer.shadowOpacity = offetY/kNavShadowHeight;
        self.navLineView.alpha = 1 - offetY/kNavShadowHeight;
        
    }
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  nil;
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBColor(31, 32, 41);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(kNavBigHeight, 0, 0, 0);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
