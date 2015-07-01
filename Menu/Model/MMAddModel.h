//
//  MMAddModel.h
//  Manito
//
//  Created by manito on 15/5/27.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MTLModel.h"

@interface MMAddModel : MTLModel<MTLJSONSerializing>

//avatar = "/media/users/logo/003/33/200400666669_33394.jpg";
//"nick_name" = "Touch Fun";
//status = 3;
//"user_id" = 200400666669;

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *addressListName;
@property (nonatomic, copy) NSString *mobileNumber;

@end
