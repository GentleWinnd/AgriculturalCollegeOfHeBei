//
//  OpinionTableViewCell.m
//  OldUniversity
//
//  Created by mahaomeng on 15/10/19.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "OpinionTableViewCell.h"

@implementation OpinionTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectBtn:(UIButton *)sender {
    
    if (_btnClickBlock) {
        _btnClickBlock(sender);
    }
    
}
@end
