//
//  ApprovalStateViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/13.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ApprovalStateViewController.h"
#import "ApprovalStateTableViewCell.h"
#import "SetNavigationItem.h"
#import "UIImageView+WebCache.h"
#import "UserData.h"

@interface ApprovalStateViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *approvalStatetab;

@property (strong, nonatomic) IBOutlet UIImageView *headPortrait;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *state;
@property (strong, nonatomic) IBOutlet UILabel *cource;
@property (strong, nonatomic) IBOutlet UILabel *approvalReson;

@property (strong, nonatomic) IBOutlet UIButton *agreeBtn;
@property (strong, nonatomic) IBOutlet UIButton *rejectBtn;
@property (strong, nonatomic) IBOutlet UIView *subView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *approvaltabBottom;


@property (strong, nonatomic) NSArray *statesArray;


@end

static NSString *approvalCell =  @"approvalCell";

@implementation ApprovalStateViewController

#pragma mark - setNav

- (void)setNavigayionBar {
    NSString *title;
    NSString *subTitle;
    if (self.userRole == UserRoleTeacher) {
        title = @"审批详情";
        subTitle = @"";
    } else {
        title = @"审批详情";
        subTitle = @"";
    }
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:title subTitle:subTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigayionBar];
    [self initData];
    [self setShowView];
    [self initTableView];

}

#pragma mark - initData

- (void)initData {

    [self getLeavedApprovalInfo];
}

#pragma mark - setShowView

- (void)setShowView {
    
    _headPortrait.layer.cornerRadius = 15;
    _headPortrait.layer.masksToBounds = YES;
    if (self.userRole == UserRoleStudent || self.approvalState) {
        _approvaltabBottom.constant = 0;
        _subView.hidden = YES;
        _agreeBtn.selected = YES;
        if (self.backMain) {
            [self modifyNavigationViewcontrollrs];
        }
    } else {
      
    }
}

#pragma mark - get leaved approval Info 
- (void)getLeavedApprovalInfo {
    if (self.approvalId == nil) {
        [Progress progressShowcontent:@"获取课程失败"];
        return;
    }
    NSDictionary *parameter = @{@"Id":self.approvalId};
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getLeavedInfoWithParameters:parameter success:^(id responseObject) {
        [progress hiddenProgress];
        if ([responseObject[@"State"] integerValue] == 0) {
            [Progress progressShowcontent:responseObject[@"Message"]];
        } else {
            self.statesArray = [NSArray arrayWithObject:[NSDictionary safeDictionary:responseObject[@"AskLeaveModel"]]];
            [self refreshedDisplayView];
            [self.approvalStatetab reloadData];
        }
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];

}

#pragma mark - agree approval

- (void)agreeApproval:(NSString *)approvalId {
    
    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"Id":approvalId};
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    
    [progress showProgress];
    [NetServiceAPI postAgreeApprovalInfoWithParameters:parameter success:^(id responseObject) {
        [progress hiddenProgress];
        if ([responseObject[@"State"] integerValue]!= 1) {
            [Progress progressShowcontent:responseObject[@"Massage"] currView:self.view];
        } else{
            [Progress progressShowcontent:@"提交成功" currView:self.view];
            [self performSelector:@selector(backUp) withObject:nil afterDelay:3];
        }
        
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}

- (void)backUp {
    [self back];

}

#pragma mark - turndown approval

- (void)turndwonApproval:(NSString *)approvalId {
    
    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"Id":approvalId,
                                @"TurndownReason":@"拒绝"};
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress showProgress];
    [NetServiceAPI postTurndownApprovalInfoWithParameters:parameter success:^(id responseObject) {
        [progress hiddenProgress];
        if ([responseObject[@"State"] integerValue]!= 1) {
            [Progress progressShowcontent:responseObject[@"Massage"] currView:self.view];
        } else{
            [Progress progressShowcontent:@"提交成功" currView:self.view];
            [self performSelector:@selector(backUp) withObject:nil afterDelay:3];
        }
        
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
}


#pragma mark - refreshed displayview

- (void)refreshedDisplayView {
    NSURL *url = [NSURL URLWithString:self.statesArray[0][@"Student"][@"Avatar"]];
    [self.headPortrait sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headPortrait"]];
    self.name.text = self.statesArray[0][@"Student"][@"FullName"];
    self.state.text = [self getStateInfoWithApproval:self.statesArray.lastObject];
//    self.className.text = self.statesArray[0][@"Activity"][@"Dependent"][@"DependentName"];
    self.cource.text = [NSString stringWithFormat:@"%@%@",self.statesArray[0][@"Activity"][@"Dependent"][@"DependentName"], self.statesArray[0][@"Activity"][@"LessonTime"]];
    self.approvalReson.text = self.statesArray[0][@"Reason"];
}

#pragma mark - get state

- (NSString *)getStateInfoWithApproval:(NSDictionary *)approval {
    NSString *stateStr;
    NSInteger OState = [approval[@"ApprovalStatus"] integerValue];
    if (OState == 0) {
        stateStr = @"审批中";
    } else if (OState == 1) {
        stateStr = @"已同意";
    } else {
        stateStr = @"已驳回";
    
    }
    return stateStr;
}


#pragma mark - 初始化tab

- (void)initTableView {
    _approvalStatetab.delegate = self;
    _approvalStatetab.dataSource = self;
    [_approvalStatetab registerNib:[UINib nibWithNibName:@"ApprovalStateTableViewCell" bundle:nil] forCellReuseIdentifier:approvalCell];
    _approvalStatetab.backgroundColor = MainBackgroudColor_GrayAndWhite;
    _approvalStatetab.rowHeight = UITableViewAutomaticDimension;
    _approvalStatetab.estimatedRowHeight = 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statesArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ApprovalStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:approvalCell forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.name.text = self.statesArray[indexPath.row][@"Student"][@"FullName"];
        cell.state.text = @"发起申请";
        cell.date.text = self.statesArray[indexPath.row][@"CreateDate"];

    } else {
        cell.name.text = self.statesArray[0][@"Student"][@"FullName"];
        cell.state.text = [self getStateInfoWithApproval:self.statesArray[0]];
        cell.date.text = self.statesArray[0][@"CreateDate"];

    }
    
    return cell;
}

- (void)modifyNavigationViewcontrollrs {
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    //把B从里面删除
    [array removeObjectAtIndex:1];
    //把删除后的控制器数组再次赋值
    [self.navigationController setViewControllers:[array copy] animated:YES];
}

- (IBAction)appravolResultAction:(UIButton *)sender {
//    sender.selected = YES;
    //[self modifyNavigationViewcontrollrs];
    if (sender.tag == 1) {//agree
        [self agreeApproval:self.approvalId];
    } else {//reject
        [self turndwonApproval:self.approvalId];
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
