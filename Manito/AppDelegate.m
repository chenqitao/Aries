//
//  AppDelegate.m
//  Manito
//
//  Created by Johnny on 15/4/27.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "AppDelegate.h"
#import "MMOneViewController.h"
#import "MMMenuViewController.h"
#import "RESideMenu.h"
#import "MMUserDefaultTool.h"
#import "MMLoginViewController.h"
#import "UIView+Frame.h"
//shareSDK 分享
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <SMS_SDK/SMS_SDK.h>
#import "MMWelcomeViewController.h"
#import "MMOpenLinkViewController.h"
#import "MMOpenLocationViewController.h"
#import "MMOpenPICViewController.h"
#import "TMCache.h"
#import "MMNotiView.h"

@interface AppDelegate ()<MMNotiViewDelegate> {
    RESideMenu *sideMenuViewController;
    NSMutableArray *dataSource; //用来存信息的数据
    MMNotiView *notiView;
    NSDictionary *tappedDic;    //点击顶部的通知栏的字典
}
@end

@implementation AppDelegate

+ (AppDelegate *)shared {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

//为视频的旋转做准备的
- ( NSUInteger )application:( UIApplication *)application supportedInterfaceOrientationsForWindow:( UIWindow *)window {
    if ( _isFull ) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self shareRegister];
    [self customizeInterface];
    [self jPushRegist:launchOptions];
    dataSource = [NSMutableArray array];
    
    if ([MMUserDefaultTool objectForKey:MMToken]) {
        MMOneViewController *one = [[MMOneViewController alloc] init];
        one.showNavi = NO;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:one];
        MMMenuViewController *leftMenuViewController = [[MMMenuViewController alloc] init];
        sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:leftMenuViewController rightMenuViewController:nil];
        sideMenuViewController.backgroundImage = [UIImage imageNamed:@"BG_sbp"];
        self.window.rootViewController = sideMenuViewController;
        MMWelcomeViewController *welcome = [[MMWelcomeViewController alloc] init];
        welcome.type = @"haveLogin";
        [sideMenuViewController addChildViewController:welcome];
        [sideMenuViewController.view addSubview:welcome.view];
    } else {
        sideMenuViewController = nil;
        MMWelcomeViewController *welcome = [[MMWelcomeViewController alloc] init];
        welcome.showNavi = NO;
        welcome.haveBack = NO;
        welcome.type = @"login";
        self.window.rootViewController = welcome;
    }
  
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"has_show_introduce"] == nil) {
//        [self setIntroduce];
//        [[NSUserDefaults standardUserDefaults] setObject:@"shown" forKey:@"has_show_introduce"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    //创建通知view
    [self createNotiView];
    
    if ([[launchOptions allKeys] containsObject:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self performSelector:@selector(showRemoteAfterDelayWithDiction:) withObject:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] afterDelay:2];
    }
    [self requestMyNotifications];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveterminateRequestTime];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self requestMyNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveterminateRequestTime];
    
}

//极光推送的代码
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    notiView.userInfoDic = userInfo;
    [self showNotive];
    
    BOOL isActive = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isActive) {//如果是后台就记录下点击的消息
        tappedDic = userInfo;
    } else {
        tappedDic = nil;
        //前台收到了消息，直接把所有的前面的未读消息清除
        [dataSource removeAllObjects];
    }
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 注册极光推送
- (void)jPushRegist:(NSDictionary *)launchOptions
{
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
}


#pragma mark - 自定义界面
- (void)customizeInterface {
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:229.0/255.0
                                                                       green:80.0/255.0
                                                                        blue:76.0/255.0
                                                                       alpha:1.0], NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:251.0/255.0
                                                                  green:44.0/255.0
                                                                   blue:74.0/255.0
                                                                  alpha:1.0]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                          [UIFont boldSystemFontOfSize:20.0], NSFontAttributeName, nil]];
}

#pragma mark - 设置引导页
- (void)setIntroduce {
    MMWelcomeViewController *welcome = [[MMWelcomeViewController alloc] init];
    [self.window addSubview:welcome.view];
}

#pragma mark - 注册shareSDK分享
- (void)shareRegister {
    [ShareSDK registerApp:@"75e36bb79f4a"];//字符串api20为您的ShareSDK的AppKey
    [SMS_SDK registerApp:@"75e267704578" withSecret:@"00c9a37faa60fc787fbbe87b5fae0684"];//注册短信验证码
    
    [WXApi registerApp:@"wx07cb0ef36c7e8639"];
    
//    添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"1328998413"
                           appSecret:@"4055afee3b7c085020b52bd52306a045"
                        redirectUri:@"http://api.touchyo.com"];
    
//    当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台  3430107101  153c39918d724798a97b72092a6c4f9e
    [ShareSDK  connectSinaWeiboWithAppKey:@"1328998413"
                                appSecret:@"4055afee3b7c085020b52bd52306a045"
                              redirectUri:@"http://www.dashen.co"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx07cb0ef36c7e8639"
                           wechatCls:[WXApi class]];
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wx07cb0ef36c7e8639"
                           appSecret:@"b27610ecdba9eed3c51c7615f52199dc"
                           wechatCls:[WXApi class]];
}

#pragma mark - shareSDK保留方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

//MARK: MMNotiView delegate
//点击忽略按钮
- (void)tappedDismissBtn:(MMNotiView *)notifiView {
    [self showNextNotive];
}

//点击打开按钮
- (void)tappedOpenBtn:(MMNotiView *)notifiView {
    if (notiView.userInfoDic) {//通知栏过来的消息
        if([notiView.userInfoDic[@"messageType"] isEqualToString:@"HI"]) {
            NSString *to_userid = notiView.userInfoDic[@"from_userid"];
            NSString *URL = @"/message/sendHi.api";
            NSDictionary *parmar = @{@"from_userid":[MMUserDefaultTool objectForKey:MMUserID],@"to_userid":to_userid};
            [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:URL parmars:parmar success:^(id responseObject) {
                [MBProgressHUD showWindowSuccessThenHide:@"say HI 成功"];
            } fail:^(NSError *error) {
                [MBProgressHUD showWindowErrorThenHide:@"say HI 失败"];
            }];
        }
        if ([notiView.userInfoDic[@"messageType"] isEqualToString:@"LOCATION"]) {
            MMOpenLocationViewController *openLoction = [[MMOpenLocationViewController alloc] init];
            openLoction.lot = notiView.userInfoDic[@"Longitude"];
            openLoction.lat = notiView.userInfoDic[@"Latitude"];
            openLoction.haveBack = NO;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:openLoction];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
        if ([notiView.userInfoDic[@"messageType"] isEqualToString:@"URL"]) {
            MMOpenLinkViewController *openLink = [[MMOpenLinkViewController alloc] init];
            openLink.linkStr = notiView.userInfoDic[@"aps"][@"alert"];
            openLink.nameStr = notifiView.userInfoDic[@"name"];
            openLink.report_id=notiView.userInfoDic[@"message_id"];
           // openLink.report_id=notifiView
            openLink.type=1;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:openLink];
            openLink.haveBack = NO;
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
        if ([notiView.userInfoDic[@"messageType"]isEqualToString:@"PIC"]) {
            MMOpenPICViewController *openPIC = [[MMOpenPICViewController alloc] init];
            openPIC.picStr = notiView.userInfoDic[@"Pic"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:openPIC];
            openPIC.type=1;
            openPIC.report_id=notiView.userInfoDic[@"message_id"];
            openPIC.haveBack = NO;
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    } else if (notiView.messageInfoDic) {//消息过来的
        int messageType = [notiView.messageInfoDic[@"topic_type"] intValue];
        if (messageType == 0) {//YO
            NSString *to_userid = notiView.messageInfoDic[@"from_userid"];
            NSString *URL = @"/message/sendHi.api";
            NSDictionary *parmar = @{@"from_userid":[MMUserDefaultTool objectForKey:MMUserID],@"to_userid":to_userid};
            [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:URL parmars:parmar success:^(id responseObject) {
                [MBProgressHUD showWindowSuccessThenHide:@"say Hi 成功"];
            } fail:^(NSError *error) {
                [MBProgressHUD showWindowErrorThenHide:@"say Hi 失败"];
            }];
        } else if (messageType == 5) {//位置
            MMOpenLocationViewController *openLoction = [[MMOpenLocationViewController alloc] init];
            openLoction.lot = notiView.messageInfoDic[@"longitude"];
            openLoction.lat = notiView.messageInfoDic[@"latitude"];
            openLoction.haveBack = NO;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:openLoction];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        } else if (messageType == 3) {//链接
            MMOpenLinkViewController *openLink = [[MMOpenLinkViewController alloc] init];
            openLink.linkStr = notiView.messageInfoDic[@"content"];
            openLink.nameStr = notifiView.messageInfoDic[@"nick_name"];
            openLink.report_id=notiView.messageInfoDic[@"message_receive_id"];
            openLink.type=1;
        
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:openLink];
            openLink.haveBack = NO;
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        } else if (messageType == 1) {//图片
            MMOpenPICViewController *openPIC = [[MMOpenPICViewController alloc] init];
            openPIC.picStr = notiView.messageInfoDic[@"topic_id"];
            openPIC.type=1;
            openPIC.report_id=notiView.messageInfoDic[@"message_receive_id"];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:openPIC];
            openPIC.haveBack = NO;
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }
    [self showNextNotive];
}

//MARK: private method
- (void)createNotiView
{
    notiView = [[MMNotiView alloc] initWithFrame:CGRectMake(0, -KKScreenWith*120/320, KKScreenWith, KKScreenWith*120/320)];
    notiView.delegate = self;
    [self.window addSubview:notiView];
    [self.window bringSubviewToFront:notiView];
}

- (void)showNotive
{
    if (notiView.top == 0) {//处于显示状态，回收一下
        [UIView animateWithDuration:.4 animations:^{
            [notiView setTop:-KKScreenWith*120/320];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 animations:^{
                [notiView setTop:0];
            }];
        }];
    } else {//处于隐藏阶段，直接显示
        [UIView animateWithDuration:.2 animations:^{
            [notiView setTop:0];
        }];
    }
}

- (void)showNextNotive
{
    [UIView animateWithDuration:.2 animations:^{
        [notiView setTop:-KKScreenWith*120/320];
    }];
    if (dataSource.count) {//必然从消息过来
        notiView.messageInfoDic = [dataSource firstObject];
        [self showNotive];
        [dataSource removeObjectAtIndex:0];
    }
    if (tappedDic) {
        tappedDic = nil;
    }
}

- (void)saveterminateRequestTime
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    [MMUserDefaultTool setObject:[NSString stringWithFormat:@"%.0f",interval] forKey:MMEnterBackOrTerminateTime];
}

- (void)showRemoteAfterDelayWithDiction:(NSDictionary *)dic
{
    notiView.userInfoDic = dic;
    [self showNotive];
    tappedDic = dic;
}

//获取中间的消息
- (void)requestMyNotifications
{
//    /message/getMessageWithMillisecondBetweenStarttimeAndEndtime.api?user_id=200400666680&startTime=1433005148000&endTime=1433995148000
    HHDPRINT(@"---request---");
    [dataSource removeAllObjects];
    if ([MMUserDefaultTool objectForKey:MMToken] && [MMUserDefaultTool objectForKey:MMEnterBackOrTerminateTime]) {
        NSInteger old = [[MMUserDefaultTool objectForKey:MMEnterBackOrTerminateTime] integerValue];
        NSInteger new = (NSInteger)[[NSDate date] timeIntervalSince1970];
        NSDictionary *dic = @{@"user_id":[MMUserDefaultTool objectForKey:MMUserID],
                              @"startTime":[NSString stringWithFormat:@"%ld",old*1000], @"endTime":[NSString stringWithFormat:@"%ld",new*1000]};
        NSString *path = @"/message/getMessageWithMillisecondBetweenStarttimeAndEndtime.api";
        [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:path parmars:dic success:^(id responseObject) {
            HHDPRINT(@"---response---");
            if ([[responseObject objectForKey:@"obj"] count]) {
                [dataSource addObjectsFromArray:[responseObject objectForKey:@"obj"]];
                
                if (tappedDic) { //有点击的效果直接筛选
                    __block NSUInteger index = -1;
                    [dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSDictionary *dic = (NSDictionary *)obj;
                        if ([[dic objectForKey:@"systime"] doubleValue] == [[tappedDic objectForKey:@"time"] doubleValue] && [[tappedDic objectForKey:@"from_userid"] isEqualToString:[dic objectForKey:@"from_userid"]]) {
                            index = idx;
                            *stop = YES;
                        }
                    }];
                    if (index != -1) {
                        HHDPRINT(@"index = %ld",index);
                        [dataSource removeObjectAtIndex:index];
                    }
                } else {//显示第一个消息
                    notiView.messageInfoDic = [dataSource objectAtIndex:0];
                    [self showNotive];
                    [dataSource removeObjectAtIndex:0];
                }
            }
        } fail:^(NSError *error) {
        }];
    }
}

@end
