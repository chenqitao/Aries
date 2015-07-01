//
//  MMBaseViewController.m
//  Manito
//
//  Created by Johnny on 15/4/27.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMBaseViewController.h"
#import "MMOneViewController.h"

@interface MMBaseViewController ()

@end

@implementation MMBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUpUIWithTableOrNot:NO];
    }
    return self;
}

- (id)initWithTableviewOrNot:(BOOL)haveTableview
{
    self = [super init];
    if (self) {
        [self setUpUIWithTableOrNot:haveTableview];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setUpUIWithTableOrNot:NO];
    }
    return self;
}

- (void)setUpUIWithTableOrNot:(BOOL)haveTableview
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _haveBack = YES;
    _showNavi = YES;
    
    if (haveTableview) {
        _mTableview = [UITableView newAutoLayoutView];
        [self.view addSubview:_mTableview];
        [_mTableview autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        _mTableview.delegate = (id<UITableViewDelegate>)self;
        _mTableview.dataSource = (id<UITableViewDataSource>)self;
        _mTableview.tableFooterView = [[UIView alloc] init];
        _mTableview.showsVerticalScrollIndicator = NO;
        _mTableview.showsHorizontalScrollIndicator = NO;
        _mTableview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_haveBack) {//默认有返回按钮
        
        self.navigationItem.leftBarButtonItem = [self itemWithImage:[UIImage imageNamed:@"back.png"] action:^(id sender) {
            [self returnBtnTapped:sender];
        }];
    }
    if (_showNavi) {//默认展示导航条
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [self createData];
    [self createUI];

 

}

- (void)returnBtnTapped:(id)sender {
    [self popNavigationer];
}

//返回键
- (void)returnBackMain:(id)sender {
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back
{
    [self presentLeftMenuViewController:self];
    [self.sideMenuViewController setContentViewController:[[MMOneViewController alloc] init] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)createUI
{
    
}

- (void)createData
{
    
}


- (void)pushNavigationerToController:(MMBaseViewController *)controller {
    UINavigationController *nav = self.navigationController;
    if (controller.showNavi && nav.navigationBarHidden) {
        [nav setNavigationBarHidden:NO animated:NO];
    } else if (!controller.showNavi && !nav.navigationBarHidden) {
        [nav setNavigationBarHidden:YES animated:NO];
    }
    [nav pushViewController:controller animated:YES];
}

- (void)popNavigationer {
    UINavigationController *nav = self.navigationController;
    NSArray *arr = nav.childViewControllers;
    if (arr.count > 1) {
        UIViewController *viewcontroller = [arr objectAtIndex:arr.count-2];
        if ([viewcontroller isKindOfClass:[MMBaseViewController class]]) {
            if (nav.navigationBarHidden && ((MMBaseViewController *)viewcontroller).showNavi) {
                [nav setNavigationBarHidden:NO animated:NO];
            } else if (!nav.navigationBarHidden && !((MMBaseViewController *)viewcontroller).showNavi) {
                [nav setNavigationBarHidden:YES animated:NO];
            }
        }
    }
    [nav popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
