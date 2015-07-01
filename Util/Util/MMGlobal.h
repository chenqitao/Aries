//
//  MMGlobal.h
//  Manito
//
//  Created by Johnny on 15/4/27.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#ifdef DEBUG
#define HHDPRINT(xx, ...)  NSLog(@"打印开始: %s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#elif RELEASE
#define HHDPRINT(xx, ...)  NSLog(@"打印开始: %s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define HHDPRINT(xx, ...)  ((void)0)
#endif

#define MMColor(r, g, b, al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0f ? YES : NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0f ? YES : NO)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define KKScreenWith    [UIScreen mainScreen].bounds.size.width
#define KKScreenHeight  [UIScreen mainScreen].bounds.size.height
#define KKIOSUIDevice   [[[UIDevice currentDevice] systemVersion] floatValue]

#define MMBaseColor [UIColor colorWithRed:251.0/255.0 green:44.0/255.0 blue:74.0/255.0 alpha:1];

//推送的东西
#define Remote @"remote"

//用户的Userid
#define MMUserID   @"UserID"
//用户的token
#define MMToken    @"Token"
//电话
#define MMPhone @"phone"
//上传一次通讯录
#define MMUpLoad @"UpLoad"
//位置公开信息
#define MMLoction @"location"
//通知的时间
#define MMEnterBackOrTerminateTime @"notificationTime"

//用户姓名
#define MMName @"nick_name"
//性别
#define MMSex  @"gender"
//头像
#define MMAvatar @"avatar"
//头衔
#define MMtitle @"title"
//主页面数据
#define MMOneData @"oneData"
//附近好友数据
#define MMNerData @"nerData"
//添加好友数据
#define MMaddData @"addData"
//存图片缓存的地址
//#define CCDataCacheDirectory [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, \
//NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString: @"/CarCircle/dataCache/"]


