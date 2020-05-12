//
//  ViewController.m
//  KLineDemo
//
//  Created by iOS on 2019/7/18.
//  Copyright © 2019 www.KlineDemo.com. All rights reserved.
//

#import "ViewController.h"
#import "BTStockChartViewController.h"

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
    [self.view addSubview:btn];
    
    [btn addTapBlock:^(UIButton *btn) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[BTStockChartViewController alloc] init]];
         [self presentViewController:nav animated:YES completion:nil];
    }];

}


@end
