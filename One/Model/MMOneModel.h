//
//  MMOneModel.h
//  Manito
//
//  Created by Johnny on 15/5/8.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MTLModel.h"

@interface MMOneModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *nameStr;  //名字String
@property (nonatomic, copy) NSString *imageStr; //图像String

//user_id	:	2004666681
//account	:
//nick_name	:	第三方
//password	:
//email	:
//avatar	:	null
//pinyin_name	:
//birthday	:
//gender	:	0
//lid	:	0
//updatetime	:	1432090651000
//systime	:	1432090651000
//userAvatar		{6}
//userProfile		{10}
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
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSDictionary *userAvatar;
@property (nonatomic, strong) NSDictionary *userProfile;
@property (nonatomic, strong) NSDictionary *userMobile;
@property (nonatomic, strong) NSDictionary *userContacts;

//"city_id" = "<null>";
//latitude = 120;
//longitude = 100;
//nation = "";
//"province_id" = "<null>";
//systime = "<null>";
//title = "??";
//"update_time" = "<null>";
//"user_id" = "<null>";
//"user_profile_id" = 8;

@end