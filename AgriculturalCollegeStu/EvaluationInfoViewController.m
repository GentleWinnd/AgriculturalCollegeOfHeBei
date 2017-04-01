//
//  EvaluationInfoViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "EvaluationInfoViewController.h"
#import "EvaluationInfoTableViewCell.h"
#import "EvaluationHeaderView.h"
#import "ClassScheduleViewController.h"
#import "SetNavigationItem.h"
#import "UIImageView+WebCache.h"
#import "RecentCourseManager.h"
#import "NSString+Date.h"
#import "UserData.h"


@interface EvaluationInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *evaluationInfoTab;
@property (copy, nonatomic) NSString *activityId;
@property (strong, nonatomic) NSDictionary *evaluationInfo;

@end
static NSString *cellID = @"evaluationInfoCellID";

@implementation EvaluationInfoViewController

#pragma mark - setNav

- (void)setNavigationBar {
    NSString *title = [NSString stringWithFormat:@"%@",self.courseName];
    NSString *subTitle = @"";
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:@"教学评价" subTitle:subTitle];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self setNavigationBar];
    [self initTableView];
}

- (void)initData {
    self.courseName = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemDependentName];
    self.activityId = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemDependentId];
    [self getTeacherEvaluationInfo];
}

- (void)getTeacherEvaluationInfo {
    if (self.activityId == nil) {
        return;
    }
    self.activityId = @"3E45D826-AA7B-452A-BE99-A6FDE7BAFF78";
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getTeachEvaluationContensWithParameters:@{@"ActivityId":self.activityId} success:^(id responseObject) {
        [progress hiddenProgress];
        if ( [responseObject[@"State"] integerValue] == 1) {
            _evaluationInfo = [NSDictionary dictionaryWithDictionary:[NSDictionary safeDictionary:responseObject[@"EvaluationContent"]]];
            [_evaluationInfoTab reloadData];
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
        }
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
}

- (void)initTableView {
    
    _evaluationInfoTab.delegate = self;
    _evaluationInfoTab.dataSource = self;
    _evaluationInfoTab.estimatedRowHeight = 44.0;
    _evaluationInfoTab.rowHeight = UITableViewAutomaticDimension;
    [_evaluationInfoTab registerNib:[UINib nibWithNibName:@"EvaluationInfoTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [NSArray safeArray:_evaluationInfo[@"EvaluationContentItems"]].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /*
     "Name": "教学态度",
     "AverageScore": 4.2,
     "EvaluationCount":
     */
     EvaluationHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"EvaluationHeaderView" owner:nil options:nil].lastObject;
    headerView.courseLabel.text = self.courseName;
    @WeakObj(headerView);
    headerView.reselecteCourse = ^(){
        ClassScheduleViewController *classView = [[ClassScheduleViewController alloc] init];
        classView.theSelectedClass = ^(NSDictionary *classInfo){
            self.courseName = classInfo[COURSE_RECENTACTICE_DEPENDENT][@"DependentName"];
            self.activityId = classInfo[COURSE_ID];
            headerViewWeak.courseLabel.text = self.courseName;
            [self getTeacherEvaluationInfo];

        };
        [self.navigationController pushViewController:classView animated:YES];
    
    };
    
    NSArray *contentInfo = [NSArray safeArray:_evaluationInfo[@"EvaluationAverageScoreItems"]];
    long score;
    NSString *evaluationCount;
    for (NSDictionary *info in contentInfo) {
        
        if ([@"授课技能" isEqualToString:info[@"Name"]]) {
            score = [contentInfo[0][@"AverageScore"] longValue];
            evaluationCount = [NSString safeString:contentInfo[0][@"EvaluationCount"]];
            headerView.oneLabel.text = [NSString stringWithFormat:@"%ld",score];
            headerView.oneLabel.textColor = [headerView setEvaluationScoreColorWithScore:score][@"color"];
            headerView.EoneLabel.backgroundColor = [headerView setEvaluationScoreColorWithScore:score][@"color"];
            headerView.EoneLabel.text = [headerView setEvaluationScoreColorWithScore:score][@"gread"];
        } else if([@"教学态度" isEqualToString:info[@"Name"]]) {
            score = [contentInfo[1][@"AverageScore"] longValue];
            evaluationCount = [NSString safeString:contentInfo[1][@"EvaluationCount"]];
            headerView.twoLabel.textColor = [headerView setEvaluationScoreColorWithScore:score][@"color"];
            headerView.twoLabel.text = [NSString stringWithFormat:@"%ld",score ];
            headerView.ETwoLabel.backgroundColor = [headerView setEvaluationScoreColorWithScore:score][@"color"];
            headerView.ETwoLabel.text = [headerView setEvaluationScoreColorWithScore:score][@"gread"];
        } else {
            score = [contentInfo[2][@"AverageScore"] longValue];
            evaluationCount = [NSString safeString:contentInfo[2][@"EvaluationCount"]];
            headerView.threeLabel.textColor = [headerView setEvaluationScoreColorWithScore:score][@"color"];
            headerView.threeLabel.text = [NSString stringWithFormat:@"%ld",score];
            headerView.EThreeLabel.backgroundColor = [headerView setEvaluationScoreColorWithScore:score][@"color"];
            headerView.EThreeLabel.text = [headerView setEvaluationScoreColorWithScore:score][@"gread"];
        }
        
    }
    
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     "CreateDate": "2016-12-22T17:08:19.977",
     "Student": {
     "Id": "353dfa26-c51e-4404-b588-f82ae5abd710",
     "UserName": "Student8",
     "FullName": "暂缺",
     "Avatar": null
     },
     "Content": "一般"
     },
     */
    EvaluationInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSArray *evaluationInfo = [NSArray safeArray:_evaluationInfo[@"EvaluationContentItems"]];
    NSDictionary *stuInfo = [NSDictionary safeDictionary:evaluationInfo[indexPath.row][@"Student"]];
    cell.dateLabel.text = [NSString stringFromDateString:evaluationInfo[indexPath.row][@"CreateDate"]];
    cell.evaluationInfo.text = evaluationInfo[indexPath.row][@"Content"];
    BOOL IsAnonymous = [evaluationInfo[indexPath.row][@"IsAnonymous"] boolValue];
    if (IsAnonymous) {
        cell.stuName.text = @"学生***";
        cell.headerPortriat.image = [UIImage imageNamed:@"default_load_image"];
    } else {
        cell.stuName = stuInfo[@"FullName"];
        [cell.headerPortriat sd_setImageWithURL:stuInfo[@"Avatar"] placeholderImage:[UIImage imageNamed:@"name"]];

    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


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
