//
//  TestResultViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "TestResultViewController.h"
#import "TestResultTableViewCell.h"
#import "SetNavigationItem.h"
#import "RecentCourseManager.h"

@interface TestResultViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *TestResultInfoTab;

@end
static NSString *cellID = @"testCellID";
@implementation TestResultViewController

- (void)setNavigationBar {
    NSString *title;
    NSString *subTitle;
    if (self.userRole == UserRoleTeacher) {
        title = @"对错率";
        subTitle = @"";
    } else {
        title = @"对错率";
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
}

#pragma mark initData 

- (void)initData {
//    self.courseArray = [NSMutableArray arrayWithObjects:@"1.图像虚化函数",@"2.图像高斯模糊",@"4.图像数字合成",@"5.线性代数",@"6.高等数学",@"7.数学分析", nil];
    
    [self getTestResultRate];
}

#pragma mark - get  class test rightwrong rate
/*
 "DataObject": [
 {
 "Id": "86119095-0d6c-4abf-b160-b0332a7e38b1",
 "Content": "细胞壁的主要作用是",
 "RightNum": 1,
 "ShouldNumber": 10
 },
 */
- (void)getTestResultRate {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    if (self.courseId == nil) {
        return;
    }
    //@"23c6434e-1dac-44f0-868e-de938be3100a"
    [NetServiceAPI getTheExerciseStateRightWrongRateWithParameters:@{@"ActivityId":self.courseId} success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            self.courseArray = [NSArray safeArray:responseObject[@"DataObject"]];
            [_TestResultInfoTab reloadData];
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];

}

#pragma mark - initTableView

- (void)initTableView {
    
    _TestResultInfoTab.delegate = self;
    _TestResultInfoTab.dataSource = self;
    _TestResultInfoTab.estimatedRowHeight = 44.0;
    _TestResultInfoTab.rowHeight = UITableViewAutomaticDimension;
    [_TestResultInfoTab registerNib:[UINib nibWithNibName:@"TestResultTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *rateInfo = [NSDictionary safeDictionary:self.courseArray[indexPath.row]];
    cell.quenstionName.text = rateInfo[@"Content"];
    cell.proporteLabel.text = [NSString stringWithFormat:@"%@/%@",rateInfo[@"RightNum"],rateInfo[@"ShouldNumber"]];
    cell.progressView.progress = [rateInfo[@"RightNum"] floatValue]/[rateInfo[@"ShouldNumber"] floatValue];
    
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
