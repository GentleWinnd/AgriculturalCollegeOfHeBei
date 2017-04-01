//
//  ClassLogSheetViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/12.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ClassLogSheetViewController.h"
#import "ClassRecordTableViewCell.h"
#import "ClassRecordHeaderView.h"
#import "SignInfoTableViewCell.h"
#import "SetNavigationItem.h"
#import "CalenderView.h"


@interface ClassLogSheetViewController ()<UITableViewDataSource
, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *calenderView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *calenderViewHeight;
@property (strong, nonatomic) IBOutlet UITableView *signedInfoTab;


@end

static NSString *cellID = @"cellID";


@implementation ClassLogSheetViewController
#pragma mark - setNaiv

- (void)setNavigationBar {
    NSString *title;
    NSString *subTitle;
    if (self.userRole == UserRoleTeacher) {
        title = @"课程记录表";
        subTitle = @"";
    } else {
        title = @"课程记录表";
        subTitle = @"";
    }
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:title subTitle:subTitle];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    [self initData];
    [self initTableView];
    [self customCalenderView];
    
}

#pragma mark  - initData

- (void)initData {
    self.courseInfoArray = [NSMutableArray arrayWithObjects:@"数字图像处理技术",@"数字图像分析",@"数学分析",@"大学物理", nil];

}

#pragma mark - initTable

- (void)initTableView {
    
    NSString *nibName;
    if (self.userRole == UserRoleTeacher) {
        nibName = @"SignInfoTableViewCell";
    } else {
        nibName = @"ClassRecordTableViewCell";
    }
    [_signedInfoTab registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:cellID];
    _signedInfoTab.delegate = self;
    _signedInfoTab.dataSource = self;
    _signedInfoTab.rowHeight = UITableViewAutomaticDimension;
    _signedInfoTab.estimatedRowHeight = 36;
}

#pragma mark - addCalenderView

- (void)customCalenderView {
    _calenderViewHeight.constant = WIDTH6Scale(54)*7;
    CalenderView *calenderView = [[NSBundle mainBundle] loadNibNamed:@"CalenderView" owner:self options:nil].lastObject;
    calenderView.frame = CGRectMake(0, 0, WIDTH, CGRectGetHeight(_calenderView.frame));
    [_calenderView addSubview:calenderView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseInfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 23;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ClassRecordHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ClassRecordHeaderView" owner:nil options:nil].lastObject;
    headerView.userRole = self.userRole;
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (self.userRole == UserRoleTeacher) {
        SignInfoTableViewCell *signedcell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell = signedcell;

    } else {
        ClassRecordTableViewCell *classCell = [tableView dequeueReusableCellWithIdentifier:cellID];
       classCell.classLabel.text = self.courseInfoArray[indexPath.row];
        cell = classCell;
    }
   cell.userInteractionEnabled = NO;
    
    return cell;
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
