//
//  StatisticalStuInfoTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/11.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "StatisticalStuInfoTableViewCell.h"

@implementation StatisticalStuInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setViewRadius:self.backView1];
    [self setViewRadius:self.backView2];
    [self setViewRadius:self.backView3];
    
}

- (void)setViewRadius:(UIView *)view {
    
    view.layer.cornerRadius = 6;
    view.layer.borderColor = MainThemeColor_Blue.CGColor;
    view.layer.borderWidth = 1;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
