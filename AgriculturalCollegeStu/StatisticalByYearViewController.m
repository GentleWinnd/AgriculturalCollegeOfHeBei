//
//  StatisticalByYearViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/11.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "StatisticalByYearViewController.h"
#import "StatisticalByYearTableViewCell.h"
#import "StatisticalByMonthController.h"
#import "StatisticalStuViewController.h"
#import "UserData.h"

@interface StatisticalByYearViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *yearInfoTable;
@property (strong, nonatomic) NSArray *statisticalInfoArray;

@end
static NSString *cellID = @"StatisticalCellID";

@implementation StatisticalByYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"统计报表";

    [_yearInfoTable registerNib:[UINib nibWithNibName:@"StatisticalByYearTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    _yearInfoTable.delegate = self;
    _yearInfoTable.dataSource = self;
    [self getYearStatisticalInfo];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.statisticalInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *statisticalInfo = [NSDictionary safeDictionary:self.statisticalInfoArray[section]];
    return [NSArray safeArray:statisticalInfo[@"Detail"]].count;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    StatisticalHeaderView *header = [[StatisticalHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    NSDictionary *statisticalInfo = [NSDictionary safeDictionary:self.statisticalInfoArray[section]];

    header.timeLabel.text = [NSString safeString:statisticalInfo[@"Year"]];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *statisticalInfo = [NSDictionary safeDictionary:self.statisticalInfoArray[indexPath.section]];
    NSArray *classArray = [NSArray safeArray:statisticalInfo[@"Detail"]];
    NSDictionary *classInfo = [NSDictionary safeDictionary:classArray[indexPath.row]];

    
    StatisticalByYearTableViewCell *YCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    YCell.classNameLabel.text = [NSString safeString:classInfo[@"Name"]];
    
    return YCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *statisticalInfo = [NSDictionary safeDictionary:self.statisticalInfoArray[indexPath.section]];
    NSArray *classArray = [NSArray safeArray:statisticalInfo[@"Detail"]];
    NSDictionary *classInfo = [NSDictionary safeDictionary:classArray[indexPath.row]];

    if (self.roler != UserRoleStudent) {
        
        StatisticalStuViewController *stuView = [[StatisticalStuViewController alloc] init];
        stuView.statisticalID = [NSString safeString:classInfo[@"Id"]];
        
        [self.navigationController pushViewController:stuView animated:YES];
        
    } else {
    
        StatisticalByMonthController *monthView = [[StatisticalByMonthController alloc] init];
        monthView.studentID = [NSString safeString:[UserData getUser].userID];
        monthView.statisticalID = [NSString safeString:classInfo[@"Id"]];
        [self.navigationController pushViewController:monthView animated:YES];
        
    }
    
}

#pragma mark - 获取按年划分的统计数据
- (void)getYearStatisticalInfo {

    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getOfflineCourseListGroupByYearWithParameters:nil success:^(id responseObject) {
        [progress hiddenProgress];

        if ([responseObject[@"State"] integerValue] == 1) {
            _statisticalInfoArray = [NSArray arrayWithArray:[NSArray safeArray:responseObject[@"DataObject"]]];
            [_yearInfoTable reloadData];
        } else {
            [Progress progressPlease:@"获取数据失败了" showView:self.view];
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


@implementation StatisticalHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, CGRectGetHeight(frame))];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        self.timeLabel.textColor = MainTextColor_DarkBlack;
        self.backgroundColor = MainBackgroudColor_GrayAndWhite;
        
        [self addSubview:self.timeLabel];
        
        
    }
    
    return self;
}





@end
