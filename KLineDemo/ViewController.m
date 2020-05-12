//
//  ViewController.m
//  KLineDemo
//
//  Created by iOS on 2019/7/18.
//  Copyright © 2019 www.KlineDemo.com. All rights reserved.
//

#import "ViewController.h"
#import "XXBitcoinDetailVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 200, 100, 100);
    [btn setTitle:@"K线Demo" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(BitcoinDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)BitcoinDetail
{
    XXBitcoinDetailVC *vc = [[XXBitcoinDetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
