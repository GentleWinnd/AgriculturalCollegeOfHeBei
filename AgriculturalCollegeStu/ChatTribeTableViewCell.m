//
//  ChatTribeTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/27.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "ChatTribeTableViewCell.h"

@implementation ChatTribeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImageView.layer.cornerRadius = 25;
    self.avatarImageView.clipsToBounds = YES;

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
