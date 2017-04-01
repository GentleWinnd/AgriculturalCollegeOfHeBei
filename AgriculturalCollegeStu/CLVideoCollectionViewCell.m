//
//  CLVideoCollectionViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/14.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "CLVideoCollectionViewCell.h"

@implementation CLVideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.borderColor = MainBackgroudColor_GrayAndWhite.CGColor;
    self.contentView.layer.borderWidth = 3;
    self.contentView.layer.shadowColor = RulesLineColor_DarkGray.CGColor;
    self.contentView.layer.shadowOpacity = 0.8;
    self.contentView.layer.shadowOffset = CGSizeMake(3,3 );
    

}

@end
