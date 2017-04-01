//
//  GradeAnswerTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "GradeAnswerTableViewCell.h"

@implementation GradeAnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.questionNum.layer.borderWidth = 1;
    self.questionNum.layer.borderColor = MainThemeColor_Blue.CGColor;
    self.questionNum.layer.cornerRadius = 3;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
