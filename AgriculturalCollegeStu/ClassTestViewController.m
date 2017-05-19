
//
//  ClassTestViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ClassTestViewController.h"
#import "SponsorTestViewController.h"
#import "ClassScheduleViewController.h"
#import "ViewTestViewController.h"
#import "RecentCourseManager.h"
#import "UserData.h"

@interface ClassTestViewController ()
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *courceName;
@property (strong, nonatomic) IBOutlet UIButton *selectedCourceBtn;
@property (strong, nonatomic) NSString *courseId;
@property (strong, nonatomic) NSString *courseTitle;
@end

@implementation ClassTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"测验";
    [self getRecentCourse];
}

- (void)getRecentCourse {
    [RecentCourseManager getRecentCourseSuccess:^(NSDictionary *coursesInfo) {
        self.courseId = [NSDictionary safeDictionary:coursesInfo][COURSE_ID];
        self.courseTitle = [NSDictionary safeDictionary:coursesInfo][COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
        self.courceName.text = self.courseTitle;
    } failure:^(NSString *failMessage) {
        
    }];
}


- (IBAction)selectedCourceAction:(UIButton *)sender {
    if (sender.tag == 1) {//查看课堂测验
        ViewTestViewController *viewTestView = [[ViewTestViewController alloc] init];
        viewTestView.courseName = _courseTitle;
        viewTestView.courseId = _courseId;
        viewTestView.assignmentType = ClassAssignmentTypeClassTest;
        [self.navigationController pushViewController:viewTestView animated:YES];
        
    } else if (sender.tag == 2){//查看临时测验
        NSString *temporaryId = [UserData getUser].temporaryTestId;
        if (temporaryId.length>0) {
            ViewTestViewController *viewTestView = [[ViewTestViewController alloc] init];
            viewTestView.courseName = _courseTitle;
            viewTestView.courseId = temporaryId;
            viewTestView.assignmentType = ClassAssignmentTypeTemporaryTest;
            [self.navigationController pushViewController:viewTestView animated:YES];

        } else {
            [Progress progressShowcontent:@"此课程，暂无测验" currView:self.view];
        }
      
    } else if (sender.tag == 3) {//发起测验
        SponsorTestViewController *sponsorTestView = [[SponsorTestViewController alloc] init];
        sponsorTestView.courseName = self.courseTitle;
        sponsorTestView.courseId = self.courseId;
        [self.navigationController pushViewController:sponsorTestView animated:YES];
        

    } else {
        ClassScheduleViewController *scheduleView = [[ClassScheduleViewController alloc] init];
        scheduleView.theSelectedClass = ^(NSDictionary *classCourse){
            self.courceName.text = classCourse[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
            self.courseId = [NSString safeString:classCourse[COURSE_RECENTACTICE_ID]];
        };
        [self.navigationController pushViewController:scheduleView animated:YES];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
