//
//  MMInfoTableViewCell.m
//  Manito
//
//  Created by manito on 15/5/19.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMInfoTableViewCell.h"

@implementation MMInfoTableViewCell

- (void)awakeFromNib {
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconIV  = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_iconIV];
        [_iconIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
        [_iconIV autoSetDimensionsToSize:CGSizeMake(24 , 24)];
        
        _text = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_text];
        [_text autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconIV withOffset:30];
        [_text autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_iconIV];
        _text.numberOfLines = 0;
        _text.font = [UIFont systemFontOfSize:16];
        [_text autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
        [_text autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15];
        [_text autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    _text.preferredMaxLayoutWidth = CGRectGetWidth(_text.frame);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
