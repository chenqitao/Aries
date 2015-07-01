//
//  MMOpenLinkViewController.h
//  Manito
//
//  Created by manito on 15/5/19.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMBaseViewController.h"

@interface MMOpenLinkViewController : MMBaseViewController

@property (nonatomic, copy) NSString *linkStr;
@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *report_id;
@property (nonatomic, assign) int type;   //用户类型，公众号等等

@end
