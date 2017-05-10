//
//  TestGradeViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//
#define STU_SELE_ANSWER @"studentSelectedAnswers"
#define QUESTION_TYPE @"QuestionType"
#define QUESTION_LIST @"Questions"


#import "TestGradeViewController.h"
#import "GradeAnswerTableViewCell.h"
#import "TestGradeTableViewCell.h"
#import "TestGradeView.h"


@interface TestGradeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *allOptions;

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
    } else {
        [self getClassExercises];
    }
    [self initTableView];
}

#pragma mark - get exercise info

- (void)getClassExercises {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    if (self.courseId == nil) {
        return;
    }
    [NetServiceAPI getTheExerciseDetailsWithParameters:@{@"ActivityId":self.courseId} success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            _allOptions = [NSArray arrayWithArray:[NSArray safeArray:[NSDictionary safeDictionary:responseObject[@"DataObject"]][QUESTION_LIST]]];

            [_testResultTab reloadData];
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
            
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
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
//    gradeView.timeLabel.text = self.timeStr;
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
        
        MStr = [self getAnswerContent:questionInfo[@"QuestionOptionList"] optionId:questionInfo[@"LastStudentAnswer"]];
        CStr = [self getAnswerContent:questionInfo[@"QuestionOptionList"] optionId:questionInfo[@"RightAnswer"]];
    }
    cell.finishedState.text = MStr.length == 0?@"未完成":@"完成";
    cell.MineAnswer.text = MStr;
    cell.correctAnswer.text = CStr;
    
    return cell;
}

- (NSString *)getAnswerContent:(NSArray *)options optionId:(NSString *)optionId {
    NSString *answerStr = @"";
    NSArray *finishedArray = [NSArray safeArray:[optionId componentsSeparatedByString:@","]];
    for (NSString *finStr in finishedArray) {
        for (NSDictionary *optionInfo in options) {
            if ([optionInfo[@"Id"] isEqualToString:finStr]) {
                answerStr = [NSString stringWithFormat:@"%@:%@\n%@",optionInfo[@"ABCorderNum"],optionInfo[@"Content"],answerStr];
                break;
            }
        }
    }
   
    return answerStr;
}

- (float)caculatedAllGrade {
    float grade=0;
    
    for (NSDictionary *questionDic in _allOptions) {
        NSString *MAnswer = questionDic[@"LastStudentAnswer"];
        NSArray *finishedArray = [NSArray safeArray:[MAnswer componentsSeparatedByString:@","]];

        NSString *answer = questionDic[@"RightAnswer"];
        NSArray *correctArray = [NSArray safeArray:[answer componentsSeparatedByString:@","]];
        if ([finishedArray isEqualToArray:correctArray]) {
            grade+=[questionDic[@"QScore"] floatValue];

        }
       
    }
    
//    //把数据源拿出来创建临时的数组，不要直接使用数据源
//    NSArray *answer = @[@1, @2, @3];//答案数组
//    NSArray *select = @[@1, @4];    //用户选的选项
//    
//    if ([answer isEqualToArray:select]) {
//        //一样就是对的
//        
//    }else {
//        //不一样就是错的
//        //拿出来answer 和 select 中一样的
//        NSArray *selectTure = [answer filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF in %@", select]];
//        NSLog(@"用户选择对的 -> %@", selectTure);
//        
//        NSArray *selectWrong = [select filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)", answer]];
//        NSLog(@"用户选择是错的 -> %@", selectWrong);
//        
//        NSArray *unselectTure = [answer filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF in %@)", selectTure]];
//        NSLog(@"用户没选择的正确答案 -> %@", unselectTure);
//        
//    }
    return grade;
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
