//
//  MMShareModel.h
//  Manito
//
//  Created by manito on 15/6/2.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MTLModel.h"

@interface MMShareModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy  ) NSString     *user_id;
@property (nonatomic, copy  ) NSString     *account;
@property (nonatomic, copy  ) NSString     *nick_name;
@property (nonatomic, copy  ) NSString     *password;
@property (nonatomic, copy  ) NSString     *email;
@property (nonatomic, copy  ) NSString     *avatar;
@property (nonatomic, copy  ) NSString     *pinyin_name;
@property (nonatomic, copy  ) NSString     *birthday;
@property (nonatomic, copy  ) NSString     *gender;
@property (nonatomic, copy  ) NSString     *lid;
@property (nonatomic, copy  ) NSString     *updatetime;
@property (nonatomic, copy  ) NSString     *systime;
@property (nonatomic, strong) NSDictionary *userAvatar;
@property (nonatomic, strong) NSDictionary *userProfile;

@end
