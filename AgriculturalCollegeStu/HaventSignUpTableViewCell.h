//
//  HaventSignUpTableViewCell.h
//  OldUniversity
//
//  Created by mahaomeng on 15/8/27.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HaventSignUpViewController.h"

@interface HaventSignUpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *nowTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseAllTimeLabel;
@property (nonatomic, retain) NSArray *subCourseArr;
@property (nonatomic, copy) NSString *subId;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *courseVersionId;
@property (nonatomic, strong) HaventSignUpViewController *superViewController;
- (IBAction)onSignUpBtnClick:(UIButton *)sender;
@end
