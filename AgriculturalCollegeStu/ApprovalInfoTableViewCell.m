//
//  ApprovalInfoTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/12.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ApprovalInfoTableViewCell.h"

@implementation ApprovalInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.agreeBtn.layer.borderWidth = 1;
    self.agreeBtn.layer.cornerRadius = 3;
    self.agreeBtn.layer.borderColor = MainThemeColor_Blue.CGColor;
    self.agreeBtn.titleLabel.textColor = MainThemeColor_Blue;
    
    self.rejectBtn.layer.borderWidth = 1;
    self.rejectBtn.layer.cornerRadius = 3;
    self.rejectBtn.layer.borderColor = RulesLineColor_LightGray.CGColor;
    self.rejectBtn.titleLabel.textColor = RulesLineColor_LightGray;
    
    self.portraitImageView.layer.cornerRadius = 18;
    self.portraitImageView.layer.masksToBounds = YES;
}
- (IBAction)approvalBtnAction:(UIButton *)sender {

    if (sender.tag == 1) {
        self.approvalResult(YES);
    } else {
        self.approvalResult(NO);
    
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
