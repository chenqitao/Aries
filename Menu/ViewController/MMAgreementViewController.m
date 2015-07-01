//
//  MMAgreementViewController.m
//  Manito
//
//  Created by manito on 15/5/8.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMAgreementViewController.h"

@interface MMAgreementViewController ()
{
    UIWebView *web;
    NSString  *urlStr;
}

@end

@implementation MMAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
}

- (void)createNeWUI
{
    web = [UIWebView newAutoLayoutView];
    [self.view addSubview:web];
    [web autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [web loadRequest:request];
}

- (void)createData
{
    [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/official/statement/query.api" parmars:@{@"type":@"1"}success:^(id responseObject) {
        urlStr = [MMString photoStringWithSubString:responseObject[@"obj"]];
        [self createNeWUI];
        
    } fail:^(NSError *error) {
        [MBProgressHUD showWindowMessageThenHide:@"网络连接错误"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
