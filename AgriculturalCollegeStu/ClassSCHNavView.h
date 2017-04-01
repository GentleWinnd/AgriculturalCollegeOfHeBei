//
//  ClassSCHNavView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/12.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassSCHNavView : UIView
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (copy, nonatomic) void(^btnSelectd)(BOOL isLeft);
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *datePsace;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@end
