//
//  MMMyDataViewController.h
//  Manito
//
//  Created by manito on 15/5/19.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMBaseViewController.h"

@class MMOneModel;
@interface MMMyDataViewController : MMBaseViewController
@property (nonatomic, strong) MMOneModel *oneModel;

@property (nonatomic, copy) NSString *type;
@end
