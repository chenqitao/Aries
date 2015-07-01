//
//  MMLoginViewController.m
//  Manito
//
//  Created by manito on 15/5/4.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//


#import "MMLoginViewController.h"
#import "RESideMenu.h"
#import "AppDelegate.h"
#import "MMOneViewController.h"
#import "MMMenuViewController.h"
#import "MMVerificationViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "BJKeyboardScrollView.h"
#import "MMAgreementViewController.h"

#define NUMBERS @"0123456789"

@interface MMLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ivhight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ivWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ivBottomToLabhight;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet BJKeyboardScrollView *keyboardScroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nexBtnToLineHight;
@property (weak, nonatomic) IBOutlet UILabel *touchYO;

@end

@implementation MMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    _ivhight.constant = KKScreenHeight*163/568;
    _ivWidth.constant = KKScreenHeight*228/568;
    _ivBottomToLabhight.constant = KKScreenHeight*124/568;
    _nexBtnToLineHight.constant = KKScreenHeight*73/568;
    [self registerForKeyboardNotifications];
}

- (void)createUI
{
    _touchYO.userInteractionEnabled = YES;
    [_touchYO bk_whenTapped:^{
        MMAgreementViewController *agreenment = [[MMAgreementViewController alloc] init];
        [self.navigationController pushViewController:agreenment animated:YES];
    }];
    _nextBtn.layer.cornerRadius = _nextBtn.bounds.size.height/4;
    _nextBtn.clipsToBounds = YES;
    
    [_nextBtn bk_whenTapped:^{
        NSString *phoneRegex = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
        NSPredicate *PhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        if (!_phoneText.text.length || ![PhoneTest evaluateWithObject:_phoneText.text]) {
            [MBProgressHUD showWindowMessageThenHide:@"请输入正确的手机号码"];
            return;
        }
        [MBProgressHUD showWindowMessageThenHide:@"正在获取验证码"];
        //获取短信验证码
        __weak MMLoginViewController *login = self;
        [SMS_SDK getVerificationCodeBySMSWithPhone:_phoneText.text zone:@"86" result:^(SMS_SDKError *error) {
            if (!error) {
                [MBProgressHUD showWindowSuccessThenHide:@"验证码发送成功"];
                MMVerificationViewController *verification = [[MMVerificationViewController alloc] init];
                verification.showNavi = NO;
                verification.phoneNumble = _phoneText.text;
                [login.navigationController pushViewController:verification animated:YES];
            } else {
                [MBProgressHUD showWindowErrorThenHide:@"获取验证码失败"];
            }
        }];
    }];
}

- (void)createData
{
    
}

#pragma mark taxtField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [MBProgressHUD showWindowMessageThenHide:@"正在获取验证码"];
//        获取短信验证码
    __weak MMLoginViewController *login = self;
    [SMS_SDK getVerificationCodeBySMSWithPhone:_phoneText.text zone:@"86" result:^(SMS_SDKError *error) {
        if (!error) {
            [MBProgressHUD showWindowSuccessThenHide:@"验证码发送成功"];
            MMVerificationViewController *verification = [[MMVerificationViewController alloc] init];
            verification.showNavi = NO;
            verification.phoneNumble = _phoneText.text;
            [login.navigationController pushViewController:verification animated:YES];
        } else {
            [MBProgressHUD showWindowErrorThenHide:@"获取验证码失败"];
        }
    }];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //只能输入4行
    NSInteger length = textField.text.length;
    if (length >= 11  &&  string.length > 0) {
        return  NO;
    }
    
    //只能输入数字
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest) {
        return NO;
    }
    return YES;
}

#pragma mark - 获取键盘高度

- (void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif {
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    [_keyboardScroll setContentOffset:CGPointMake(0, keyboardSize.height) animated:YES];
}
- (void) keyboardWasHidden:(NSNotification *) notif {
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    [_keyboardScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
