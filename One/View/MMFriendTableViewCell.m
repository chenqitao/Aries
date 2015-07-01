//
//  MMFriendTableViewCell.m
//  Manito
//
//  Created by manito on 15/5/7.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMFriendTableViewCell.h"
#import "BlocksKit+UIKit.h"
#import "SelectImageTools.h"
#import "MMOneViewController.h"

@implementation MMFriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = KKScreenWith*80/320;
        CGFloat height = KKScreenWith*172/640;
        _cellScrolview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWith, height)];
        [self.contentView addSubview:_cellScrolview];
        _cellScrolview.pagingEnabled = YES;
        _cellScrolview.contentSize = CGSizeMake(KKScreenWith + KKScreenWith*80/320, height);
        _cellScrolview.bounces = NO;
        _cellScrolview.contentOffset = CGPointMake(0, 0);
        _cellScrolview.showsVerticalScrollIndicator = NO;
        _cellScrolview.showsHorizontalScrollIndicator = NO;
        _cellScrolview.delegate = self;
        
        //左边的View
        _cellInformationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWith, height)];
        _cellInformationView.userInteractionEnabled = YES;
        [_cellScrolview addSubview:_cellInformationView];
        
        _iconIV = [UIImageView newAutoLayoutView];
        [_cellInformationView addSubview:_iconIV];
        _iconIV.userInteractionEnabled = YES;
        [_iconIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:KKScreenWith*33/640];
        [_iconIV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_iconIV autoSetDimensionsToSize:CGSizeMake(KKScreenWith*122/640, KKScreenWith*122/640)];
        _iconIV.layer.cornerRadius = (KKScreenWith*122/640)/2;
        _iconIV.clipsToBounds = YES;
        
        _nameLab = [UILabel newAutoLayoutView];
        [_cellInformationView addSubview:_nameLab];
        [_nameLab autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_nameLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconIV withOffset:65/2];
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.font = [UIFont boldSystemFontOfSize:22];
        
        _stateIV = [UIImageView newAutoLayoutView];
        [_cellInformationView addSubview:_stateIV];
        [_stateIV autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_nameLab withOffset:5];
        [_stateIV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_stateIV autoSetDimensionsToSize:CGSizeMake(25, 25)];
        
        _haveMessage = [UIImageView newAutoLayoutView];
        [_cellInformationView addSubview:_haveMessage];
        [_haveMessage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [_haveMessage autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_haveMessage autoSetDimensionsToSize:CGSizeMake(23, 22)];
        _haveMessage.image = [UIImage imageNamed:@"icon_feedback_mp"];
        
        _loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
        [_loadingView setCenter:CGPointMake(KKScreenWith/2, height/2)];//指定进度轮中心点
        [_loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
        [_cellInformationView addSubview:_loadingView];
        
        //右边的View
        _cellRightView = [[UIView alloc] initWithFrame:CGRectMake(KKScreenWith , 0, width, height)];
        [_cellScrolview addSubview:_cellRightView];

        _cameraIV = [UIImageView newAutoLayoutView];
        [_cellRightView addSubview:_cameraIV];
        [_cameraIV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_cameraIV autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_cameraIV autoSetDimensionsToSize:CGSizeMake(37, 37)];
        _cameraIV.image = [UIImage imageNamed:@"icon_photo.png"];
        
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapp:)];
        [_cellInformationView addGestureRecognizer:tap];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [_cellInformationView addGestureRecognizer:doubleTap];
        [tap requireGestureRecognizerToFail:doubleTap];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongTap:)];
        [_cellInformationView addGestureRecognizer:longTap];
    }
    return self;
}

// MARK: 手势的处理
- (void)cellTapp:(UIGestureRecognizer *)gesture {
    if ([_delegate respondsToSelector:@selector(tappedRightFriendTableviewCell:)]) {
        [_delegate tappedRightFriendTableviewCell:self];
    }
}

//点击两下
- (void)cellDoubleTap:(UIGestureRecognizer *)gesture {
    if ([_delegate respondsToSelector:@selector(tappedDoubleRightFriendTableviewCell:)]) {
        [_delegate tappedDoubleRightFriendTableviewCell:self];
    }
}

//长按手势
- (void)cellLongTap:(UILongPressGestureRecognizer *)gesture {
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        //长按事件开始"
        self.nameLab.text = @"正在发送链接";
        _linkView = [[UIImageView alloc] initWithFrame:CGRectMake(-75, 0, 75, _cellInformationView.frame.size.height)];
        [_cellInformationView addSubview:_linkView];
        _linkView.image = [UIImage imageNamed:@"light_mp"];
        
        POPBasicAnimation *base = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        base.toValue = [NSValue valueWithCGRect:CGRectMake(KKScreenWith-75, 0, 75, _cellInformationView.frame.size.height)];
        base.duration = 2.5;
        [_linkView pop_addAnimation:base forKey:@"frame"];
        [base setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            if (finished) {
                self.userInteractionEnabled = NO;
                id ann = [_linkView pop_animationKeys];
                if (ann) {
                    [_linkView pop_removeAllAnimations];
                    [self performSelector:@selector(longTapFail:) withObject:ann afterDelay:.1];
                } else {
                    
                }
//                [self performSelector:@selector(longTapSuccess:) withObject:ann afterDelay:0.1];
            }
        }];
    }
    else if ([gesture state] == UIGestureRecognizerStateEnded) {
        //长按事件结束
        self.userInteractionEnabled = NO;
        id ann = [_linkView pop_animationKeys];
        if (ann) {
            [_linkView pop_removeAllAnimations];
            [self performSelector:@selector(longTapFail:) withObject:ann afterDelay:.1];
        } else {
            
        }
        [self performSelector:@selector(longTapSuccess:) withObject:ann afterDelay:0.1];
    }
}

- (void)longTapFail:(id)annimation {
    [_linkView removeFromSuperview];
    if (annimation && [_delegate respondsToSelector:@selector(tappedLongFriendTableViewCellFail:)]) {
        [_delegate tappedLongFriendTableViewCellFail:self];
    }
}

- (void)longTapSuccess:(id)annimation {
    [_linkView removeFromSuperview];
    if (!annimation && [_delegate respondsToSelector:@selector(tappedLongFriendTableviewCell:)]) {
        [_delegate tappedLongFriendTableviewCell:self];
    }
    self.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (_cellScrolview.contentOffset.x >= KKScreenWith*80/320) {
        if ([_delegate respondsToSelector:@selector(scrollFriendTableviewCell:)]) {
            [_delegate scrollFriendTableviewCell:self];
        }
    }
}


@end
