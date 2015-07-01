//
//  MMNearFriendViewController.m
//  Manito
//
//  Created by manito on 15/5/18.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMNearFriendViewController.h"
#import "MMNearTableViewCell.h"
#import "CoreImageTools.h"
#import "MMNearModel.h"
#import "MyLocation.h"
#import "TMCache.h"

@interface MMNearFriendViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    MMNearModel *nearModel;
    NSMutableArray *dataSource;
}

@property(nonatomic, copy) NSString *lon;
@property(nonatomic, copy) NSString *lat;

@end

@implementation MMNearFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"同城好友";
    dataSource = [NSMutableArray array];
}

- (void)createUI {
    self.mTableview = [UITableView newAutoLayoutView];
    [self.view addSubview:self.mTableview];
    [self.mTableview autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.mTableview.delegate = (id<UITableViewDelegate>)self;
    self.mTableview.dataSource = (id<UITableViewDataSource>)self;
    self.mTableview.showsVerticalScrollIndicator = NO;
    self.mTableview.showsHorizontalScrollIndicator = NO;
    self.mTableview.tableFooterView = [[UIView alloc] init];
}

#pragma mark - 获取当前经纬度
- (void)getToLoction {
    [[MyLocation shareMyLocation] getUserLocation:^(CLLocation *lo, NSError *error) {
        _lat = [NSString stringWithFormat:@"%f", lo.coordinate.latitude];
        _lon = [NSString stringWithFormat:@"%f", lo.coordinate.longitude];
        
            [MBProgressHUD showWindowLoading:@"正在获取好友列表"];
            [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/social/getFriendsInTheSameCity.api" parmars:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID], @"latitude":_lat, @"longitude":_lon, @"distance":@"999999"} success:^(id responseObject) {
                NSArray *arr = responseObject[@"obj"];
                for (NSDictionary *dic in arr) {
                    nearModel = [MTLJSONAdapter modelOfClass:[MMNearModel class] fromJSONDictionary:dic error:nil];
                    [dataSource addObject:nearModel];
                }
                [self.mTableview reloadData];
                [MBProgressHUD showWindowSuccessThenHide:@"好友列表获取成功"];
            } fail:^(NSError *error) {
                [MBProgressHUD showWindowMessageThenHide:@"列表获取失败"];
            }];
    } fail:^(NSString *file) {
        
    }];
}

- (void)createData {
    [self getToLoction];
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[TMCache sharedCache] objectForKey:MMNerData]) {
        dataSource = [[TMCache sharedCache] objectForKey:MMNerData];
        return [dataSource count];
    } else {
        return [dataSource count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MMNearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MMNearTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    nearModel = dataSource[indexPath.row];
    cell.naemLab.text = [NSString stringWithFormat:@"%@",nearModel.nick_name];
    if (nearModel.distance < 1) {
        cell.loctionLab.text = [NSString stringWithFormat:@"%.0fm",nearModel.distance*1000];
    } else {
        cell.loctionLab.text = [NSString stringWithFormat:@"%.2fkm",nearModel.distance];
    }
    [cell.iconIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:nearModel.avatar]] placeholderImage:[UIImage imageNamed:@"head_friend list photo"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
