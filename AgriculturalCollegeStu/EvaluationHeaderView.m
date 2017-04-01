//
//  EvaluationHeaderView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "EvaluationHeaderView.h"

@implementation EvaluationHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.reselectedBtn.hidden = YES;
    self.EoneLabel.layer.cornerRadius = 3;
    self.EoneLabel.clipsToBounds = YES;
    self.ETwoLabel.layer.cornerRadius = 3;
    self.ETwoLabel.clipsToBounds = YES;
    self.EThreeLabel.layer.cornerRadius = 3;
    self.EThreeLabel.clipsToBounds = YES;
    
}

- (NSDictionary *)setEvaluationScoreColorWithScore:(CGFloat)score {
    NSDictionary *scoreGread;
    if (score>2.5&&score<4.5) {
        scoreGread = @{@"color":MainColor_Red,
                       @"gread":@"平"};
    } else if (score<=2.5) {
        scoreGread = @{@"color":MainEvaluColor_Green,
                       @"gread":@"低"};
    
    } else {
        scoreGread = @{@"color":MainColor_Red,
                       @"gread":@"高"};

    }
    return scoreGread;
}

- (IBAction)reselectedCourse:(UIButton *)sender {
    if (self.reselecteCourse) {
        self.reselecteCourse();
    }
}

@end
