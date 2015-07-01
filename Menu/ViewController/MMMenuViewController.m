//
//  MMMenuViewController.m
//  Manito
//
//  Created by manito on 15/5/4.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMMenuViewController.h"
#import "MMSettingViewController.h"
#import "RESideMenu.h"
#import "MMInfoViewController.h"
#import "MMSetInfoViewController.h"
#import "MMMenuTableViewCell.h"
#import "MMNearFriendViewController.h"
#import "MMMyDataViewController.h"
#import "MMPerson.h"
#import "MMInfoModel.h"
#import "MMAddFriendViewController.h"

@interface MMMenuViewController () {
    UIImageView * iconIV;
    UILabel     * nameLab;
    NSArray     * dataArr;
    MMPerson    *personModel;
    FBKVOController *fbKVO;
    MMInfoModel *infoModel;
}

@end

@implementation MMMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(name:) name:@"name" object:nil];
}

- (void)name:(NSNotification *)text {
    nameLab.text = text.userInfo[@"name"];
}

- (void)tongzhi:(NSNotification *)text {
    [iconIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:text.userInfo[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"head_friend list photo"]];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor clearColor];
    iconIV = [UIImageView newAutoLayoutView];
    [self.view addSubview:iconIV];
    iconIV.userInteractionEnabled = YES;
    [iconIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70];
    [iconIV autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:31];
    [iconIV autoSetDimensionsToSize:CGSizeMake(96 , 96)];
    iconIV.layer.cornerRadius = 96/2;
    [iconIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:[MMUserDefaultTool objectForKey:MMAvatar]]] placeholderImage:[UIImage imageNamed:@"head_friend list photo"]];
    iconIV.clipsToBounds = YES;
    [iconIV bk_whenTapped:^{
        UINavigationController *nav = (UINavigationController *)self.sideMenuViewController.contentViewController;
        MMMyDataViewController *myData = [[MMMyDataViewController alloc] init];
        myData.showNavi = YES;
        myData.type = @"menu";
        [nav pushViewController:myData animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }];
    
    nameLab = [UILabel newAutoLayoutView];
    [self.view addSubview:nameLab];
    [nameLab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:iconIV withOffset:10];
    [nameLab autoAlignAxis:ALAxisVertical toSameAxisOfView:iconIV];
    nameLab.text = [MMUserDefaultTool objectForKey:MMName];
    nameLab.textColor = [UIColor whiteColor];

    self.mTableview = [UITableView newAutoLayoutView];
    [self.view addSubview:self.mTableview];
    [self.mTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.mTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:110];
    [self.mTableview autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nameLab withOffset:30];
    [self.mTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    self.mTableview.scrollEnabled                  = NO;
    self.mTableview.delegate                       = (id<UITableViewDelegate>)self;
    self.mTableview.dataSource                     = (id<UITableViewDataSource>)self;
    self.mTableview.tableFooterView                = [[UIView alloc] init];
    self.mTableview.showsVerticalScrollIndicator   = NO;
    self.mTableview.showsHorizontalScrollIndicator = NO;
    self.mTableview.backgroundColor                = [UIColor clearColor];
    self.mTableview.separatorStyle                 = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)createData {
    dataArr = @[@"我的资料", @"添加好友", @"同城好友", @"配置"];
}

#pragma mark tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KKScreenWith*60/320;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MMMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MMMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    NSArray *imageArr = @[@"icon_profile.png", @"icon_add friend.png", @"icon_location.png", @"icon_setting.png"];
    cell.titleLab.text = dataArr[indexPath.row];
    cell.iconIV.image = [UIImage imageNamed:imageArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            UINavigationController *nav = (UINavigationController *)self.sideMenuViewController.contentViewController;
            MMInfoViewController *info = [[MMInfoViewController alloc] init];
            info.showNavi = YES;
            [nav pushViewController:info animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 1: {
            UINavigationController *nav = (UINavigationController *)self.sideMenuViewController.contentViewController;
            MMAddFriendViewController *addFriend = [[MMAddFriendViewController alloc] init];
            addFriend.showNavi = YES;
            [nav pushViewController:addFriend animated:YES];
            [self.sideMenuViewController hideMenuViewController];        }
            break;
        case 2: {
            UINavigationController *nav = (UINavigationController *)self.sideMenuViewController.contentViewController;
            MMNearFriendViewController *near = [[MMNearFriendViewController alloc] init];
            near.showNavi = YES;
            [nav pushViewController:near animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 3: {
#warning 修改地点
            //压入Controller
            UINavigationController *nav = (UINavigationController *)self.sideMenuViewController.contentViewController;
            MMSettingViewController *setting = [[MMSettingViewController alloc] init];
            setting.showNavi = YES;
            [nav pushViewController:setting animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
