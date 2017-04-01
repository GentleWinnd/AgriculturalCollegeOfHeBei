//
//  HaventSignUpTableViewCell.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/27.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "HaventSignUpTableViewCell.h"
#import "MukeDetailViewController.h"
#import "UserCenterViewController.h"
#import "MBProgressManager.h"
#import "UserData.h"


@implementation HaventSignUpTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _signUpBtn.layer.cornerRadius = 5;
    _signUpBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onSignUpBtnClick:(UIButton *)sender {
    UserRole role = [UserData getUser].userRole;
    if (role == UserRoleTeacher) {
        [Progress progressShowcontent:@"此功能暂未教师开放"];
        return;
    }
    NSString *accessToken = [UserData getAccessToken];
    if (!accessToken) {
        UserCenterViewController *uvc = [[UserCenterViewController alloc]initWithFlag:YES];
        [_superViewController.navigationController pushViewController:uvc animated:YES];
        [Progress progressShowcontent:@"暂未开放，敬请期待！"];
    } else {
        if (_subCourseArr && _superViewController && sender.backgroundColor != RGB_COLOR(131, 176, 17)) {
            NSLog(@"%@", _subCourseArr);
            MBProgressManager *progress = [[MBProgressManager alloc] init];
            [progress loadingWithTitleProgress:@"正在报名"];
            if (_subCourseArr.count >0) {
                NSLog(@"%@", [_superViewController.userDefaults objectForKey:USERINFO][@"AccessToken"]);
                NSDictionary *para = @{@"BatchId" :_subCourseArr[0][@"Id"] , @"AccessToken":[UserData getAccessToken]};
                
                [NetServiceAPI postSignUpMCOVWithParameters:para success:^(id responseObject) {
                    [progress hiddenProgress];

                    if ([responseObject[@"State"] integerValue] ==1) {
                        [Progress progressShowcontent:@"报名成功"];
                        sleep(2);

                        MukeDetailViewController *dvc = [[MukeDetailViewController alloc]init];
                        dvc.subTitle = _subTitle;
                        dvc.subId = _subId;
                        dvc.CourseVersionId = _courseVersionId;
                        [_superViewController.navigationController pushViewController:dvc animated:YES];
                    } else {
                        [Progress  progressShowcontent:responseObject[@"Message"]];
                    }

                } failure:^(NSError *error) {
                    [progress hiddenProgress];
                    [KTMErrorHint showNetError:error inView:_superViewController.view];
                    
                }];
                } else if (_subCourseArr && _superViewController && sender.backgroundColor == RGB_COLOR(131, 176, 17)) {
            
                }
        }
    }
}
@end
