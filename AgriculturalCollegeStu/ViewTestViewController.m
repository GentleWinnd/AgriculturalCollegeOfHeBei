//
//  ViewTestViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#define STU_INFO_VIEW_TAG 111

#import "ViewTestViewController.h"
#import "TestResultViewController.h"
#import "StuTaskInfoViewController.h"
#import "TestGradeViewController.h"
#import "ClassScheduleViewController.h"

#import "CurrentClassView.h"
#import "SetNavigationItem.h"
#import "SignedStuView.h"
#import "HintMassageView.h"
#import "NSString+Extension.h"
#import "RecentCourseManager.h"
@interface ViewTestViewController ()
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *proportionLabel;
@property (strong, nonatomic) IBOutlet UIButton *viewInfoBtn;
@property (strong, nonatomic) IBOutlet UIView *StuInfoView;
@property (strong, nonatomic) SetNavigationItem *setNav;
@property (strong, nonatomic) IBOutlet UILabel *massageLabel;
@property (strong, nonatomic) NSDictionary *testInfo;
@property (strong, nonatomic) NSTimer *timer;


@end

@implementation ViewTestViewController

- (void)setNavigationBar {
    _setNav = [[SetNavigationItem alloc] init];
    if (self.assignmentType == ClassAssignmentTypeHomeTask) {
        [_setNav setNavTitle:self withTitle:@"作业" subTitle:@""];
//        [_setNav setNavRightItem:self withItemTitle:@"提交" textColor:MaintextColor_LightBlack];
//        @WeakObj(self);
//        _setNav.rightClick = ^(){
//            HintMassageView *hintView = [HintMassageView initLayoutView];
//            [hintView.hintLabel setTitle:@"提交成功" forState:UIControlStateNormal];
//            hintView.hiddenSelf = ^(){
//                [selfWeak back];
//            };
//            [selfWeak.view addSubview:hintView];
//        };

    } else {
        [_setNav setNavTitle:self withTitle:@"查看测验" subTitle:@""];
        self.massageLabel.text = @"答对问题学生总数/课程学生总数";
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    [self initData];
    [self customShowViewByTaskType];
    [self customCurrentClassView];
    [self customStuView];
    
}

#pragma mark - initdata 

- (void)initData {
    
    if (self.courseId == nil) {
        self.courseId = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemCourseId];
    }
    
    if (self.courseName == nil) {
        self.courseName = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemDependentName];
    }
    
    [self refreshedStudentsSignedState];
}

//home work

#pragma mark - get homework detail

- (void)getHomeWorkDetail {
    if (_courseId == nil) {
        [Progress progressShowcontent:@"获取最近课程失败，请在课表获取"];
        return;
    }
//    MBProgressManager *progress = [[MBProgressManager alloc] init];
//    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getHomeWorkStateDetailWithParameters:@{@"ActivityID":_courseId} success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            _testInfo = [[NSDictionary alloc ]initWithDictionary:[NSDictionary safeDictionary:responseObject[@"DataObject"]]];
            [self reDisplayNewData];
        } else {
//            NSString *message = responseObject[@"Message"];
            [Progress progressShowcontent:responseObject[@"Message"]];
            [_timer setFireDate:[NSDate distantFuture]];
        }
//        [progress hiddenProgress];
    } failure:^(NSError *error) {
//        [progress hiddenProgress];
        [_timer setFireDate:[NSDate distantFuture]];

        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
}

#pragma mark - get home work state(no use)

//- (void)getHomeWorkPutupState {
//    [NetServiceAPI getHomeWorkStateWithParameters:@{@"ActicityId":@""} success:^(id responseObject) {
//        if ([responseObject[@"State"] integerValue] == 1) {
//            [self getHomeWorkDetail];
//        } else {
//            [Progress progressShowcontent:responseObject[@"Message"]];
//        }
//    } failure:^(NSError *error) {
//        [KTMErrorHint showNetError:error inView:self.view];
//    }];
//    
//}

//temporarytest
#pragma mark - 暂时不用API

//- (void)getTemporaryTestStudentRate {
//    //.get("/TemporaryTest/StudentTemporaryTestStat?TemporaryTestQuestionId=7F1CA316-C4B8-4417-A5C4-85CFDAB5166D"
//    [NetServiceAPI getStudentTemporaryTestResultWithParameters:@{@"TemporaryTestQuestionId":@""} success:^(id responseObject) {
//        
//        if ([responseObject[@"State"] integerValue] == 1) {
//            
//        } else {
//            [Progress progressShowcontent:responseObject[@"Message"]];
//        }
//    } failure:^(NSError *error) {
//        [KTMErrorHint showNetError:error inView:self.view];
//    }];
//    
//}

#pragma mark - get temporarytest student info

- (void)getTemporaryTestInfo {
    if (_courseId == nil) {
        [Progress progressShowcontent:@"获取最近课程失败，请在课表获取"];
        return;
    }
    [NetServiceAPI getTheTemporaryDetailWithParameters:@{@"coourseId":self.courseId} success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            
            _testInfo = [[NSDictionary alloc ]initWithDictionary:responseObject[@"StudentTemporaryTestStatDetail"]];
            [self reDisplayNewData];
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
            [_timer setFireDate:[NSDate distantFuture]];

        }
    } failure:^(NSError *error) {
        [_timer setFireDate:[NSDate distantFuture]];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}

#pragma mark - get class exercise detail

- (void)getClassExerciseDetail {
    if (_courseId == nil) {
        [Progress progressShowcontent:@"获取最近课程失败，请在课表获取"];
        return;
    }
//    self.courseId = @"23c6434e-1dac-44f0-868e-de938be3100a";
    //    MBProgressManager *progress = [[MBProgressManager alloc] init];
    //    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getTheExerciseStateDetailWithParameters:@{@"ActivityID":self.courseId} success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            _testInfo = [[NSDictionary alloc ]initWithDictionary:[NSDictionary safeDictionary:responseObject[@"DataObject"]]];
            [self reDisplayNewData];
        } else {
            //            NSString *message = responseObject[@"Message"];
            [Progress progressShowcontent:responseObject[@"Message"]];
            [_timer setFireDate:[NSDate distantFuture]];
            
        }
        //        [progress hiddenProgress];
    } failure:^(NSError *error) {
        //        [progress hiddenProgress];
        [_timer setFireDate:[NSDate distantFuture]];
        
        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
}

#pragma mark - set showview

- (void)customShowViewByTaskType {
    if (self.assignmentType == ClassAssignmentTypeHomeTask) {
        self.viewInfoBtn.hidden = YES;
    
    } else {
        self.viewInfoBtn.hidden = NO;

    }
}

#pragma mark - 定义classView

- (void)customCurrentClassView {
    CurrentClassView *classView = [CurrentClassView initViewLayout];
    __block  CurrentClassView *weakClassView = classView;
    CGRect frame = _topView.frame;
    frame.origin = CGPointMake(0, 0);
    classView.frame = frame;
    classView.courceName.text = self.courseName;
    [_topView addSubview:classView];
    classView.selectedClick = ^(UIButton *sender) {
        ClassScheduleViewController *scheduleView = [[ClassScheduleViewController alloc] init];
        scheduleView.theSelectedClass = ^(NSDictionary *classCourse){
            weakClassView.courceName.text = classCourse[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
            self.courseId = [NSString safeString:classCourse[COURSE_RECENTACTICE_ID]];
        };
        [self.navigationController pushViewController:scheduleView animated:YES];
    };
}

#pragma mark - 定义stuView

- (void)customStuView {
    SignedStuView *stuView = [SignedStuView initViewLayout];
    CGRect frame = _StuInfoView.frame;
    frame.origin = CGPointMake(0, 0);
    stuView.frame = frame;
    stuView.titleLabel.hidden = YES;
    stuView.stuType = _assignmentType == ClassAssignmentTypeHomeTask? StuInfoTypeTask:StuInfoTypeTest;
    stuView.tag = STU_INFO_VIEW_TAG;
    [_StuInfoView addSubview: stuView];
    stuView.selectedStu = ^(NSString * stuId){
        if (self.assignmentType == ClassAssignmentTypeHomeTask) {
            StuTaskInfoViewController *taskView = [[StuTaskInfoViewController alloc] init];
            taskView.role = UserRoleTeacher;
            taskView.courseId = self.courseId;
            taskView.ActivityId = self.courseId;
            taskView.studentId = stuId;
            for (NSDictionary *stuDic in [NSArray safeArray:_testInfo[@"HomeWorkStudents"]]) {
                if ([stuDic[@"Id"] isEqualToString:stuId]) {
                    taskView.stuInfo = stuDic;
                    break;
                }
            }
            [self.navigationController pushViewController:taskView animated:YES];
        } else  if (self.assignmentType == ClassAssignmentTypeClassTest){
            TestGradeViewController *gradeView = [[TestGradeViewController alloc] init];
            gradeView.role = UserRoleTeacher;
            gradeView.courseId = self.courseId;
            gradeView.studentId = stuId;
            [self.navigationController pushViewController:gradeView animated:YES];

        }
      
    };
}

- (IBAction)ViewInfoAction:(UIButton *)sender {
    
    TestResultViewController *testView = [[TestResultViewController alloc] init];
    testView.courseId = self.courseId;
    testView.courseName = self.courseName;
    testView.temporaryInfo = _testInfo;
    testView.assignmentType = self.assignmentType;
    [self.navigationController pushViewController:testView animated:YES];
    
}

#pragma mark - get students signed info

- (void)refreshedStudentsSignedState {
    
    NSInteger timeInterval = 60;
    if (self.assignmentType == ClassAssignmentTypeTemporaryTest) {
        timeInterval = 2;
    }
    _timer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)timerAction {
    if (self.assignmentType == ClassAssignmentTypeHomeTask) {
        [self getHomeWorkDetail];
    } else if (self.assignmentType == ClassAssignmentTypeTemporaryTest){
        [self getTemporaryTestInfo];

    } else {
        [self getClassExerciseDetail];
    }
 }


#pragma mark - show new Data

- (void)reDisplayNewData {
    
    SignedStuView *stuView = (SignedStuView*)[self.view viewWithTag:STU_INFO_VIEW_TAG];
    if (self.assignmentType == ClassAssignmentTypeHomeTask) {
        stuView.signedStuInfo = @{SHOULD_STU:_testInfo[@"ShouldStudents"],
                                  SUBMIT_STU:_testInfo[@"HomeWorkStudents"]};
        _proportionLabel.text = [NSString stringWithFormat:@"%tu/%tu",[NSArray safeArray: _testInfo[@"HomeWorkStudents"]].count,[NSArray safeArray:_testInfo[@"ShouldStudents"]].count];
    } else if (self.assignmentType == ClassAssignmentTypeTemporaryTest){
        stuView.signedStuInfo = @{SHOULD_STU:_testInfo[@"ShouldStudents"],
                                  SUBMIT_STU:_testInfo[@"TemporaryTestStudents"]};
        _proportionLabel.text = [NSString stringWithFormat:@"%tu/%tu",[NSArray safeArray: _testInfo[@"RightStudents"]].count,[NSArray safeArray:_testInfo[@"ShouldStudents"]].count];
    } else {//ExerciseStudents
        stuView.signedStuInfo = @{SHOULD_STU:_testInfo[@"ShouldStudents"],
                                  SUBMIT_STU:_testInfo[@"ExerciseStudents"]};
        _proportionLabel.text = [NSString stringWithFormat:@"%tu/%tu",[NSArray safeArray: _testInfo[@"ExerciseStudents"]].count,[NSArray safeArray:_testInfo[@"ShouldStudents"]].count];

    }
    [stuView.stuCollectionView reloadData];
    
 

}

//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated{
//开启定时器
    [_timer setFireDate:[NSDate distantPast]]; //很远的过去
    
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated {
//关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];  //很远的将来

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
