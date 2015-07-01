//
//  MMAddFriendTableViewCell.h
//  Manito
//
//  Created by manito on 15/5/19.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAddModel.h"

@class MMAddFriendTableViewCell;
@protocol MMAddFriendTableViewCellDelegate <NSObject>
@required

- (void)tappedAddFriendTableviewCellStartBtn:(MMAddFriendTableViewCell *)cell;//单击

@end

@interface MMAddFriendTableViewCell : UITableViewCell



@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UILabel     *nameLab;
@property (nonatomic, strong) UIButton    *startBtn;
@property (nonatomic, strong) MMAddModel  *addModel;
@property (nonatomic, strong) UILabel     *phoneNameLab;

@property (nonatomic, unsafe_unretained) id<MMAddFriendTableViewCellDelegate>delegate;

@end
