//
//  NoDataView.m
//  AgriculturalCollegeStu
//
//  Created by SUPADATA on 2017/5/12.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (IBAction)clickBtnAction:(UIButton *)sender {
    
    if (self.type == NoDataTypeDefualt) {
    } else {
        if (self.reloadData) {
            self.reloadData();
            [self removeFromSuperview];
        }
    }
}

+ (instancetype)layoutNoDataView {
    NoDataView *slf = [[[NSBundle mainBundle] loadNibNamed:@"NoDataView" owner:self options:nil]  lastObject];
    return slf;
}

- (void)setType:(NoDataType)type {
    if (type == NoDataTypeDefualt) {
        [self.clickBtn setTitle:@"暂无数据" forState:UIControlStateNormal];

    } else {
        [self.clickBtn setTitle:@"数据加载失败了" forState:UIControlStateNormal];
    }
}

- (void)removeNoDataView {
    [self removeFromSuperview];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
