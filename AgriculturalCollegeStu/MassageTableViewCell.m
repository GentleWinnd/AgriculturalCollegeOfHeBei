//
//  MassageTableViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/8.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "MassageTableViewCell.h"
#import "RecentCourseManager.h"

@implementation MassageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (IBAction)classScheduleAction:(UIButton *)sender {
    if (sender.tag == 1) {//选课
        self.classSchedule(sender);
    } else {//刷新最近课程
        [RecentCourseManager getRecentCourseInView:nil success:^(NSDictionary *coursesInfo) {
            self.massageLabel.text = [NSString safeString:coursesInfo[@"Dependent"][@"DependentName"]];
            
        } failure:^(NSString *failMessage) {
            
        }];
    }
}

- (IBAction)reloadCurrentClass:(UIButton *)sender {
    if (_reloadCurrentClass) {
        self.reloadCurrentClass();
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
