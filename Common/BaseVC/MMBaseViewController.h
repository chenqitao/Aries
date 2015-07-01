//
//  MMBaseViewController.h
//  Manito
//
//  Created by Johnny on 15/4/27.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMHTTPRequest.h"
#import "OpenUDID.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "MMString.h"
#import "MBProgressHUD+Simple.h"

@interface MMBaseViewController : UIViewController

@property (nonatomic, assign) BOOL haveBack;//是否显示返回键
@property (nonatomic, assign) BOOL showNavi;//是否显示导航栏
@property (nonatomic, strong) UITableView *mTableview;


- (id)initWithTableviewOrNot:(BOOL)haveTableview;
- (void)returnBtnTapped:(id)sender;
- (void)createUI;//创建ui
- (void)createData;//请求数据
- (void)returnBackMain:(id)sender; //返回到主界面

//有导航栏需要调用的方法
- (void)pushNavigationerToController:(MMBaseViewController *)controller;
- (void)popNavigationer;

@end
