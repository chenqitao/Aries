//
//  MMAddFriendViewController.m
//  Manito
//
//  Created by manito on 15/5/5.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMMyDataViewController.h"
#import "MMOneModel.h"

@interface  MMMyDataViewController ()<UINavigationControllerDelegate>
{
    UIImageView *iconIV;
    UILabel     *nameLab;
    UILabel     *infoLab;
    UIImageView *iconBJ;
    UIImageView *sexIV;
    UIButton    *followBtn;//关注按钮
    UILabel     *phoneLab;//☎️号码
}
@end

@implementation MMMyDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人主页";
}

- (void)createUI
{
    iconBJ = [UIImageView newAutoLayoutView];
    [self.view addSubview:iconBJ];
    [iconBJ autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
    [iconBJ autoSetDimension:ALDimensionWidth toSize:KKScreenWith];
    [iconBJ autoSetDimension:ALDimensionHeight toSize:KKScreenHeight*354/1136];
    iconBJ.image = [UIImage imageNamed:@"photo_fp"];
    
    iconIV = [UIImageView newAutoLayoutView];
    [iconBJ addSubview:iconIV];
    [iconIV autoAlignAxis:ALAxisVertical toSameAxisOfView:iconBJ withOffset:-1];
    [iconIV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:iconBJ withOffset:2];
    [iconIV autoSetDimensionsToSize:CGSizeMake(KKScreenWith*147/320, KKScreenWith*147/320)];
    
    if ([self.type isEqualToString:@"menu"]) {
        [iconIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:[MMUserDefaultTool objectForKey:MMAvatar]]] placeholderImage:[UIImage imageNamed:@"head_fp-1"]];
    } else {
        [iconIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:_oneModel.avatar]] placeholderImage:[UIImage imageNamed:@"head_fp-1"]];
    }
    iconIV.layer.cornerRadius = (KKScreenWith*147/320)/2;
    iconIV.clipsToBounds = YES;
    
    sexIV = [UIImageView newAutoLayoutView];
    [iconBJ addSubview:sexIV];
    [sexIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:KKScreenWith*68/320];
    [sexIV autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12];
    if ([self.type isEqualToString:@"menu"]) {
        if ([[MMUserDefaultTool objectForKey:MMSex] isEqualToString:@"1"]) {
            sexIV.image = [UIImage imageNamed:@"man_guide page4_2-1"];
        } else {
            sexIV.image = [UIImage imageNamed:@"woman_guide page4_2-1"];
        }
    } else {
        if ([[NSString stringWithFormat:@"%@",_oneModel.gender] isEqualToString:@"1"]) {
            sexIV.image = [UIImage imageNamed:@"man_guide page4_2-1"];
        } else {
            sexIV.image = [UIImage imageNamed:@"woman_guide page4_2-1"];
        }
    }
    [sexIV autoSetDimensionsToSize:CGSizeMake(19, 19)];
    
    nameLab = [UILabel newAutoLayoutView];
    [self.view addSubview:nameLab];
    [nameLab autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [nameLab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:iconBJ withOffset:30];
    [nameLab autoSetDimension:ALDimensionHeight toSize:40];
    [nameLab autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [nameLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont boldSystemFontOfSize:18.0f];
    if ([_type isEqualToString:@"menu"]) {
        nameLab.text = [MMUserDefaultTool objectForKey:MMName];
    } else {
        if (![_oneModel.userContacts[@"name"] isKindOfClass:[NSNull class]] && ![_oneModel.userContacts isKindOfClass:[NSNull class]] && _oneModel.userContacts != nil && _oneModel.userContacts[@"name"] != nil) {
        nameLab.text = [NSString stringWithFormat:@"%@(%@)",_oneModel.nick_name, _oneModel.userContacts[@"name"]];
        } else {
            nameLab.text = _oneModel.nick_name;
        }
    }
    
    if (![_type isEqualToString:@"menu"]){
        phoneLab = [UILabel newAutoLayoutView];
        [self.view addSubview:phoneLab];
        [phoneLab autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [phoneLab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nameLab withOffset:20];
        [phoneLab autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
        [phoneLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30];
        phoneLab.textAlignment = NSTextAlignmentCenter;
        phoneLab.font = [UIFont boldSystemFontOfSize:19.0f];
        phoneLab.text = _oneModel.userMobile[@"mobile"];
    }
    
    infoLab = [UILabel newAutoLayoutView];
    [self.view addSubview:infoLab];
    [infoLab autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [infoLab autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
    [infoLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30];
    infoLab.textAlignment = NSTextAlignmentCenter;
    infoLab.numberOfLines = 0;
    infoLab.font = [UIFont boldSystemFontOfSize:19.0f];
    if ([_type isEqualToString:@"menu"]) {
        infoLab.text = [MMUserDefaultTool objectForKey:MMtitle];
        [infoLab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nameLab withOffset:20];
    } else {
        if (![_oneModel.userProfile[@"title"] isKindOfClass:[NSNull class]]) {
            [infoLab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:phoneLab withOffset:20];
            infoLab.text = _oneModel.userProfile[@"title"];
        }
    }
    
    if (![_type isEqualToString:@"menu"] && [_oneModel.lid integerValue] != 100) {
        followBtn = [UIButton newAutoLayoutView];
        [self.view addSubview:followBtn];
        [followBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:30];
        [followBtn autoConstrainAttribute:ALAttributeWidth toAttribute:ALAttributeHeight ofView:followBtn withMultiplier:280/85];
        [followBtn autoSetDimension:ALDimensionHeight toSize:42];
        [followBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
        followBtn.layer.cornerRadius = 10;
        followBtn.clipsToBounds = YES;
        followBtn.backgroundColor = MMBaseColor;
        [followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [followBtn bk_whenTapped:^{
            [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/social/cancleFollow.api" parmars:@{@"from_userid":[MMUserDefaultTool objectForKey:MMUserID], @"to_userid":self.oneModel.user_id} success:^(id responseObject) {
                [self returnBtnTapped:nil];
                NSNotification *notification =[NSNotification notificationWithName:@"reloadData" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            } fail:^(NSError *error) {
                [MBProgressHUD showWindowMessageThenHide:@"取消关注失败"];
            }];
        }];
    }
}

- (void)createData
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
