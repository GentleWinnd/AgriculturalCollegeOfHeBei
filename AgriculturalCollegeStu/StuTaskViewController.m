//
//  StuTaskViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/21.
//  Copyright © 2016年 YH. All rights reserved.
//
#define COURSE @"Items"

#import "StuTaskViewController.h"
#import "CourseInfoCollectionViewCell.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ClassScheduleViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "SetNavigationItem.h"
#import "FinishedCourseView.h"
#import "HintMassageView.h"
#import "MBProgressManager.h"
#import "RecentCourseManager.h"
#import "UserData.h"


@interface StuTaskViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HintViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *selectedCource;
@property (strong, nonatomic) IBOutlet UIButton *selecteCourceBtn;
@property (strong, nonatomic) IBOutlet UIButton *finishedRateBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *courseCollectionView;
@property (strong, nonatomic) SetNavigationItem *setNav;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPScrollView;
@property (strong, nonatomic) NSMutableArray *answersInfo;
@property (strong, nonatomic) NSDictionary *allAssignmentInfo;
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *courseName;



@end
static NSString *cellID= @"cellID";

@implementation StuTaskViewController

#pragma mark - setNav

- (void)setNavigationBar {
    _setNav = [[SetNavigationItem alloc] init];
    
    NSString *title;
    NSString *subTitle;
    if (self.userRole == UserRoleTeacher) {
        title = @"作业";
        subTitle = @"";
    } else {
        title = @"作业";
        subTitle = @"";
    }
    [_setNav setNavTitle:self withTitle:title subTitle:subTitle];
    [_setNav setNavRightItem:self withItemTitle:@"提交" textColor:MainTextColor_DarkBlack];
    @WeakObj(self);
    
    _setNav.rightClick = ^(){
        [selfWeak.view endEditing:YES];
        [selfWeak putupStudentShcoolAssignment];
    
    };
}

#pragma mark - create hint view

- (void)createHintView {
    HintMassageView *hintView = [HintMassageView initLayoutView];
    [hintView.hintLabel setTitle:@"提交成功" forState:UIControlStateNormal];
    hintView.hiddenSelf = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:hintView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _TPScrollView.scrollEnabled = NO;
    [self setNavigationBar];
    [self initData];
    [self creatCustomCollectioView];
    
}

- (void)initData {

    self.answersInfo = [NSMutableArray arrayWithCapacity:0];
    [self getRecentCourse];
    [self getSchollAssignment];
}
- (void)getRecentCourse {
    [RecentCourseManager getRecentCourseSuccess:^(NSDictionary *coursesInfo) {
        self.courseId = [NSDictionary safeDictionary:coursesInfo][COURSE_ID];
        self.courseName = [NSDictionary safeDictionary:coursesInfo][COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
        self.selectedCource.text = self.courseName;
    } failure:^(NSString *failMessage) {
        
    }];
}

#pragma mark - get school assignment

- (void)getSchollAssignment {
    if (self.courseId == nil) {
        return;
    }
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"努力加载中..."];
    NSString *testID = @"23c6434e-1dac-44f0-868e-de938be3100a";
    
    [NetServiceAPI getSchoolAssignmentWithParameters:@{@"Activty":self.courseId} success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            _allAssignmentInfo = [NSDictionary safeDictionary:responseObject[@"HomeWorkDetailsModel"]];
            for (NSDictionary *dic in _allAssignmentInfo[@"Items"]) {
                [self.answersInfo addObject:@{@"Key":dic[@"Key"],
                                              @"Answer":@""}];
            }
            
            [self updateCourseFinishedState];
            [_courseCollectionView reloadData];
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}
//$.post("/HomeWork/SubmitAnswer",{HomeWorkDataId:"01852f7b-1300-4b2d-a652-4b4fb8f43498",Items[0].Key:"44b33362-d37c-4ef6-8204-456a7db47903",Items[0].Answer:"test",Items[1].Key:"f03b6153-9efb-4e7a-a60f-8c7ac9505bf2",Items[1].Answer:"test"}

- (void)putupStudentShcoolAssignment {
    if (self.allAssignmentInfo == nil) {
        return;
    }
    NSDictionary *CParameter = @{@"HomeWorkDataId":_allAssignmentInfo[@"HomeWorkDataId"]};
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:CParameter];
//    [parameter addEntriesFromDictionary:[self joinAllAssignmentAnswers]];
    [parameter setValue:[self joinAllAssignmentAnswers] forKey:@"StudentAnswers"];
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"提交中..."];
    [NetServiceAPI postStudentSchollAssignmentWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            [Progress progressShowcontent:@"作业提交成功"];
            [self createHintView];
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        [progress hiddenProgress];
    }];

}

#pragma mark - join  assignment answer

//- (NSDictionary *)joinAllAssignmentAnswers {
//    
//    NSMutableDictionary *joinAnswer = [NSMutableDictionary dictionaryWithCapacity:0];
//    for (int i=0;i<_answersInfo.count;i++) {
//        NSString *IDKey = [NSString stringWithFormat:@"Items[%d].Key",i];
//        NSString *answerKey = [NSString stringWithFormat:@"Items[%d].Answer",i];
//        [joinAnswer setValue:_answersInfo[i][@"Key"] forKey:IDKey];
//        [joinAnswer setValue:_answersInfo[i][@"Answer"] forKey:answerKey];
//    }
//    return joinAnswer;
//}
- (NSString *)joinAllAssignmentAnswers {
    
    NSString *joinAnswer = @"";
    for (int i=0;i<_answersInfo.count;i++) {
        if (i == 0) {
            joinAnswer = [NSString stringWithFormat:@"%@^^%@",_answersInfo[i][@"Key"],_answersInfo[i][@"Answer"] ];
            
        } else {
            joinAnswer = [NSString stringWithFormat:@"%@||%@^^%@",joinAnswer,_answersInfo[i][@"Key"],_answersInfo[i][@"Answer"] ];
        }
    }
    return joinAnswer;
}


#pragma mark - 创建collectionView
- (void)creatCustomCollectioView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.courseCollectionView.collectionViewLayout = layOut;
    self.courseCollectionView.delegate = self;
    self.courseCollectionView.dataSource = self;
    layOut.minimumInteritemSpacing = 1;
    layOut.minimumLineSpacing = 1;
    self.courseCollectionView.backgroundColor = [UIColor whiteColor];
    [self.courseCollectionView registerNib:[UINib nibWithNibName:@"CourseInfoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  [_allAssignmentInfo[COURSE] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.courseLabel.text = _allAssignmentInfo[COURSE][indexPath.row][@"Description"];
    
    cell.getAnswer = ^(NSString *answer){
        if (answer.length>0) {
            NSMutableDictionary *answerDic = [NSMutableDictionary dictionaryWithDictionary:self.answersInfo[indexPath.row]];
            [answerDic setValue:answer forKey:@"Answer"];
            [self.answersInfo replaceObjectAtIndex:indexPath.row withObject:answerDic];
            [self updateCourseFinishedState];
        }
    };
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 0, 1);
}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(WIDTH, 300);
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
}


- (IBAction)courseClickAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.tag == 1) {//重选课程
        ClassScheduleViewController *classView = [[ClassScheduleViewController alloc] init];
        classView.theSelectedClass = ^(NSDictionary *classCourse){
            _selectedCource.text = classCourse[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
            _courseId = classCourse[COURSE_ID];
        [self getSchollAssignment];
        };
        [self.navigationController pushViewController:classView animated:YES];
        
    } else {//作业完成率
        [UIView animateWithDuration:0.3 animations:^{
            FinishedCourseView *finisedView = [[NSBundle mainBundle] loadNibNamed:@"FinishedCourseView" owner:nil options:nil].lastObject;
            [finisedView.courseBtn setTitle:[NSString stringWithFormat:@"%tu/%tu",self.answersInfo.count,[_allAssignmentInfo[COURSE] count]] forState:UIControlStateNormal];
            finisedView.courseNumber = [_allAssignmentInfo[COURSE] count];
            finisedView.finishedNum = self.answersInfo.count;
            finisedView.finishedArray = [self getFinishedNumbersIndex];
            finisedView.selectedNum = ^(NSInteger index) {
                _courseCollectionView.contentOffset = CGPointMake(WIDTH * index, 0);
            };

            [self.view addSubview:finisedView];
            
        }];
    
    }
}


#pragma mark - update finihsed rate

- (void)updateCourseFinishedState {

    [_finishedRateBtn setTitle:[NSString stringWithFormat:@"%tu/%tu",[self getFinishedNumber],[_allAssignmentInfo[COURSE] count]] forState:UIControlStateNormal];
}

#pragma mark - get finished question num
- (NSInteger)getFinishedNumber {
    [self.view endEditing:YES];
    NSInteger num=0;
    for (NSDictionary *dic in _answersInfo) {
        if ([dic[@"Answer"] length] >0) {
            num++;
        }
    }
    return num;
}

- (NSArray *)getFinishedNumbersIndex {
    NSInteger index=0;
    NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in self.answersInfo) {
        if ([dic[@"Answer"] length] >0) {
            [indexArray addObject:[NSNumber numberWithInteger:index]];
        }
        index++;
    }
    return indexArray;
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

/*******************view mothed*******************/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.interactivePopGestureRecognizer.enabled = false;
    });
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return NO;
    }
    // add whatever logic you would otherwise have
    return YES;
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//
//}


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
