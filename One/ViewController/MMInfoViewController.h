//
//  MMAddFriendViewController.h
//  Manito
//
//  Created by manito on 15/5/5.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMBaseViewController.h"
#import "MMInfoModel.h"

typedef void (^ModifyImageBlock) (NSString *haveChangedImage); //改变后图片

@interface MMInfoViewController : MMBaseViewController

@property (nonatomic, strong) MMInfoModel          *infoModel;//个人信息数据
@property (nonatomic, strong) MMTitleModel         *titleModel;//个人头衔数据
@property (nonatomic, copy  ) ModifyImageBlock     imageBlock;

@end
