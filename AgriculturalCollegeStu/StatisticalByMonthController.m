//
//  StatisticalByMonthController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/11.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "StatisticalByMonthController.h"
#import "StatisticalMonthInfoTableViewCell.h"


@interface StatisticalByMonthController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *StatisticalMonthTable;
@property (strong, nonatomic) NSArray *monthInfoArray;


@end

static NSString *cellId = @"monthInfoCell";
@implementation StatisticalByMonthController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"统计报表";
    [_StatisticalMonthTable registerNib:[UINib nibWithNibName:@"StatisticalMonthInfoTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    _StatisticalMonthTable.delegate = self;
    _StatisticalMonthTable.dataSource = self;
    [self getMonthStatisticalInfo];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    
    return self.monthInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *statisticalInfo = [NSDictionary safeDictionary:self.monthInfoArray[section]];
    
    return [NSArray safeArray:statisticalInfo[@"Detail"]].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *statisticalInfo = [NSDictionary safeDictionary:self.monthInfoArray[section]];

    StatisticalMonthHeaderView *header = [[StatisticalMonthHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    header.timeLabel.text = [NSString safeString:statisticalInfo[@"YearMonth"]];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *statisticalInfo = [NSDictionary safeDictionary:self.monthInfoArray[indexPath.section]];
    NSDictionary *info = [NSDictionary safeDictionary:[NSArray safeArray:statisticalInfo[@"Detail"]][indexPath.row]];
    
   /*
    AskQuestionCount = 0;
    CheckInCompleteStatusName = "\U672a\U7b7e\U5230";
    CheckInNumber = 0;
    HasAskLeave = 0;
    Id = "6f63b1a6-1cb1-42c7-b84e-b6f0825c5492";
    LessonDate = "2017-04-09";
    LessonTime = "2017-04-09 10:00~12:00";
    ShouldCheckInNumber = 2;

    */
    
    StatisticalMonthInfoTableViewCell *MCell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    MCell.hasAsked = [info[@"HasAskLeave"] boolValue];

    MCell.signLabel.text = [NSString safeString:info[@"CheckInCompleteStatusName"]];
    
    MCell.questionNum.text = [NSString safeString:info[@"AskQuestionCount"]];
    
    MCell.timeLabel.text = [NSString safeString:info[@"LessonDate"]];
    [MCell setShowState];
    return MCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


#pragma mark - 获取按月划分的统计数据
- (void)getMonthStatisticalInfo {
    if (self.studentID.length == 0 || self.statisticalID.length == 0) {
        [Progress progressShowcontent:@"此学生暂无数据" currView:self.view];
        return;
    }
    
    NSDictionary *parameter = @{@"Id":self.statisticalID,
                                @"StudentId":self.studentID};
    
    
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getOfflineCourseStatisticalDetailByMonthWithParameters:parameter success:^(id responseObject) {
        [progress hiddenProgress];
        if ([responseObject[@"State"] integerValue] == 1) {
            self.monthInfoArray = [NSArray arrayWithArray:[NSArray safeArray:responseObject[@"DataObject"]]];
            
            [_StatisticalMonthTable reloadData];
            
        } else {
            [Progress progressPlease:@"获取数据失败了" showView:self.view];
        }
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
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


@implementation StatisticalMonthHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, CGRectGetHeight(frame))];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        self.timeLabel.textColor = MaintextColor_MiddleBlack;
        self.backgroundColor = MainBackgroudColor_GrayAndWhite;
        
        [self addSubview:self.timeLabel];
        
        
    }
    
    return self;
}





@end

