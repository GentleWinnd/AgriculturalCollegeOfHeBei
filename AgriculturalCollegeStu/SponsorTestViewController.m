//
//  SponsorTestViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

typedef NS_ENUM(NSInteger ,QuestionType) {
    QuestionTypeSigle = 1,
    QuestionTypeMultiple,
    QuestionTypeJudge
};

#import "SponsorTestViewController.h"
#import "ClassScheduleViewController.h"
#import "CurrentClassView.h"
#import "SetNavigationItem.h"
#import "UIImage+Color.h"
#import "SetNavigationItem.h"
#import "HintMassageView.h"
#import "RecentCourseManager.h"
#import "UserData.h"

@interface SponsorTestViewController ()<HintViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *sigleBtn;
@property (strong, nonatomic) IBOutlet UIButton *multipleBtn;
@property (strong, nonatomic) IBOutlet UIButton *judgeBtn;

@property (strong, nonatomic) IBOutlet UIButton *OPABtn;
@property (strong, nonatomic) IBOutlet UIButton *OPBBtn;
@property (strong, nonatomic) IBOutlet UIButton *OPCBTn;
@property (strong, nonatomic) IBOutlet UIButton *OPDBTn;
@property (strong, nonatomic) IBOutlet UIButton *OPEBtn;
@property (strong, nonatomic) IBOutlet UIButton *OPGBtn;
@property (strong, nonatomic) IBOutlet UIButton *OPFBtn;
@property (strong, nonatomic) IBOutlet UIButton *OPHBtn;

@property (strong, nonatomic) IBOutlet UIButton *CPABtn;
@property (strong, nonatomic) IBOutlet UIButton *CPBBtn;
@property (strong, nonatomic) IBOutlet UIButton *CPCBtn;

@property (strong, nonatomic) IBOutlet UIButton *CPDBtn;

@property (strong, nonatomic) IBOutlet UIButton *CPEBtn;

@property (strong, nonatomic) IBOutlet UIButton *CPFBtn;
@property (strong, nonatomic) IBOutlet UIButton *CPGBtn;
@property (strong, nonatomic) IBOutlet UIButton *CPHBtn;
@property (strong, nonatomic) IBOutlet UIButton *judgeOPBtn;
@property (strong, nonatomic) IBOutlet UIButton *judgeErroOPBtn;


@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIView *optionView;

@property (strong, nonatomic) IBOutlet UIView *answerView;

@property (strong, nonatomic) IBOutlet UIView *OAnswerView;

@property (strong, nonatomic) SetNavigationItem *setNav;
@property (assign, nonatomic) QuestionType QType;
@property (strong, nonatomic) NSMutableArray *anwserArray;
@property (strong, nonatomic) NSMutableArray *optionArray;
@property (strong, nonatomic) NSString *questionType;
@property (strong, nonatomic) HintMassageView *hintView;
@end

@implementation SponsorTestViewController

#pragma mark - setNavigationBar

- (void)setNavigationBar {
    _setNav = [[SetNavigationItem alloc] init];
    [_setNav setNavTitle:self withTitle:@"发起测验" subTitle:@""];

    [_setNav setNavRightItem:self withItemTitle:@"发布" textColor:MainTextColor_DarkBlack];
    @WeakObj(self);
    _setNav.rightClick = ^(){
        [selfWeak publishedClassTemporaryTest];
        
    };
}

#pragma mark - hiddenHintView
- (void)hiddenSelfView {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    [self initData];
    [self customCurrentClassView];
    [self setBtn];
}

#pragma mark - initdata

- (void)initData {
    self.anwserArray = [NSMutableArray arrayWithCapacity:9];
    self.optionArray = [NSMutableArray arrayWithCapacity:9];
    if (self.courseId == nil) {
        [self getRecentCourse];
    }
}

- (void)getRecentCourse {
    [RecentCourseManager getRecentCourseSuccess:^(NSDictionary *coursesInfo) {
        self.courseId = [NSDictionary safeDictionary:coursesInfo][COURSE_ID];
        self.courseName = [NSDictionary safeDictionary:coursesInfo][COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
    } failure:^(NSString *failMessage) {
        
    }];
}


#pragma Mark - published test

- (void)publishedClassTemporaryTest {
    
    if (self.optionArray.count == 0 && self.QType != QuestionTypeJudge) {
        [Progress progressShowcontent:@"请添加问题选项"];
        return;
    }
    NSString *optionStr = @"";
    for (NSString *item in self.optionArray) {
        if (optionStr.length == 0) {
            optionStr = item;
        } else {
            optionStr = [NSString stringWithFormat:@"%@,%@",optionStr,item];
        }
    }
    if (self.anwserArray.count == 0) {
        [Progress progressShowcontent:@"请添加问题答案"];
        return;
    }
    if (self.courseId == nil) {
        return;
    }
    
    NSString *answerStr;
    for (NSString *item in self.anwserArray) {
        if (answerStr.length == 0) {
            answerStr = item;
        } else {
            answerStr = [NSString stringWithFormat:@"%@,%@",answerStr,item];
        }
    }

    NSDictionary *paraneter = @{@"AccessToken":[UserData getAccessToken],
                                @"ActivityId":self.courseId,
                                @"QuestionType":_questionType,
                                @"QuestionOptions":optionStr,
                                @"RightAnswer":answerStr};
    [NetServiceAPI postPublishClassTestWithParameters:paraneter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] !=1) {
            [Progress progressShowcontent:responseObject[@"Message"] currView:self.view];
        } else {
            _hintView = [HintMassageView initLayoutView];
            _hintView.delegate = self;
            [_hintView.hintLabel  setTitle:@"测试发布成功" forState:UIControlStateNormal];
            [self.view addSubview:_hintView];

        }
        
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        
    }];

}

#pragma mark - 定义classView

- (void)customCurrentClassView {
    CurrentClassView *classView = [CurrentClassView initViewLayout];
    CGRect frame = _topView.frame;
    frame.origin = CGPointMake(0, 0);
    classView.frame = frame;
    classView.courceName.text = self.courseName;
    [_topView addSubview:classView];
   
    @WeakObj(classView);
    classView.selectedClick = ^(UIButton *sender) {
        ClassScheduleViewController *scheduleView = [[ClassScheduleViewController alloc] init];
        scheduleView.theSelectedClass = ^(NSDictionary *classCourse){
            self.courseName = classCourse[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
            self.courseId = [NSString safeString:classCourse[COURSE_RECENTACTICE_ID]];
            classViewWeak.courceName.text = self.courseName;

        };
        [self.navigationController pushViewController:scheduleView animated:YES];
        
    };
}

- (void)setBtn {
    [self customBtnWithBtn:_sigleBtn withCornerRadius:3];
    [self customBtnWithBtn:_multipleBtn withCornerRadius:3];
    [self customBtnWithBtn:_judgeBtn withCornerRadius:3];
    
    [self customBtnWithBtn:_OPABtn withCornerRadius:2];
    [self customBtnWithBtn:_OPBBtn withCornerRadius:2];
    [self customBtnWithBtn:_OPCBTn withCornerRadius:2];
    [self customBtnWithBtn:_OPDBTn withCornerRadius:2];
    [self customBtnWithBtn:_OPEBtn withCornerRadius:2];
    [self customBtnWithBtn:_OPFBtn withCornerRadius:2];
    [self customBtnWithBtn:_OPGBtn withCornerRadius:2];
    [self customBtnWithBtn:_OPHBtn withCornerRadius:2];
    [self customBtnWithBtn:_CPABtn withCornerRadius:2];
    [self customBtnWithBtn:_CPBBtn withCornerRadius:2];
    [self customBtnWithBtn:_CPCBtn withCornerRadius:2];
    [self customBtnWithBtn:_CPDBtn withCornerRadius:2];
    
    [self customBtnWithBtn:_CPEBtn withCornerRadius:2];
    [self customBtnWithBtn:_CPFBtn withCornerRadius:2];
    [self customBtnWithBtn:_CPGBtn withCornerRadius:2];
    [self customBtnWithBtn:_CPHBtn withCornerRadius:2];
    [self customBtnWithBtn:_judgeOPBtn withCornerRadius:3];
    [self customBtnWithBtn:_judgeErroOPBtn withCornerRadius:3];
    
    _QType = QuestionTypeSigle;
    [self setButtonBackgroundColor:_sigleBtn];
    _sigleBtn.selected = YES;
    _questionType = @"单选题";
}

- (UIButton *)customBtnWithBtn:(UIButton *)btn withCornerRadius:(NSInteger)radius {

    btn.layer.cornerRadius = radius;
    btn.layer.borderColor = MainThemeColor_Blue.CGColor;
    btn.layer.borderWidth = 1;
    return btn;
}

- (IBAction)quenstionTypeBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
   
    if (sender.selected) {
        [self setButtonBackgroundColor:sender];
    }
    [_optionArray removeAllObjects];
    [_anwserArray removeAllObjects];
    [self setSigleAnswerBtnState:0];
    [self setOptionBtnState];
    
    self.QType = sender.tag;
    _questionType = sender.titleLabel.text;
    [self setQuestionType];
}

- (IBAction)optionBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_optionArray removeAllObjects];

    if (sender.selected) {
        for (int i=11; i<=sender.tag; i++) {
            UIButton *optionBtn = (UIButton *)[self.view viewWithTag:i];
            [_optionArray addObject:optionBtn.titleLabel.text];
            optionBtn.selected = YES;
            [self setButtonBackgroundColor:optionBtn];
        }
    } else {
        for (NSInteger i=sender.tag; i<=18; i++) {
            UIButton *optionBtn = (UIButton *)[self.view viewWithTag:i];
            optionBtn.selected = NO;
            [_optionArray removeObject:optionBtn.titleLabel.text];
            [self setButtonNoSelected:optionBtn];
        }
    }

   
//    NSString *selectedOP = sender.titleLabel.text;
//    NSInteger count = _optionArray.count;
//    
//    if (_optionArray.count) {
//        
//        for (int index = 0;index <count;index++) {
//            NSString *text = _optionArray[index];
//            if ([text isEqualToString:selectedOP]) {
//                [_optionArray removeObjectAtIndex:index];
//                break;
//            } else {
//                if (index == count-1) {
//                    [_optionArray addObject:selectedOP];
//                }
//            }
//        }
//    } else {
//        [_optionArray addObject:selectedOP];
//    }
    
//    NSLog(@"--=options=%@",_optionArray);
}


- (IBAction)answerBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self setButtonBackgroundColor:sender];
    }
    NSString *selectedOP = sender.titleLabel.text;

    if (self.QType == QuestionTypeSigle) {
        [self setSigleAnswerBtnState:sender.tag];
        if (_anwserArray.count == 0) {
            [_anwserArray addObject:selectedOP];
        } else {
            [_anwserArray replaceObjectAtIndex:0 withObject:selectedOP];
        }
        
    } else if (self.QType == QuestionTypeMultiple){
        if (_anwserArray.count) {
            NSInteger count = _anwserArray.count;
            for (int index = 0;index <count;index++) {
                NSString *text = _anwserArray[index];
                if ([text isEqualToString:selectedOP]) {
                    [_anwserArray removeObjectAtIndex:index];
                    break;
                } else {
                    if (index == count-1) {
                        [_anwserArray addObject:selectedOP];
                    }
                }
            }
 
        } else {
            [_anwserArray addObject:selectedOP];
        }
        
    } else {
        if (sender == _judgeErroOPBtn) {
            _judgeOPBtn.selected = NO;
        } else {
            _judgeErroOPBtn.selected = NO;
        }
        if (_anwserArray.count == 0) {
            [_anwserArray addObject:selectedOP];
        } else {
            [_anwserArray replaceObjectAtIndex:0 withObject:selectedOP];
        }
    }
   // NSLog(@"--=anwser=%@",_anwserArray);
}

#pragma mark - setBtnBackColor

- (void)setButtonBackgroundColor:(UIButton *)sender {
    UIImage *colorImg = [UIImage imageFromColor:MainThemeColor_Blue withSize:sender.frame.size];
    [sender setBackgroundImage:colorImg forState:UIControlStateSelected];
}

#pragma mark - setButtonNoSelected
- (void)setButtonNoSelected:(UIButton *)sender {
    sender.selected = NO;
}

#pragma mark - setQuestionView

- (void)setQuestionType {
    switch (_QType) {
        case QuestionTypeSigle:
            self.sigleBtn.selected = YES;
            self.multipleBtn.selected = NO;
            self.judgeBtn.selected = NO;
            self.optionView.hidden = NO;
            self.answerView.hidden = NO;
            self.OAnswerView.hidden = YES;
            break;
        case QuestionTypeMultiple:
            self.sigleBtn.selected = NO;
            self.multipleBtn.selected = YES;
            self.judgeBtn.selected = NO;
            self.optionView.hidden = NO;
            self.answerView.hidden = NO;
            self.OAnswerView.hidden = YES;
            break;
        case QuestionTypeJudge:
            self.sigleBtn.selected = NO;
            self.multipleBtn.selected = NO;
            self.judgeBtn.selected = YES;
            self.optionView.hidden = YES;
            self.answerView.hidden = YES;
            self.OAnswerView.hidden = NO;

            break;

        default:
            break;
    }
}

#pragma mark - setSigleAnswer

- (void)setSigleAnswerBtnState:(NSInteger)selectedBtn {
    for (NSInteger i = 20; i<=28; i++) {
        UIButton *btn = (UIButton *)[_answerView viewWithTag:i];
        if (i!=selectedBtn) {
            btn.selected = NO;
        }
    }
}

- (void)setOptionBtnState {
    for (int i=10;i<=18;i++) {
        UIButton *opstion = (UIButton *)[_optionView viewWithTag:i];
        opstion.selected = NO;
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
