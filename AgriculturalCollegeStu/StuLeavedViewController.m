//
//  StuLeavedViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/21.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "StuLeavedViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ApprovalStateViewController.h"
#import "ClassScheduleViewController.h"
#import "StuApprovalInfoTableViewController.h"
#import "SetNavigationItem.h"
#import "RecentCourseManager.h"
#import "UIImageView+AFNetworking.h"

#import "UserData.h"

@interface StuLeavedViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPKeyBoardScrollView;
@property (strong, nonatomic) IBOutlet UIButton *selecteClassBtn;
@property (strong, nonatomic) IBOutlet UILabel *currentCource;
@property (strong, nonatomic) IBOutlet UITextView *leavedResonTextView;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (strong, nonatomic) SetNavigationItem  *setNav;
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *courseName;

@end

@implementation StuLeavedViewController

#pragma mark - setNav

- (void)setNavigationBar {
    _setNav = [[SetNavigationItem alloc] init];
    [_setNav setNavTitle:self withTitle:@"请假" subTitle:@""];
    [_setNav setNavRightItem:self withItemTitle:@"提交" textColor:MainTextColor_DarkBlack];
    @WeakObj(self);
    _setNav.rightClick = ^(){
        [selfWeak.view resignFirstResponder];
        if (self.leavedResonTextView.text.length>0) {
            [selfWeak putupStudentLeavedInfo];
        } else {
            [Progress progressShowcontent:@"请填写请假内容" currView:selfWeak.view];
        }
    };
    if (self.presentingViewController) {
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [cancelBtn addTarget:self action:@selector(cancelBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
        cancelBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 38);
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }

}

#pragma mark - Data

- (void)cancelBarButtonItemPressed:(UIButton* )sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    [self initData];
    
}

- (void)initData {
    self.currentCource.text = [NSString stringWithFormat:@"%@%@",[RecentCourseManager getRecentCourseDataWithDateItem:DataItemLessonTime],[RecentCourseManager getRecentCourseDataWithDateItem:DataItemDependentName]];
    self.courseId = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemCourseId];
    if (self.courseId == nil) {
        [Progress progressShowcontent:@"获取课程失败，请前往课程表获取"];
        return;
    }

}

#pragma mark - textView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _placeHolderLabel.alpha = 0;//开始编辑时
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {//将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
        _placeHolderLabel.alpha = 1;
    }
    return YES;
}



- (IBAction)selecteClassCourceAction:(UIButton *)sender {
    
    
}

#pragma mark - 创建提示框

- (void)alertController {
 
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"新建请假审批成功，是否查看我的请假详情？" preferredStyle:UIAlertControllerStyleAlert];
    @WeakObj(self);
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        ApprovalStateViewController *stateView = [[ApprovalStateViewController alloc] init];
//        stateView.userRole = UserRoleStudent;
        StuApprovalInfoTableViewController *approvalView = [[StuApprovalInfoTableViewController alloc] init];
        approvalView.needToRootView = YES;
        [selfWeak.navigationController pushViewController:approvalView animated:YES];
    
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

        [selfWeak.navigationController popViewControllerAnimated:YES];
    
    }]];
 
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)selecteCourseAction:(UIButton *)sender {
    ClassScheduleViewController *classView = [[ClassScheduleViewController alloc] init];
    classView.theSelectedClass = ^(NSDictionary *classCourse){
        _currentCource.text = [NSString stringWithFormat:@"%@%@",classCourse[COURSE_TIME],classCourse[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME]];
        self.courseId = classCourse[COURSE_ID];
    
    };
    [self.navigationController pushViewController:classView animated:YES];
    
}

#pragma mark - putup student leaved info 

- (void)putupStudentLeavedInfo {
    //"/OfflineCourse/AskLeave",{AccessToken:"773daf60657f4bcaada90e5f5bd968ef",ActivityId:"eda68775-a5c1-4b18-b1b5-bfcaa39d7f5e",Reason:"生病了，请假"}
    if (self.courseId == nil) {
        [Progress progressShowcontent:@"获取课程失败"];
        return;
    }
    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"ActivityId":self.courseId,
                                @"Reason":self.leavedResonTextView.text};
    [NetServiceAPI postLeaveResonWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue]!=1) {
            [Progress progressShowcontent:responseObject[@"Message"] currView:self.view];

        } else {
            [self alertController];

        }
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];
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
