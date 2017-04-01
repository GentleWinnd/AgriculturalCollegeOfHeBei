//
//  CourseNumCollectionViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "CourseNumCollectionViewCell.h"

@implementation CourseNumCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.courseNumLabel.layer.cornerRadius = 21;
    self.courseNumLabel.layer.borderColor = RulesLineColor_DarkGray.CGColor;
    self.courseNumLabel.layer.borderWidth = 1;
    
}

- (void)setSelectedColor {
    
    self.courseNumLabel.layer.borderColor = MainThemeColor_Blue.CGColor;
    self.courseNumLabel.layer.backgroundColor = MainThemeColor_LightBlue.CGColor;
    self.courseNumLabel.textColor = MainThemeColor_Blue;
}


@end
