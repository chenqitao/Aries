//
//  MMSettingViewController.m
//  Manito
//
//  Created by manito on 15/5/7.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMSettingViewController.h"
#import "MMAboutViewController.h"
#import "MMGifViewController.h"
#import "MMAgreementViewController.h"
#import "MMLoginViewController.h"
#import "TMCache.h"
#import "MMWelcomeViewController.h"

@interface MMSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *dataArr;
    UISwitch *sw;
}

@end

@implementation MMSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
}

- (void)createUI
{
    self.mTableview = [UITableView newAutoLayoutView];
    [self.view addSubview:self.mTableview];
    [self.mTableview autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.mTableview.delegate                       = (id<UITableViewDelegate>)self;
    self.mTableview.dataSource                     = (id<UITableViewDataSource>)self;
    self.mTableview.tableFooterView                = [[UIView alloc] init];
    self.mTableview.showsVerticalScrollIndicator   = NO;
    self.mTableview.showsHorizontalScrollIndicator = NO;
    self.mTableview.separatorInset                 = UIEdgeInsetsMake(0, 0, 0, 10);
    self.mTableview.backgroundColor                = [UIColor clearColor];
}

- (void)createData
{
    dataArr = @[@"给我们评分", @"关于我们", @"功能介绍", @"公开位置", @"用户协议", @"退出登陆"];
}

#pragma mark tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    UILabel *textLab = [UILabel newAutoLayoutView];
    [cell.contentView addSubview:textLab];
    [textLab autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [textLab autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
    textLab.text = dataArr[indexPath.row];
    if (indexPath.row == 5) {
        UIImageView *loginOut = [UIImageView newAutoLayoutView];
        [cell.contentView addSubview:loginOut];
        [loginOut autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [loginOut autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [loginOut autoSetDimensionsToSize:CGSizeMake(22, 21)];
        loginOut.image = [UIImage imageNamed:@"icon_exit_sp"];
    }
    (indexPath.row  == 5 || indexPath.row == 3) ? (cell.accessoryType = UITableViewCellAccessoryNone) : (cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator);
    if (indexPath.row == 3) {
        sw = [UISwitch newAutoLayoutView];
        [cell.contentView addSubview:sw];
        [sw autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [sw autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [[MMUserDefaultTool objectForKey:MMLoction] integerValue] == 0 ? (sw.on = YES) : (sw.on = NO);
        [sw addTarget:self action:@selector(swChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

- (void)swChanged:(id)sender {
    NSString *param = (sw.isOn ? @"0" : @"1");
    NSDictionary *parmer = @{@"user_id":[MMUserDefaultTool objectForKey:MMUserID], @"param":param, @"type":@"0"};
    [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/api/user/modifyUserControlInfo.api" parmars:parmer success:^(id responseObject) {
        [MMUserDefaultTool setObject:param forKey:MMLoction];
    } fail:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/genre/ios/id36?mt=8"]];
        }
            break;
        case 1: {//关于我们
            MMAboutViewController *about = [[MMAboutViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
        case 2: {//功能介绍
            MMGifViewController *gif = [[MMGifViewController alloc] init];
            [self presentViewController:gif animated:YES completion:nil];
        }
            break;
        case 3: {//位置信息
        }
            break;
        case 4: {//用户协议
            MMAgreementViewController *agreement = [[MMAgreementViewController alloc] init];
            [self.navigationController pushViewController:agreement animated:YES];
        }
            break;
        case 5: {
            MMWelcomeViewController *welcome = [[MMWelcomeViewController alloc] init];
            welcome.showNavi = NO;
            welcome.haveBack = NO;
            welcome.type = @"login";
            [[AppDelegate shared].window setRootViewController:welcome];
            [MMUserDefaultTool removeObjectForKey:MMToken];
            [[TMCache sharedCache] removeAllObjects]; //清除所有缓存数据
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
