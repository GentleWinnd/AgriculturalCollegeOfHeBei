//
//  StuEvaluationViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//
#define TEACH_ATTITUDE @"teachAttitude"
#define TEACH_ABILITY @"teachAbility"
#define TEACH_PROGREMM @"teachProgremm"
#define TEACH_EVA_ID @"Id"
#define TEACH_EVA_CONTENT @"teachEvaContent"

#import "StuEvaluationViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ClassScheduleViewController.h"
#import "HCSStarRatingView.h"
#import "CurrentClassView.h"
#import "HCSStarRatingView.h"
#import "SetNavigationItem.h"
#import "HintMassageView.h"
#import "RecentCourseManager.h"
#import "UserData.h"
#import "KTMErrorHint.h"

@interface StuEvaluationViewController ()<UITextViewDelegate, HintViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *teacherName;
@property (strong, nonatomic) IBOutlet UIView *startView;
@property (strong, nonatomic) IBOutlet UITextView *ealuationText;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPScrollView;
@property (strong, nonatomic) IBOutlet UILabel *placeHodlerLabel;

@property (strong, nonatomic) IBOutlet HCSStarRatingView *oneStarView;
@property (strong, nonatomic) IBOutlet UILabel *oneLabel;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *twoStarView;
@property (strong, nonatomic) IBOutlet UILabel *twoLabel;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *threeStarView;
@property (strong, nonatomic) IBOutlet UILabel *threeLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentCourse;
@property (strong, nonatomic) IBOutlet UILabel *anonymityLabel;
@property (strong, nonatomic) IBOutlet UIButton *anonimityBtn;

@property (strong, nonatomic) NSMutableDictionary *evaluationStarInfo;
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *courseName;


@end

@implementation StuEvaluationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:@"教学评价" subTitle:@""];
    [self initData];
    [self customCurrentClassView];
    [self setEvaluationStar];
    [self initTextView];
}

#pragma mark - initdata 

- (void)initData {
    _evaluationStarInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    _courseName = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemDependentName];
    _courseId = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemCourseId];
    if (_courseId == nil) {
        [Progress progressShowcontent:@"获取课程失败，请前往课表选择"];
    }
    [self getTeachEvaluationItem];
    [self modifyEvaluationScoreWithItem:TEACH_ATTITUDE score:5];
    [self modifyEvaluationScoreWithItem:TEACH_ABILITY score:5];
    [self modifyEvaluationScoreWithItem:TEACH_PROGREMM score:5];
}

#pragma mark - initTextView

- (void)initTextView {
    _ealuationText.delegate = self;
    
}

#pragma mark - 定义classView

- (void)customCurrentClassView {
    CurrentClassView *classView = [CurrentClassView initViewLayout];
    CGRect frame = _topView.frame;
    frame.origin = CGPointMake(0, 0);
    classView.frame = frame;
    classView.courceName.text = _courseName;
    [_topView addSubview:classView];
    @WeakObj(classView);
    classView.selectedClick = ^(UIButton *sender) {
        ClassScheduleViewController *classView = [[ClassScheduleViewController alloc] init];
        classView.theSelectedClass = ^(NSDictionary *courseInfo){
            classViewWeak.courceName.text = courseInfo[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
            self.courseId = courseInfo[COURSE_ID];
        };
        [self.navigationController pushViewController:classView animated:YES];
        
    };
}

#pragma mark - set evaluationStar

- (void)setEvaluationStar {

    [self customEvaluationStar:_oneStarView];
    [self customEvaluationStar:_twoStarView];
    [self customEvaluationStar:_threeStarView];
}

- (HCSStarRatingView*)customEvaluationStar:(HCSStarRatingView *)starRatingView {
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.tintColor = [UIColor redColor];
    starRatingView.allowsHalfStars = NO;
    starRatingView.emptyStarImage = [[UIImage imageNamed:@"heart-empty"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    starRatingView.filledStarImage = [[UIImage imageNamed:@"heart-full"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    
       return starRatingView;
}

#pragma mark star did changed

- (void)didChangeValue:(HCSStarRatingView *)starView {

    if (starView == self.oneStarView) {
        [self modifyEvaluationScoreWithItem:TEACH_ATTITUDE score:starView.value];
        self.oneLabel.text = [self setEvaluationScoreColorWithScore:starView.value][@"gread"];
        self.oneLabel.textColor = [self setEvaluationScoreColorWithScore:starView.value][@"color"];
    } else if(starView == self.twoStarView) {
        [self modifyEvaluationScoreWithItem:TEACH_ABILITY score:starView.value];
        self.twoLabel.text = [self setEvaluationScoreColorWithScore:starView.value][@"gread"];
        self.twoLabel.textColor = [self setEvaluationScoreColorWithScore:starView.value][@"color"];
    } else {
        [self modifyEvaluationScoreWithItem:TEACH_PROGREMM score:starView.value];
        self.threeLabel.text = [self setEvaluationScoreColorWithScore:starView.value][@"gread"];
        self.threeLabel.textColor = [self setEvaluationScoreColorWithScore:starView.value][@"color"];
    }
}

#pragma mark - modify score of evaluation

- (void)modifyEvaluationScoreWithItem:(NSString *)item score:(NSInteger)score {
    NSMutableDictionary *evaInfo = [NSMutableDictionary dictionaryWithDictionary:_evaluationStarInfo[item]];
    [evaInfo setValue:[NSString stringWithFormat:@"%tu",score] forKey:TEACH_EVA_CONTENT];
    [_evaluationStarInfo setValue:evaInfo forKey:item];

}

#pragma mark - textView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _placeHodlerLabel.alpha = 0;//开始编辑时
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {//将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
        _placeHodlerLabel.alpha = 1;
    }
    return YES;
}

#pragma mark - putupevaluation

- (IBAction)putupEvaluation:(UIButton *)sender {
    if (self.ealuationText.text.length>0) {
        [self putupTeachEvaluation];
    } else {
        [Progress progressShowcontent:@"请输入评价信息"];
    }
}

#pragma mark - hintViewDelegate

- (void)hiddenSelfView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)reselectedCourse:(UIButton *)sender {
    ClassScheduleViewController *classView = [[ClassScheduleViewController alloc] init];
    classView.theSelectedClass = ^(NSDictionary *courseInfo){
    self.currentCourse.text = courseInfo[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
        self.courseId = courseInfo[COURSE_ID];
    };
    [self.navigationController pushViewController:classView animated:YES];
    
}

#pragma mark - get evaluation item

- (void)getTeachEvaluationItem {
    
    [NetServiceAPI getTeachEvaluationItemListWithParameters:nil success:^(id responseObject) {
        
        if ([responseObject[@"State"] integerValue] !=1) {
            [Progress progressShowcontent:responseObject[@"Message"]];
        } else {
            /*
             "EvaluationItems": [
             {
             "Id": "1de3021b-37f9-40b7-a05e-5dff1398036f",
             "Name": "教学态度"
             },
             {
             "Id": "3d09abde-2ca5-44cf-a93c-35cb4dbf4605",
             "Name": "授课技能"
             },
             {
             "Id": "fa0dcbb9-ef10-4626-9ae0-9b4001dc96ed",
             "Name": "课后辅导"
             }
             ],*/
            NSArray *EvaluationItems = responseObject[@"EvaluationItems"];
            NSMutableDictionary *evaInfo0 = [NSMutableDictionary dictionaryWithDictionary:_evaluationStarInfo[TEACH_ATTITUDE]];
            [evaInfo0  setValuesForKeysWithDictionary:EvaluationItems[0]];
            [_evaluationStarInfo setValue:evaInfo0 forKey:TEACH_ATTITUDE];
            
            NSMutableDictionary *evaInfo1 = [NSMutableDictionary dictionaryWithDictionary:_evaluationStarInfo[TEACH_ABILITY]];
            [evaInfo1 setValuesForKeysWithDictionary:EvaluationItems[1]];
            [_evaluationStarInfo setValue:evaInfo1 forKey:TEACH_ABILITY];
            
            NSMutableDictionary *evaInfo2 = [NSMutableDictionary dictionaryWithDictionary:_evaluationStarInfo[TEACH_PROGREMM]];
            [evaInfo2 setValuesForKeysWithDictionary:EvaluationItems[2]];
            [_evaluationStarInfo setValue:evaInfo2 forKey:TEACH_PROGREMM];
        }
        
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
}

#pragma mark - putup evaluation

- (void)putupTeachEvaluation {
    //post("/OfflineCourse/Evaluation",{AccessToken:"773daf60657f4bcaada90e5f5bd968ef",ActivityId:"3e45d826-aa7b-452a-be99-a6fde7baff78",Content:"讲得太好啦",EvaluationScores:"1de3021b-37f9-40b7-a05e-5dff1398036f,5|3d09abde-2ca5-44cf-a93c-35cb4dbf4605,5|fa0dcbb9-ef10-4626-9ae0-9b4001dc96ed,4"}
    if (self.courseId == nil) {
        return;
    }
    NSString *evaluationScores = [NSString stringWithFormat:@"%@,%@|%@,%@|%@,%@",_evaluationStarInfo[TEACH_ATTITUDE][TEACH_EVA_ID],_evaluationStarInfo[TEACH_ATTITUDE][TEACH_EVA_CONTENT],_evaluationStarInfo[TEACH_ABILITY][TEACH_EVA_ID],_evaluationStarInfo[TEACH_ABILITY][TEACH_EVA_CONTENT],_evaluationStarInfo[TEACH_PROGREMM][TEACH_EVA_ID],_evaluationStarInfo[TEACH_PROGREMM][TEACH_EVA_CONTENT]];
    
    
    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"ActivityId":_courseId,
                                @"Content":self.ealuationText.text,
                                @"EvaluationScores":evaluationScores,
                                @"IsAnonymous":[NSNumber numberWithBool:self.anonimityBtn.selected]};
    
    [NetServiceAPI postTeachEvaluationWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] !=1) {
            [Progress progressShowcontent:responseObject[@"Message"]];
        } else {
            HintMassageView *hintView = [HintMassageView initLayoutView];
            hintView.delegate = self;
            [hintView.hintLabel setTitle:@"提交成功" forState:UIControlStateNormal];
            [self.view addSubview:hintView];
        }
        
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
//        NSLog(@"error--==%@",[error description]);
    }];

}

#pragma mark - get evaluationGrad

- (NSDictionary *)setEvaluationScoreColorWithScore:(CGFloat)score {
    NSDictionary *scoreGread;
    if (score==1) {
        scoreGread = @{@"color":MainEvaluColor_Green,
                       @"gread":@"差"};
    } else if (score==2) {
        scoreGread = @{@"color":MainEvaluColor_Green,
                       @"gread":@"较差"};
        
    } else if (score==3) {
        scoreGread = @{@"color":MainColor_Red,
                       @"gread":@"一般"};
        
    } else if (score==4) {
        scoreGread = @{@"color":MainColor_Red,
                       @"gread":@"良好"};
        
    }  else if (score == 5){
        scoreGread = @{@"color":MainColor_Red,
                       @"gread":@"优秀"};
        
    }
    return scoreGread;
}

#pragma mark - 

- (IBAction)anonymityBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.anonymityLabel.text = sender.selected  == NO?@"您写的评价会以真实姓名的形式展现":@"您写的评价会以匿名的形式展现";
    
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
