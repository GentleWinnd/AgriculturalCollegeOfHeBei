//
//  ClassRoomViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/8.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ClassRoomViewController.h"
#import "MassageTableViewCell.h"
#import "SecondTableViewCell.h"
#import "ThirdTableViewCell.h"
#import "SigninViewController.h"
#import "StatisticalTabViewController.h"
#import "ApprovalViewController.h"
#import "NoticeViewController.h"
#import "ClassScheduleViewController.h"
#import "SourceLoadViewController.h"
#import "ChatGroupTableViewController.h"
#import "SPContactListController.h"
#import "ClassTestViewController.h"
#import "SponsorTestViewController.h"
#import "ViewTestViewController.h"
#import "TestGradeViewController.h"
#import "StuTestViewController.h"
#import "TeachingEvaluationViewController.h"
#import "StuLeavedViewController.h"
#import "SenconTableViewCell.h"
#import "StuTaskViewController.h"
#import "StuClassTestViewController.h"
#import "EvaluationInfoViewController.h"
#import "StuEvaluationViewController.h"
#import "SponsorViewController.h"

#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOpenIMSDKFMWK/YWServiceDef.h>
#import "SPKitExample.h"
#import "LogInViewController.h"

#import "IMManager.h"
#import "VerificationAccessToken.h"
#import "NSString+Attribute.h"
#import "SetNavigationItem.h"
#import "RecentCourseManager.h"
#import "SourseDataCache.h"
#import "DeviceDetailManager.h"
#import "UserData.h"
#import "NSString+Date.h"


@interface ClassRoomViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *classTable;
    NSArray *itemsIconArray;
    NSArray *itemsTitleAray;
    SetNavigationItem *setNav;
    UserRole userRole;

}
@end

static NSString  *firstCellID = @"firstCellId";
static NSString  *secondCellID = @"secondCellID";
static NSString  *thirdCellID = @"thirdCellID";

@implementation ClassRoomViewController

- (void)judgeUserLoginState {
    
    NSString *accessToken = [UserData getAccessToken];
    if (accessToken) {
        if ([VerificationAccessToken accessTokenIsValid]) {
            [IMManager tryLoginIMInViewController:self];
            
        } else {
            [VerificationAccessToken refreshToken:^(bool getToken) {
                if (getToken) {//获取token成功
                    [IMManager tryLoginIMInViewController:self];
                }
            } failure:nil ];
        }
    } else {
        LogInViewController *logView = [[LogInViewController alloc] init];
        
        [self presentViewController:logView animated:YES completion:nil];
    }
}

- (void)customNavigationBar {
    setNav = [[SetNavigationItem alloc] init];
    __block SetNavigationItem *weakSetNav = setNav;
    __block ClassRoomViewController *weakSel = self;
    __block UITableView *weakTab = classTable;
    
    if (userRole == UserRoleTeacher) {
         [weakSetNav setNavTitle:weakSel withTitle:@"首页" subTitle:@""];
    } else {
        [weakSetNav setNavTitle:weakSel withTitle:@"首页" subTitle:@""];
    }
    [self haveNewMessage];
    setNav.leftClick = ^(){
    [weakSel alertClickAction];
    };
}

#pragma mark - 提醒消息事件

- (void)alertClickAction {
    
    NoticeViewController *noticeView = [[NoticeViewController alloc] init];
    noticeView.userRole = userRole;
    noticeView.showUnreadNews = YES;
    noticeView.refreshed = ^(){
        [self haveNewMessage];
    };
    [self pushViewController:noticeView animated:YES hiddenTabbar:YES];
}

#pragma mark - user login suceess

- (void)refreshedUserRole {
    userRole = [UserData getUser].userRole;
    [self getClassDaySchedule];
    [self customNavigationBar];
    [self initData];

    [classTable reloadData];
}

#pragma mark - observer userrole chaneged

- (void)observerUserRoleChanged {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshedUserRole) name:NOTICE_USERROLE_CHANGED object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self observerUserRoleChanged];
    [self addOberverForIMLogState];
    [self observeNewNotice];
    [self judgeUserLoginState];
    
    [self initTableView];
    [self refreshedUserRole];

}

#pragma mark - 初始化数据

- (void)initData {
    userRole = [UserData getUser].userRole;
    if (userRole == UserRoleStudent) {
        itemsIconArray = @[@"signed",@"leave",@"sourseload",@"task",@"classchat",@"test",@"minegroupo",@"statisticaltab",@"evaluation",@"notice"];
        itemsTitleAray = @[@"签到",@"请假审批",@"资源下载",@"作业",@"课堂交流",@"测验",@"我的群组",@"统计报表",@"教学评价",@"通知公告"];

    } else {
        itemsIconArray = @[@"signed",@"leave",@"sourseload",@"task",@"classchat",@"test",@"postQuestion@2x",@"minegroupo",@"statisticaltab",@"evaluation",@"notice"];
        itemsTitleAray = @[@"签到",@"请假审批",@"资源下载",@"作业",@"课堂交流",@"测验",@"发起提问",@"我的群组",@"统计报表",@"教学评价",@"通知公告"];

    }
   
    
    [self getToolsInfo];
    [self postCrashLog];
    [self getClassDaySchedule];
}


#pragma mark - get recent course 

- (void)getRecentCourseInfoShowOnLabel:(UILabel *)label {
    
    @WeakObj(label);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [RecentCourseManager getRecentCourseInView:nil success:^(NSDictionary *coursesInfo) {
            /*
             "StartDate": "2017-01-06T10:00:00",
             "EndDate": "2017-01-06T12:00:00",
             */
            NSString *startD = [NSString  stringFromTDateString:[NSString safeString:coursesInfo[@"StartDate"]]];
            NSString *endD = [NSString stringFromTDateString:[NSString safeString:coursesInfo[@"EndDate"]]];
            
            NSString *timeStr = [NSString stringWithFormat:@"%@ %@~%@",[NSString stringMDFromTDateString:startD],[NSString stringHMFromTDateString:startD],[NSString stringHMFromTDateString:endD]];
            labelWeak.text = [NSString stringWithFormat:@"%@ %@",timeStr,coursesInfo[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME]];

        } failure:^(NSString *failMessage) {
             labelWeak.text = @"获取最近的课程失败了😭";
        }];
       
    });
}

#pragma mark - get class day schedule

- (void)getClassDaySchedule {

    [NetServiceAPI getClassDayScheduleWithParameters:nil success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            SenconTableViewCell *cell = [classTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            cell.dayScheduleArray = [NSArray safeArray:responseObject[@"DataObject"]];
            [cell.collectionView reloadData];
        } else {
        
        }
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}

#pragma mark - 初始化tableView

- (void)initTableView {
    CGRect frame = self.view.frame;
    frame.size.height = self.view.frame.size.height;
    classTable = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    classTable.delegate = self;
    classTable.dataSource = self;
    classTable.estimatedRowHeight = 44.0;
    classTable.rowHeight = UITableViewAutomaticDimension;
    classTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    classTable.allowsSelection = NO;
    classTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:classTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (userRole == UserRoleStudent) {
//        return 2;
//    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0;
    switch (indexPath.section) {
        case 0:
            rowHeight = 36;
            break;
        case 1:
            //rowHeight = userRole == UserRoleStudent? WIDTH*3/4+23: 120;
            rowHeight = 120;
            break;
        case 2:
            rowHeight = WIDTH*3/4+23;
            break;

        default:
            break;
    }
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 56;
    }
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            cell = [self tableView:tableView massageCellForAtIndexPath:indexPath];
            break;
        case 1:
//            if (userRole == UserRoleStudent) {
//                cell = [self tableView:tableView thirdCellForAtIndexPath:indexPath];
//            } else {
                cell = [self tableView:tableView secondCellForAtIndexPath:indexPath];
//            }
            break;
        case 2:
            cell = [self tableView:tableView thirdCellForAtIndexPath:indexPath];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 加载第一个cell

- (MassageTableViewCell *)tableView:(UITableView *)tablebView massageCellForAtIndexPath:(NSIndexPath *)indexPath {
    MassageTableViewCell *cell  = [tablebView dequeueReusableCellWithIdentifier:firstCellID];

    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MassageTableViewCell" owner:self options:nil].lastObject;
    }
    [self getRecentCourseInfoShowOnLabel:cell.massageLabel];
    @WeakObj(cell);
    cell.classSchedule = ^(UIButton *clickBtn) {
        ClassScheduleViewController *classView = [[ClassScheduleViewController alloc] init];
        classView.theSelectedClass = ^(NSDictionary *courseDic) {
            if (courseDic != nil) {
                cellWeak.massageLabel.text = [NSString stringWithFormat:@"%@",courseDic[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME]];
                NSString *startD = [NSString  stringFromTDateString:[NSString safeString:courseDic[@"StartDate"]]];
                NSString *endD = [NSString stringFromTDateString:[NSString safeString:courseDic[@"EndDate"]]];
                
                NSString *timeStr = [NSString stringWithFormat:@"%@ %@~%@",[NSString stringMDFromTDateString:startD],[NSString stringHMFromTDateString:startD],[NSString stringHMFromTDateString:endD]];
               cellWeak.massageLabel.text = [NSString stringWithFormat:@"%@ %@",timeStr,courseDic[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME]];

                [SourseDataCache saveRecentCourseInfo:courseDic];
                
            }
            
        };
        
        [self pushViewController:classView animated:YES hiddenTabbar:YES];
    };
    
    return cell;
}

#pragma mark - 加载第二个cell

- (SenconTableViewCell *)tableView:(UITableView *)tablebView secondCellForAtIndexPath:(NSIndexPath *)indexPath {
    SenconTableViewCell *cell  = [tablebView dequeueReusableCellWithIdentifier:secondCellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SenconTableViewCell" owner:self options:nil].lastObject;
    }
    return cell;
}

#pragma mark - 加载第三个cell

- (ThirdTableViewCell *)tableView:(UITableView *)tablebView thirdCellForAtIndexPath:(NSIndexPath *)indexPath {
    ThirdTableViewCell *cell  = [tablebView dequeueReusableCellWithIdentifier:thirdCellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ThirdTableViewCell" owner:self options:nil].lastObject;
    }
    cell.itemsIconArray = itemsIconArray;
    cell.itemsTitleArray = itemsTitleAray;
    cell.itemSelectedIndex = ^(NSIndexPath *indexPath) {
       UIViewController *view = [self gotoTheSelectedItemViewAtIndexPath:indexPath];
        if (view) {
            [self pushViewController:view animated:YES hiddenTabbar:YES];
        }

    };
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:self.view.bounds];
    if (section == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
        imageView.image = [UIImage imageNamed:@"school_picture"];
        headerView = imageView;
    } else {
        headerView.backgroundColor = MainLineColor_LightGray;
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:self.view.bounds];
    footerView.backgroundColor = MainLineColor_LightGray;
    
    return footerView;
}

#pragma mark - 转到选中的itemView

- (UIViewController *)gotoTheSelectedItemViewAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *view;
    switch (indexPath.row) {
        case 0:{
            SigninViewController *signView = [[SigninViewController alloc] init];
            signView.userRole = userRole;
            view = signView;
        }//签到
            break;
        case 1:{
            if (userRole == UserRoleTeacher) {
                ApprovalViewController *approvalView = [[ApprovalViewController alloc] init];
                view = approvalView;
            } else {
                StuLeavedViewController *stuLeavedView = [[StuLeavedViewController alloc] init];
                view = stuLeavedView;
            }
           
        }//请假审批
            break;
        case 2:{
            SourceLoadViewController *sourceView = [[SourceLoadViewController alloc] init];
            sourceView.userRole = userRole;
            view = sourceView;
            
        }//资源下载
            break;
        case 3:{
            if (userRole == UserRoleTeacher) {
                ViewTestViewController *taskView = [[ViewTestViewController alloc] init];
                taskView.assignmentType = ClassAssignmentTypeHomeTask;
                view = taskView;

            } else {
                StuTaskViewController *stuTaskView = [[StuTaskViewController alloc] init];
                stuTaskView.userRole = userRole;
                view = stuTaskView;
            }
        }//作业
            break;
        case 4:{
            /*
             tribeID: 1580121323, tribeName: 一班, notice: , type: 0,memberCount: 0
             [[self ywTribeService] requestTribeFromServer:@"tribeID" completion:^(YWTribe *tribe, NSError *error) {
             
             }];

             */
            
//            [SPKitExample sharedInstance].isMain = YES;
//            YWTribe *tribe = [[self ywTribeService] fetchAllTribes].lastObject;
//            [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithTribe:tribe fromNavigationController:self.navigationController];
//            [TabbarManager setTabBarHidden:YES];
            ChatGroupTableViewController *chatView = [[ChatGroupTableViewController alloc] init];
            chatView.userRole = userRole;
            chatView.isClassTribe = YES;
            view = chatView;
            
        }//课堂交流
            break;
        case 5:{
            if (userRole == UserRoleTeacher) {
                ClassTestViewController *testView = [[ClassTestViewController alloc] init];
                view = testView;

            } else {
                StuTestViewController *stuTestView = [[StuTestViewController alloc] init];
                view = stuTestView;
            }
            
        }//测验
            break;
        case 6:{
            
            if (userRole == UserRoleStudent) {
                ChatGroupTableViewController *chatView = [[ChatGroupTableViewController alloc] init];
                chatView.userRole = userRole;
                chatView.isClassTribe = NO;
                view = chatView;

            } else {//发起提问
                SponsorViewController *sponsorView = [[SponsorViewController alloc] init];
                view = sponsorView;
            }
            
        }//我的群组
            break;
        case 7:{
            if (userRole == UserRoleStudent) {
                StatisticalTabViewController *statisticalView = [[StatisticalTabViewController alloc] init];
                statisticalView.userRole = userRole;
                view = statisticalView;
            } else {
                ChatGroupTableViewController *chatView = [[ChatGroupTableViewController alloc] init];
                chatView.userRole = userRole;
                chatView.isClassTribe = NO;
                view = chatView;

            }
           
            
        }//统计报表
            break;
        case 8:{
//            TeachingEvaluationViewController *teachingView = [[TeachingEvaluationViewController alloc] init];
//            teachingView.userRole = userRole;
//            view = teachingView;
            
            if (userRole == UserRoleTeacher) {
                StatisticalTabViewController *statisticalView = [[StatisticalTabViewController alloc] init];
                statisticalView.userRole = userRole;
                view = statisticalView;
                
            } else {
                StuEvaluationViewController *stuView = [[StuEvaluationViewController alloc] init];
                view = stuView;
            }
            
        }//教学评价
            break;
        case 9:{
            if (userRole == UserRoleStudent) {
                NoticeViewController *noticeView = [[NoticeViewController alloc] init];
                noticeView.userRole = userRole;
                view = noticeView;
            } else {
                EvaluationInfoViewController *evaluationView = [[EvaluationInfoViewController alloc] init];
                view = evaluationView;

            }
           
        }//通知公告
            break;
        case 10:{
            if (userRole == UserRoleStudent) {
                
            } else {
                NoticeViewController *noticeView = [[NoticeViewController alloc] init];
                noticeView.userRole = userRole;
                view = noticeView;
            }
            
        }
            break;
        case 11:{
            
            
        }
            break;

            
        default:
            break;
    }
    return view;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TabbarManager setTabBarHidden:NO];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark - push viewcontroller

- (void)pushViewController:(UIViewController *)VC animated:(BOOL)animated hiddenTabbar:(BOOL)hidden {
    [self.navigationController pushViewController:VC animated:YES];
    [TabbarManager setTabBarHidden:hidden];
}



/***************get tool info***************/

- (void)getToolsInfo {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NetServiceAPI getFeedBackMailWithParameters:nil success:^(id responseObject) {
            if ([responseObject[@"State"] integerValue] == 1) {
                [SourseDataCache saveAppToolsInfo:responseObject[@"DataObject"]];
            }
        } failure:^(NSError *error) {
            
        }];
    });
   
}

#pragma mark - post crach log

- (void)postCrashLog {
    
   NSString *crashLog = [SourseDataCache getAPPCrashLogInfo];
    if (crashLog.length >0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *jsonStr = [NSDictionary convertToJSONData:@{@"DeviceName":[DeviceDetailManager getSystemDeviceName],
                                                                  @"DeviceSystem":[DeviceDetailManager getSystemVersion],
                                                                  @"DevicePaltForm":[DeviceDetailManager getDevicePlatForm]}];
            [NetServiceAPI postLogErrorWithParameters:@{@"Content":crashLog,
                                                        @"JsonExpandData":jsonStr,
                                                        @"Origin":@"Ios_API"} success:^(id responseObject) {
                if ([responseObject[@"State"]  integerValue] == 1) {
                    [SourseDataCache removeCrashLog];
                } else {
                    
                }
            } failure:^(NSError *error) {
                
            }];
        });
 
    }
}
/******************logout IM and app log state********************/
#pragma mark - observer IM log state

- (void)addOberverForIMLogState {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutIMAndApp) name:IM_CONECTIONSTATE_FORCE_LOGOUT object:nil];

}

- (void)logoutIMAndApp {
    [Progress progressShowcontent:@"您的账号已在别的设备登录，请重新登录！"];
    LogInViewController *logView = [[LogInViewController alloc] init];
    
    [self presentViewController:logView animated:YES completion:nil];

}

/***************************current seleceted course*****************************/


/***************************have new message*****************************/

#pragma mark - have new message

- (void)observeNewNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveNewMessage) name:NOTICE_NEW_MESSAGE object:nil];

}

- (void)haveNewMessage {
    NSArray *unread = [SourseDataCache getUnreadNotices];
    [setNav setNavLeftItem:self withItemTitle:[NSString stringWithFormat:@"%tu",unread.count] image:[UIImage imageNamed:@"alert"]];
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
