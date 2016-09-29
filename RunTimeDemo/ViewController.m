//
//  ViewController.m
//  RunTimeDemo
//
//  Created by tunsuy on 11/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "ViewController.h"
#import "Man.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 150, [UIScreen mainScreen].bounds.size.width-40, 50)];
    btn.layer.cornerRadius = 20;
    [btn setTitle:@"iOS接口测试" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(startCall:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)startCall:(UIButton *)btn {
    Man *man = [[Man alloc] init];
    [man eat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
