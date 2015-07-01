//
//  MMShareTableViewCell.m
//  Manito
//
//  Created by manito on 15/6/2.
//  Copyright (c) 2015年 com.Manito.apps. All rights reserved.
//

#import "MMShareTableViewCell.h"

@implementation MMShareTableViewCell

- (void)awakeFromNib {
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconIV = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:_iconIV];
        [_iconIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [_iconIV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_iconIV autoSetDimensionsToSize:CGSizeMake(52, 52)];
        _iconIV.layer.cornerRadius = 52/2;
        _iconIV.clipsToBounds = YES;
        
        _naemLab = [UILabel newAutoLayoutView];
        [self.contentView addSubview:_naemLab];
        [_naemLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconIV withOffset:20];
        [_naemLab autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
        [_naemLab autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end