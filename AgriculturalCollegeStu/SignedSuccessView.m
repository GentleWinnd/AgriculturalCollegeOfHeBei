//
//  SignedSuccessView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/27.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "SignedSuccessView.h"

@implementation SignedSuccessView

+ (instancetype)initLayoutView {
    SignedSuccessView *view = [[NSBundle mainBundle] loadNibNamed:@"SignedSuccessView" owner:nil options:nil].lastObject;
    
       return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView:)];
    [self addGestureRecognizer:tap];
}

- (void)hiddenView:(UIGestureRecognizer *)tap {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
