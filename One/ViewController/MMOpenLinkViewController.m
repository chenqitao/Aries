//
//  MMOpenLinkViewController.m
//  Manito
//
//  Created by manito on 15/5/19.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMOpenLinkViewController.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "MMShareViewController.h"


@interface MMOpenLinkViewController ()<UIWebViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIWebView   *web;
    UIView      *leftView;
    UIView      *rightView;
    UILabel     *rightLab;
    UILabel     *leftLab;
    UIImageView *leftIV;
    UIImageView *rightIV;
    YLImageView *imageView;
    UILabel *lab;
    NSMutableArray *datasource;
    UIView      *blackView;
    UIView      *whiteView;
    UIView      *backgourndView;
    UIButton    *Cancelbtn;
    UIButton    *Surebtn;
    UIPickerView *PickView;
    NSArray     *reportlist;
    int         report_type;
    NSString    *reason;
    
    BOOL isSelect;//是否滑动pickView;
}
@end

@implementation MMOpenLinkViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_close_slp"] style:UIBarButtonItemStylePlain target:self action:@selector(backDown)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" 链接来自大神科技" style:UIBarButtonItemStylePlain target:self action:nil];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = [NSString stringWithFormat:@"链接来自%@",self.nameStr];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    UIButton *UGCbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UGCbtn.frame=CGRectMake(self.nameStr.length*2+145,10 ,25 , 20);
    [UGCbtn setImage:[UIImage imageNamed:@"icon_question"] forState:UIControlStateNormal];
    [UGCbtn addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:UGCbtn];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
 
}

-(void)report{

    [self showactionsheet];


}
-(void)showactionsheet{
    UIActionSheet *actionsheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报该内容" otherButtonTitles:nil, nil];
    [actionsheet showInView:self.view];

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self getreportlist];//获取举报列表
        
  
    }
    else{
    
        return;
    
    }


}

-(void)createmotal{
    UIView *bagview=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bagview.backgroundColor=[UIColor blackColor];
    bagview.alpha=0.3;
    backgourndView=bagview;
    
    UIView *blackview=[[UIView alloc]initWithFrame:CGRectMake(0, KKScreenHeight-300, KKScreenWith, 50)];
    blackview.backgroundColor=[UIColor blackColor];
    blackview.alpha=1;
    blackView=blackview;
    
    UIButton *cancelbtn=[UIButton buttonWithType:UIButtonTypeSystem];
    cancelbtn.frame=CGRectMake(0, KKScreenHeight-300, 70, 50);
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelbtn addTarget:self action:@selector(removeAllModal) forControlEvents:UIControlEventTouchUpInside];
    Cancelbtn=cancelbtn;
    
    
    UIButton *surebtn=[UIButton buttonWithType:UIButtonTypeSystem];
    surebtn.frame=CGRectMake(KKScreenWith-80, KKScreenHeight-290, 70, 30);
    [surebtn setTitle:@"确认" forState:UIControlStateNormal];
    surebtn.layer.cornerRadius=3;
    [surebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    surebtn.backgroundColor=[UIColor colorWithRed:0 green:191/255.0 blue:255/255.0 alpha:1];
    [surebtn addTarget:self action:@selector(uploadroport) forControlEvents:UIControlEventTouchUpInside];
    Surebtn=surebtn;
    
    UIView *whiteview=[[UIView alloc]initWithFrame:CGRectMake(0, KKScreenHeight-300+50, KKScreenWith, 250)];
    whiteview.backgroundColor=[UIColor whiteColor];
    whiteView=whiteview;
    
    UIPickerView *pickerview=[[UIPickerView alloc]initWithFrame:whiteview.frame];
    pickerview.dataSource=self;
    pickerview.delegate=self;
    PickView=pickerview;
    
    [bagview bk_whenTapped:^{
        [self removeAllModal];
        
    }];
    [self.view.window addSubview:backgourndView];
    [self.view.window addSubview:blackView];
    [self.view.window addSubview:Cancelbtn];
    [self.view.window addSubview:Surebtn];
    [self.view.window addSubview:whiteView];
    [self.view.window addSubview:PickView];


}


-(void)uploadroport{
    
    if(isSelect == NO) {
        report_type = 3;
        reason = @"举报不实信息";
    }
    [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/api/report/insertReportInfo.api" parmars:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID],@"type":[NSNumber numberWithInt:_type],@"report_id":_report_id,@"report_type":[NSNumber numberWithInt:report_type],@"reason":reason} success:^(id responseObject) {
        NSLog(@"message is:%@",responseObject[@"message"]);
        if ([responseObject[@"message"] isEqualToString:@"保存成功！"]) {
             [MBProgressHUD showWindowMessageThenHide:@"已成功举报"];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
     [self removeAllModal];


}


-(void)removeAllModal{
    
    [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{

        NSArray *uiitems=[NSArray arrayWithObjects:whiteView,blackView,Cancelbtn,Surebtn,whiteView,PickView, nil];
        for (CALayer *uitem in uiitems) {
            [self animationremoveallitems:uitem];
        }
       
    } completion:^(BOOL finished) {
        [backgourndView removeFromSuperview];
        [blackView removeFromSuperview];
        [Cancelbtn removeFromSuperview];
        [Surebtn removeFromSuperview];
        [whiteView removeFromSuperview];
        [PickView removeFromSuperview];
        

    }];

}
#pragma 移除动画，向下淡出
-(void)animationremoveallitems:(CALayer*)item{
    item.frame=CGRectMake(item.frame.origin.x, KKScreenHeight, item.frame.size.width, item.frame.size.height);
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    
    return reportlist.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return reportlist[row][@"type_name"];
    


}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    report_type=[reportlist[row][@"report_type_id"]intValue];
    reason=reportlist[row][@"type_name"];
    isSelect = YES;
    

}


-(void )getreportlist{
    
    NSString *url=@"http://api.touchyo.com/api/report/getReportTypeList.api";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    AFHTTPRequestOperation *op = [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        reportlist=responseObject[@"obj"][@"reportTypeList"];
          [self createmotal];    //创建模态视图
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
    [op start];
}

- (void)backDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    datasource=[NSMutableArray array];
}

#pragma mark 调用视频的通知方法

- (void)videoStarted { // 开始播放
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    appDelegate.isFull = YES ;
    
}

- (void)videoFinished { // 完成播放
    
    AppDelegate *appDelegate = [[ UIApplication sharedApplication ] delegate ];
    
    appDelegate.isFull = NO ;
    
    if ([[ UIDevice currentDevice ] respondsToSelector : @selector (setOrientation:)]) {
        
        SEL selector = NSSelectorFromString (@"setOrientation:");
        
        NSInvocation *invocation = [ NSInvocation invocationWithMethodSignature :[ UIDevice instanceMethodSignatureForSelector :selector]];
        
        [invocation setSelector :selector];
        
        [invocation setTarget :[ UIDevice currentDevice ]];
        
        int val = UIInterfaceOrientationPortrait ;
        
        [invocation setArgument :&val atIndex : 2 ];
        
        [invocation invoke ];
    }
}

- (void)createUI
{
    web = [UIWebView newAutoLayoutView];
    [self.view addSubview:web];
    [web autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 44, 0)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.linkStr]];
    [web loadRequest:request];
    web.delegate = (id<UIWebViewDelegate>)self;
    
    imageView = [[YLImageView alloc] initWithFrame:CGRectMake((KKScreenWith-64)/2, (KKScreenHeight-44-64-64)/2, 64, 64)];
    imageView.image = [YLGIFImage imageNamed:@"loading64@2x.gif"];
    [web addSubview:imageView];
    
    leftView = [UIView newAutoLayoutView];
    [self.view addSubview:leftView];
    leftView.userInteractionEnabled = YES;
    [leftView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [leftView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [leftView autoSetDimension:ALDimensionHeight toSize:KKScreenWith*44/320];
    leftView.backgroundColor = MMColor(253, 134, 77, 1);;
    [leftView bk_whenTapped:^{
        [self share];
    }];
    
    rightView = [UIView newAutoLayoutView];
    [self.view addSubview:rightView];
    rightView.userInteractionEnabled = YES;
    [rightView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [rightView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [rightView autoConstrainAttribute:ALAttributeWidth toAttribute:ALAttributeWidth ofView:leftView];
    [rightView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftView withOffset:0];
    [rightView autoConstrainAttribute:ALAttributeHeight toAttribute:ALAttributeHeight ofView:leftView];
    rightView.backgroundColor = MMColor(251, 44, 74, 1);
    [rightView bk_whenTapped:^{
        MMShareViewController *share = [[MMShareViewController alloc] init];
        share.haveBack = NO;
        share.shareURL = self.linkStr;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:share];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }];
    
    leftIV = [UIImageView newAutoLayoutView];
    [leftView addSubview:leftIV];
    [leftIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:KKScreenWith*49/320];
    [leftIV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [leftIV autoSetDimensionsToSize:CGSizeMake(20, 26)];
    leftIV.image = [UIImage imageNamed:@"icon_share_slp"];
    
    leftLab = [UILabel newAutoLayoutView];
    [leftView addSubview:leftLab];
    [leftLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftIV withOffset:KKScreenWith*7/320];
    [leftLab autoAlignAxis:ALAxisHorizontal toSameAxisOfView:leftIV];
    leftLab.text = @"转发";
    leftLab.textColor = [UIColor whiteColor];
    leftLab.font = [UIFont boldSystemFontOfSize:15];
    
    rightIV = [UIImageView newAutoLayoutView];
    [rightView addSubview:rightIV];
    [rightIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:KKScreenWith*35/320];
    [rightIV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [rightIV autoSetDimensionsToSize:CGSizeMake(24, 20)];
    rightIV.image = [UIImage imageNamed:@"icon_friends_slp"];
    
    rightLab = [UILabel newAutoLayoutView];
    [rightView addSubview:rightLab];
    [rightLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:rightIV withOffset:KKScreenWith*7/320];
    [rightLab autoAlignAxis:ALAxisHorizontal toSameAxisOfView:rightIV];
    rightLab.text = @"发送给朋友";
    rightLab.textColor = [UIColor whiteColor];
    rightLab.font = [UIFont boldSystemFontOfSize:15];
}

#pragma mark - WebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [imageView removeFromSuperview];
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    return YES;
//}

- (void)share
{
    //self.voteModel;
    
    //  图片地址
    // NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"meinv"ofType:@"png"];
    
    /*
     content: 在微博中会显示, qq和微信不显示
     defaultContent: 配合content
     image: 图片, 可以是本地, 也可以是网络的
     title: 标题,qq和微信显示
     url: 微信和qq点击转到得地址
     description: qq和微信中显示在标题的下面
     
     //  本地图片地址                     [ShareSDK imageWithPath:imagePath]
     //  网络图片地址(sina微博不支持)       [ShareSDK imageWithUrl:imagePath]

    */
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.linkStr
                                       defaultContent:@"分享这条链接"
                                                image:[ShareSDK imageWithPath:nil]
                                                title:@"TouchYO"
                                                  url:self.linkStr
                                          description:@"来自TouchYo的分享"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
