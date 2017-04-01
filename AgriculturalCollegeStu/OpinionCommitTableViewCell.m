//
//  OpinionCommitTableViewCell.m
//  OldUniversity
//
//  Created by mahaomeng on 15/10/19.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "OpinionCommitTableViewCell.h"

@implementation OpinionCommitTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onCommitBtnClick:(UIButton *)sender {
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:nil];
    }
    
}
@end
