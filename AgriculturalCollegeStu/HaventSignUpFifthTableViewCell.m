//
//  HaventSignUpFifthTableViewCell.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/28.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "HaventSignUpFifthTableViewCell.h"

@implementation HaventSignUpFifthTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _signInBtn.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
