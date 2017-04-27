//
//  StatisticalMonthInfoTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/11.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticalMonthInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
//
@property (strong, nonatomic) IBOutlet UILabel *leaveLabel;
@property (strong, nonatomic) IBOutlet UILabel *signLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;

//
@property (strong, nonatomic) IBOutlet UILabel *questionNum;

//
@property (strong, nonatomic) IBOutlet UIView *backView1;//请假
@property (strong, nonatomic) IBOutlet UIView *backView2;//签到
@property (strong, nonatomic) IBOutlet UIView *backView3;
//
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *signTrailingsPace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leavedTrailingSpace;
//
@property (assign, nonatomic) BOOL hasAsked;
@property (assign, nonatomic) int questedNum;

- (void)setShowState;
@end
