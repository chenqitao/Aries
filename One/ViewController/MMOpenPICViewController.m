//
//  MMOpenPICViewController.m
//  Manito
//
//  Created by manito on 15/6/1.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMOpenPICViewController.h"

@interface MMOpenPICViewController ()<UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIImageView *pic;
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
    
    BOOL isSelect;
}

@end

@implementation MMOpenPICViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"图片";
     UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWith, 44)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(KKScreenWith/2-30, 10, 40, 30)];
    label.text=@"图片";
    label.font=[UIFont fontWithName:nil size:18];
    label.textColor=[UIColor whiteColor];
    
    [view addSubview:label];
    
    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setImage:[UIImage imageNamed:@"icon_close_slp"] forState:UIControlStateNormal];
    backbtn.frame=CGRectMake(KKScreenWith-70, 10, 25, 25);
    [backbtn addTarget:self action:@selector(backDown) forControlEvents:UIControlEventTouchUpInside];
   
    [view addSubview:backbtn];
    
    UIButton *UGCbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UGCbtn.frame=CGRectMake(KKScreenWith/2+20,15 ,25 , 20);
    [UGCbtn setImage:[UIImage imageNamed:@"icon_question"] forState:UIControlStateNormal];
    [UGCbtn addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:UGCbtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
}
-(void)report{
    
    [self showactionsheet];
    
    
}
-(void)showactionsheet{
    UIActionSheet *actionsheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报该内容" otherButtonTitles:nil, nil];
    actionsheet.tag=1001;
    [actionsheet showInView:self.view];
    
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

- (void)createUI {
    pic = [UIImageView newAutoLayoutView];
    [self.view addSubview:pic];
    pic.userInteractionEnabled = YES;
    [pic autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [pic setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:self.picStr]]];
    pic.clipsToBounds = YES;
    pic.contentMode = UIViewContentModeScaleAspectFit;
    [pic bk_whenTapped:^{
        
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"保存到相册" delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认", nil];
        action.actionSheetStyle = UIActionSheetStyleAutomatic;
        [action showInView:self.view];
    }];
}

//保存到本地相册
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = nil;
    if (!error) {
        [MBProgressHUD showWindowSuccessThenHide:@"图片保存成功"];
    }else {
        message = [error description];
        [MBProgressHUD showWindowErrorThenHide:@"图片保存失败"];
    }
}

#pragma mark - UIActionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag==1001) {
        if (buttonIndex==0) {
            [self getreportlist];//获取举报列表
            
            
        }
        else{
            
            return;
            
        }
    }
    else{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0: {
            UIImageWriteToSavedPhotosAlbum(pic.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
            break;
        }
    }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
