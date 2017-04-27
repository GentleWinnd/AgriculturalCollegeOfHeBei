//
//  StuTaskInfoViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "StuTaskInfoViewController.h"
#import "StuTaskTableViewCell.h"
#import "SetNavigationItem.h"
#import "HintMassageView.h"
#import "UIImageView+AFNetworking.h"
#import "RecentCourseManager.h"

@interface StuTaskInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *headPortrait;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UITableView *taskInfoTab;
@property (strong, nonatomic) SetNavigationItem *setNav;
@property (strong, nonatomic) NSString *ActivityId;
@property (strong, nonatomic) NSDictionary *allAssignmentInfo;

@end
static NSString *cellID = @"taskCellID";
@implementation StuTaskInfoViewController

#pragma  mark - setNav

- (void)setNavigationBar {
    _setNav = [[SetNavigationItem alloc] init];
    
    [_setNav setNavTitle:self withTitle:@"作业" subTitle:@""];
    @WeakObj(self);
    [_setNav setNavRightItem:self withItemTitle:@"提交" textColor:MainTextColor_DarkBlack];
    _setNav.rightClick = ^(){
       HintMassageView *hintView = [HintMassageView initLayoutView];
        [hintView.hintLabel setTitle:@"提交成功" forState:UIControlStateNormal];
        hintView.hiddenSelf = ^(){
            [selfWeak back];
        };
        [selfWeak.view addSubview:hintView];
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    [self initData];
    [self initTableView];
}

#pragma mark - initdata

- (void)initData {
    [RecentCourseManager getRecentCourseSuccess:^(NSDictionary *coursesInfo) {
        if (coursesInfo == nil) return ;
        self.ActivityId = coursesInfo[@"RecentestActivity"][@"Id"];
    } failure:^(NSString *failMessage) {
        
    }];
    [self  getSchollAssignment];
    [self showStuInfo];

}


#pragma  mark - inittableView

- (void)initTableView {
    
    _taskInfoTab.delegate = self;
    _taskInfoTab.dataSource = self;
    _taskInfoTab.estimatedRowHeight = 44.0;
    _taskInfoTab.rowHeight = UITableViewAutomaticDimension;
    [_taskInfoTab registerNib:[UINib nibWithNibName:@"StuTaskTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    
}

#pragma mark - get school assignment

- (void)getSchollAssignment {

    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"努力加载中..."];
    self.ActivityId = @"23c6434e-1dac-44f0-868e-de938be3100a";
    NSDictionary *parameter = @{@"ActivityId":self.ActivityId,
                                @"StudentId":self.studentId};
    [NetServiceAPI getHomeWorkDetailsByTeacherWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            _allAssignmentInfo = [NSDictionary safeDictionary:responseObject[@"HomeWorkDetailsModel"]];
            [self.taskInfoTab reloadData];
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}

- (void)showStuInfo {
    [self.headPortrait setImageWithURL:[NSURL URLWithString:[NSString safeString:self.stuInfo[@"Avatar"]]] placeholderImage:nil];
    self.name.text = self.stuInfo[@"FullName"];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allAssignmentInfo[@"Items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StuTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.questionName.text = self.allAssignmentInfo[@"Items"][indexPath.row][@"Description"];
    cell.answerLabel.text = [NSString safeString:self.allAssignmentInfo[@"Items"][indexPath.row][@"Answer"]];
    
    
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
