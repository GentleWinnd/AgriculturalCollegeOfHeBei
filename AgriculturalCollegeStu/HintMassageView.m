//
//  HintMassageView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "HintMassageView.h"

@implementation HintMassageView

+ (instancetype)initLayoutView {
    HintMassageView *OSelf = [[NSBundle mainBundle] loadNibNamed:@"HintMassageView" owner:nil options:nil].lastObject;
    
    return OSelf;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    [self addGestureRecognizer:tap];
    
}

- (void)tapAction {
    if ([self.delegate respondsToSelector:@selector(hiddenSelfView)]) {
        [self.delegate hiddenSelfView];

    }
    if (self.hiddenSelf) {
        self.hiddenSelf();
    }
    [self removeFromSuperview];

}

- (IBAction)btnClickAction:(UIButton *)sender {
    [self tapAction];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
