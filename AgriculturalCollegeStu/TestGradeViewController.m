//
//  TestGradeViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "TestGradeViewController.h"
#import "GradeAnswerTableViewCell.h"
#import "TestGradeTableViewCell.h"
#import "TestGradeView.h"



@interface TestGradeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *testResultTab;
@end

static NSString *gradeCellID = @"GradeCellID";
static NSString *answerCellID = @"AnswerCellID";

@implementation TestGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"测验成绩";
    if (self.role == UserRoleTeacher) {
        [self getExerciseOfTeacher];
    }
    [self initTableView];
}

- (void)getExerciseOfTeacher {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    if (self.studentId == nil||self.courseId == nil) {
        return;
    }
    
    NSDictionary *parameter = @{@"ActivityId":self.courseId,
                                @"StudentId":self.studentId};
    [NetServiceAPI getTheExerciseDetailsOfTeacherWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            self.allOptions = [NSArray safeArray:responseObject[@"DataObject"][@"Questions"]];
            [self.testResultTab reloadData];
        } else {
            [Progress progressShowcontent:@"获取测验详情失败了"];
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError: error inView:self.view ];
    }];

}

- (void)initTableView {
    
    _testResultTab.delegate = self;
    _testResultTab.dataSource = self;
    _testResultTab.estimatedRowHeight = 44.0;
    _testResultTab.rowHeight = UITableViewAutomaticDimension;
    [_testResultTab registerNib:[UINib nibWithNibName:@"GradeAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:answerCellID];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return _allOptions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TestGradeView *gradeView = [[NSBundle mainBundle] loadNibNamed:@"TestGradeView" owner:nil options:nil].lastObject;
    gradeView.gradeToMiddleSpace.constant = self.role == UserRoleStudent?-WIDTH/4:0;
    gradeView.timeLabel.hidden = self.role == UserRoleStudent?NO:YES;
    gradeView.middleLine.hidden = self.role == UserRoleStudent?NO:YES;
    gradeView.useTimeLabel.hidden = self.role == UserRoleStudent?NO:YES;
    gradeView.timeLabel.text = self.timeStr;
    gradeView.gradeLabel.text = [NSString stringWithFormat:@"%.2f分",[self caculatedAllGrade]];
    
    return gradeView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GradeAnswerTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:answerCellID];
    NSDictionary *questionInfo = [NSDictionary safeDictionary: _allOptions[indexPath.row]];
    cell.questionNum.text = [NSString stringWithFormat:@"第%@题",questionInfo[@"QSerialnumber"]];
    cell.questionName.text = questionInfo[@"Content"];
    cell.gradelabel.text = [NSString stringWithFormat:@"%@",questionInfo[@"QScore"]];
    NSString *MStr;
    NSString *CStr;
    if (self.role == UserRoleTeacher) {
        MStr = [self getAnswerContent:questionInfo[@"QuestionOptionList"] optionId:questionInfo[@"LastStudentAnswer"]];
        CStr = [self getAnswerContent:questionInfo[@"QuestionOptionList"] optionId:questionInfo[@"RightAnswer"]];
    } else {
        MStr = [self getAnswerContent:questionInfo[@"QuestionOptionList"] optionId:[self getStuAnswer:[_answerInfo objectForKey:questionInfo[@"Id"]]]];
        CStr = [self getAnswerContent:questionInfo[@"QuestionOptionList"] optionId:questionInfo[@"RightAnswer"]];
    }
    cell.finishedState.text = MStr.length == 0?@"未完成":@"完成";
    cell.MineAnswer.text = MStr;
    cell.correctAnswer.text = CStr;
    
    return cell;
}

- (NSString *)getAnswerContent:(NSArray *)options optionId:(NSString *)optionId {
    NSString *answerStr;
    for (NSDictionary *optionInfo in options) {
        if ([optionInfo[@"Id"] isEqualToString:optionId]) {
            answerStr = [NSString stringWithFormat:@"%@:%@",optionInfo[@"ABCorderNum"],optionInfo[@"Content"]];
            break;
        }
    }
    return answerStr;
}

- (float)caculatedAllGrade {
    float grade=0;
    for (NSDictionary *questionDic in _allOptions) {
        NSString *MAnswer = self.role == UserRoleTeacher?questionDic[@"LastStudentAnswer"]:[self getStuAnswer:_answerInfo[questionDic[@"Id"]]];
        NSString *answer = questionDic[@"RightAnswer"];
        if ([MAnswer isEqualToString:answer]) {
            grade+=[questionDic[@"QScore"] floatValue];
        }
    }
    return grade;
}

- (NSString *)getStuAnswer:(NSArray *)answers {
    NSString *answerStr = @"";
    for (NSDictionary *answerDic in answers) {
        NSString *string = answerDic[@"Id"];
        if (string.length>0) {
            answerStr = [NSString stringWithFormat:@"%@%@",answerStr,string];
  
        }
    }
    return answerStr;

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
