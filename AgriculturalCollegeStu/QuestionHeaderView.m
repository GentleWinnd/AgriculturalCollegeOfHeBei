//
//  QuestionHeaderView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "QuestionHeaderView.h"

@implementation QuestionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.questionType.layer.cornerRadius = 3;
    self.questionType.layer.borderColor = MainThemeColor_Blue.CGColor;
    self.questionType.layer.borderWidth = 1;
    
}

- (void)setType:(NSInteger)type {
    switch (type) {
        case 1:
            self.questionType.text = @"单选题";
            break;
        case 2:
            self.questionType.text = @"多选题";
            break;
        case 3:
            self.questionType.text = @"判断题";
            break;
        case 4:
            self.questionType.text = @"填空题";
            break;
 
        default:
            break;
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
