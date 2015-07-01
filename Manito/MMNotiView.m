//
//  MMNotiView.m
//  Manito
//
//  Created by manito on 15/6/1.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMNotiView.h"
#import "MMString.h"

@interface MMNotiView ()

@end

@implementation MMNotiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    _notiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWith, KKScreenWith*120/320)];
    [self addSubview:_notiView];
    _notiView.backgroundColor = MMColor(37, 55, 67, .94);;
    
    _avatarIV = [UIImageView newAutoLayoutView];
    [_notiView addSubview:_avatarIV];
    [_avatarIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [_avatarIV autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [_avatarIV autoSetDimensionsToSize:CGSizeMake(KKScreenWith*82/640, KKScreenWith*82/640)];
    _avatarIV.layer.cornerRadius = KKScreenWith*82/640/2;
    _avatarIV.clipsToBounds = YES;
    
    _timeLab = [UILabel newAutoLayoutView];
    [_notiView addSubview:_timeLab];
    [_timeLab autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_avatarIV];
    [_timeLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_avatarIV withOffset:20];
    _timeLab.textColor = [UIColor whiteColor];
    _timeLab.font = [UIFont systemFontOfSize:15];
    _timeLab.alpha = .8;
    
    _infoLab = [UILabel newAutoLayoutView];
    [_notiView addSubview:_infoLab];
    [_infoLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_timeLab];
    [_infoLab autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_avatarIV];
    [_infoLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    _infoLab.textColor = [UIColor whiteColor];
    _infoLab.font = [UIFont boldSystemFontOfSize:16];
    
    _lineView = [UIView newAutoLayoutView];
    [_notiView addSubview:_lineView];
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [_lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_infoLab withOffset:10];
    [_lineView autoSetDimension:ALDimensionHeight toSize:1];
    _lineView.backgroundColor = MMColor(190, 190, 190, .3);
    
    _dismissBtn = [UIButton newAutoLayoutView];
    [_notiView addSubview:_dismissBtn];
    [_dismissBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [_dismissBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [_dismissBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lineView withOffset:10];
    _dismissBtn.backgroundColor = MMColor(190, 190, 190, .3);
    _dismissBtn.layer.cornerRadius = 10;
    _dismissBtn.clipsToBounds = YES;
    [_dismissBtn setTitle:@"忽略" forState:UIControlStateNormal];
    [_dismissBtn addTarget:self action:@selector(tappedDismissBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    
    _openBtn = [UIButton newAutoLayoutView];
    [_notiView addSubview:_openBtn];
    [_openBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [_openBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [_openBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_dismissBtn];
    [_openBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_dismissBtn withOffset:15];
    [_openBtn autoConstrainAttribute:ALAttributeWidth toAttribute:ALAttributeWidth ofView:_dismissBtn];
    _openBtn.backgroundColor = MMColor(190, 190, 190, .3);
    _openBtn.layer.cornerRadius = 10;
    _openBtn.clipsToBounds = YES;
    [_openBtn setTitle:@"打开" forState:UIControlStateNormal];
    [_openBtn addTarget:self action:@selector(tappedOpenBtnDown:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUserInfoDic:(NSDictionary *)userInfoDic
{
    _userInfoDic = [userInfoDic copy];
    _messageInfoDic = nil;
    
//    NSString *alert  = _userInfoDic[@"aps"][@"alert"];
    NSString *avatar = _userInfoDic[@"avatar"];
    NSString *name   = _userInfoDic[@"name"];
    NSString *time   = _userInfoDic[@"time"];

    [self.avatarIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:avatar]] placeholderImage:[UIImage imageNamed:@"head_main page"]];
    self.timeLab.text = [self timeIntervalSince1970:[time doubleValue] formot:@"MM-dd HH:mm"];
    NSString *messageType = _userInfoDic[@"messageType"];
    
    if ([messageType isEqualToString:@"HI"]) {
        self.infoLab.text = [NSString stringWithFormat:@"%@发来一个%@",name,@"Hi"];
        [self.openBtn setTitle:@"回Hi" forState:UIControlStateNormal];
    }
    if ([messageType isEqualToString:@"LOCATION"]) {
        self.infoLab.text = [NSString stringWithFormat:@"%@%@",name,@"发来了一个位置"];
        [self.openBtn setTitle:@"打开" forState:UIControlStateNormal];
    }
    if ([messageType isEqualToString:@"URL"]) {
        self.infoLab.text =[NSString stringWithFormat:@"%@发来一条链接",name];
        [self.openBtn setTitle:@"打开" forState:UIControlStateNormal];
    }
    if ([messageType isEqualToString:@"PIC"]) {
        self.infoLab.text = [NSString stringWithFormat:@"%@%@",name,@"发来一张图片"];
        [self.openBtn setTitle:@"打开" forState:UIControlStateNormal];
    }
}

- (void)setMessageInfoDic:(NSDictionary *)messageInfoDic
{
    _messageInfoDic = [messageInfoDic copy];
    _userInfoDic = nil;
    
    NSString *content  = _messageInfoDic[@"content"];
    NSString *avatar = _messageInfoDic[@"avatar"];
    NSString *name   = _messageInfoDic[@"nick_name"];
    NSString *time   = _messageInfoDic[@"systime"];
    
    [self.avatarIV setImageWithURL:[NSURL URLWithString:[MMString photoStringWithSubString:avatar]] placeholderImage:[UIImage imageNamed:@"head_main page"]];
    self.timeLab.text = [self timeIntervalSince1970:[time doubleValue] formot:@"MM-dd HH:mm"];
    
    int messageType = [_messageInfoDic[@"topic_type"] intValue];
    if (messageType == 0) {//YO
        self.infoLab.text = [NSString stringWithFormat:@"%@发来一个%@",name,content];
        [self.openBtn setTitle:@"回HI" forState:UIControlStateNormal];
    } else if (messageType == 5) {//位置
        self.infoLab.text = [NSString stringWithFormat:@"%@%@",name,content];
        [self.openBtn setTitle:@"打开" forState:UIControlStateNormal];
    } else if (messageType == 3) {//链接
        self.infoLab.text =[NSString stringWithFormat:@"%@发来一条链接",name];
        [self.openBtn setTitle:@"打开" forState:UIControlStateNormal];
    } else if (messageType == 1) {//图片
        self.infoLab.text = [NSString stringWithFormat:@"%@%@",name,content];
        [self.openBtn setTitle:@"打开" forState:UIControlStateNormal];
    }
}

- (NSString *)timeIntervalSince1970:(double)interval
                             formot:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (void)tappedDismissBtnDown:(id)sender
{
    if ([_delegate respondsToSelector:@selector(tappedDismissBtn:)]) {
        [_delegate tappedDismissBtn:self];
    }
}

- (void)tappedOpenBtnDown:(id)sender
{
    if ([_delegate respondsToSelector:@selector(tappedOpenBtn:)]) {
        [_delegate tappedOpenBtn:self];
    }
}

@end
