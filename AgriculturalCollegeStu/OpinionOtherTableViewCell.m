//
//  OpinionOtherTableViewCell.m
//  OldUniversity
//
//  Created by mahaomeng on 15/10/19.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "OpinionOtherTableViewCell.h"

@implementation OpinionOtherTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _opinionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _opinionTextView.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
