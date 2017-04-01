//
//  AlertCollectionViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "AlertCollectionViewCell.h"
@interface AlertCollectionViewCell()


@end


@implementation AlertCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _countLabel.layer.cornerRadius= 6;
    _countLabel.layer.borderColor = RulesLineColor_LightGray.CGColor;
    _countLabel.layer.borderWidth = 1;
    
}

@end
