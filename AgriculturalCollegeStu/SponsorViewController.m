//
//  SponsorViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/12.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "ClassScheduleViewController.h"
#import "StusCollectionViewCell.h"
#import "SponsorViewController.h"
#import "UIImageView+WebCache.h"
#import "RecentCourseManager.h"
#import "HCSStarRatingView.h"
#import "CurrentClassView.h"
#import "UserData.h"

@interface SponsorViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *topClassView;
@property (strong, nonatomic) IBOutlet UICollectionView *studentCollection;
@property (strong, nonatomic) IBOutlet UIButton *signUpBtn;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (strong, nonatomic) IBOutlet UILabel *gradelabel;
@property (strong, nonatomic) IBOutlet UILabel *studentNameView;

@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *courseId;
@property (strong, nonatomic) NSString *acvitiveId;
@property (strong, nonatomic) NSString *evaluationScore;
@property (strong, nonatomic) NSString *studentId;
@property (strong, nonatomic) NSString *studentName;



@property (strong, nonatomic) NSArray *allStuArray;

@end

static NSString *cellID = @"studentInfoCell";
@implementation SponsorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发起提问";
    _courseName = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemDependentName];
    _courseId = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemDependentId];
    _acvitiveId = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemCourseId];
    if (_courseId == nil) {
        [Progress progressShowcontent:@"获取课程失败，请前往课表选择"];
    }

    [self customCurrentClassView];
    [self creatCustomCollectioView];
    [self customEvaluationStar:self.starView];
    [self getSponsorStudentsInfo];
    
    
}

#pragma mark - 定义classView

- (void)customCurrentClassView {
    CurrentClassView *classView = [CurrentClassView initViewLayout];
    CGRect frame = self.topClassView.frame;
    frame.origin = CGPointMake(0, 0);
    classView.frame = frame;
    classView.courceName.text = _courseName;
    [ self.topClassView addSubview:classView];
    @WeakObj(classView);
    classView.selectedClick = ^(UIButton *sender) {
        ClassScheduleViewController *classView = [[ClassScheduleViewController alloc] init];
        classView.theSelectedClass = ^(NSDictionary *courseInfo){
            classViewWeak.courceName.text = courseInfo[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
            self.courseName = classViewWeak.courceName.text;
            self.courseId = courseInfo[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_ID];
            self.acvitiveId = courseInfo[COURSE_ID];
        };
        [self.navigationController pushViewController:classView animated:YES];
        
    };
}

#pragma mark - 获取提问学生信息

- (void)getSponsorStudentsInfo {
    if (self.courseId == nil) {
        [Progress progressPlease:@"未知错误" showView:self.view];
        return;
    }
    NSDictionary *parameter = @{@"OfflineCourseId":_courseId};
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    
    [NetServiceAPI getOfflineCourseAskQuestionMemberStatWithParameters:parameter success:^(id responseObject) {
        [progress hiddenProgress];
        if ([responseObject[@"State"] intValue] == 1) {
            self.allStuArray = [NSArray arrayWithArray:[NSArray safeArray:responseObject[@"DataObject"]]];
            [self.studentCollection reloadData];
        } else {
            [Progress progressShowcontent:@"获取提问学生信息失败了" currView:self.view];
        }
    } failure:^(NSError *error) {
        [progress hiddenProgress];

        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
}

#pragma mark - 上传提问学生评价

- (void)uploadSponsorStudentEvalluation {
    if (self.evaluationScore == nil) {
        [Progress progressShowcontent:@"请设置评价分数" currView:self.view];
        return;
    }
    if (COURSE_ID == nil || _studentId.length == 0) {
        [Progress progressShowcontent:@"未知错误" currView:self.view];
        return;
    }
    
    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"ActivityId":_acvitiveId,
                                @"StudentId":_studentId,
                                @"EvaluationScore":_evaluationScore};
    
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@""];
    @WeakObj(_studentName)

    [NetServiceAPI postOfflineCourseAskQuestionEvaluationWithParameters:parameter success:^(id responseObject) {
        [progress hiddenProgress];
        if ([responseObject[@"State"] intValue] == 1) {
            [Progress progressShowcontent:[NSString stringWithFormat:@"对于%@答题评价提交成功",_studentNameWeak] currView:self.view];
            [self getSponsorStudentsInfo];
        } else {
            [Progress progressShowcontent:@"上传学生评价失败了" currView:self.view];
        }
    } failure:^(NSError *error) {
        [progress hiddenProgress];

        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
}

#pragma mark - 发起提问

- (void)sponsorQuestion {

    if (self.courseId ==  nil || self.studentId.length == 0) {
        [Progress progressShowcontent: @"未知错误" currView:self.view];
        return;
    }
    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"ActivityId":_acvitiveId,
                                @"StudentId":_studentId};
    @WeakObj(_studentName)
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@""];
    [NetServiceAPI postOfflineCoorseSponsorQuestionWithParameters:parameter success:^(id responseObject) {
        [progress hiddenProgress];
        if ([responseObject[@"State"] intValue] == 1) {
            [Progress progressShowcontent:[NSString stringWithFormat:@"已经向%@发出通知了",_studentNameWeak] currView:self.view];
            
        } else {
            [Progress progressShowcontent:@"发起提问失败了" currView:self.view];
        }
    } failure:^(NSError *error) {
        [progress hiddenProgress];

        [KTMErrorHint showNetError:error inView:self.view];
    }];

}

#pragma mark- 设置星星view

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

    self.gradelabel.text = [self setEvaluationScoreColorWithScore:starView.value][@"gread"];
    self.gradelabel.textColor = [self setEvaluationScoreColorWithScore:starView.value][@"color"];
    self.evaluationScore = [NSString stringWithFormat:@"%f",starView.value];
    
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

#pragma mark - 创建collectionView
- (void)creatCustomCollectioView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.studentCollection.collectionViewLayout = layOut;
    self.studentCollection.delegate = self;
    self.studentCollection.dataSource = self;
    layOut.minimumInteritemSpacing = 1;
    layOut.minimumLineSpacing = 1;
    self.studentCollection.backgroundColor = [UIColor whiteColor];
    [self.studentCollection registerNib:[UINib nibWithNibName:@"StusCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.allStuArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    NSDictionary *dic = [NSDictionary safeDictionary:self.allStuArray[indexPath.row]];
    NSDictionary *stuInfo = [NSDictionary safeDictionary:dic[@"Student"]];
    int number = [[NSString safeNumber:dic[@"AskQuestionNum"]] intValue];
    
    [cell.headPortriat sd_setImageWithURL:[NSURL URLWithString:[NSString safeString:stuInfo[@"Avatar" ]]] placeholderImage:nil];
    cell.stuName.text = [NSString safeString:stuInfo[@"FullName"]];
    cell.askNumber.text = [NSString stringWithFormat:@"%d",number];
    cell.askNumber.hidden = number == 0?YES:NO;
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 0, 1);
}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (WIDTH-9)/4;
    return CGSizeMake(width, width);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(WIDTH, 30);
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [NSDictionary safeDictionary:self.allStuArray[indexPath.row]];
    NSDictionary *stuInfo = [NSDictionary safeDictionary:dic[@"Student"]];
    _studentName = [NSString safeString:stuInfo[@"FullName"]];
    _studentNameView.text = _studentName;
    _studentId = [NSString safeString:stuInfo[@"Id"]];

}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}



- (IBAction)questionBtnAction:(UIButton *)sender {
    
    [self sponsorQuestion];
}


- (IBAction)signUpClick:(UIButton *)sender {
    
    [self uploadSponsorStudentEvalluation];
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
