//
//  TestResultTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "TestResultTableViewCell.h"

@implementation TestResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.progressView.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
