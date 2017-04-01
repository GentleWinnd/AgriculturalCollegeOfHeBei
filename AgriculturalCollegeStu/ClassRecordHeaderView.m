//
//  ClassRecordHeaderView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/21.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ClassRecordHeaderView.h"

@implementation ClassRecordHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.userRole == UserRoleStudent) {
        self.signedCountLabel.hidden = YES;
        self.sigendLabel.hidden = YES;
        self.leavedLabel.hidden = YES;
        self.leavedCOuntLabel.hidden = YES;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
