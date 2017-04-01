//
//  TestGradeView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestGradeView : UIView
@property (strong, nonatomic) IBOutlet UILabel *gradeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *middleLine;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *gradeToMiddleSpace;
@property (strong, nonatomic) IBOutlet UILabel *useTimeLabel;

@end
