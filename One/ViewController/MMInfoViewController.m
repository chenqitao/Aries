//
//  MMAddFriendViewController.m
//  Manito
//
//  Created by manito on 15/5/5.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMInfoViewController.h"
#import "MMInfoTableViewCell.h"
#import "MMModifyViewController.h"
#import "Pesontools.h"
#import "MMInfoModel.h"
#import <TMCache.h>

#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"

@interface MMInfoViewController ()<UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, DBCameraViewControllerDelegate>
{
    UIImageView        *iconIV;
    UITextField        *hideText;
    NSArray            *titleArr;       //标题数组
    NSArray            *placeHolderArr; //提示语数组
    NSArray            *iconArr;
}
@end

@implementation MMInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
}

- (void)createUI {
    iconIV = [UIImageView newAutoLayoutView];
    [self.view addSubview:iconIV];
    iconIV.userInteractionEnabled = YES;
    [iconIV autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [iconIV autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:KKScreenWith*67/640];
    [iconIV autoSetDimensionsToSize:CGSizeMake(KKScreenWith*288/640, KKScreenWith*288/640)];
    iconIV.layer.cornerRadius = KKScreenWith*288/640/2;
    iconIV.layer.borderWidth = 7.0f;
    iconIV.backgroundColor = MMBaseColor;
    iconIV.layer.borderColor = [MMColor(251, 44, 74, 1) CGColor];
    iconIV.clipsToBounds = YES;
    //点击更换头像
    [iconIV bk_whenTapped:^{
        //---------------------------调取相机--------------------------//
        DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:(id<DBCameraViewControllerDelegate>)self];
        [cameraContainer setFullScreenMode];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
        [nav setNavigationBarHidden:YES];
        [self presentViewController:nav animated:YES completion:nil];
        //---------------------------调取相机--------------------------//
    }];
    
    self.mTableview = [UITableView newAutoLayoutView];
    [self.view addSubview:self.mTableview];
    [self.mTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.mTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.mTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.mTableview autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:iconIV withOffset:20];
    self.mTableview.delegate = (id<UITableViewDelegate>)self;
    self.mTableview.dataSource = (id<UITableViewDataSource>)self;
    self.mTableview.showsVerticalScrollIndicator = NO;
    self.mTableview.showsHorizontalScrollIndicator = NO;
    self.mTableview.tableFooterView = [[UIView alloc] init];
}

- (void)createData
{
    iconArr = @[@"icon_user_pg.png", @"icon_call_pg.png", @"icon_friends_pg.png", @"icon_read_pg.png"];
    titleArr = @[@"姓名", @"电话", @"性别", @"个性签名"];
    placeHolderArr = @[@"修改一个洋气的名字，让大家记住你", @"", @"选择您的性别", @" "];
        [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/api/user/selectUserInfo.api" parmars:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID]} success:^(id responseObject) {
            NSDictionary *dic = responseObject[@"obj"][@"userInfo"];
            NSDictionary *dic2 = responseObject[@"obj"][@"userInfo"][@"userProfile"];
            _infoModel = [MTLJSONAdapter modelOfClass:[MMInfoModel class] fromJSONDictionary:dic error:nil];
            _titleModel = [MTLJSONAdapter modelOfClass:[MMTitleModel class] fromJSONDictionary:dic2 error:nil];
            [iconIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:_infoModel.avatar]] placeholderImage:[UIImage imageNamed:@"head_fp-1"]];
            [self.mTableview reloadData];
        } fail:^(NSError *error) {
            [MBProgressHUD showWindowErrorThenHide:@"个人信息获取失败"];
        }];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        static NSString *identifier = @"detailCell";
        MMInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MMInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [self configureCell:cell withIndexPath:indexPath];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
        return height;
    } else {
        return KKScreenWith*60/320;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"detailCell";
    MMInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MMInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1: {
            break;
        } case 2: {
            [self selectSex];
            break;
        }
        default: {
            MMModifyViewController *modify = [[MMModifyViewController alloc] init];
            modify.titleStr = [titleArr objectAtIndex:indexPath.row];
            modify.infoStr = [self personModelStrWithIndexPath:indexPath];
            modify.placeholder = [placeHolderArr objectAtIndex:indexPath.row];
            [self configuremofify:modify withIndexPath:indexPath];
            [self.navigationController pushViewController:modify animated:YES];
        }
            break;
    }
}

- (void)configureCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    MMInfoTableViewCell *TextCell = (MMInfoTableViewCell *)cell;
    TextCell.iconIV.image = [UIImage imageNamed:iconArr[indexPath.row]];
    if (indexPath.row!= 2) {
        TextCell.text.text = [self personModelStrWithIndexPath:indexPath];
    } else {
        TextCell.accessoryType = UITableViewCellAccessoryNone;
        if ([[NSString stringWithFormat:@"%@",_infoModel.gender] isEqualToString:@"0"]) {
            TextCell.text.text = @"女";
        } else {
            TextCell.text.text = @"男";
        }
    }
}

- (void)configuremofify:(MMModifyViewController *)controller withIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            controller.type = ModifyTypeName;
            controller.competeBlock = ^(NSString * str) {
                _infoModel.nick_name = str;
                [MMUserDefaultTool setObject:str forKey:MMName];
                NSDictionary *dic = @{@"name":str};
                NSNotification *notification =[NSNotification notificationWithName:@"name" object:nil userInfo:dic];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [self.mTableview reloadData];
            };
        }
            break;
        case 1: {
            
        }
            break;
        case 2: {
            
        }
             break;
        case 3: {
            controller.type = ModifyTypeTitle;
            controller.competeBlock = ^(NSString * str) {
                _titleModel.title = str;
                [MMUserDefaultTool setObject:str forKey:MMtitle];
                [self.mTableview reloadData];
            };
        }
            break;
        default:
            break;
    }
}

- (NSString *)personModelStrWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = @"";
    switch (indexPath.row) {
        case 0: {
            str = _infoModel.nick_name;
        }
            break;
        case 1: {
            str = _infoModel.userMobile[@"mobile"];
        }
            break;
        case 2: {
        }
            break;
        case 3: {
            str = (_titleModel.title && [_titleModel.title length]) ? _titleModel.title : @"     "; //解决空字符串的高度问题;
        }
            break;
        default:
            break;
    }
    return str;
}

#pragma  mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)selectSex
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"请选择性别" delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"♂男", @"♀女", nil];
    action.actionSheetStyle = UIActionSheetStyleAutomatic;
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
   NSString *reqStr = @"/api/user/modifyUserGender.api";
    switch (buttonIndex) {
        case 0: {
            NSLog(@"男");
            [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:reqStr parmars:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID], @"gender":@"1"} success:^(id responseObject) {
                _infoModel.gender = @"1";
                [MMUserDefaultTool setObject:@"1" forKey:MMSex];
                [self.mTableview reloadData];
            } fail:^(NSError *error) {
                
            }];
            break;
        }
        case 1: {
            NSLog(@"女");
            [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:reqStr parmars:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID], @"gender":@"0"} success:^(id responseObject) {
                _infoModel.gender = @"0";
                [MMUserDefaultTool setObject:@"0" forKey:MMSex];
                [self.mTableview reloadData];
            } fail:^(NSError *error) {
                
            }];
            break;
        }
    }
}

#pragma mark - 相机代理方法

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata {
    
//获取图片宽高
    NSString *width = [NSString stringWithFormat:@"%d",(int)image.size.width];
    NSString *hight = [NSString stringWithFormat:@"%d",(int)image.size.height];
    
    [[MMHTTPRequest sharedHTTPRequest] requestPostWithApi:@"/api/upload/uploadUserLogo.api" andParams:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID],@"width":width,@"height":hight,@"type":@"2"} andImage:image andSuccess:^(id responseObject) {
        HHDPRINT(@"成功");
        iconIV.image = image;
        [MMUserDefaultTool setObject:responseObject[@"obj"][@"logo_url"] forKey:MMAvatar];
        
        NSDictionary *dic = @{@"avatar":responseObject[@"obj"][@"logo_url"]};
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dic];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    } andfail:^(NSError *error) {
        HHDPRINT(@"%@",error.localizedDescription);
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}

- (void) dismissCamera:(id)cameraViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}

@end
