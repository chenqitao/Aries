//
//  MMMenuTableViewCell.m
//  Manito
//
//  Created by manito on 15/5/14.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMMenuTableViewCell.h"

@implementation MMMenuTableViewCell

- (void)awakeFromNib {
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconIV = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_iconIV];
        [_iconIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:35];
        [_iconIV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_iconIV autoSetDimensionsToSize:CGSizeMake(24, 24)];
        
        _titleLab = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_titleLab];
        [_titleLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconIV withOffset:10];
        [_titleLab autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_iconIV];
        [_titleLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        _titleLab.textColor = [UIColor whiteColor];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
