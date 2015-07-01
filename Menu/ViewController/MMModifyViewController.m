//
//  MMModifyViewController.m
//  Manito
//
//  Created by manito on 15/5/19.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMModifyViewController.h"

@interface MMModifyViewController ()
{
    UITextField *textfield;
    UITextView  *textView;
}

@end

@implementation MMModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([_titleStr isEqualToString:@"个性签名"]) {
        self.title = _titleStr;
    } else {
        self.title = [NSString stringWithFormat:@"修改%@",_titleStr];
    }
    __weak MMModifyViewController *weakSelf = self;
    self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"保存" action:^(id sender){
        [weakSelf request];
    }];
}

- (void)createUI
{
    if (_type == ModifyTypeTitle) {
        textView = [UITextView newAutoLayoutView];
        [self.view addSubview:textView];
        [textView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [textView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
        [textView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
        [textView autoSetDimension:ALDimensionHeight toSize:180];
        textView.text = _infoStr;
        textView.font = [UIFont systemFontOfSize:15];
        
        UIView *whiteView = [UIView newAutoLayoutView];
        [self.view addSubview:whiteView];
        [whiteView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:textView withOffset:-5];
        [whiteView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:textView withOffset:5];
        [whiteView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:textView withOffset:-1];
        [whiteView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:textView withOffset:1];
        whiteView.layer.borderWidth = 1;
        whiteView.layer.borderColor = MMColor(212, 210, 214, 1).CGColor;
        whiteView.clipsToBounds = YES;
        [self.view bringSubviewToFront:textView];
        
        UILabel *placeholder  = [UILabel newAutoLayoutView];
        [self.view addSubview:placeholder];
        [placeholder autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:whiteView withOffset:10];
        [placeholder autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        placeholder.font      = [UIFont systemFontOfSize:14];
        placeholder.textColor = [UIColor darkGrayColor];
        placeholder.text      = _placeholder;
    } else {
        textfield = [UITextField newAutoLayoutView];
        [self.view addSubview:textfield];
        [textfield autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [textfield autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [textfield autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [textfield autoSetDimension:ALDimensionHeight toSize:40];
        textfield.text = [NSString stringWithFormat:@"%@",_infoStr];
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UIView *whiteView = [UIView newAutoLayoutView];
        [self.view addSubview:whiteView];
        [whiteView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:textfield withOffset:-16];
        [whiteView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:textfield withOffset:16];
        [whiteView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:textfield withOffset:-10];
        [whiteView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:textfield withOffset:10];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.layer.borderWidth = 1;
        whiteView.layer.borderColor = MMColor(212, 210, 214, 1).CGColor;
        [self.view bringSubviewToFront:textfield];
        
        UILabel *placeholder = [UILabel newAutoLayoutView];
        [self.view addSubview:placeholder];
        [placeholder autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:whiteView withOffset:10];
        [placeholder autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        placeholder.font      = [UIFont systemFontOfSize:14];
        placeholder.textColor = [UIColor darkGrayColor];
        placeholder.text      = _placeholder;
    }
}

- (void)request
{
    if ([textView.text isEqualToString:_infoStr]||[textfield.text isEqualToString:_infoStr]) {//消息没有修改不请求
        HHDPRINT(@"不需要修改");
        [self returnBtnTapped:nil];
        return;
    }
    
    NSString *reqStr;
    NSDictionary *reqDic;
    NSString *user_id = [MMUserDefaultTool objectForKey:MMUserID];
    switch (_type) {
        case ModifyTypeName: {
            reqStr = @"/api/user/modifyUserName.api";
            reqDic = @{@"user_id":user_id, @"nick_name":textfield.text};
            break;
        }
        case ModifyTypePhone: {
            
            break;
        }
        case ModifyTypeSex: {
           
            break;
        }
        case ModifyTypeTitle: {
            reqStr = @"/api/user/modifyUserTitle.api";
            reqDic = @{@"user_id":user_id, @"title":textView.text};
            break;
        }
        default: {
            break;
        }
    }
    
    [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:reqStr parmars:reqDic success:^(id responseObject) {
        if (_competeBlock) {
            if (_type == ModifyTypeTitle) {
                _competeBlock(textView.text);
            } else {
                if ([responseObject[@"obj"][@"data"] boolValue]) {
                    _competeBlock(textfield.text);
                    [self returnBtnTapped:nil];
                } else {
                    [MBProgressHUD showWindowErrorThenHide:@"用户名已存在"];
                    [textfield setText:_infoStr];
                    [textfield resignFirstResponder];
                }
            }
        }

    } fail:^(NSError *error) {
        [MBProgressHUD showWindowErrorThenHide:error.localizedDescription];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
