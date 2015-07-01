//
//  MMPerson.h
//  Manito
//
//  Created by manito on 15/5/22.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MTLModel.h"

@interface MMPerson : MTLModel<MTLJSONSerializing>

//user_id` '用户Id 主键',
//`account`  '登入用帐号',
//`nick_name`  '员工姓名',
//`password`  '登录密码',
//`email`  '电子邮件',
//`avatar`  '头像图片',
//`pinyin_name`  '拼音名称',
//`birthday`  '生日',
//`gender`  '性别 0：女 1：男',
//`lid` '用户级别 0：普通用户， 100：企业用户',
//`updatetime`  '修改时间',
//`systime` '创建时间',

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *pinyin_name;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *lid;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *systime;
@property (nonatomic, copy) NSDictionary *userAvatar;
@property (nonatomic, copy) NSDictionary *userProfile;

@end
