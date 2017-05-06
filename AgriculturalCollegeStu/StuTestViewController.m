//
//  StuTestViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#define DATE_LABEL_TAG 11
#define QUESTION_LIST @"Questions"
#define QUESTION_OPTION_LIST @"QuestionOptionList"
#define STU_SELE_ANSWER @"studentSelectedAnswers"
#define QUESTION_TYPE @"QuestionType"

#import "StuTestViewController.h"
#import "QuestionCollectionViewCell.h"
#import "ClassScheduleViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "TestGradeViewController.h"
#import "FinishedCourseView.h"
#import "HintMassageView.h"
#import "SetNavigationItem.h"
#import "RecentCourseManager.h"
#import "CurrentClassView.h"
#import "UserData.h"

@interface StuTestViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HintViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *quenstionInfoCollV;
@property (strong, nonatomic) IBOutlet UIButton *putupBtn;
@property (strong, nonatomic) IBOutlet UIButton *finishedBtn;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) HintMassageView *hintView;


@property (strong, nonatomic) NSMutableDictionary *questionDic;

@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *timeStr;
@property (copy, nonatomic) NSString *courseName;
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int secondNum;

@end
static NSString *cellID = @"questionCellID";
@implementation StuTestViewController

- (void)setNavigationBar {
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 120, 30);
//    rightBtn.tag = DATE_LABEL_TAG;
//    [rightBtn setTitleColor:MainThemeColor_Blue forState:UIControlStateNormal];
//    [rightBtn setTitle:@"倒计时：00:00:00" forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -18);
//    [[SetNavigationItem shareSetNavManager] setNavRightItem:self withCustomView:rightBtn];
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:@"测验" subTitle:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    [self initData];

    [self customCourseView];
    [self creatCustomCollectioView];
    
}

- (void)initData {
//    [self createDisplayLink];
    [self getRecentCourse];
    [self getClassExercises];
}

#pragma mark - get recent course

- (void)getRecentCourse {
    [RecentCourseManager getRecentCourseSuccess:^(NSDictionary *coursesInfo) {
        self.courseId = [NSDictionary safeDictionary:coursesInfo][COURSE_ID];
        self.courseName = [NSDictionary safeDictionary:coursesInfo][COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
    } failure:^(NSString *failMessage) {
        
    }];
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
            _questionDic = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary safeDictionary:responseObject[@"DataObject"]]];
            [self refreshedFinishedRate];
            [_quenstionInfoCollV reloadData];
          
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
        
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];

}

#pragma mark - post exercise answer

- (void)postExerciseAnswers {
    if (_questionDic == nil) {
        [Progress progressShowcontent:@"没有作业，无法完成提交"];
        return;
    }

    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"提交中..."];
    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"Unitid":_questionDic[@"UnitId"],
                                @"AllStudentExerciseAnswers":[self joinExerciseAnswer]};
    [NetServiceAPI postExerciseAnswersWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue ] == 1) {
            [self showPostSuccessView];
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];

}

#pragma mark - join finished answer

- (NSString *)joinExerciseAnswer {
    NSString *answerStr;
    NSArray *queArray = [NSArray safeArray:_questionDic[QUESTION_LIST]];
    int index=0;
    for (NSDictionary *queInfo in queArray) {
        
        NSArray * answers = [NSArray safeArray:queInfo[STU_SELE_ANSWER]];
        NSString *queId = [NSString safeString:queInfo[@"Id"]];
        NSInteger anIndex = 0;
        if (index == [queArray count]-2) {
            for (NSDictionary *anInfo in answers) {
                if ([NSString safeString:anInfo[@"Id"]].length>0) {
                    anIndex++;
                }
            }
            if (anIndex > 1) {
                NSString *anStr = @"";
                for (NSDictionary *anInfo in answers) {
                    anStr = [NSString stringWithFormat:@"%@,%@",anStr,anInfo[@"Id"]];
                }
                 answerStr = [NSString stringWithFormat:@"%@^%@",queId,anStr];
            } else {
                  answerStr = [NSString stringWithFormat:@"%@^%@",queId,[NSDictionary safeDictionary:answers[0]][@"Id"]];
            }

          
        } else {
            for (NSDictionary *anInfo in answers) {
                if ([NSString safeString:anInfo[@"Id"]].length>0) {
                    anIndex++;
                }
            }
            if (anIndex > 1) {
                NSString *anStr = @"";
                for (NSDictionary *anInfo in answers) {
                    anStr = [NSString stringWithFormat:@"%@,%@",anStr,anInfo[@"Id"]];
                }
                answerStr = [NSString stringWithFormat:@"%@^%@|",queId,anStr];
            } else {
                answerStr = [NSString stringWithFormat:@"%@^%@|",queId,[NSDictionary safeDictionary:answers[0]][@"Id"]];
            }
        }
        ++index;
    }
    if (answerStr == nil) {
        [Progress progressShowcontent:@"没有作业答案，无法完成提交！"];
    }
    return answerStr;
}


#pragma mark - custom class view

- (void)customCourseView {

    CurrentClassView *classView = [CurrentClassView initViewLayout];
    CGRect frame = self.topView.bounds;
    classView.frame = frame;
    classView.courceName.text = self.courseName;
    @WeakObj(classView);
    classView.selectedClick = ^(UIButton *sender) {
        ClassScheduleViewController *scheduleView = [[ClassScheduleViewController alloc] init];
        scheduleView.theSelectedClass = ^(NSDictionary *classCourse){
            self.courseName = classCourse[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
            self.courseId = [NSString safeString:classCourse[COURSE_RECENTACTICE_ID]];
            classViewWeak.courceName.text = self.courseName;
            [self getClassExercises];
        };
        [self.navigationController pushViewController:scheduleView animated:YES];
        
    };

    [self.topView addSubview:classView];

}

#pragma mark - 创建collectionView
- (void)creatCustomCollectioView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.quenstionInfoCollV.collectionViewLayout = layOut;
    self.quenstionInfoCollV.delegate = self;
    self.quenstionInfoCollV.dataSource = self;
    layOut.minimumInteritemSpacing = 1;
    layOut.minimumLineSpacing = 1;
    self.quenstionInfoCollV.backgroundColor = [UIColor whiteColor];
    [self.quenstionInfoCollV registerNib:[UINib nibWithNibName:@"QuestionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_questionDic[QUESTION_LIST] count];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QuestionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.courseInfo = _questionDic[QUESTION_LIST][indexPath.row];
    cell.answerArray = self.answersInfo[_questionDic[QUESTION_LIST][indexPath.row][@"Id"]];
    @WeakObj(self)
    cell.selectedAnswer = ^(NSArray *item){
        [self setSelectedAnswer:item indexPath:indexPath];
    };
    
    return cell;
}

- (void)setSelectedAnswer:(NSArray *)seleArray indexPath:(NSIndexPath *)indexPath {
    NSMutableArray *queArray = [NSMutableArray arrayWithArray:[NSArray safeArray:_questionDic[QUESTION_LIST]]];
    NSMutableDictionary *queInfo = [NSMutableDictionary dictionaryWithDictionary:queArray[indexPath.row]];
    
    
    

}


//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(WIDTH, HEIGHT-60);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int page = scrollView.contentOffset.x/WIDTH;
    [self.finishedBtn setTitle:[NSString stringWithFormat:@"%d/%tu",page+1,[_questionDic[QUESTION_LIST] count]] forState:UIControlStateNormal];
}


- (IBAction)putupBtnAction:(UIButton *)sender {
    if (sender.tag == 1) {//提交作业
        [self postExerciseAnswers];
    } else {//查看
        [UIView animateWithDuration:0.3 animations:^{
            FinishedCourseView *finisedView = [[NSBundle mainBundle] loadNibNamed:@"FinishedCourseView" owner:nil options:nil].lastObject;
            [finisedView.courseBtn setTitle:[NSString stringWithFormat:@"%tu/%tu",[self getFinishedNumber],[_questionDic[QUESTION_LIST] count]] forState:UIControlStateNormal];
            finisedView.courseNumber = [_questionDic[QUESTION_LIST] count];
            finisedView.finishedArray = [self getFinishedNumbersIndex];
            finisedView.finishedNum = [self getFinishedNumber];
            finisedView.selectedNum = ^(NSInteger index) {
                _quenstionInfoCollV.contentOffset = CGPointMake(WIDTH * index, 0);
                [self.finishedBtn setTitle:[NSString stringWithFormat:@"%d/%tu",(int)index+1,[_questionDic[QUESTION_LIST] count]] forState:UIControlStateNormal];
            };
            
            [self.view addSubview:finisedView];
        }];
    }
}

#pragma mark - show success View

- (void)showPostSuccessView {
    
    _hintView = [HintMassageView initLayoutView];
    [_hintView.hintLabel setTitle:@"提交成功" forState:UIControlStateNormal];
    _hintView.delegate = self;
    [self.view addSubview:_hintView];
}

#pragma mark - get finished question num
- (NSInteger)getFinishedNumber {
    NSInteger num=0;
    for (NSArray *values in [self.answersInfo allValues]) {
        for (NSDictionary *anInfo in values) {
            if ([anInfo[@"Id"] length]>0) {
                num++;
            }
        }
    }
    return num;
}

- (NSArray *)getFinishedNumbersIndex {
    NSInteger index=0;
    NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:0];
    for (NSArray *values in [self.answersInfo allValues]) {
            for (NSDictionary *anInfo in values) {
                if ([anInfo[@"Id"] length]>0) {
                    [indexArray addObject:[NSNumber numberWithInteger:index]];
                }
            }
        index++;
    }
    return indexArray;
}



#pragma mark - refresh finished rate

- (void )refreshedFinishedRate {
//    [self.finishedBtn setTitle:[NSString stringWithFormat:@"%tu/%tu",[self getFinishedNumber],[_questionDic[QUESTION_LIST] count]] forState:UIControlStateNormal];
    [self.finishedBtn setTitle:[NSString stringWithFormat:@"1/%tu",[_questionDic[QUESTION_LIST] count]] forState:UIControlStateNormal];
}


#pragma mark - hintViewDelegate

- (void)hiddenSelfView {
    TestGradeViewController *gradeView = [[TestGradeViewController alloc] init];
    gradeView.role = UserRoleStudent;
    gradeView.answerInfo = self.answersInfo;
    gradeView.allOptions = _questionDic[QUESTION_LIST];
    gradeView.timeStr = _timeStr;
    [self.navigationController pushViewController:gradeView animated:YES];
    
}

#pragma mark - 取消提示

- (void)createAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否放弃已完成的作业" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (BOOL)navigationShouldPopOnBackButton {
    if ([self getFinishedNumber] >0) {
        [self createAlertView];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    return NO;
}

/*********************** timer **********************/

- (void)createDisplayLink {
    _secondNum = 0;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    self.displayLink.preferredFramesPerSecond = 1;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)handleDisplayLink:(CADisplayLink *)linker {
    _secondNum++;
    NSString *timeStr = @"";
    int hour = _secondNum/pow(60, 2);
    int minute = (_secondNum - hour*pow(60, 2))/pow(60, 1);
    int second = _secondNum - hour*pow(60, 2) - minute*pow(60, 1);
    
    timeStr = [NSString stringWithFormat:@"倒计时：%2d:%2d:%2d",100,minute,second];
    UIButton *dateBtn = self.navigationItem.rightBarButtonItem.customView;
    [dateBtn setTitle:timeStr forState:UIControlStateNormal];
    
}

- (void)stopTimer {
    [self.displayLink invalidate];
    self.displayLink = nil;
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
