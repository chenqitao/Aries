//
//  MMAddFrienderViewController.m
//  Manito
//
//  Created by manito on 15/5/18.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMAddFriendViewController.h"
#import "MMOneViewController.h"
#import "MMAddFriendTableViewCell.h"
#import "CoreImageTools.h"
#import "MMAddModel.h"
#import "TMCache.h"
#import <MessageUI/MessageUI.h>
#import "ChineseString.h"
#import "pinyin.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "MMAddFriendTableViewCell.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface MMAddFriendViewController ()<UITableViewDelegate, UITableViewDataSource, MMAddFriendTableViewCellDelegate, MFMessageComposeViewControllerDelegate, UISearchBarDelegate>
{
    MMAddModel     *addModel;
    NSMutableArray *dataSource;//数据
    MFMessageComposeViewController *message;
    NSMutableArray *sectionHeadsKeys;//拼音
    NSMutableArray *array;
    
    NSMutableArray *searchResults;//搜索结果
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
    
    NSMutableArray *arrOne;
    NSMutableArray *arrTwo;
    NSMutableArray *arrThree;
}
@end

@implementation MMAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    dataSource    = [NSMutableArray array];
    array         = [NSMutableArray array];
}

- (void)createUI {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"微信邀请" style:UIBarButtonItemStylePlain target:self action:@selector(weChatInvitation)];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KKScreenWith, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索"];
    [self.view addSubview:mySearchBar];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    self.mTableview                                = [UITableView newAutoLayoutView];
    [self.view addSubview:self.mTableview];
    [self.mTableview autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(40, 0, 0, 0)];
    self.mTableview.delegate                       = (id<UITableViewDelegate>)self;
    self.mTableview.dataSource                     = (id<UITableViewDataSource>)self;
    self.mTableview.showsVerticalScrollIndicator   = NO;
    self.mTableview.showsHorizontalScrollIndicator = NO;
    self.mTableview.tableFooterView                = [[UIView alloc] init];
}

- (void)weChatInvitation {
    SendMessageToWXReq *sendMsg = [[SendMessageToWXReq alloc] init];
    sendMsg.text =  @"Touch YO，时刻分享！下载并添加我为好友。Less Touch, More Touching.  http://www.touchyo.com";
    sendMsg.bText = YES;
    [WXApi sendReq:sendMsg];
}

/*
 case 4: {//等待验证
 [cell.startBtn setImage:[UIImage imageNamed:@"icon_validation_fdp"] forState:UIControlStateNormal];
 }
 case 2: {//未确定   接受
 [cell.startBtn setImage:[UIImage imageNamed:@"icon_added_fdp"] forState:UIControlStateNormal];
 }
 break;
 case 1: {//非好友  关注
 [cell.startBtn setImage:[UIImage imageNamed:@"icon_add_fdp"] forState:UIControlStateNormal];
 }
 break;
 case 5: {//邀请
 [cell.startBtn setImage:[UIImage imageNamed:@"icon_invite"] forState:UIControlStateNormal];
 }

 */

- (void)createData {
    [dataSource removeAllObjects];
    [array removeAllObjects];
    arrOne = [NSMutableArray array];
    arrTwo = [NSMutableArray array];
    arrThree = [NSMutableArray array];
    
    [MBProgressHUD showWindowMessageThenHide:@"正在获取好友列表"];
    [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/social/getFriendsListWithStatus.api" parmars:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID]} success:^(id responseObject) {
        NSArray *arr = responseObject[@"obj"];
        for (NSDictionary *dic in arr) {
            addModel = [MTLJSONAdapter modelOfClass:[MMAddModel class] fromJSONDictionary:dic error:nil];
            switch (addModel.status) {
                case 2: {//接受邀请
                    [arrOne addObject:addModel];
                }
                    break;
                case 4: {//等待验证
                    [arrTwo addObject:addModel];
                }
                    break;
                case 1: {//关注
                    [arrThree addObject:addModel];
                }
                    break;
                case 5: {//邀请
                    [dataSource addObject:addModel];
                }
                    break;
                default:
                    break;
            }
        }
        
        
        [self getChineseStringArr:dataSource];
        [self.mTableview reloadData];
        if (arr.count == 0) {
            [[UIAlertView bk_showAlertViewWithTitle:@"通讯录被拒绝" message:@"开启通讯录可以获取更多好友\n请在设置－隐私－通讯录中进行设置" cancelButtonTitle:@"取消" otherButtonTitles:@[@"设置"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if(buttonIndex == 1) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }] show];
        } else {
            [MBProgressHUD showWindowSuccessThenHide:@"好友列表获取成功"];
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showWindowErrorThenHide:@"好友列表获取失败"];
    }];
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    } else {
        if (section == 0) {
            return arrOne.count;
        } else if (section == 1) {
            return arrTwo.count;
        } else if (section == 2) {
            return arrThree.count;
        } else {
            return [[array objectAtIndex:section-3] count];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return tableView == self.searchDisplayController.searchResultsTableView ? 1 :sectionHeadsKeys.count+3;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    return tableView == self.searchDisplayController.searchResultsTableView ? 0 :sectionHeadsKeys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        if (section == 0) {
            return arrOne.count ? @"接受" : @"";
        } else if (section == 1) {
            return arrTwo.count ? @"等待中" : @"";
        } else if (section == 2) {
            return arrThree.count ?  @"添加" : @"";
        } else {
            return [sectionHeadsKeys objectAtIndex:section-3];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MMAddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MMAddFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }  if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.addModel = searchResults[indexPath.row];
    } else {
        if(indexPath.section == 0) {
            cell.addModel = arrOne[indexPath.row];
        } else if (indexPath.section == 1) {
            cell.addModel = arrTwo[indexPath.row];
        } else if (indexPath.section == 2) {
            cell.addModel = arrThree[indexPath.row];
        } else {
            ChineseString *str = array[indexPath.section-3][indexPath.row];
            cell.addModel = str.info;
        }
    }
    cell.nameLab.text = cell.addModel.nick_name;
    [cell.iconIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:cell.addModel.avatar]] placeholderImage:[UIImage imageNamed:@"head_friend list photo"]];
    
    if (![cell.addModel.addressListName isKindOfClass:[NSNull class]] && cell.addModel.status != 5) {
        cell.phoneNameLab.text = cell.addModel.addressListName;
    } else {
        cell.phoneNameLab.text = @"";
    }
    switch (cell.addModel.status) {
        case 1: {//非好友  关注
            [cell.startBtn setImage:[UIImage imageNamed:@"icon_add_fdp"] forState:UIControlStateNormal];
        }
            break;
        case 2: {//未确定   接受
            [cell.startBtn setImage:[UIImage imageNamed:@"icon_added_fdp"] forState:UIControlStateNormal];
        }
            break;
        case 3: {//好友   取消关注
            [cell.startBtn setImage:[UIImage imageNamed:@"icon_refused_fdp"] forState:UIControlStateNormal];
        }
            break;
        case 4: {//等待验证
            [cell.startBtn setImage:[UIImage imageNamed:@"icon_validation_fdp"] forState:UIControlStateNormal];
        }
            break;
        case 5: {//邀请
            [cell.startBtn setImage:[UIImage imageNamed:@"icon_invite"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tappedAddFriendTableviewCellStartBtn:(MMAddFriendTableViewCell *)cell
{
    switch (cell.addModel.status) {
        case 1: {//非好友 关注   点击之后变成  好友 取消关注
            [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/social/follow.api" parmars:@{@"from_userid":[MMUserDefaultTool objectForKey:MMUserID], @"to_userid":cell.addModel.user_id} success:^(id responseObject) {
                cell.addModel.status = 4;
                [self.mTableview reloadData];
                NSNotification *notification =[NSNotification notificationWithName:@"reloadData" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            } fail:^(NSError *error) {
                [MBProgressHUD showWindowMessageThenHide:@"关注好友失败"];
            }];
        }
            break;
        case 2: {//未确定 接受   点击之后变成 好友 取消关注
            [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/social/reFollow.api" parmars:@{@"from_userid":[MMUserDefaultTool objectForKey:MMUserID], @"to_userid":cell.addModel.user_id} success:^(id responseObject) {
                
                [arrOne removeObjectAtIndex:[self.mTableview indexPathForCell:cell].row];
                [self.mTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self.mTableview indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationLeft];
                [self.mTableview reloadData];
                NSNotification *notification =[NSNotification notificationWithName:@"reloadData" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            } fail:^(NSError *error) {
                [MBProgressHUD showWindowMessageThenHide:@"关注好友失败"];
            }];
        }
            break;
        case 3: {//好友 取消关注   点击之后变成 非好友  关注
            [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/social/cancleFollow.api" parmars:@{@"from_userid":[MMUserDefaultTool objectForKey:MMUserID], @"to_userid":cell.addModel.user_id} success:^(id responseObject) {
                cell.addModel.status = 1;
                [self.mTableview reloadData];
                NSNotification *notification =[NSNotification notificationWithName:@"reloadData" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            } fail:^(NSError *error) {
                [MBProgressHUD showWindowMessageThenHide:@"取消关注失败"];
            }];
        }
            break;
        case 4: { //等待验证 此时不能点击
            
        }
            break;
        case 5: {//通讯录  不是本App用户 调短信
            message = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText]){//判断设备能否实现发短信功能
                [message setBody:@"TouchYO，时刻分享！下载并添加我为好友。Less Touch, More Touching.  http://www.touchyo.com"];//短信内容
                message.recipients = @[cell.addModel.mobileNumber];//接短信对象，是个数组
                message.messageComposeDelegate = (id<MFMessageComposeViewControllerDelegate>)self;//短信功能回调
                [self presentViewController:message animated:YES completion:nil];//将messageController设为第一视图
            }
            break;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];//将messageController移除
    if (result == MessageComposeResultCancelled) {//返回值为取消
        NSLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent) {//返回值为发出
        [MBProgressHUD showWindowMessageThenHide:@"好友邀请成功"];
    }
    else {//其他
        NSLog(@"Message failed");
    }
}

#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchResults = [[NSMutableArray alloc]init];
    if (mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i<dataSource.count; i++) {
            addModel = dataSource[i];
            if ([ChineseInclude isIncludeChineseInString:addModel.nick_name]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:addModel.nick_name];
                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:addModel];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:addModel.nick_name];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:addModel];
                }
            }
            else {
                NSRange titleResult = [addModel.nick_name rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:addModel];
                }
            }
        }
    } else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
            for (int i = 0; i < dataSource.count; i++) {
                addModel = dataSource[i];
                NSRange titleResult=[addModel.nick_name rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:addModel];
                }
        }
    }
}

//MARK: 拼音
- (void)getChineseStringArr:(NSMutableArray *)arrToSort{
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString = [[ChineseString alloc] init];
        addModel = arrToSort[i];
        chineseString.string = addModel.nick_name;
        //  添加一个属性.为名字对应的字典
        chineseString.info = arrToSort[i];
        
        if (chineseString.string == nil) {
            chineseString.string = @"";
        }
        
        if (![chineseString.string isEqualToString:@""]) {
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])] uppercaseString];
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex = NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    NSMutableArray *_sectionHeadsKeys = [NSMutableArray array];
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar = [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr = [strchar substringToIndex:1];
        NSString *regex = @"[0-9]";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([predicate evaluateWithObject:sr]) {
            sr = [sr stringByReplacingOccurrencesOfString:sr withString:@"#"];
        }
        
        if (![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [NSMutableArray array];
            checkValueAtIndex = NO;
        }
        if ([_sectionHeadsKeys containsObject:[sr uppercaseString]]) {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO) {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    sectionHeadsKeys = _sectionHeadsKeys;
    array = arrayForArrays;
    [self.mTableview reloadData];
}

@end
