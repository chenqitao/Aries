//
//  MMModifyViewController.h
//  Manito
//
//  Created by manito on 15/5/19.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMBaseViewController.h"

typedef NS_ENUM(NSInteger, ModifyType)
{
    ModifyTypeName,
    ModifyTypePhone,
    ModifyTypeSex,
    ModifyTypeTitle
};

typedef void (^ModifyCompleteBlock) (NSString *haveChangedStr); //改变后的字符串

@interface MMModifyViewController : MMBaseViewController

@property (nonatomic, assign) ModifyType type;                  //修改类型
@property (nonatomic, copy) ModifyCompleteBlock competeBlock;   //修改成功后调用的方法
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *infoStr;                  //修改的信息
@property (nonatomic, copy) NSString *placeholder;              //提示的信息

@end
