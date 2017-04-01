//
//  CDayTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/20.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "CDayTableViewCell.h"

@implementation CDayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
