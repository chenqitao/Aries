//
//  MMAddFriendTableViewCell.m
//  Manito
//
//  Created by manito on 15/5/19.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMAddFriendTableViewCell.h"

@implementation MMAddFriendTableViewCell

- (void)awakeFromNib {

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconIV = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_iconIV];
        [_iconIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [_iconIV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_iconIV autoSetDimensionsToSize:CGSizeMake(52, 52)];
        _iconIV.layer.cornerRadius = 52/2;
        _iconIV.clipsToBounds = YES;
        
        _startBtn = [UIButton newAutoLayoutView];
        _startBtn.userInteractionEnabled = YES;
        [self.contentView addSubview:_startBtn];
        [_startBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [_startBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_startBtn autoSetDimensionsToSize:CGSizeMake(75/2, 33)];
        [_startBtn addTarget:self action:@selector(tapBtnDown:) forControlEvents:UIControlEventTouchUpInside];
        
        _nameLab = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_nameLab];
        [_nameLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconIV withOffset:20];
        [_nameLab autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_startBtn withOffset:20];
        [_nameLab autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        _phoneNameLab = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_phoneNameLab];
        [_phoneNameLab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameLab withOffset:5];
        [_phoneNameLab autoConstrainAttribute:ALAttributeLeft toAttribute:ALAttributeLeft ofView:_nameLab];
        _phoneNameLab.font = [UIFont systemFontOfSize:12];
        _phoneNameLab.textColor = MMColor(128, 128, 128, 1);
        
    }
    return self;
}

- (void)tapBtnDown:(id)sender
{
    if ([_delegate respondsToSelector:@selector(tappedAddFriendTableviewCellStartBtn:)]) {
        [_delegate tappedAddFriendTableviewCellStartBtn:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
