//
//  StatisticalMonthInfoTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/11.
//  Copyright © 2017年 YH. All rights reserved.
//


#import "StatisticalMonthInfoTableViewCell.h"

@implementation StatisticalMonthInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewRadius:self.backView1];
    [self setViewRadius:self.backView2];
    [self setViewRadius:self.backView3];
    self.signLabel.textColor = MainThemeColor_Blue;
    self.questionNum.textColor = MainColor_Green;
    self.questionLabel.textColor = MainColor_Green;
    self.leaveLabel.textColor = MainColor_Orange;
    
    self.backView1.layer.borderColor = MainColor_Orange.CGColor;
    self.backView2.layer.borderColor = MainThemeColor_Blue.CGColor;
    self.backView3.layer.borderColor = MainColor_Green.CGColor;
}

- (void)setShowState {

    if (self.questedNum == 0) {//提问
        self.backView3.hidden = YES;
    } else {
        self.backView3.hidden = NO;
        self.questionNum.text = [NSString stringWithFormat:@"%d",self.questedNum];
    }
    
    self.backView1.hidden = !self.hasAsked;
    

    if (self.questedNum == 0) {
        if (self.hasAsked) {
            self.signTrailingsPace.constant = 87;
            self.leavedTrailingSpace.constant = 20;

        } else {
            self.signTrailingsPace.constant = 20;
        }
    } else {
        if (self.hasAsked == NO) {
            self.signTrailingsPace.constant = 87;
        }
    }
    
}

- (void)setViewRadius:(UIView *)view {
    
    view.layer.cornerRadius = 10;
    view.layer.borderWidth = 1;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
