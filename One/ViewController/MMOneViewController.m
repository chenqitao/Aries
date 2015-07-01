//
//  OneViewController.m
//  Manito
//
//  Created by Johnny on 15/4/27.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMOneViewController.h"
#import "MMInfoViewController.h"
#import "MMFriendTableViewCell.h"
#import "SelectImageTools.h"
#import "MyLocation.h"
#import "MMOneModel.h"
#import "MMOpenLinkViewController.h"
#import "MMOpenLocationViewController.h"
#import "CoreImageTools.h"
#import "MMMyDataViewController.h"
#import "MMGifViewController.h"

#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"

#import "TMCache.h"
#import "AudioTools.h"
#import "MMNotiView.h"

typedef NS_ENUM(NSInteger, TappedType) {
    TypeTapped,
    TypeDouble,
    TypeLong,
    TypeCamera
};

@interface MMOneViewController ()<MMFriendTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, DBCameraViewControllerDelegate, MMNotiViewDelegate> {
    
    UIScrollView   * scroll;
    UITableView    * leftTableview;
    UIView         * navigation;
    UIImageView    * logoIV;
    UIImageView    * iconIV;
    MMOneModel     * oneModel; //MV模型
    NSArray        * cameraArr; //相机的图片
    NSArray        * bjArr;     //背景的图片
    NSMutableArray * dataSource; //数据
    UIImageView    * gif;
    MMNotiView     *notiView;  //弹框View
    
    NSDictionary   *NotiDic;   //公众号的数据
    NSString       *nameStr;
    NSString       *user_id;
    MMFriendTableViewCell *cameraCell;
}
@property (nonatomic, assign) TappedType type;
@property (nonatomic, copy  ) NSString   *lon;
@property (nonatomic, copy  ) NSString   *lat;

@end

@implementation MMOneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    notiView = [[MMNotiView alloc] initWithFrame:CGRectMake(0, -KKScreenWith*120/320, KKScreenWith, KKScreenWith*120/320)];
    [self.view addSubview:notiView];
    dataSource = [NSMutableArray array];
    [self setRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"reloadData" object:nil];
}

- (void)reloadData:(NSNotification *)text {
    [self loadNewData];
}

- (void)tongzhi:(NSNotification *)text
{
    [iconIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:text.userInfo[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"head_friend list photo"]];
}

- (void)setRefresh {
    // 添加动画图片的下拉刷新
    [leftTableview addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 隐藏时间
    leftTableview.header.updatedTimeHidden = YES;
    // 隐藏状态
    leftTableview.header.stateHidden = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 0; i<29; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading__00%d", i]];
        [idleImages addObject:image];
    }
    [leftTableview.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading__00%d", i]];
        [refreshingImages addObject:image];
    }
    [leftTableview.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
    
    // 马上进入刷新状态
//    [leftTableview.header beginRefreshing];
}

- (void)loadNewData {
    
    [[TMCache sharedCache] removeObjectForKey:MMOneData];
    [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/api/user/getFriendList.api" parmars:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID]} success:^(id responseObject) {
        [dataSource removeAllObjects];
        NSArray *arr = responseObject[@"obj"][@"friendList"];
        for (NSDictionary *dic in arr) {
            oneModel = [MTLJSONAdapter modelOfClass:[MMOneModel class] fromJSONDictionary:dic error:nil];
            [dataSource addObject:oneModel];
        }
        [self reloadTable];
        [[TMCache sharedCache] setObject:dataSource forKey:MMOneData block:nil];
    } fail:^(NSError *error) {
        [MBProgressHUD showWindowErrorThenHide:error.localizedDescription];
    }];
    // 拿到当前的下拉刷新控件，结束刷新状态
    [leftTableview.header endRefreshing];
}

- (void)createUI {
    
    navigation = [UIView newAutoLayoutView];
    [self.view addSubview:navigation];
    navigation.backgroundColor = [UIColor whiteColor];
    [navigation autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [navigation autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [navigation autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [navigation autoSetDimension:ALDimensionHeight toSize:84];
    
    logoIV = [UIImageView newAutoLayoutView];
    [navigation addSubview:logoIV];
    [logoIV autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:9];
    [logoIV autoAlignAxis:ALAxisHorizontal toSameAxisOfView:navigation withOffset:10];
    [logoIV autoConstrainAttribute:ALAttributeWidth toAttribute:ALAttributeHeight ofView:logoIV withMultiplier:222/37];
    [logoIV autoSetDimension:ALDimensionWidth toSize:KKScreenWith*222/640];
    logoIV.image = [UIImage imageNamed:@"LOGO.png"];
    
    iconIV = [UIImageView newAutoLayoutView];
    [navigation addSubview:iconIV];
    [iconIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:KKScreenWith*50/640];
    [iconIV autoAlignAxis:ALAxisHorizontal toSameAxisOfView:navigation withOffset:10];
    [iconIV autoSetDimensionsToSize:CGSizeMake(KKScreenWith*82/640, KKScreenWith*82/640)];
    iconIV.layer.cornerRadius = (KKScreenWith*82/640)/2;
    iconIV.layer.borderWidth  = 2.0;
    iconIV.backgroundColor = MMBaseColor;
    iconIV.layer.borderColor  = [MMColor(251, 44, 74, 1) CGColor];
    iconIV.clipsToBounds      = YES;
    [iconIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:[MMUserDefaultTool objectForKey:MMAvatar]]] placeholderImage:[UIImage imageNamed:@"head_main page"]];
    iconIV.userInteractionEnabled = YES;
    [iconIV bk_whenTapped:^{
        [self presentLeftMenuViewController:self];
    }];
    
    leftTableview = [UITableView newAutoLayoutView];
    [self.view addSubview:leftTableview];
    [leftTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [leftTableview autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:navigation withOffset:0];
    [leftTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [leftTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    leftTableview.delegate                       = (id<UITableViewDelegate>)self;
    leftTableview.dataSource                     = (id<UITableViewDataSource>)self;
    leftTableview.tableFooterView                = [[UIView alloc] init];
    leftTableview.showsVerticalScrollIndicator   = NO;
    leftTableview.showsHorizontalScrollIndicator = NO;
    leftTableview.separatorStyle                 = NO;
    
    if ([_isFirst isEqualToString:@"Y"]){
        gif = [UIImageView newAutoLayoutView];
        [self.view addSubview:gif];
        gif.userInteractionEnabled = YES;
        [gif autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:23];
        [gif autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
        [gif autoSetDimensionsToSize:CGSizeMake(102, 45)];
        gif.image = [UIImage imageNamed:@"icon_help_mp_new"];
        [gif bk_whenTapped:^{
            
            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            anim.toValue = [NSValue valueWithCGRect:CGRectMake(KKScreenWith-102-20, -45, 102, 45)];
            anim.duration = .3;
            [gif pop_addAnimation:anim forKey:@"gif"];
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    MMGifViewController *gifVC = [[MMGifViewController alloc] init];
                    [self.navigationController presentViewController:gifVC animated:YES completion:nil];
                    [gif removeFromSuperview];
                }
            }];
        }];
    }
}

- (void)createData {
    cameraArr = @[@"1.photo_red",@"2.photo_orange",@"3.photo_light orange",@"4.photo_yellow",@"5.photo_light green",@"6.photo_green"];
    bjArr = @[@"circle1_mp",@"circle2_mp",@"circle3_mp",@"circle4_mp",@"circle5_mp",@"circle6_mp"];
 
    [self getToLoction];
    if (![[TMCache sharedCache] objectForKey:MMOneData]) {//数据缓存
        [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/api/user/getFriendList.api" parmars:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID]} success:^(id responseObject) {
            [dataSource removeAllObjects];
            NSArray *arr = responseObject[@"obj"][@"friendList"];
            for (NSDictionary *dic in arr) {
                oneModel = [MTLJSONAdapter modelOfClass:[MMOneModel class] fromJSONDictionary:dic error:nil];
                [dataSource addObject:oneModel];
            }
            [self reloadTable];
            [[TMCache sharedCache] setObject:dataSource forKey:MMOneData block:nil];

        } fail:^(NSError *error) {
            [MBProgressHUD showWindowErrorThenHide:error.localizedDescription];
        }];
    }
}

- (void)createDataWithURL:(NSString *)URL withParmars:(NSDictionary *)parmars andTableViewCell:(MMFriendTableViewCell *)cell {
    [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:URL parmars:parmars success:^(id responseObject) {
        [[AudioTools shareplaySouldTools] playSould:@"message" ofType:@"wav"];
        [cell.loadingView stopAnimating];
        cell.nameLab.hidden = NO;
        switch (_type) {
            case TypeTapped: {
                HHDPRINT(@"单击");
                if ([cell.oneModel.lid integerValue] == 100) {
                    if (![responseObject[@"obj"] isKindOfClass:[NSNull class]]) {
                        NotiDic = responseObject[@"obj"];
                        nameStr = cell.oneModel.nick_name;
                        user_id=cell.oneModel.user_id;       //获取点击每一行公众号或者非公众号的id
                        notiView.frame = CGRectMake(0, 0, KKScreenWith, KKScreenWith*120/320);
                        notiView.infoLab.text = NotiDic[@"title"];
                        notiView.timeLab.text = @"刚刚";
                        [notiView.avatarIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:cell.oneModel.avatar]] placeholderImage:[UIImage imageNamed:@"head_main page"]];
                        notiView.delegate = self;
                        cell.oneModel.type = @"1";
                    } else {
                        [MBProgressHUD showWindowMessageThenHide:@"公众号没有最新消息"];
                        return ;
                    }
                }
                cell.nameLab.text   = @"已发送 Hi";
                cell.stateIV.hidden = NO;
                cell.stateIV.image  = [UIImage imageNamed:@"icon_wink_mainpage"];
                [self performSelector:@selector(topCell:) withObject:cell afterDelay:.7];
                [self performSelector:@selector(reloadTable) withObject:nil afterDelay:1];
                break;
            }
            case TypeDouble: {
                HHDPRINT(@"双击");
                cell.nameLab.text   = @"已发送";
                cell.stateIV.hidden = NO;
                cell.stateIV.image  = [UIImage imageNamed:@"icon_location_mainpage"];
                [self performSelector:@selector(topCell:) withObject:cell afterDelay:.7];
                [self performSelector:@selector(reloadTable) withObject:nil afterDelay:1];
                break;
            }
            case TypeLong: {
                HHDPRINT(@"长按");
                cell.nameLab.text   = @"已发送";
                cell.stateIV.hidden = NO;
                cell.stateIV.image  = [UIImage imageNamed:@"icon_link_mainpage"];
                [self performSelector:@selector(topCell:) withObject:cell afterDelay:.7];
                [self performSelector:@selector(reloadTable) withObject:nil afterDelay:1];
                break;
            }
            case TypeCamera: {
                cell.nameLab.text = @"图片发送成功";
                [self performSelector:@selector(topCell:) withObject:cell afterDelay:.7];
                [self performSelector:@selector(reloadTable) withObject:nil afterDelay:1];
            }
            default: {
                break;
            }
        }
    } fail:^(NSError *error) {
        [cell.loadingView stopAnimating];
        cell.nameLab.hidden = NO;
        cell.nameLab.text = cell.oneModel.nick_name;
        [MBProgressHUD showWindowErrorThenHide:@"发送失败"];
    }];
}

- (void)topCell:(MMFriendTableViewCell *)cell {
    [leftTableview moveRowAtIndexPath:[leftTableview indexPathForCell:cell] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [dataSource removeObject:cell.oneModel];
    [dataSource insertObject:cell.oneModel atIndex:0];

}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[TMCache sharedCache] objectForKey:MMOneData]) {
        dataSource = [[TMCache sharedCache] objectForKey:MMOneData];
        return [dataSource count];
    } else {
        return [dataSource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    MMFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MMFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    [self configureCell:cell withIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KKScreenWith*172/640;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    MMFriendTableViewCell *friendCell = (MMFriendTableViewCell *)cell;
    friendCell.oneModel                  = dataSource[indexPath.row];
    friendCell.nameLab.text              = friendCell.oneModel.nick_name;
    friendCell.stateIV.hidden            = YES;
    //公众号有最新消息的时显示图标
   ([friendCell.oneModel.lid integerValue] == 100 && [friendCell.oneModel.type integerValue] == 0 )? (friendCell.haveMessage.hidden = NO) : (friendCell.haveMessage.hidden = YES);
    [friendCell.iconIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:friendCell.oneModel.avatar]] placeholderImage:[UIImage imageNamed:@"head_friend list photo"]];
    friendCell.iconIV.clipsToBounds = YES;
    friendCell.contentMode = UIViewContentModeScaleAspectFit;
    //点击头像跳转到MMMyData页面
    [friendCell.iconIV bk_whenTapped:^{
        MMMyDataViewController *myData = [[MMMyDataViewController alloc] init];
        myData.oneModel                = friendCell.oneModel;
        myData.type                    = @"one";
        [self.navigationController pushViewController:myData animated:YES];
    }];
    friendCell.cameraIV.image            = [UIImage imageNamed:cameraArr[indexPath.row%6]];
    friendCell.cellInformationView.image = [UIImage imageNamed:bjArr[indexPath.row%6]];

}

#pragma mark - 获取当前经纬度
- (void)getToLoction {
    [[MyLocation shareMyLocation] getUserLocation:^(CLLocation *lo, NSError *error) {
        _lat = [NSString stringWithFormat:@"%f", lo.coordinate.latitude];
        _lon = [NSString stringWithFormat:@"%f", lo.coordinate.longitude];
        
        [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/api/user/updateUserLocation.api" parmars:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID], @"latitude":_lat, @"longitude":_lon} success:^(id responseObject) {
            
        } fail:^(NSError *error) {
            
        }];
    } fail:^(NSString *file) {
        
    }];
}

- (void)reloadTable {
    [leftTableview reloadData];
}

#pragma mark - 点击和长按
//点击一下
- (void)tappedRightFriendTableviewCell:(MMFriendTableViewCell *)cell {
    [cell.loadingView startAnimating];
    cell.nameLab.hidden = YES;
    NSString *URL = nil;
    NSDictionary *parmars = nil;
    if([cell.oneModel.lid integerValue] == 100) {
        URL = @"/message/getNewestPost.api";
        parmars = @{@"user_id":[MMUserDefaultTool objectForKey:MMUserID], @"public_user_id":cell.oneModel.user_id};
        cell.haveMessage.hidden = YES;
    } else {
        URL = @"/message/sendHi.api";
        parmars = @{@"from_userid":[MMUserDefaultTool objectForKey:MMUserID],@"to_userid":cell.oneModel.user_id};
    }
    _type = TypeTapped;
    [self createDataWithURL:URL withParmars:parmars andTableViewCell:cell];
}

//点击两下
- (void)tappedDoubleRightFriendTableviewCell:(MMFriendTableViewCell *)cell {
    [cell.loadingView startAnimating];
    cell.nameLab.hidden = YES;
        [[MyLocation shareMyLocation] getUserLocation:^(CLLocation *lo, NSError *error) {
            _lat = [NSString stringWithFormat:@"%f", lo.coordinate.latitude];
            _lon = [NSString stringWithFormat:@"%f", lo.coordinate.longitude];
                [self createDataWithURL:@"/message/sendLocation.api" withParmars:@{@"from_userid":[MMUserDefaultTool objectForKey:MMUserID],@"to_userid":cell.oneModel.user_id, @"latitude":_lat, @"longitude":_lon} andTableViewCell:cell];
        } fail:^(NSString *file) {
            if ([file isEqualToString:@"file"]) {
                [cell.loadingView stopAnimating];
                cell.nameLab.hidden = NO;
            }
        }];
    _type = TypeDouble;

}

//长按
- (void)tappedLongFriendTableviewCell:(MMFriendTableViewCell *)cell {
    //获取剪贴板内容
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //判断URL是否有效
    NSString *phoneRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *PhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if (!pasteboard.string.length || ![PhoneTest evaluateWithObject:pasteboard.string]) {
        [MBProgressHUD showWindowMessageThenHide:@"无效的链接地址"];
        cell.nameLab.text = cell.oneModel.nick_name;
        return;
    }
    NSString *URL = @"/message/sendContent.api";
    NSDictionary *parmars = @{@"from_userid":[MMUserDefaultTool objectForKey:MMUserID],@"to_userid":cell.oneModel.user_id, @"content":pasteboard.string};
    _type = TypeLong;
    [self createDataWithURL:URL withParmars:parmars andTableViewCell:cell];
}
//停止长按
- (void)tappedLongFriendTableViewCellFail:(MMFriendTableViewCell *)cell {
        cell.nameLab.text = cell.oneModel.nick_name;
}

//滑动
- (void)scrollFriendTableviewCell:(MMFriendTableViewCell *)cell
{
    //---------------------------调取相机--------------------------//
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [cameraContainer setFullScreenMode];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
    _type = TypeCamera;
    //---------------------------调取相机--------------------------//
    
    cameraCell = cell;
}

#pragma mark - 相机代理方法

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata {
  
    NSString *width = [NSString stringWithFormat:@"%d",(int)image.size.width];
    NSString *hight = [NSString stringWithFormat:@"%d",(int)image.size.height];
    
    [[MMHTTPRequest sharedHTTPRequest] requestPostWithApi:@"/api/upload/uploadUserLogo.api" andParams:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID],@"width":width,@"height":hight,@"type":@"3"} andImage:image andSuccess:^(id responseObject) {
        
        NSString *picUrl      = responseObject[@"obj"][@"logo_url"];
        NSString *URL         = @"/message/sendPic.api";
        NSDictionary *parmars = @{@"from_userid":[MMUserDefaultTool objectForKey:MMUserID],@"to_userid":cameraCell.oneModel.user_id, @"picUrl":picUrl};

        [self createDataWithURL:URL withParmars:parmars andTableViewCell:cameraCell];
       
    } andfail:^(NSError *error) {
        [MBProgressHUD showWindowErrorThenHide:error.localizedDescription];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}

- (void) dismissCamera:(id)cameraViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tappedOpenBtn:(MMNotiView *)notifiView {
    notiView.frame = CGRectMake(0, -KKScreenWith*120/320, KKScreenWith, KKScreenWith*120/320);
    NSLog(@"%@",notifiView.messageInfoDic);
    MMOpenLinkViewController *link = [[MMOpenLinkViewController alloc] init];
    if ([NotiDic[@"type"] integerValue] == 0) {
        link.linkStr = [MMString photoStringWithSubString:NotiDic[@"item_1"]];
        
    } else {
        link.linkStr = NotiDic[@"item_1"];
        
    
    }
    link.nameStr = nameStr;
    link.report_id=user_id;
    link.type=2;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:link];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)tappedDismissBtn:(MMNotiView *)notifiView {
    notiView.frame = CGRectMake(0, -KKScreenWith*120/320, KKScreenWith, KKScreenWith*120/320);
}
@end
