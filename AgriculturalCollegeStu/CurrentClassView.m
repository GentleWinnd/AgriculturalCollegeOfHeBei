//
//  CurrentClassView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "CurrentClassView.h"

@implementation CurrentClassView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)initViewLayout {
    
    CurrentClassView *selfObj = [[NSBundle mainBundle] loadNibNamed:@"CurrentClassView" owner:self options:nil].lastObject;
    return selfObj;
}

- (IBAction)selectedAction:(UIButton *)sender {
    self.selectedClick(sender);
}

@end
