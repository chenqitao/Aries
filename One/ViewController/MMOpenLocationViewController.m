//
//  MMOpenLocationViewController.m
//  Manito
//
//  Created by manito on 15/5/20.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMOpenLocationViewController.h"
#import "LocationNode.h"
#import "LocationInfoMapView.h"
#import "RRHTTPLive.h"
#import "SecurityUtil.h"

@interface MMOpenLocationViewController ()<LocationInfoMapViewDelegate>
{
    
}
@property (nonatomic, strong)NSMutableArray *locationArray;
@property (nonatomic, strong)LocationInfoMapView *mapView;

@end

@implementation MMOpenLocationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_close_slp"] style:UIBarButtonItemStylePlain target:self action:@selector(backDown)];
}

- (void)backDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createData {
    NSDictionary *parmars = @{@"x":_lot,@"y":_lat,@"from":@"0",@"to":@"2", @"mode":@"1"};
    [[RRHTTPLive sharedHTTPRequest]openAPIGetToMethod:@"/ag/coord/convert" parmars:parmars success:^(id responseObject) {
        NSString *x = [SecurityUtil decodeBase64String:responseObject[0][@"x"]];
        NSString *y = [SecurityUtil decodeBase64String:responseObject[0][@"y"]];
        [self initData:x andlot:y];
        [self initView];
    } fail:^(NSError *error) {
        [MBProgressHUD showWindowErrorThenHide:@"网络连接错误"];
    }];
}

- (void)initData:(NSString *)x andlot:(NSString *)y
{
    self.locationArray = [[NSMutableArray alloc] init];
    LocationNode *node1 = [[LocationNode alloc] init];
    node1.index = 1;
    node1.lng = [x doubleValue];
    node1.lat = [y doubleValue];
    [self.locationArray addObject:node1];
}

- (void)initView
{
    self.mapView = [[LocationInfoMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.mapView showAnnotation:self.locationArray];
    [self.mapView makeAnnotationCenter:[self.locationArray firstObject]];
    [self.view addSubview:self.mapView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
