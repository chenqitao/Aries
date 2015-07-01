//
//  MMNearModel.h
//  Manito
//
//  Created by manito on 15/5/25.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MTLModel.h"

@interface MMNearModel : MTLModel<MTLJSONSerializing>

//user_id
//string	用户ID
//nick_name
//string	用户名称
//avatar
//string	头像路径
//latitude
//double	纬度
//longitude
//double	经度
//distance

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) double distance;

@end
