//
//  MMVerificationViewController.m
//  Manito
//
//  Created by manito on 15/5/11.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMVerificationViewController.h"
#import "BJKeyboardScrollView.h"
#import "MMSetInfoViewController.h"
#import "RESideMenu.h"
#import "MMOneViewController.h"
#import "MMMenuViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "PhoneBookTools.h"
#import "MMPerson.h"
#import "Pesontools.h"

#define NUMBERS @"0123456789"

@interface MMVerificationViewController ()<UITextFieldDelegate>
@property (weak, nonatomic  ) IBOutlet UIButton             *againBtn;//下一步
@property (weak, nonatomic  ) IBOutlet UILabel              *oneLab;
@property (weak, nonatomic  ) IBOutlet UILabel              *twoLab;
@property (weak, nonatomic  ) IBOutlet UILabel              *threeLab;
@property (weak, nonatomic  ) IBOutlet UILabel              *fourLab;
@property (weak, nonatomic  ) IBOutlet UITextField          *hideTextField;
@property (weak, nonatomic  ) IBOutlet UILabel              *phoneLab;
@property (weak, nonatomic  ) IBOutlet UIButton             *backBtn;//返回上一页
@property (weak, nonatomic  ) IBOutlet BJKeyboardScrollView *keyBoardScroll;
@property (weak, nonatomic  ) IBOutlet UILabel              *tishiLab;//提示文字
@property (nonatomic, assign) BOOL                 select;//是否第一相应者
@property (nonatomic, assign) int                  time;//倒计时时间
@property (nonatomic, strong) NSTimer              *timer;
@property (nonatomic, strong) MMPerson             *personModel;//个人信息数据
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ivWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ivhight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnToLabHight;

@end

@implementation MMVerificationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _time = 10;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleMaxShowTimer:) userInfo:nil repeats:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ivWidth.constant = KKScreenHeight*228/568;
    _ivhight.constant = KKScreenHeight*163/568;
    _hight.constant = KKScreenHeight*95/568;
    _btnToLabHight.constant = KKScreenHeight*65/568;
    [self setLabLayer];
    [self settextFieldNoti];
    [self registerForKeyboardNotifications];
}

- (void)settextFieldNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
    _select = NO;
    [self.view bk_whenTapped:^{
        if (_select) {
            [_hideTextField resignFirstResponder];
        } else {
            [_hideTextField becomeFirstResponder];
        }
        _select = !_select;
    }];
}

//触发定时器
- (void)handleMaxShowTimer:(NSTimer *)timer
{
    _time = _time-1;
    [_againBtn setTitle:[NSString stringWithFormat:@"%d秒",_time] forState:UIControlStateNormal];
    if (_time <= 0) {
        [_timer invalidate];
        _timer = nil;
        [_againBtn setTitle:@"重发" forState:UIControlStateNormal];
        _againBtn.userInteractionEnabled = YES;
    }
}


- (void)setLabLayer {
    HHDPRINT(@"_oneLab.bounds.size.width == %f",_oneLab.bounds.size.width);
    _oneLab.layer.cornerRadius = _oneLab.bounds.size.height/2;
    _oneLab.layer.borderWidth = 2.0f;
    _oneLab.layer.borderColor = [MMColor(251, 44, 75, 1) CGColor];
    _oneLab.clipsToBounds = YES;
    
    _twoLab.layer.cornerRadius = _twoLab.bounds.size.height/2;
    _twoLab.layer.borderWidth = 2.0f;
    _twoLab.layer.borderColor = [MMColor(248, 85, 72, 1) CGColor];
    _twoLab.clipsToBounds = YES;
    
    _threeLab.layer.cornerRadius = _threeLab.bounds.size.height/2;
    _threeLab.layer.borderWidth = 2.0f;
    _threeLab.layer.borderColor = [MMColor(253, 134, 77, 1) CGColor];
    _threeLab.clipsToBounds = YES;
    
    _fourLab.layer.cornerRadius = _fourLab.bounds.size.height/2;
    _fourLab.layer.borderWidth = 2.0f;
    _fourLab.layer.borderColor = [MMColor(252, 173, 72, 1) CGColor];
    _fourLab.clipsToBounds = YES;
    
    _againBtn.layer.cornerRadius = _againBtn.bounds.size.height/4;
    _againBtn.clipsToBounds = YES;
    [_againBtn setTitle:@"5秒" forState:UIControlStateNormal];
    _againBtn.backgroundColor = MMColor(255, 70, 92, 1);
}

- (void)textChange:(NSNotification *)notifi
{
    switch ([_hideTextField.text length]) {
        case 0: {
            _oneLab.text   = @"";
            _twoLab.text   = @"";
            _threeLab.text = @"";
            _fourLab.text  = @"";

            _oneLab.backgroundColor   = [UIColor whiteColor];
            _twoLab.backgroundColor   = [UIColor whiteColor];
            _threeLab.backgroundColor = [UIColor whiteColor];
            _fourLab.backgroundColor  = [UIColor whiteColor];
            
            if (_time <= 0) {
                [_timer invalidate];
                _timer=nil;
                [_againBtn setTitle:@"重发" forState:UIControlStateNormal];
            }
            _againBtn.backgroundColor = MMColor(255, 70, 92, 1);
            break;
        }
        case 1: {
            _oneLab.text   = [_hideTextField.text substringWithRange:NSMakeRange(0, 1)];
            _twoLab.text   = @"";
            _threeLab.text = @"";
            _fourLab.text  = @"";
            
            _oneLab.backgroundColor   = MMColor(251, 44, 75, 1);
            _twoLab.backgroundColor   = [UIColor whiteColor];
            _threeLab.backgroundColor = [UIColor whiteColor];
            _fourLab.backgroundColor  = [UIColor whiteColor];
            
            [_timer invalidate];
            _timer = nil;
            [_againBtn setTitle:@"重发" forState:UIControlStateNormal];
            _againBtn.backgroundColor = MMColor(255, 70, 92, 1);
            break;
        }
        case 2: {
            _oneLab.text   = [_hideTextField.text substringWithRange:NSMakeRange(0, 1)];
            _twoLab.text   = [_hideTextField.text substringWithRange:NSMakeRange(1, 1)];
            _threeLab.text = @"";
            _fourLab.text  = @"";
            
            _oneLab.backgroundColor   = MMColor(251, 44, 75, 1);
            _twoLab.backgroundColor   = MMColor(248, 85, 72, 1);
            _threeLab.backgroundColor = [UIColor whiteColor];
            _fourLab.backgroundColor  = [UIColor whiteColor];
            
            [_timer invalidate];
            _timer = nil;
            [_againBtn setTitle:@"重发" forState:UIControlStateNormal];
            _againBtn.backgroundColor = MMColor(255, 70, 92, 1);
            break;
        }
        case 3: {
            _oneLab.text   = [_hideTextField.text substringWithRange:NSMakeRange(0, 1)];
            _twoLab.text   = [_hideTextField.text substringWithRange:NSMakeRange(1, 1)];
            _threeLab.text = [_hideTextField.text substringWithRange:NSMakeRange(2, 1)];
            _fourLab.text  = @"";
            
            _oneLab.backgroundColor   = MMColor(251, 44, 75, 1);
            _twoLab.backgroundColor   = MMColor(248, 85, 72, 1);
            _threeLab.backgroundColor = MMColor(253, 134, 77, 1);
            _fourLab.backgroundColor  = [UIColor whiteColor];
            
            [_timer invalidate];
            _timer = nil;
            [_againBtn setTitle:@"重发" forState:UIControlStateNormal];
            _againBtn.backgroundColor = MMColor(255, 70, 92, 1);
            break;
        }
        case 4: {
            _oneLab.text   = [_hideTextField.text substringWithRange:NSMakeRange(0, 1)];
            _twoLab.text   = [_hideTextField.text substringWithRange:NSMakeRange(1, 1)];
            _threeLab.text = [_hideTextField.text substringWithRange:NSMakeRange(2, 1)];
            _fourLab.text  = [_hideTextField.text substringWithRange:NSMakeRange(3, 1)];
            
            _oneLab.backgroundColor   = MMColor(251, 44, 75, 1);
            _twoLab.backgroundColor   = MMColor(248, 85, 72, 1);
            _threeLab.backgroundColor = MMColor(253, 134, 77, 1);
            _fourLab.backgroundColor  = MMColor(252, 173, 72, 1);
            
            [_againBtn setTitle:@"完成" forState:UIControlStateNormal];
            _againBtn.backgroundColor = MMColor(250, 44, 75, 1);
            break;
        }
        default:
            break;
    }
    
}

- (void)createUI
{
    [self.tishiLab sizeToFit];
    self.phoneLab.text = self.phoneNumble;
    [self.backBtn bk_whenTapped:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.againBtn bk_whenTapped:^{
        
        switch ([_hideTextField.text length]) {
            case 4: {
                [MBProgressHUD showWindowMessageThenHide:@"正在登陆"];
                [self request];
            }
                break;
            default: {
                //重新发起获取验证码网络请求
                [SMS_SDK getVerificationCodeBySMSWithPhone:self.phoneNumble zone:@"86" result:^(SMS_SDKError *error) {
                    if (!error) {
                        [MBProgressHUD showWindowSuccessThenHide:@"获取验证码成功"];
                    } else {
                        [MBProgressHUD showWindowErrorThenHide:@"获取验证码失败"];
                    }
                }];
            }
                break;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - taxtField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    switch ([_hideTextField.text length]) {
        case 4: {
            [MBProgressHUD showWindowMessageThenHide:@"正在登陆"];
            [self request];
        }
            break;
        default: {
            //重新发起获取验证码网络请求
            [SMS_SDK getVerificationCodeBySMSWithPhone:self.phoneNumble zone:@"86" result:^(SMS_SDKError *error) {
                if (!error) {
                   [MBProgressHUD showWindowSuccessThenHide:@"获取验证码成功"];
                } else {
                    [MBProgressHUD showWindowErrorThenHide:@"获取验证码失败"];
                }
            }];
        }
            break;
    }
    return YES;
}

//调取通讯录
- (void)updatePhoneBook{
    [[PhoneBookTools sharePhoneBookTools] getPhoneBook:^(NSMutableArray *phoneBookArr) {
        [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"/infoUp/upLoadContacts.api" parmars:@{@"user_id":[MMUserDefaultTool objectForKey:MMUserID], @"contactsJSON":[phoneBookArr JSONString]} success:^(id responseObject) {
            [MMUserDefaultTool setObject:@"UpLoad" forKey:MMUpLoad];
        } fail:^(NSError *error) {
            
        }];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //只能输入4行
    NSInteger length = textField.text.length;
    if (length >= 4  &&  string.length > 0) {
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

//请求数据  跳转到下一页
- (void)request
{
    NSDictionary *parmars = @{@"client_id":[OpenUDID value], @"terminal":@"1", @"mobile":self.phoneNumble, @"code":_hideTextField.text};
    [[MMHTTPRequest sharedHTTPRequest] openAPIPostToMethod:@"api/login/codeConfirm.api" parmars:parmars success:^(id responseObject) {
        [MBProgressHUD showWindowSuccessThenHide:@"登录成功"];
        NSDictionary *obj = [responseObject objectForKey:@"obj"];
        NSString *token   = obj[@"userInfo"][@"userToken"][@"token"];
        NSString *userID  = obj[@"userInfo"][@"user_id"];
        NSDictionary *loction = obj[@"userInfo"][@"userControl"];
        if (![loction isKindOfClass:[NSNull class]]){
            NSString *loc = loction[@"loction"];
            [MMUserDefaultTool setObject:loc forKey:MMLoction];
        }
        //推送注册别名
        [APService setAlias:userID callbackSelector:nil object:nil];
        [MMUserDefaultTool setObject:token forKey:MMToken];
        [MMUserDefaultTool setObject:userID forKey:MMUserID];
        [MMUserDefaultTool setObject:self.phoneNumble forKey:MMPhone];
        
        
        _personModel = [MTLJSONAdapter modelOfClass:[MMPerson class] fromJSONDictionary:responseObject[@"obj"][@"userInfo"] error:nil];
        
        [MMUserDefaultTool setObject:_personModel.avatar forKey:MMAvatar];
        [MMUserDefaultTool setObject:_personModel.nick_name forKey:MMName];
        [MMUserDefaultTool setObject:[NSString stringWithFormat:@"%@", _personModel.gender] forKey:MMSex];
        if ([_personModel.userProfile[@"title"] isKindOfClass:[NSNull class]]) {
        } else {
            [MMUserDefaultTool setObject:_personModel.userProfile[@"title"] forKey:MMtitle];
        }
        
        NSString *type = [obj objectForKey:@"type"];
        if ([type isEqualToString:@"0"]) {
            //跳转到设置头像页面
            MMSetInfoViewController *info = [[MMSetInfoViewController alloc] init];
            info.showNavi = NO;
            [self.navigationController pushViewController:info animated:YES];
                    [self updatePhoneBook];//调取通讯录
        } else {
            // 跳转到主界面
            MMOneViewController *one = [[MMOneViewController alloc] init];
            one.showNavi = NO;
            one.isFirst = @"N";
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:one];
            MMMenuViewController *leftMenuViewController = [[MMMenuViewController alloc] init];
           RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController leftMenuViewController:leftMenuViewController rightMenuViewController:nil];
            sideMenuViewController.backgroundImage = [UIImage imageNamed:@"BG_sbp"];
            [[AppDelegate shared].window setRootViewController:sideMenuViewController];
                    [self updatePhoneBook];//调取通讯录
        }
    } fail:^(NSError *error) {
        [MBProgressHUD showWindowErrorThenHide:@"登陆失败"];
        [_hideTextField setText:nil];
        _oneLab.text   = @"";
        _twoLab.text   = @"";
        _threeLab.text = @"";
        _fourLab.text  = @"";
        
        _oneLab.backgroundColor   = [UIColor whiteColor];
        _twoLab.backgroundColor   = [UIColor whiteColor];
        _threeLab.backgroundColor = [UIColor whiteColor];
        _fourLab.backgroundColor  = [UIColor whiteColor];
        [_againBtn setTitle:@"重发" forState:UIControlStateNormal];
        _againBtn.backgroundColor = MMColor(255, 70, 92, 1);
    }];
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
    [_keyBoardScroll setContentOffset:CGPointMake(0, keyboardSize.height) animated:YES];
}
- (void) keyboardWasHidden:(NSNotification *) notif {
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    [_keyBoardScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

@end
