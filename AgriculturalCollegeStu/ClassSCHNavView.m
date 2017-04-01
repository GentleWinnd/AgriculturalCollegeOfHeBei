//
//  ClassSCHNavView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/12.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "ClassSCHNavView.h"

@implementation ClassSCHNavView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
//    _leftBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    _rightBtn.transform = CGAffineTransformMakeRotation(-M_PI);
}


- (IBAction)btnAction:(UIButton *)sender {
    
    if (sender.tag == 1) {//left
        self.btnSelectd(YES);
    } else {
        self.btnSelectd(NO);
    }
}

@end
