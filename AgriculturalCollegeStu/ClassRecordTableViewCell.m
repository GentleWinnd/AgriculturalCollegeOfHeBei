//
//  ClassRecordTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/21.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ClassRecordTableViewCell.h"

@implementation ClassRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.stateLabel.layer.cornerRadius = 8;
    self.stateLabel.layer.borderColor = MainThemeColor_Blue.CGColor;
    self.stateLabel.layer.borderWidth = 1;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
