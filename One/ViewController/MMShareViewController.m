//
//  MMShareViewController.m
//  Manito
//
//  Created by manito on 15/6/2.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMShareViewController.h"
#import "MMShareTableViewCell.h"
#import "MMShareModel.h"
#import "AudioTools.h"

@interface MMShareViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataSource;
    MMShareModel *shareModel;
}
@end

@implementation MMShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享好友";
    dataSource = [NSMutableArray array];
}

- (void)backDown {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_close_slp"] style:UIBarButtonItemStylePlain target:self action:@selector(backDown)];
    self.mTableview = [UITableView newAutoLayoutView];
    [self.view addSubview:self.mTableview];
    [self.mTableview autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.mTableview.delegate                       = (id<UITableViewDelegate>)self;
    self.mTableview.dataSource                     = (id<UITableViewDataSource>)self;
    self.mTableview.tableFooterView                = [[UIView alloc] init];
    self.mTableview.showsVerticalScrollIndicator   = NO;
    self.mTableview.showsHorizontalScrollIndicator = NO;
    self.mTableview.tableFooterView = [[UIView alloc] init];
}

- (void)createData {
    
    [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/api/user/getFriendList.api" parmars:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID]} success:^(id responseObject) {
        [dataSource removeAllObjects];
        NSArray *arr = responseObject[@"obj"][@"friendList"];
        for (NSDictionary *dic in arr) {
            shareModel = [MTLJSONAdapter modelOfClass:[MMShareModel class] fromJSONDictionary:dic error:nil];
            [dataSource addObject:shareModel];
        }
        [self.mTableview reloadData];
        
    } fail:^(NSError *error) {
        [MBProgressHUD showWindowErrorThenHide:error.localizedDescription];
    }];
}

#pragma  mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MMShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MMShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    shareModel = dataSource[indexPath.row];
    [cell.iconIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:shareModel.avatar]] placeholderImage:[UIImage imageNamed:@"head_fp-1"]];
    cell.naemLab.text = shareModel.nick_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *URL = @"/message/sendContent.api";
    shareModel = dataSource[indexPath.row];
    NSDictionary *parmars = @{@"from_userid":[MMUserDefaultTool objectForKey:MMUserID],@"to_userid":shareModel.user_id, @"content":self.shareURL};
    [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:URL parmars:parmars success:^(id responseObject) {
        [[AudioTools shareplaySouldTools] playSould:@"message" ofType:@"wav"];
        [MBProgressHUD showWindowSuccessThenHide:@"分享成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } fail:^(NSError *error) {
        [MBProgressHUD showWindowErrorThenHide:@"发送失败"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
