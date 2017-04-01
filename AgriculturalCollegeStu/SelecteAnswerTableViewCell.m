//
//  SelecteAnswerTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "SelecteAnswerTableViewCell.h"

@implementation SelecteAnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _selecteItem.layer.borderWidth = 1;
    _selecteItem.layer.cornerRadius = 10;
    _selecteItem.layer.borderColor = RulesLineColor_DarkGray.CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
