//
//  MMNearTableViewCell.m
//  Manito
//
//  Created by manito on 15/5/22.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMNearTableViewCell.h"

@implementation MMNearTableViewCell

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
        
        _loctionLab = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_loctionLab];
        [_loctionLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [_loctionLab autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//        [_loctionLab autoSetDimensionsToSize:CGSizeMake(80, 44)];
        _loctionLab.textColor = MMColor(128, 128, 128, 1);
        _loctionLab.textAlignment = NSTextAlignmentRight;
        
        _naemLab = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_naemLab];
        [_naemLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconIV withOffset:20];
        [_naemLab autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_loctionLab withOffset:20];
        [_naemLab autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
