//
//  NoticeViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/13.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "NoticeFirstTableViewCell.h"
#import "ApprovalStateViewController.h"
#import "StuClassTestViewController.h"
#import "NoticeHeaderView.h"
#import "SetNavigationItem.h"
#import "SourseDataCache.h"
#import "UserData.h"


@interface NoticeViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *noticeTabel;
    NSMutableArray *allNoticeArray;
    BOOL isLast;

}
@end
static NSString *firstCellID = @"firstcellId";
static NSString *secondCellID = @"secondcellID";

@implementation NoticeViewController
#pragma mark - setNav

- (void)setNavigationBar {
    NSString *title;
    NSString *subTitle;
    if (self.userRole == UserRoleTeacher) {
        title = @"通知公告";
        subTitle = @"";
    } else {
        title = @"通知公告";
        subTitle = @"";
    }
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:title subTitle:subTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    
    [self initData];
    [self initTableView];

};

- (void)initData {
    isLast = NO;
    allNoticeArray = [NSMutableArray arrayWithCapacity:0];
    if (self.showUnreadNews) {
        [allNoticeArray addObjectsFromArray: [SourseDataCache getUnreadNotices]];
        [SourseDataCache changeNoticeState];
        self.refreshed();

    } else {
        [allNoticeArray addObjectsFromArray: [SourseDataCache getAllNotice]];

    }
   
}

/*
 Key = TemporaryTest;
 QuestionOptions = "A,B,C,D,E";
 QuestionType = "\U5355\U9009\U9898";
 */
/*
 Id = "e403965c-ff02-4cd5-90d9-23f7aa9dca68";
 Key = AskLeave;

 
 */

#pragma mark  - initableview

- (void)initTableView {
    noticeTabel = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    noticeTabel.delegate = self;
    noticeTabel.dataSource = self;
    noticeTabel.rowHeight = UITableViewAutomaticDimension;
    noticeTabel.estimatedRowHeight = 44.0;
    noticeTabel.backgroundColor = MainBackgroudColor_GrayAndWhite;
    noticeTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    [noticeTabel registerNib:[UINib nibWithNibName:@"NoticeFirstTableViewCell" bundle:nil] forCellReuseIdentifier:firstCellID];
    [noticeTabel registerNib:[UINib nibWithNibName:@"NoticeTableViewCell" bundle:nil] forCellReuseIdentifier:secondCellID];
    [self.view addSubview:noticeTabel];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return allNoticeArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 26;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NoticeHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"NoticeHeaderView" owner:nil options:nil].lastObject;
    headerView.backgroundColor = [UIColor clearColor];
    headerView.dateLabel.layer.cornerRadius = 3;
    headerView.dateLabel.text = [NSDictionary safeDictionary:allNoticeArray[section]][@"Date"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell;
//    if (indexPath.section == 0) {
//        cell = (NoticeFirstTableViewCell *)[tableView dequeueReusableCellWithIdentifier:firstCellID forIndexPath:indexPath];
//        if (cell == nil) {
//            cell = [[NSBundle mainBundle] loadNibNamed:@"NoticeFirstTableViewCell" owner:self options:nil].lastObject;
//        }
//        
//    } else {
      NoticeTableViewCell *cell = (NoticeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:secondCellID forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"NoticeTableViewCell" owner:self options:nil].lastObject;
        }
    NSDictionary *noticeInfo = [NSDictionary safeDictionary:allNoticeArray[indexPath.section]];
    cell.titleLabel.text = noticeInfo[@"extra"][@"TypeName"];
    cell.smallTitle.text = noticeInfo[@"body"][@"title"];
    cell.contentLabel.text = noticeInfo[@"body"][@"text"];

//    cell.userInteractionEnabled = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *noticeInfo = [NSDictionary safeDictionary:allNoticeArray[indexPath.section]];
    
    NSString *type = noticeInfo[@"extra"][@"Key"];
    if ([type isEqualToString:@"AskLeave"]) {//请假
        ApprovalStateViewController *leaveView = [[ApprovalStateViewController alloc] init];
        leaveView.approvalId = noticeInfo[@"extra"][@"Id"];
        leaveView.approvalState = [UserData getUser].userRole == UserRoleStudent?YES:NO;
        [self.navigationController pushViewController:leaveView animated:YES];

    } else if ([type isEqualToString:@"TemporaryTest"]) {//临时测验
        StuClassTestViewController *stuTest = [[StuClassTestViewController alloc] init];
        stuTest.testInfo = noticeInfo[@"extra"];
        [self.navigationController pushViewController:stuTest animated:YES];
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
