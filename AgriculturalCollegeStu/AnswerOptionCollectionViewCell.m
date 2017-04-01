//
//  AnswerOptionCollectionViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "AnswerOptionCollectionViewCell.h"
#import "UIImage+Color.h"

@implementation AnswerOptionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.optionBtn setBackgroundImage:[UIImage imageFromColor:MainThemeColor_Blue withSize:self.optionBtn.frame.size] forState:UIControlStateSelected];
    
    self.optionBtn.layer.cornerRadius = 2;
    self.optionBtn.layer.borderColor = MainThemeColor_Blue.CGColor;
    self.optionBtn.layer.borderWidth = 1;
    
}

- (IBAction)optionAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.optionClick) {
        self.optionClick(sender);
    }
}


@end
