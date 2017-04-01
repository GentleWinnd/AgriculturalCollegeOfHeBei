//
//  AnswerOptionCollectionViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//
typedef void(^OptionBtnClick) (UIButton *sender);

#import <UIKit/UIKit.h>

@interface AnswerOptionCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIButton *optionBtn;
@property (copy, nonatomic) OptionBtnClick optionClick;


@end
