//
//  MMInfoModel.h
//  Manito
//
//  Created by manito on 15/5/27.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MTLModel.h"

@interface MMInfoModel : MTLModel<MTLJSONSerializing>
//user_id	:	200400666668
//account	:
//nick_name	:	hehe
//password	:
//email	:
//avatar	:	/media/users/logo/003/33/200400666668_33393.jpg
//pinyin_name	:
//birthday	:
//gender	:	0
//lid	:	100
//update_time	:	1432653568000
//systime	:	1431658574000
//userProfile		{10}
//userMobile		{5}

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
@property (nonatomic, copy) NSString *update_time;
@property (nonatomic, copy) NSString *systime;
@property (nonatomic, strong) NSDictionary *userProfile;
@property (nonatomic, strong) NSDictionary *userMobile;

@end

@interface MMTitleModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *title;

@end
