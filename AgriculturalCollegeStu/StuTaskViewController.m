//
//  StuTaskViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/21.
//  Copyright © 2016年 YH. All rights reserved.
//
#define COURSE @"Items"
#define ANSWER @"Answer"
#define ATTACHMENTS @"AttachmentItems"
#define ATTACHMENR_ID @"AttachmentId"
#define ATTACHMENT_URL @"AttachmentUrl"
#define DESCRIPTION @"Description"
#define ASSIGNMENT_KEY @"Key"
#define LOCAL_ATTACHMENT @"local"
#define ATTACHMENT_IMAGE @"attachmentImage"

#import "StuTaskViewController.h"
#import "CourseInfoCollectionViewCell.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ClassScheduleViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "AttachmentCollectionViewCell.h"
#import "JKImagePickerController.h"
#import "SetNavigationItem.h"
#import "FinishedCourseView.h"
#import "HintMassageView.h"
#import "MBProgressManager.h"
#import "RecentCourseManager.h"
#import "UIImageView+WebCache.h"
#import "UserData.h"


@interface StuTaskViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HintViewDelegate, UIGestureRecognizerDelegate, JKImagePickerControllerDelegate>{
    NSInteger currentIndex;
}
@property (strong, nonatomic) IBOutlet UILabel *selectedCource;
@property (strong, nonatomic) IBOutlet UIButton *selecteCourceBtn;
@property (strong, nonatomic) IBOutlet UIButton *finishedRateBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *courseCollectionView;
@property (strong, nonatomic) SetNavigationItem *setNav;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPScrollView;

@property (strong, nonatomic) IBOutlet UIButton *postQuestionBt;//height:38
@property (strong, nonatomic) IBOutlet UIButton *addAttementBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *attachmentsCollection;
@property (strong, nonatomic) IBOutlet UIView *attachmentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *attachmentViewBottom;

@property (strong, nonatomic) NSMutableArray *answersInfoArray;
@property (strong, nonatomic) NSDictionary *allAssignmentInfo;
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *courseName;



@end
static NSString *cellID= @"cellID";
static NSString *attachmentCellID= @"AttachmentCellID";

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
    currentIndex = 0;
    [self setNavigationBar];
    [self initData];
    [self creatCustomCollectioView];
    [self customAttachmentCollectioView];
    
}

- (void)initData {
    self.answersInfoArray = [NSMutableArray arrayWithCapacity:0];
    [self getRecentCourse];
    [self getSchollAssignment];
    self.attachmentViewBottom.constant = -142;
    
    
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
    
    [NetServiceAPI getSchoolAssignmentWithParameters:@{@"Activty":self.courseId} success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            
            _allAssignmentInfo = [NSDictionary safeDictionary:responseObject[@"HomeWorkDetailsModel"]];
            [_answersInfoArray addObjectsFromArray:[NSArray safeArray:_allAssignmentInfo[@"Items"]]];
            
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

- (void)putupStudentShcoolAssignment {
    if (self.allAssignmentInfo == nil) {
        return;
    }
    NSDictionary *CParameter = @{@"HomeWorkDataId":_allAssignmentInfo[@"HomeWorkDataId"]};
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:CParameter];
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

- (NSString *)joinAllAssignmentAnswers {
    
    NSString *joinAnswer = @"";
    for (int i=0;i<_answersInfoArray.count;i++) {
        if (i == 0) {
            joinAnswer = [NSString stringWithFormat:@"%@^^%@",_answersInfoArray[i][@"Key"],_answersInfoArray[i][@"Answer"] ];
            
        } else {
            joinAnswer = [NSString stringWithFormat:@"%@||%@^^%@",joinAnswer,_answersInfoArray[i][@"Key"],_answersInfoArray[i][@"Answer"] ];
        }
    }
    return joinAnswer;
}

#pragma mark - add attachment button

- (IBAction)attachmentBtnClick:(UIButton *)sender {
    if (sender.tag == 1122) {//uploadattachment
        [UIView animateWithDuration:1 animations:^{
           
            if (!sender.selected) {//弹出
                self.attachmentViewBottom.constant = 0;
                [_attachmentsCollection reloadData];
            } else {//收起
                self.attachmentViewBottom.constant = -142;
                
                NSArray *attacheMents = [NSArray safeArray:[self getCurrentAssignmentInfo][ATTACHMENTS]];
                if (attacheMents.count >0) {
//                    [self uploadAttachmentData];
                }
            }
 
        }];
        sender.selected = !sender.selected;
    } else {//前往相册
        [self composePicAdd];
        
    }
}

- (NSDictionary *)getCurrentAssignmentInfo {
    if (_answersInfoArray.count == 0) {
        return nil;
    }
    NSDictionary *assignInfo = [NSDictionary safeDictionary:_answersInfoArray[currentIndex]];
    return assignInfo;
}


#pragma mark - 创建collectionView
- (void)customAttachmentCollectioView {
    
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.attachmentsCollection.collectionViewLayout = layOut;
    self.attachmentsCollection.delegate = self;
    self.attachmentsCollection.dataSource = self;
    layOut.minimumInteritemSpacing = 1;
    layOut.minimumLineSpacing = 1;
    self.attachmentsCollection.backgroundColor = [UIColor whiteColor];
    [self.attachmentsCollection registerNib:[UINib nibWithNibName:@"AttachmentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:attachmentCellID];
    
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
    if (collectionView == self.attachmentsCollection) {
        NSArray *attachments = [NSArray safeArray:[self getCurrentAssignmentInfo][ATTACHMENTS]];
        return  attachments.count;
    } else {
        return  [_answersInfoArray count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if (collectionView == self.attachmentsCollection) {
        AttachmentCollectionViewCell *ACell = [collectionView dequeueReusableCellWithReuseIdentifier:attachmentCellID forIndexPath:indexPath];
        NSArray *attachments = [NSArray safeArray:[self getCurrentAssignmentInfo][ATTACHMENTS]];
        NSDictionary *attachInfo = [NSDictionary safeDictionary:attachments[indexPath.row]];
        
        NSString *imageUrl = [NSString safeString:attachInfo[ATTACHMENT_URL]];
        NSData *imageData = attachInfo[ATTACHMENT_IMAGE];
        if (imageData) {
            ACell.attachmentType.image = [UIImage imageWithData:attachInfo[ATTACHMENT_IMAGE]];
        } else {
            NSURL *url = [NSURL URLWithString:imageUrl];
            [ACell.attachmentType sd_setImageWithURL:url];
        }
        ACell.deletedAttachment = ^(){
            [self removeHomeWorkAttachments:[self getCurrentAssignmentInfo][ASSIGNMENT_KEY] attachmentId:attachInfo[ATTACHMENR_ID] indexPath:indexPath];
            
        };
        cell = ACell;
    } else {
        CourseInfoCollectionViewCell *CCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        CCell.courseLabel.text = [NSString safeString:_answersInfoArray[indexPath.row][@"Description"]];
        CCell.answerTextView.text = [NSString safeString:_answersInfoArray[indexPath.row][ANSWER]];
        CCell.answerStr = [NSString safeString:_answersInfoArray[indexPath.row][ANSWER]];;
        CCell.getAnswer = ^(NSString *answer){
            if (answer.length>0) {
                [self setAnswerWithIndexPath:indexPath answer:answer];

            }
        };
        cell = CCell;
    }
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.attachmentsCollection) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(1, 1, 0, 1);
    }
}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.attachmentsCollection) {
        return CGSizeMake(90 , 90);
    } else {
        return CGSizeMake(WIDTH, 300);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)setAnswerWithIndexPath:(NSIndexPath *)indexPath answer:(NSString *)answer {
    
    NSMutableDictionary *assignInfo = [NSMutableDictionary dictionaryWithDictionary:_answersInfoArray[indexPath.row]];
    [assignInfo setValue:answer forKey:ANSWER];
    [_answersInfoArray replaceObjectAtIndex:indexPath.row withObject:assignInfo];
//    [self updateCourseFinishedState];

}

- (void)dealAttachmentImage:(NSIndexPath *)indexPath images:(NSArray *)images {
    NSMutableDictionary *assignInfo = [NSMutableDictionary dictionaryWithDictionary:_answersInfoArray[currentIndex]];
    NSMutableArray *attachments = [NSMutableArray arrayWithArray:[NSArray safeArray:assignInfo[ATTACHMENTS]]];
   
    if (images.count>0) {
        for (UIImage *image in images) {
            NSDictionary *attachInfo = @{ATTACHMENT_IMAGE:UIImageJPEGRepresentation(image, 0.5)};
            [attachments addObject:attachInfo];
        }
    } else {
        if (indexPath.row>attachments.count-1) {
            return;
        }

        [attachments removeObjectAtIndex:indexPath.row];
    }
  
    [assignInfo setValue:attachments forKey:ATTACHMENTS];
    [_answersInfoArray replaceObjectAtIndex:currentIndex withObject:assignInfo];
    
    [_attachmentsCollection reloadData];
    
    [self uploadAttachmentData];
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
            [finisedView.courseBtn setTitle:[NSString stringWithFormat:@"%tu/%tu",[self getFinishedNumber],[_answersInfoArray count]] forState:UIControlStateNormal];
            finisedView.courseNumber = [_allAssignmentInfo[COURSE] count];
            finisedView.finishedNum = [self getFinishedNumber];
            finisedView.finishedArray = [self getFinishedNumbersIndex];
            finisedView.selectedNum = ^(NSInteger index) {
                _courseCollectionView.contentOffset = CGPointMake(WIDTH * index, 0);
                [_finishedRateBtn setTitle:[NSString stringWithFormat:@"%d/%tu",index+1,[_allAssignmentInfo[COURSE] count]] forState:UIControlStateNormal];
            };

            [self.view addSubview:finisedView];
            
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    int page = scrollView.contentOffset.x/WIDTH;
    for (UICollectionViewCell *cell in scrollView.subviews) {
        if ([cell isKindOfClass:[CourseInfoCollectionViewCell class]]) {
            [_finishedRateBtn setTitle:[NSString stringWithFormat:@"%d/%tu",page+1,[_allAssignmentInfo[COURSE] count]] forState:UIControlStateNormal];
            currentIndex = page;
            [self.attachmentsCollection reloadData];

        }
    }
}

#pragma mark - update finihsed rate

- (void)updateCourseFinishedState {

//    [_finishedRateBtn setTitle:[NSString stringWithFormat:@"%tu/%tu",[self getFinishedNumber],[_allAssignmentInfo[COURSE] count]] forState:UIControlStateNormal];
    [_finishedRateBtn setTitle:[NSString stringWithFormat:@"%d/%tu",1,[_allAssignmentInfo[COURSE] count]] forState:UIControlStateNormal];

}

#pragma mark - get finished question num
- (NSInteger)getFinishedNumber {
    [self.view endEditing:YES];
    NSInteger num=0;
    for (NSDictionary *dic in _answersInfoArray) {
        if ([[NSString safeString:dic[@"Answer"]] length] >0) {
            num++;
        }
    }
    return num;
}

- (NSArray *)getFinishedNumbersIndex {
    NSInteger index=0;
    NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in self.answersInfoArray) {
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

/*************get image************/

- (void)composePicAdd {
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
//    imagePickerController.selectedAssetArray = self.attachmentsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSelectedImage:) name:@"sendSelectedImages" object:nil];
    
}

- (void)notificationSelectedImage:(NSNotification *)notice {

    if (notice.userInfo.count>0) {
        [self dealAttachmentImage:nil images:[NSArray safeArray:notice.userInfo[@"image"]]];
    }
}

#pragma mark - JKImagePickerControllerDelegate

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source {
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source {

    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - upload homework attaments

- (void)uploadAttachmentData {
    NSString *imageStr ;
    if (_allAssignmentInfo.count == 0) {
        [Progress progressShowcontent:@"此课程暂无作业" currView:self.view];
    }
    
    NSDictionary *assignInfo = [NSDictionary safeDictionary:_answersInfoArray[currentIndex]];
    NSArray *attachments = [NSArray safeArray:assignInfo[ATTACHMENTS]];
    
    
    if (attachments.count == 0) {
//        [Progress progressShowcontent:@"请选择作业附件" currView:self.view];
        return;
    }
    BOOL haveAttach = NO;
    NSInteger index = 0;
    for (NSDictionary *attachDic in attachments) {
        if (index == 0) {
            NSData *imageData = attachDic[ATTACHMENT_IMAGE];
            if (imageData) {
                imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                haveAttach = YES;
            }
        } else {
            NSData *imageData = attachDic[ATTACHMENT_IMAGE];
            if (imageData) {
                imageStr = [NSString stringWithFormat:@"||%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
                haveAttach = YES;
            }
        }
        index++;
    }
    if (haveAttach == NO) {
        return;
    }
  
    NSDictionary *parameter =@{@"ActivityId":self.courseId,
                               @"HomeWorkDataId":_allAssignmentInfo[@"HomeWorkDataId"],
                               @"Key":assignInfo[ASSIGNMENT_KEY],
                               @"FileExt":@"png",
                               @"AttachmentBase64String":imageStr};
    
    [NetServiceAPI postUploadHomeWorkAttachmentsWithParameters:parameter success:^(id responseObject) {
    
        if ([responseObject[@"State"] integerValue] == 1) {

        } else {
            [Progress progressShowcontent:@"作业附件上传失败" currView:self.view];
        }
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];

}

#pragma mark - 删除附件

- (void)removeHomeWorkAttachments:(NSString *)assignKey attachmentId:(NSString *)attachmentId indexPath:(NSIndexPath *)indexPath {

    if (attachmentId == nil) {
        return;
    }
    NSDictionary *parameter = @{@"HomeWorkDataId":_allAssignmentInfo[@"HomeWorkDataId"],
                                @"Key":assignKey,
                                @"AttachmentId":attachmentId};
    
    [NetServiceAPI postRemoveHomeWorkAttachmentsWithParameters:parameter success:^(id responseObject) {
        
        if ( [responseObject[@"State"] integerValue] == 1) {
            [Progress progressShowcontent:@"删除成功" currView:self.view];
            [self dealAttachmentImage:indexPath images:nil];

        } else {
            [Progress progressShowcontent:[NSString safeString:responseObject[@"Message"]] currView:self.view];
        }
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];

}


//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//
//}

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
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return NO;
    }
    // add whatever logic you would otherwise have
    return YES;
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
