//
//  StuClassTestViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "StuClassTestViewController.h"
#import "AnswerOptionCollectionViewCell.h"
#import "CurrentClassView.h"
#import "SetNavigationItem.h"
#import "HintMassageView.h"
#import "TabbarManager.h"
#import "UserData.h"

@interface StuClassTestViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, HintViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *courseTypeLable;
@property (strong, nonatomic) IBOutlet UICollectionView *selecteAnswerCollectionView;

@property (strong, nonatomic) NSMutableArray *answerArray;
@property (strong, nonatomic) NSMutableArray *selectedAnswers;
@property (strong, nonatomic) SetNavigationItem *setNav;
@property (strong, nonatomic) HintMassageView *hintView;


@end

static NSString *cellID = @"CellID";

@implementation StuClassTestViewController

#pragma  mark - setnav

- (void)setNavigationBar {
    
    _setNav = [[SetNavigationItem alloc] init];
    NSString *title = @"测试";
    NSString *subTitle = @"";
    [_setNav setNavTitle:self withTitle:title subTitle:subTitle];
    [_setNav setNavRightItem:self withItemTitle:@"提交" textColor:MainTextColor_DarkBlack];
    @WeakObj(self);
    _setNav.rightClick = ^(){
        [selfWeak putupStudentTemporaryAnswer];
    };
    
}

#pragma mark - hintViewDelegate
- (void)hiddenSelfView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    [self initData];
    [self customCurrentClassView];
    [self creatCustomCollectioView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TabbarManager setTabBarHidden:YES];
    [self updateTestCourse];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TabbarManager setTabBarHidden:NO];
}

#pragma mark -  initData

- (void)initData {
    /*ActivityId = "0765e4e0-03d5-4f19-83be-751990065728";
     Id = "2337cc17-c1b4-48a3-b4a3-0de9802f52af";
     Key = TemporaryTest;
     QuestionOptions = "A,B,C,D,E";
     QuestionType = "\U5355\U9009\U9898";
*/
    _answerArray = [NSMutableArray arrayWithCapacity:0];
    _selectedAnswers = [NSMutableArray arrayWithCapacity:0];
}

- (void)updateTestCourse {
    CurrentClassView *courseView = (CurrentClassView *)[self.view viewWithTag:100];
    courseView.courceName.text = @"";
    self.courseTypeLable.text = self.testInfo[@"QuestionType"];
    NSString *answerstr = self.testInfo[@"QuestionOptions"];
    if ([self.testInfo[@"QuestionType"] isEqualToString:@"判断题"]) {
        [_answerArray addObjectsFromArray:@[@"对",@"错"]];
    } else {
        [_answerArray addObjectsFromArray:[answerstr  componentsSeparatedByString:@","]];

    }
    [self.selecteAnswerCollectionView reloadData];
}

#pragma mark - 定义classView

- (void)customCurrentClassView {
    CurrentClassView *classView = [CurrentClassView initViewLayout];
    CGRect frame = _topView.frame;
    frame.origin = CGPointMake(0, 0);
    classView.frame = frame;
    classView.tag = 100;
    [_topView addSubview:classView];
    classView.selectedClick = ^(UIButton *sender) {
        
    };
}

#pragma mark - 创建collectionView

- (void)creatCustomCollectioView {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.selecteAnswerCollectionView.collectionViewLayout = layOut;
    self.selecteAnswerCollectionView.delegate = self;
    self.selecteAnswerCollectionView.dataSource = self;
    self.selecteAnswerCollectionView.scrollEnabled = NO;
    layOut.minimumInteritemSpacing = 1;
    layOut.minimumLineSpacing = 1;
    self.selecteAnswerCollectionView.backgroundColor = [UIColor whiteColor];
    [self.selecteAnswerCollectionView registerNib:[UINib nibWithNibName:@"AnswerOptionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _answerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AnswerOptionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell.optionBtn setTitle:_answerArray[indexPath.row] forState:UIControlStateNormal];
    NSString *seletedItem = _answerArray[indexPath.row];
    
    cell.optionClick = ^(UIButton *sender) {
    
        NSInteger count = _selectedAnswers.count;
        if ([self.testInfo[@"QuestionType"] isEqualToString:@"判断题"]) {
            [_selectedAnswers insertObject:seletedItem atIndex:0];
            NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row==0?1:0 inSection:0];
            AnswerOptionCollectionViewCell *proCell = (AnswerOptionCollectionViewCell *)[_selecteAnswerCollectionView cellForItemAtIndexPath:index];
            proCell.optionBtn.selected = NO;
            
        } else {
            if (_selectedAnswers.count >0) {
                for (NSInteger i=0; i<count; i++) {
                    NSString *text = _selectedAnswers[i];
                    if ([text isEqualToString:seletedItem]) {
                        [_selectedAnswers removeObject:text];
                        break;
                    }
                    if (i == count-1) {
                        [_selectedAnswers addObject:seletedItem];
                    }
                }
            } else {
                [_selectedAnswers addObject:seletedItem];
            }
        }

    };
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

//通过协议方法设置单元格尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (WIDTH-10)/10;
    return CGSizeMake(width, width);
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

#pragma mark - putup student answer

- (void)putupStudentTemporaryAnswer {

    if (self.selectedAnswers.count == 0) {
        [Progress progressShowcontent:@"请选择答案"];
        return;
    }
    NSString *optionStr;
    for (NSString *item in self.selectedAnswers) {
        if (optionStr.length == 0) {
            optionStr = item;
        } else {
            optionStr = [NSString stringWithFormat:@"%@,%@",optionStr,item];
        }
    }
    
    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"TemporaryTestQuestionId":self.testInfo[@"Id"],
                                @"Answer":optionStr};
    [NetServiceAPI postStudentClassTestAnswerWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] !=1 ) {
            [Progress progressShowcontent:responseObject[@"Message"]];
        } else {
            _hintView = [HintMassageView initLayoutView];
            _hintView.delegate = self;
            [_hintView.hintLabel setTitle:@"提交成功" forState:UIControlStateNormal];
            [self.view addSubview:_hintView];
        }
        
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];

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
