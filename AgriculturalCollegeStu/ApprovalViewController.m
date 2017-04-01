
//
//  ApprovalViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/12.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ApprovalViewController.h"
#import "ApprovalInfoTableViewCell.h"
#import "ApprovalStateViewController.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary+Extension.h"
#import "NSString+Date.h"
#import "UserData.h"

@interface ApprovalViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *waitApproal;
@property (strong, nonatomic) IBOutlet UIButton *approvaled;
@property (strong, nonatomic) IBOutlet UIView *sliderLine;
@property (strong, nonatomic) IBOutlet UITableView *firstTable;
@property (strong, nonatomic) IBOutlet UITableView *secondTab;
@property (strong, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sliderLineLeading;
@property (strong, nonatomic) NSMutableArray *waitArray;
@property (strong, nonatomic) NSMutableArray *agreeArray;


@end
static NSString *firstCellID = @"firstCellID";
static NSString *secondCellID = @"secondCellID";

@implementation ApprovalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"审批";
    
    [self initData];
    [self setShowView];
    [self initApprovalTableView];
}

- (void)initData {
//    self.waitArray = [NSMutableArray arrayWithArray:@[@{@"name":@"张欣",@"reason":@"病假"},@{@"name":@"张无极",@"reason":@"事假"},@{@"name":@"王石",@"reason":@"病假"},@{@"name":@"王健林",@"reason":@"病假"},@{@"name":@"张国庆",@"reason":@"事假"}]];
//    self.agreeArray = [NSMutableArray arrayWithArray:@[@{@"name":@"张无忌",@"reason":@"病假"},@{@"name":@"王思聪",@"reason":@"事假"},@{@"name":@"王器",@"reason":@"病假"},@{@"name":@"王胡",@"reason":@"病假"}]];
    self.waitArray = [NSMutableArray arrayWithCapacity:0];
    self.agreeArray = [NSMutableArray arrayWithCapacity:0];
    [self refresheTopView];
    [self getWaitApprovalList];
    [self getCompletedApproavlaList];
}

#pragma mark - get wait approval list

- (void)getWaitApprovalList {
    /*"AskLeaveModels": [
     {
     "CreateDate": "2016-12-16T12:37:25.997",
     "Student": {
     "Id": "717408c9-8bd7-4ccf-a184-d8c375ab2972",
     "UserName": "Student9",
     "FullName": "暂缺"
     },
     "ApprovalUserName": null,
     "ApprovalStatus": 0,
     "ApprovalDate": null,
     "Reason": "生病了，请假",
     "TurndownReason": null,
     "Activity": {
     "Id": "6996789b-7280-4c3b-a003-f5e0741a5033",
     "StartDate": "2016-12-16T16:00:00",
     "EndDate": "2016-12-16T18:00:00",
     "Dependent": {
     "DependentId": "96ea5d28-4f23-47b4-bf8f-7eec67156717",
     "DependentType": "Batch",
     "DependentName": "测试群组1"
     }
     }
     }
     ],
     "State": true,
     "Message": ""*/
    [NetServiceAPI getMyWaitApprovalsInfoListWithParameters:nil success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 0) {
            [Progress progressShowcontent:responseObject[@"Message"]];
        } else{
            [self.waitArray removeAllObjects];
            [self.waitArray addObjectsFromArray:responseObject[@"AskLeaveModels"]];
            [self.firstTable reloadData];
            [self refresheTopView];
        }
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];

}

#pragma mark - get completed approval list 

- (void)getCompletedApproavlaList {
    [NetServiceAPI getMyCompletedApprovalsListWithParameters:nil success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue]!= 1) {
            [Progress progressShowcontent:responseObject[@"Message"]];
        } else{
            [self.agreeArray removeAllObjects];
            [self.agreeArray addObjectsFromArray:responseObject[@"AskLeaveModels"]];
            [self.secondTab reloadData];
            [self refresheTopView];
        }

    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        
    }];
}

#pragma mark - agree approval 

- (void)agreeApproval:(NSString *)approvalId {
    
    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"Id":approvalId};
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"处理中..."];
    [NetServiceAPI postAgreeApprovalInfoWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue]!= 1) {
            [Progress progressShowcontent:responseObject[@"Massage"] currView:self.view];
        } else{
            [Progress progressShowcontent:@"提交成功" currView:self.view];
            [self getWaitApprovalList];
            [self getCompletedApproavlaList];
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}

#pragma mark - turndown approval

- (void)turndwonApproval:(NSString *)approvalId {

    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"Id":approvalId,
                                @"TurndownReason":@"拒绝"};
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"处理中..."];

    [NetServiceAPI postTurndownApprovalInfoWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue]!= 1) {
            [Progress progressShowcontent:responseObject[@"Massage"] currView:self.view];
        } else{
            [Progress progressShowcontent:@"提交成功" currView:self.view];
            [self getWaitApprovalList];
            [self getCompletedApproavlaList];
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
}

#pragma mark - refreshed top view

- (void)refresheTopView {
    [self.waitApproal setTitle:[NSString stringWithFormat:@"待我审批的（%tu）", self.waitArray.count] forState:UIControlStateNormal];
   [self.approvaled setTitle:[NSString stringWithFormat:@"我已审批的（%tu）", self.agreeArray.count] forState:UIControlStateNormal];
}

#pragma mark - set show view 

- (void)setShowView {
    _backScrollView.delegate = self;
    _approvaled.backgroundColor = [UIColor clearColor];
    _waitApproal.backgroundColor = [UIColor clearColor];
    _waitApproal.selected = YES;
}

#pragma mark - initTable

- (void)initApprovalTableView {
    _firstTable.delegate = self;
    _firstTable.dataSource = self;
    [_firstTable registerNib:[UINib nibWithNibName:@"ApprovalInfoTableViewCell" bundle:nil] forCellReuseIdentifier:firstCellID];
    _firstTable.rowHeight = UITableViewAutomaticDimension;
    _firstTable.estimatedRowHeight = 60;
    
    _secondTab.delegate = self;
    _secondTab.dataSource = self;
    [_secondTab registerNib:[UINib nibWithNibName:@"ApprovalInfoTableViewCell" bundle:nil] forCellReuseIdentifier:secondCellID];
    _secondTab.rowHeight = UITableViewAutomaticDimension;
    _secondTab.estimatedRowHeight = 60;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _firstTable) {
      return  self.waitArray.count;
    } else {
        return self.agreeArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ApprovalInfoTableViewCell *cell;
    if (tableView == _firstTable) {
        cell = [self firstTableView:tableView cellForRorAtIndexPath:indexPath];
    } else {
        cell = [self secondTaleView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (ApprovalInfoTableViewCell *)firstTableView:(UITableView *)tableView cellForRorAtIndexPath:(NSIndexPath *)indexPath {
    ApprovalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellID];
    NSDictionary *approvalInfo = self.waitArray[indexPath.row];
    
    [cell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:[NSDictionary safeDictionary:approvalInfo[@"Student"]][@"Avatar"]] placeholderImage:nil];
    cell.stuName.text = [NSDictionary safeDictionary:approvalInfo[@"Student"]][@"FullName"];
    cell.approvalReson.text = approvalInfo[@"Reason"];
    cell.dateLabel.text = [NSString stringFromDate:[NSString dateFromSSSDateString:[NSString safeString:approvalInfo[@"ApprovalDate"]]]];

    cell.approvalResult = ^(BOOL agreement){
        if (agreement) {
//            [self.waitArray removeObjectAtIndex:indexPath.row];
//            [self.agreeArray addObject:self.waitArray[indexPath.row]];
            
            [self agreeApproval:approvalInfo[@"Id"]];
        } else {
//            [self.waitArray removeObjectAtIndex:indexPath.row];
//            [self.agreeArray addObject:self.waitArray[indexPath.row]];
            [self turndwonApproval:approvalInfo[@"Id"]];
        }
    };
    return cell;
}

- (ApprovalInfoTableViewCell *)secondTaleView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApprovalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCellID];
    NSDictionary *approvalInfo = self.agreeArray[indexPath.row];
    [cell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:[NSDictionary safeDictionary:approvalInfo[@"Student"]][@"Avatar"]] placeholderImage:nil];
    cell.stuName.text = [NSDictionary safeDictionary:approvalInfo[@"Student"]][@"FullName"];
    cell.approveState.hidden = NO;
    BOOL approvalS = [approvalInfo[@"ApprovalStatus"] integerValue] == 1?YES:NO;
    cell.approveState.text = approvalS == YES ?@"审批通过":@"申请驳回";
    cell.approveState.textColor = approvalS?MainThemeColor_Blue:MaintextColor_LightBlack;
    cell.approveState.layer.cornerRadius = 2;
    cell.approveState.layer.borderColor = approvalS?MainThemeColor_Blue.CGColor:MaintextColor_LightBlack.CGColor;
    cell.approveState.layer.borderWidth = 1;
    cell.approvalReson.text = approvalInfo[@"Reason"];
    cell.dateLabel.text = [NSString stringFromDate:[NSString dateFromSSSDateString:[NSString safeString:approvalInfo[@"ApprovalDate"]]]];

    cell.agreeBtn.hidden = YES;
    cell.rejectBtn.hidden = YES;
    cell.approvalResult = ^(BOOL agreement){
       
        
    };

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ApprovalStateViewController *infoView = [[ApprovalStateViewController alloc] initWithNibName:@"ApprovalStateViewController" bundle:nil];
    if (tableView == _firstTable) {
        infoView.approvalInfo = [self.waitArray objectAtIndex:indexPath.row];
        infoView.approvalId = [self.waitArray  objectAtIndex:indexPath.row][@"Id"];
        infoView.approvalState = NO;
    } else {
        infoView.approvalInfo = [self.agreeArray objectAtIndex:indexPath.row];
        infoView.approvalId = [self.agreeArray  objectAtIndex:indexPath.row][@"Id"];
        infoView.approvalState = YES;
    }
    [self.navigationController pushViewController:infoView animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _backScrollView) {
        CGFloat currentPage = scrollView.contentOffset.x/WIDTH;
        [self setTopViewWithPage:currentPage];
       
    }
}

- (IBAction)btnClickAction:(UIButton *)sender {
    if (sender.tag == 1) {
    
        [_backScrollView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
    } else {
        [_backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    }

}

- (void)setTopViewWithPage:(NSInteger)page {
    CGFloat positionOne = _approvaled.frame.origin.x;
    CGFloat positionTwo = _waitApproal.frame.origin.x;
    
    if (page == 0) {
        _sliderLineLeading.constant = positionTwo;
        _approvaled.selected = NO;
        _waitApproal.selected = YES;
        
    } else {
        _sliderLineLeading.constant = positionOne;
        _waitApproal.selected = NO;
        _approvaled.selected = YES;
    }
    
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
