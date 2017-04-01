//
//  HaventSignInForthTableViewCell.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/27.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "HaventSignInForthTableViewCell.h"

@implementation HaventSignInForthTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _iconImageView.layer.cornerRadius = _iconImageView.frame.size.height /2.f;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
