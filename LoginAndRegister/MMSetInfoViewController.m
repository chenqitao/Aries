//
//  MMSetInfoViewController.m
//  Manito
//
//  Created by manito on 15/5/14.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMSetInfoViewController.h"
#import "MMOneViewController.h"
#import "MMMenuViewController.h"
#import "RESideMenu.h"
#import "PhoneBookTools.h"
#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"

@interface MMSetInfoViewController ()<UIScrollViewDelegate, DBCameraViewControllerDelegate, UITextFieldDelegate>

{
    UIScrollView *scrollView;
    UIImageView  *leftView;   //左边的背景
    UIImageView  *centerView; //中间的背景
    UIImageView  *rightView;  //右边的背景
    UIImageView  *iconIV;     //设置头像
    UIImageView  *sexIV;      //设置性别
    UIButton     *nextBtn;    //马上开始
    BOOL select;              //选择性别
    UITextField  *nametext;   //设置名字
    UIButton *skip1;
    UIButton *skip2;
    
}

@end

@implementation MMSetInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createUI {
    [self.view bk_whenTapped:^{
        [nametext resignFirstResponder];
    }];
    CGFloat height = KKScreenHeight;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWith, height)];
    [self.view addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    [scrollView setContentSize:CGSizeMake(KKScreenWith * 3, height)];
    scrollView.contentOffset = CGPointMake(0, 0);
    
    //左边的View
    leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWith, height)];
    [scrollView addSubview:leftView];
    leftView.userInteractionEnabled = YES;
    leftView.image = [UIImage imageNamed:@"guide page4_1-2"];

    iconIV = [UIImageView newAutoLayoutView];
    iconIV.userInteractionEnabled = YES;
    [leftView addSubview:iconIV];
    [iconIV autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:KKScreenHeight*409/1136];
    [iconIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:KKScreenWith*188/640];
    [iconIV autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:KKScreenWith*205/640];
    [iconIV autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:KKScreenHeight*480/1136];
    [iconIV autoSetDimensionsToSize:CGSizeMake(KKScreenWith*247/640, KKScreenWith*247/640)];
    iconIV.image = [UIImage imageNamed:@"head_guide page4_1-1.png"];
    iconIV.layer.cornerRadius = KKScreenWith*247/640/2;
    iconIV.clipsToBounds = YES;
    [iconIV bk_whenTapped:^{
        DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
        [cameraContainer setFullScreenMode];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
        [nav setNavigationBarHidden:YES];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    
//    skip1 = [UIButton newAutoLayoutView];
//    [leftView addSubview:skip1];
//    [skip1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:14];
//    [skip1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15];
//    [skip1 autoSetDimensionsToSize:CGSizeMake(29, 40)];
//    [skip1 setTitle:@"skip" forState:UIControlStateNormal];
//    skip1.titleLabel.font = [UIFont systemFontOfSize:14];
//    [skip1 setTitleColor:MMColor(251, 44, 75, 1) forState:UIControlStateNormal];
//    [skip1 bk_whenTapped:^{
//        HHDPRINT(@"马上开始");
//        [self nextViewPop];
//    }];
    
    //中间的View
    centerView = [[UIImageView alloc] initWithFrame:CGRectMake(KKScreenWith, 0, KKScreenWith, height)];
    [scrollView addSubview:centerView];
    centerView.userInteractionEnabled = YES;
    centerView.image = [UIImage imageNamed:@"guide page4_2-2"];
    
    nametext = [UITextField newAutoLayoutView];
    [centerView addSubview:nametext];
    [nametext autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:KKScreenWith*156/640];
    [nametext autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:KKScreenHeight*306/1136];
    [nametext autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:KKScreenWith*250/640];
    nametext.textAlignment = NSTextAlignmentCenter;
    nametext.font = [UIFont systemFontOfSize:20];
    nametext.text = @"名字";
    nametext.textColor = [UIColor whiteColor];
    nametext.delegate = (id<UITextFieldDelegate>)self;
    
    sexIV = [UIImageView newAutoLayoutView];
    [centerView addSubview:sexIV];
    sexIV.userInteractionEnabled = YES;
    [sexIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:KKScreenWith*76/640];
    [sexIV autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:KKScreenHeight*400/1136];
    sexIV.image = [UIImage imageNamed:@"man_guide page4_2"];
    select = NO;
    [sexIV bk_whenTapped:^{
        if (!select) {
            sexIV.image = [UIImage imageNamed:@"woman_guide page4_2"];
        } else {
            sexIV.image = [UIImage imageNamed:@"man_guide page4_2"];
        }
        select = !select;
    }];
    
//    skip2 = [UIButton newAutoLayoutView];
//    [centerView addSubview:skip2];
//    [skip2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
//    [skip2 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15];
//    [skip2 autoSetDimensionsToSize:CGSizeMake(100, 40)];
//    [skip2 setTitle:@"skip" forState:UIControlStateNormal];
//    skip2.titleLabel.font = [UIFont systemFontOfSize:12];
//    [skip2 setTitleColor:MMColor(251, 44, 75, 1) forState:UIControlStateNormal];
//    [skip2 bk_whenTapped:^{
//        HHDPRINT(@"马上开始");
//        [self nextViewPop];
//    }];
    
    //右边的View
    rightView = [[UIImageView alloc] initWithFrame:CGRectMake(KKScreenWith*2, 0, KKScreenWith, height)];
    [scrollView addSubview:rightView];
    rightView.userInteractionEnabled = YES;
    rightView.image = [UIImage imageNamed:@"guide page4_3-1"];
    
    nextBtn = [UIButton newAutoLayoutView];
    [rightView addSubview:nextBtn];
    [nextBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:28];
    [nextBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [nextBtn autoConstrainAttribute:ALAttributeWidth toAttribute:ALAttributeHeight ofView:nextBtn withMultiplier:280/85];
    [nextBtn autoSetDimension:ALDimensionHeight toSize:42];
    [nextBtn setTitle:@"马上开始" forState:UIControlStateNormal];
    nextBtn.backgroundColor = MMColor(251, 44, 75, 1);
    nextBtn.layer.cornerRadius = 10;
    nextBtn.clipsToBounds = YES;
    [nextBtn bk_whenTapped:^{
        
        if (nametext.text.length == 0 || [nametext.text isEqualToString:@"名字"]) {
            [MBProgressHUD showWindowMessageThenHide:@"姓名不能为空"];
            return;
        } else {
            [MBProgressHUD showWindowLoading:@"请稍后"];
            [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/api/user/modifyUserName.api" parmars:@{@"user_id": [MMUserDefaultTool objectForKey:MMUserID],@"nick_name":nametext.text}success:^(id responseObject) {
                if ([responseObject[@"obj"][@"data"] boolValue]) {
                    [MMUserDefaultTool setObject:nametext.text forKey:MMName];
                } else {
                    [MBProgressHUD showWindowErrorThenHide:@"用户名已存在"];
                    [nametext setText:nil];
                    [nametext resignFirstResponder];
                }
               
            } fail:^(NSError *error) {
                [MBProgressHUD showWindowMessageThenHide:error.localizedDescription];
            }];
        }
        
        NSString *gender = nil;
        if (select) {
            gender = @"0";
        } else {
            gender = @"1";
        }
        [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/api/user/modifyUserGender.api" parmars:@{@"user_id": [MMUserDefaultTool objectForKey:MMUserID], @"gender":gender}success:^(id responseObject) {
            [MBProgressHUD showWindowSuccessThenHide:@"个人信息设置成功"];
            [MMUserDefaultTool setObject:gender forKey:MMSex];
        } fail:^(NSError *error) {
            [MBProgressHUD showWindowErrorThenHide:error.localizedDescription];
        }];
        [self nextViewPop];
    }];
}

- (void)nextViewPop
{
    POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    basic.toValue = @(0.6);
    basic.duration = 0.5;
    basic.fromValue = @(0.8);
    [basic setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        if (finished) {
            MMOneViewController *one = [[MMOneViewController alloc] init];
            one.showNavi = NO;
            one.isFirst = @"Y";
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:one];
            MMMenuViewController *leftMenuViewController = [[MMMenuViewController alloc] init];
            RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:leftMenuViewController rightMenuViewController:nil];
            sideMenuViewController.backgroundImage = [UIImage imageNamed:@"BG_sbp"];
            [[AppDelegate shared].window setRootViewController:sideMenuViewController];
            [[AppDelegate shared].window setRootViewController:sideMenuViewController];
        }
        
    }];
    [self.view pop_addAnimation:basic forKey:@"hha"];
}

- (void)createData {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [nametext resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //只能输入6行
    NSInteger length = nametext.text.length;
    if (length >= 8  &&  string.length > 0) {
        [MBProgressHUD showWindowMessageThenHide:@"名字不能超过八个字符"];
        return  NO;
    }
    return YES;
}
#pragma mark - scroll delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

#pragma mark - camera delegate

- (void)camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    [MBProgressHUD showWindowLoading:@"正在更改头像"];
    [[MMHTTPRequest sharedHTTPRequest] requestPostWithApi:@"/api/upload/uploadUserLogo.api" andParams:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID],@"width":@"123",@"height":@"123",@"type":@"2"} andImage:image andSuccess:^(id responseObject) {
        [MBProgressHUD showWindowSuccessThenHide:@"头像更改成功"];
        [MMUserDefaultTool setObject:responseObject[@"obj"][@"logo_url"] forKey:MMAvatar];
        iconIV.image = image;
    } andfail:^(NSError *error) {
        [MBProgressHUD showWindowErrorThenHide:error.localizedDescription];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}

- (void)dismissCamera:(id)cameraViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}

@end
