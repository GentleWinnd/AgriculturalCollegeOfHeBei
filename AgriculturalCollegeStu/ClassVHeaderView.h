//
//  ClassVHeaderView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/14.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^moreBtnSelcted)(UIButton *moreBtn);

@interface ClassVHeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;

@property (nonatomic, copy) moreBtnSelcted selectedBtn;
@end
