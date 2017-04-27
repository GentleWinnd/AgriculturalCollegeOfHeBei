//
//  StatisticalStuViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/12.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "StatisticalStuViewController.h"
#import "StatisticalStuInfoTableViewCell.h"
#import "StatisticalByMonthController.h"
#import "UIImageView+WebCache.h"

@interface StatisticalStuViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *statisticalStuTable;
@property (strong, nonatomic) NSArray *stuInfoArray;
@end

static NSString *CellIDSTU = @"cellIDSTU";
@implementation StatisticalStuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"统计报表";
    [_statisticalStuTable registerNib:[UINib nibWithNibName:@"StatisticalStuInfoTableViewCell" bundle:nil] forCellReuseIdentifier:CellIDSTU];
    _statisticalStuTable.delegate = self;
    _statisticalStuTable.dataSource = self;
    
    [self getStudentsStatisticalInfo];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.stuInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *stuInfo = [NSDictionary safeDictionary:self.stuInfoArray[indexPath.row]];
    NSDictionary *stuDic = [NSDictionary safeDictionary:stuInfo[@"Student"]];
    
    StatisticalStuInfoTableViewCell *MCell = [tableView dequeueReusableCellWithIdentifier:CellIDSTU forIndexPath:indexPath];
    
    [MCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString safeString:stuDic[@"Avatar"]]] placeholderImage:[UIImage imageNamed:@""]];
    MCell.nameLabel.text = [NSString safeString:stuDic[@"FullName"]];
    
    MCell.signNum.text = [NSString safeString:stuInfo[@"CheckInCount"]];
    MCell.questionNum.text = [NSString safeString:stuInfo[@"AskQuestionCount"]];
    MCell.leavelNum.text = [NSString safeString:stuInfo[@"AskLeaveCount"]];
    
    return MCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *stuInfo = [NSDictionary safeDictionary:self.stuInfoArray[indexPath.row]];
    NSDictionary *stuDic = [NSDictionary safeDictionary:stuInfo[@"Student"]];
    StatisticalByMonthController *monthView = [[StatisticalByMonthController alloc] init];
    monthView.studentID = stuDic[@"Id"];
    monthView.statisticalID = self.statisticalID;
    [self.navigationController pushViewController:monthView animated:YES];

}


#pragma mark - get

- (void)getStudentsStatisticalInfo {
    
    if (self.statisticalID.length == 0) {
        [Progress progressShowcontent:@"此课程暂无数据" currView:self.view];
        return;
    }
    
    NSDictionary *parameter = @{@"Id":self.statisticalID};
    
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getOfflineCourseStatisticalDetailWithParameters:parameter success:^(id responseObject) {
        [progress hiddenProgress];
        if ([responseObject[@"State"] integerValue] == 1) {
            _stuInfoArray = [NSArray arrayWithArray:[NSArray safeArray:responseObject[@"DataObject"]]];
            
            [_statisticalStuTable reloadData];
            
        } else {
            [Progress progressPlease:@"获取数据失败了" showView:self.view];
        }
    } failure:^(NSError *error) {
        [progress hiddenProgress];
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
