//
//  MMFriendTableViewCell.h
//  Manito
//
//  Created by manito on 15/5/7.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMOneModel.h"

@class MMFriendTableViewCell;
@protocol MMFriendTableViewCellDelegate <NSObject>
@required

- (void)tappedRightFriendTableviewCell:(MMFriendTableViewCell *)cell;//单击
- (void)tappedDoubleRightFriendTableviewCell:(MMFriendTableViewCell *)cell;//双击
- (void)tappedLongFriendTableviewCell:(MMFriendTableViewCell *)cell;//长按
- (void)scrollFriendTableviewCell:(MMFriendTableViewCell *)cell;//滑动
- (void)tappedLongFriendTableViewCellFail:(MMFriendTableViewCell *)cell;//停止长按
@end


@interface MMFriendTableViewCell : UITableViewCell <UIScrollViewDelegate>

@property (nonatomic, assign) id           target;
@property (nonatomic, strong) UIScrollView *cellScrolview;
@property (nonatomic, strong) UIImageView  *cellInformationView;//cell的展示信息的view
@property (nonatomic, strong) UIView       *cellRightView;
@property (nonatomic, strong) UIImageView  *iconIV;//头像
@property (nonatomic, strong) UILabel      *nameLab;
@property (nonatomic, strong) UIImageView  *cameraIV;//相机的图标
@property (nonatomic, strong) UIImageView  *linkView;//正在发送链接的View
@property (nonatomic, strong) MMOneModel   *oneModel;
@property (nonatomic, strong) UIImageView  *stateIV;//发送状态
@property (nonatomic, strong) UIImageView  *haveMessage;//是否有最新消息
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, assign) BOOL one;//只发送一次链接

@property (nonatomic, unsafe_unretained) id<MMFriendTableViewCellDelegate>delegate;

@end
