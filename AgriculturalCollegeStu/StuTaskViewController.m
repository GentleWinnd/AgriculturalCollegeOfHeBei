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
#define ATTAH_IMAGES @"attachImages"
#define STU_ANSWER_LAST @"studentLastAnswer"

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
@property (strong, nonatomic) IBOutlet UIButton *originPictureBtn;


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSelectedImage:) name:@"sendSelectedImages" object:nil];

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
        [Progress progressShowcontent:@"没有作业可提交" currView:self.view];
        return;
    }
    NSDictionary *CParameter = @{@"HomeWorkDataId":_allAssignmentInfo[@"HomeWorkDataId"],
                                 @"ActivityId":self.courseId,};
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
        NSString *proAnswer = [NSString safeString:_answersInfoArray[i][ANSWER]];
        NSString *lastAsnwer = [NSString safeString:_answersInfoArray[i][STU_ANSWER_LAST]];

        NSString *asnerInfo = lastAsnwer.length>0?lastAsnwer:proAnswer;
        if (i == 0) {
            joinAnswer = [NSString stringWithFormat:@"%@^^%@",_answersInfoArray[i][@"Key"],asnerInfo ];
            
        } else {
            joinAnswer = [NSString stringWithFormat:@"%@||%@^^%@",joinAnswer,_answersInfoArray[i][@"Key"],asnerInfo];
        }
    }
    return joinAnswer;
}

#pragma mark - add attachment button

- (IBAction)attachmentBtnClick:(UIButton *)sender {
    if (sender.tag == 1122) {//uploadattachment
        if (self.answersInfoArray.count == 0) {
            [Progress progressShowcontent:@"没有作业，无法添加附件" currView:self.view];
            return ;
        }

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
            ACell.attachmentType.image = [UIImage imageWithData:imageData];
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
        NSString *proAnswer = [NSString safeString:_answersInfoArray[indexPath.row][ANSWER]];
        NSString *lastAsnwer = [NSString safeString:_answersInfoArray[indexPath.row][STU_ANSWER_LAST]];

        CCell.courseLabel.text = [NSString safeString:_answersInfoArray[indexPath.row][@"Description"]];
        CCell.answerTextView.text = lastAsnwer.length>0?lastAsnwer:proAnswer;
        CCell.answerStr = lastAsnwer.length>0?lastAsnwer:proAnswer;
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
    [assignInfo setValue:answer forKey:STU_ANSWER_LAST];
    [_answersInfoArray replaceObjectAtIndex:indexPath.row withObject:assignInfo];

}

- (void)dealAttachmentImages:(NSArray *)images {
    NSMutableDictionary *assignInfo = [NSMutableDictionary dictionaryWithDictionary:_answersInfoArray[currentIndex]];
    NSMutableArray *attImageArr = [NSMutableArray arrayWithArray:assignInfo[ATTAH_IMAGES]];
    if (images.count>0) {
        for (UIImage *image in images) {
            NSDictionary *attachInfo = @{ATTACHMENT_IMAGE:UIImageJPEGRepresentation(image, 0.5)};
            [attImageArr addObject:attachInfo];
        }
    } else {
        [attImageArr removeAllObjects];
    }
  
    [assignInfo setValue:attImageArr forKey:ATTAH_IMAGES];
    [_answersInfoArray replaceObjectAtIndex:currentIndex withObject:assignInfo];
    
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
        if (self.answersInfoArray.count == 0) {
            [Progress progressShowcontent:@"没有作业" currView:self.view];
            return ;
        }

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
    [_finishedRateBtn setTitle:[NSString stringWithFormat:@"%d/%tu",1,[_allAssignmentInfo[COURSE] count]] forState:UIControlStateNormal];
}

#pragma mark - get finished question num
- (NSInteger)getFinishedNumber {
    [self.view endEditing:YES];
    NSInteger num=0;
    for (NSDictionary *dic in _answersInfoArray) {
        if ([[NSString safeString:dic[STU_ANSWER_LAST]] length] >0) {
            if (![[NSString safeString:dic[STU_ANSWER_LAST]] isEqualToString:[NSString safeString:dic[ANSWER]]]) {
                num++;
            }
        }
    }
    return num;
}

- (NSArray *)getFinishedNumbersIndex {
    NSInteger index=0;
    NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in self.answersInfoArray) {
        if ([dic[STU_ANSWER_LAST] length] >0) {
            if (![[NSString safeString:dic[STU_ANSWER_LAST]] isEqualToString:[NSString safeString:dic[ANSWER]]]) {
                [indexArray addObject:[NSNumber numberWithInteger:index]];
            }
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
        [[NSNotificationCenter defaultCenter] removeObserver:self];

    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];

}

- (BOOL)navigationShouldPopOnBackButton {
    [self.view resignFirstResponder];
    if ([self getFinishedNumber] >0) {
        [self createAlertView];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self];

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
    imagePickerController.originPicture = self.originPictureBtn.selected;
//    imagePickerController.selectedAssetArray = self.attachmentsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
    
}

- (void)notificationSelectedImage:(NSNotification *)notice {

    if (notice.userInfo.count>0) {
        [self dealAttachmentImages:[NSArray safeArray:notice.userInfo[@"image"]]];
        [self uploadAttachmentData:nil];
    }
}

#pragma mark - JKImagePickerControllerDelegate

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source {
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source {
    
    [self getImageWithAsset:assets];
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)getImageWithAsset:(NSArray *)assets {
    NSMutableArray *currentImages = [NSMutableArray arrayWithCapacity:0];
    for (JKAssets *asset in assets) {
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                UIImage *imagePro = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.01)];
                [currentImages addObject:imagePro];
                if (currentImages.count == assets.count) {
                    [self dealAttachmentImages:currentImages];
                    [self uploadAttachmentData:nil];
                }
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
}


#pragma mark - upload homework attaments

- (void)uploadAttachmentData:(NSArray *)imageData {
    NSString *imageStr ;
    if (_allAssignmentInfo.count == 0) {
        [Progress progressShowcontent:@"此课程暂无作业" currView:self.view];
    }
    
    NSDictionary *assignInfo = [NSDictionary safeDictionary:_answersInfoArray[currentIndex]];
    NSArray *attachments = [NSArray safeArray:assignInfo[ATTAH_IMAGES]];
    
    
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
                imageStr = [NSString stringWithFormat:@"%@||%@",imageStr,[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
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
            [self setUploadedAttachs:[NSArray safeArray:responseObject[@"DataObject"]]];
        } else {
            [Progress progressShowcontent:@"作业附件上传失败" currView:self.view];
            [self dealAttachmentImages:nil];

        }

    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        [self dealAttachmentImages:nil];
    }];
}

- (void)setUploadedAttachs:(NSArray *)attachIdArr {

    NSMutableDictionary *assignInfo = [NSMutableDictionary dictionaryWithDictionary:_answersInfoArray[currentIndex]];
    NSMutableArray *attachments = [NSMutableArray arrayWithArray:[NSArray safeArray:assignInfo[ATTACHMENTS]]];
    NSArray *attImageArr = [NSArray safeArray:assignInfo[ATTAH_IMAGES]];
    
    NSInteger index = 0;
    for (NSString *attId in attachIdArr) {
        [attachments addObject:@{ATTACHMENT_IMAGE: attImageArr[index][ATTACHMENT_IMAGE],
                                ATTACHMENR_ID: attachIdArr[index]}];
        index++;
        
    }
    
    [assignInfo setValue:attachments forKey:ATTACHMENTS];
    [_answersInfoArray replaceObjectAtIndex:currentIndex withObject:assignInfo];
    [_attachmentsCollection reloadData];
    [self dealAttachmentImages:nil];

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
            [self deletedAttachmentImageURL:indexPath];
        } else {
            [Progress progressShowcontent:[NSString safeString:responseObject[@"Message"]] currView:self.view];
        }
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];

}

- (void)deletedAttachmentImageURL:(NSIndexPath *)indexPath {
    NSMutableDictionary *assignInfo = [NSMutableDictionary dictionaryWithDictionary:_answersInfoArray[currentIndex]];
    NSMutableArray *attachments = [NSMutableArray arrayWithArray:[NSArray safeArray:assignInfo[ATTACHMENTS]]];
    [attachments removeObjectAtIndex:indexPath.row];
    
    [assignInfo setValue:attachments forKey:ATTACHMENTS];
    [_answersInfoArray replaceObjectAtIndex:currentIndex withObject:assignInfo];
    [_attachmentsCollection reloadData];
    
}

- (IBAction)originPictureAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
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
