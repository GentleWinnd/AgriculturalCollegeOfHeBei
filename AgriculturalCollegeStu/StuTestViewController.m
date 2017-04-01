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
#import "MZTimerLabel.h"
#import "UserData.h"

@interface StuTestViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HintViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *quenstionInfoCollV;
@property (strong, nonatomic) IBOutlet UIButton *putupBtn;
@property (strong, nonatomic) IBOutlet UIButton *finishedBtn;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) HintMassageView *hintView;
@property (strong, nonatomic) MZTimerLabel *mzLabel;
@property (strong, nonatomic) NSMutableDictionary *answersInfo;
@property (strong, nonatomic) NSDictionary *questionDic;
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
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 120, 30);
    rightBtn.tag = DATE_LABEL_TAG;
    [rightBtn setTitleColor:MainThemeColor_Blue forState:UIControlStateNormal];
    [rightBtn setTitle:@"倒计时：00:00:00" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -18);
    [[SetNavigationItem shareSetNavManager] setNavRightItem:self withCustomView:rightBtn];
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
//    _courseArray = [NSMutableArray arrayWithObjects:@{@"course":@"1、“大煮干丝”是哪个菜系的代表菜之一",@"answer":@[@"A四川菜系 ",@"B山东菜系 ",@"C广东菜系",@"D淮扬菜系",]},@{@"course":@"2、下列哪种邮件如果丢失了，邮局不负赔偿责任",@"answer":@[@"A.平信",@"B.挂号信",@"C.保价邮件",@"D.非保价邮包",]},@{@"course":@"3、下列地点与电影奖搭配不正确的是",@"answer":@[@"A.戛纳-金棕榈",@"B.亚洲-金马",@"C.洛杉矶-奥斯卡",@"D.中国-金鸡",]},@{@"course":@"4、下半旗是把旗子下降到",@"answer":@[@"A.旗杆的一半处",@"B.下降1米",@"C.下降1．5米",@"D.距离杆顶的1/3处",]},@{@"course":@" 5人体最大的解毒器官是",@"answer":@[@"A.胃",@"B.肾脏",@"C.肝脏",@"D.脾",]},@{@"course":@" 6、人体含水量百分比最高的器官是",@"answer":@[@"A.肝",@"B.肾",@"C.眼球"]}, @{@"course":@"7、“大煮干丝”是哪个菜系的代表菜之一",@"answer":@[@"A四川菜系 ",@"B山东菜系 ",@"C广东菜系",@"D淮扬菜系",]},@{@"course":@"8、下列哪种邮件如果丢失了，邮局不负赔偿责任",@"answer":@[@"A.平信",@"B.挂号信",@"C.保价邮件",@"D.非保价邮包",]},@{@"course":@"9、下列地点与电影奖搭配不正确的是",@"answer":@[@"A.戛纳-金棕榈",@"B.亚洲-金马",@"C.洛杉矶-奥斯卡",@"D.中国-金鸡",]},@{@"course":@"10、下半旗是把旗子下降到",@"answer":@[@"A.旗杆的一半处",@"B.下降1米",@"C.下降1．5米",@"D.距离杆顶的1/3处",]},@{@"course":@"11、人体最大的解毒器官是",@"answer":@[@"A.胃",@"B.肾脏",@"C.肝脏",@"D.脾",]},@{@"course":@"12、人体含水量百分比最高的器官是",@"answer":@[@"A.肝",@"B.肾",@"C.眼球"]},nil];
    self.answersInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [self getRecentCourse];
//    [self setTimeStamp:1800];
    [self createDisplayLink];
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


/*
 "DataObject": {
 "UnitId": "f3f113c0-66f5-4216-a331-92c005cf4811",
 "Questions": [
 {
 "Id": "86119095-0d6c-4abf-b160-b0332a7e38b1",
 "Content": "细胞壁的主要作用是",
 "QuestionType": 1,
 "QtypeString": "单选题",
 "QScore": 2.0,
 "LastStudentAnswer": "65413328-62df-43b2-a25e-329596019935",
 "QuestionOptionList": [
 {
 "Id": "fef4381d-8112-4b83-b55f-e829db5ef51a",
 "ABCorderNum": "A",
 "Content": "运输",
 "OrderNum": 1
 },
 {
 "Id": "60d87800-2178-4cf2-8d5d-33f3e9c0af89",
 "ABCorderNum": "B",
 "Content": "分泌",
 "OrderNum": 2
 },
 {
 "Id": "65413328-62df-43b2-a25e-329596019935",
 "ABCorderNum": "C",
 "Content": "保护和支持",
 "OrderNum": 3
 },
 {
 "Id": "83ed6fbe-eecd-46fe-8dd3-619bdd8bebde",
 "ABCorderNum": "D",
 "Content": "传递",
 "OrderNum": 4
 }
 ]
 },
*/
#pragma mark - get exercise info

- (void)getClassExercises {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
//     self.courseId = @"23c6434e-1dac-44f0-868e-de938be3100a";
    if (self.courseId == nil) {
        return;
    }
    [NetServiceAPI getTheExerciseDetailsWithParameters:@{@"ActivityId":self.courseId} success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            _questionDic = [[NSDictionary alloc] initWithDictionary:[NSDictionary safeDictionary:responseObject[@"DataObject"]]];
            [self refreshedFinishedRate];
            [_quenstionInfoCollV reloadData];
            for (NSDictionary *dic in _questionDic[@"Questions"]) {
                [_answersInfo setValue:@"" forKey:dic[@"Id"]];
            }
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
    int index=0;
    for (NSString *key in [self.answersInfo allKeys]) {
        NSArray * answers = [NSArray safeArray:self.answersInfo[key]];
        NSInteger anIndex = 0;
        if (index == [_answersInfo count]-2) {
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
                 answerStr = [NSString stringWithFormat:@"%@^%@",key,anStr];
            } else {
                  answerStr = [NSString stringWithFormat:@"%@^%@",key,[NSDictionary safeDictionary:answers[0]][@"Id"]];
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
                answerStr = [NSString stringWithFormat:@"%@^%@|",key,anStr];
            } else {
                answerStr = [NSString stringWithFormat:@"%@^%@|",key,[NSDictionary safeDictionary:answers[0]][@"Id"]];
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


#pragma mark - 添加定时器

- (void)setTimeStamp:(CGFloat)timeStamp{
    
    _mzLabel =[[MZTimerLabel alloc] initWithLabel:nil andTimerType:MZTimerLabelTypeTimer];
    [_mzLabel setCountDownTime:timeStamp];
//    @WeakObj(_mzLabel);
//    @WeakObj(self);
    [_mzLabel startWithEndingBlock:^(NSTimeInterval countTime) {

//        [_mzLabelWeak setCountDownTime:3600];
//        [_mzLabelWeak reset];
//        [_mzLabelWeak start];
        
    }];
    [self addTimeObserver];
}

#pragma mark - addTimeobsrever

- (void)addTimeObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChange:) name:@"surplusTime" object:nil];
    
}

#pragma mark - notice

- (void)shouldChange:(NSNotification *)notice {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        _timeStr = [notice.userInfo allValues].lastObject;
        NSString *date =  [NSString stringWithFormat:@"倒计时：%@",[notice.userInfo allValues].lastObject];
        UIButton *dateBtn = self.navigationItem.rightBarButtonItem.customView;
        [dateBtn setTitle:date forState:UIControlStateNormal];
    });
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
    cell.selectedAnswer = ^(NSArray *item){
        [self.answersInfo setValue:item forKey:_questionDic[QUESTION_LIST][indexPath.row][@"Id"]];
        [self refreshedFinishedRate];
    };
    
    return cell;
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(WIDTH, HEIGHT-60);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
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
    [self.finishedBtn setTitle:[NSString stringWithFormat:@"%tu/%tu",[self getFinishedNumber],[_questionDic[QUESTION_LIST] count]] forState:UIControlStateNormal];;
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

- (void)createTimer {

    NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

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

//    if (_secondNum<60) {
//        timeStr = [NSString stringWithFormat:@"00:00:%tu",_secondNum];
//    } if (_secondNum <pow(60, 2)) {
//         timeStr = [NSString stringWithFormat:@"00:00:%tu",_secondNum];
//    } if (_secondNum <pow(60, 3)) {
//        
//    } else {
//    
//    }
    
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
