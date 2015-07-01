//
//  MMNotiView.h
//  Manito
//
//  Created by manito on 15/6/1.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMNotiView;
@protocol MMNotiViewDelegate <NSObject>

- (void)tappedDismissBtn:(MMNotiView *)notifiView;
- (void)tappedOpenBtn:(MMNotiView *)notifiView;

@end

@interface MMNotiView : UIView

@property (nonatomic, strong) UIView *notiView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UIImageView *avatarIV;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) NSDictionary *userInfoDic;    //通知的数据
@property (nonatomic, strong) NSDictionary *messageInfoDic; //消息的数据

@property (nonatomic, unsafe_unretained) id<MMNotiViewDelegate>delegate;

@end
