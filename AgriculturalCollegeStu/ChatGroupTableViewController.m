//
//  SPTribeListViewController.m
//  WXOpenIMSampleDev
//
//  Created by shili.nzy on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//
#import "ChatGroupTableViewController.h"
#import "SPTribeListViewController.h"
#import "SPTribeInfoEditViewController.h"
#import <WXOpenIMSDKFMWK/YWTribeConversation.h>
#import "SPUtil.h"
#import "SPKitExample.h"
#import "ChatTribeTableViewCell.h"
#import "SPContactCell.h"
#import "NSString+Date.h"

@interface ChatGroupTableViewController ()
<UITableViewDataSource, UITableViewDelegate,
UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableDictionary *groupedTribes;
@property (nonatomic, strong) NSMutableArray *allTribeAray;

@end

@implementation ChatGroupTableViewController


- (void)customNavigationBar {
    UIButton *createTribeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createTribeBtn.frame = CGRectMake(0, 0, 60, 50);
    [createTribeBtn setTitle:@"创建" forState:UIControlStateNormal];
    [createTribeBtn setTitleColor:MainTextColor_DarkBlack forState:UIControlStateNormal];
    [createTribeBtn addTarget:self action:@selector(tribeCreationBarItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:createTribeBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
     self.title = !self.isClassTribe ?@"我的群组":@"课堂交流";
    self.allTribeAray = [NSMutableArray arrayWithCapacity:0];
    
//    [self customNavigationBar];
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatTribeTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"ContactCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(requestData) forControlEvents:UIControlEventValueChanged];
    if (_isClassTribe) {
        [self getOfflineCourseList];
    } else {
        [self getAllGroupList];

    }
}

/************get Class And Group DaySchedule List************/

- (void)getClassAndGroupDayScheduleList {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress: @"加载中..."];
    [NetServiceAPI getClassAndGroupDayScheduleListWithParameters:nil success:^(id responseObject) {
        if ( [responseObject[@"State"] integerValue]== 1) {
            [_allTribeAray  addObjectsFromArray:[NSArray safeArray:responseObject[@"OfflineCourses"]]];
            [self reloadData];
        } else {
        
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        [progress hiddenProgress];
    }];

}

- (void)getOfflineCourseList {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress: @"加载中..."];
    [NetServiceAPI getAllOfflineCourseWithParameters:nil success:^(id responseObject) {
        if ( [responseObject[@"State"] integerValue]== 1) {
            [_allTribeAray  addObjectsFromArray:[NSArray safeArray:responseObject[@"OfflineCourses"]]];
            [self reloadData];
        } else {
            
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        [progress hiddenProgress];
    }];
    
}


#pragma mark - get group list

- (void)getAllGroupList {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress: @"加载中..."];
    [NetServiceAPI getClassGroupSourseWithParameters:nil success:^(id responseObject) {
        if ( [responseObject[@"State"] integerValue]== 1) {
            [self.allTribeAray addObjectsFromArray:[NSArray safeArray:responseObject[@"Groups"]]];
            [self reloadData];

        } else {
            
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        [progress hiddenProgress];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reloadData];
    [self addTribeCallbackBlocks];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self removeTribeCallbackBlocks];
}

- (void)addTribeCallbackBlocks {
    __weak __typeof(self) weakSelf = self;
    [[self ywTribeService] addDidExpelFromTribeBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        NSNumber *tribeType = userInfo[YWTribeServiceKeyTribeType];
        [weakSelf deleteTribeFromTableViewWithTribeID:tribeID tribeType:[tribeType integerValue]];
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
    
    [[self ywTribeService] addMemberDidJoinBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        YWPerson *person = userInfo[YWTribeServiceKeyPerson];
        YWPerson *me = [[[weakSelf ywIMCore] getLoginService] currentLoginedUser];
        if ([person isEqualToPerson:me]) {
            [weakSelf insertTribeToTableViewWithTribeID:tribeID];
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
    
    
    [[self ywTribeService] addMemberDidExitBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        NSNumber *tribeType = userInfo[YWTribeServiceKeyTribeType];
        YWPerson *person = userInfo[YWTribeServiceKeyPerson];
        YWPerson *me = [[[weakSelf ywIMCore] getLoginService] currentLoginedUser];
        if ([person isEqualToPerson:me]) {
            [weakSelf deleteTribeFromTableViewWithTribeID:tribeID tribeType:[tribeType integerValue]];
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
    
    
    [[self ywTribeService] addTribeDidDisbandBlock:^(NSDictionary *userInfo) {
        NSString *tribeID = userInfo[YWTribeServiceKeyTribeId];
        NSNumber *tribeType = userInfo[YWTribeServiceKeyTribeType];
        [weakSelf deleteTribeFromTableViewWithTribeID:tribeID tribeType:[tribeType integerValue]];
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}

- (void)removeTribeCallbackBlocks {
    [[self ywTribeService] removeDidExpelFromTribeBlockForKey:self.description];
    [[self ywTribeService] removeMemberDidJoinBlockForKey:self.description];
    [[self ywTribeService] removeMemberDidExitBlockForKey:self.description];
    [[self ywTribeService] removeTribeDidDisbandBlockForKey:self.description];
}


- (void)reloadData {
    NSArray *tribes = [self.ywTribeService fetchAllTribes];
    [self configureDataWithTribes:tribes];
    [self.tableView reloadData];
}

- (void)requestData {
    if ([[[self ywIMCore] getLoginService] isCurrentLogined]) {
        __weak typeof(self) weakSelf = self;
        [self.ywTribeService requestAllTribesFromServer:^(NSArray *tribes, NSError *error) {
            if( error == nil ) {
                [weakSelf configureDataWithTribes:tribes];
                [weakSelf.tableView reloadData];
            } else {
                [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                    title:@"获取群列表失败"
                                                                 subtitle:nil
                                                                     type:SPMessageNotificationTypeError];
            }
            [weakSelf.refreshControl endRefreshing];
        }];
    }
}

- (void)configureDataWithTribes:(NSArray *)tribes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableArray *normalTribes = [NSMutableArray array];
    dictionary[[@(YWTribeTypeNormal) stringValue]] = normalTribes;
    NSMutableArray *multipleChatTribes = [NSMutableArray array];
    dictionary[[@(YWTribeTypeMultipleChat) stringValue]] = multipleChatTribes;
    
    for (NSDictionary *courseInfo in self.allTribeAray) {
        for (YWTribe *tribe in tribes) {
            if ([courseInfo[@"IMTribeId"] isEqualToString:tribe.tribeId]) {
                if (tribe.tribeType == YWTribeTypeNormal) {
                }
                else if (tribe.tribeType == YWTribeTypeMultipleChat) {
                    [multipleChatTribes addObject:tribe];
                }
            }
        }

    }
    self.groupedTribes = dictionary;
}

- (void)insertTribeToTableViewWithTribeID:(NSString *)tribeId {
    YWTribe *tribe = [[self ywTribeService] fetchTribe:tribeId];
    if (!tribe) {
        return;
    }
    
    NSInteger section = tribe.tribeType;
    NSMutableArray *tribes = self.groupedTribes[[@(section) stringValue]];
    if (!tribes) {
        return;
    }
    
    NSInteger row = [tribes indexOfObject:tribe];
    if (row != NSNotFound) {
        return;
    }
    
    [tribes addObject:tribe];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tribes.count - 1 inSection:section];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)deleteTribeFromTableViewWithTribeID:(NSString *)tribeId tribeType:(YWTribeType)tribeType {
    if (!tribeId) {
        return;
    }
    
    NSInteger section = tribeType;
    NSMutableArray *tribes = self.groupedTribes[[@(section) stringValue]];
    if (!tribes) {
        return;
    }
    
    NSInteger row = [tribes indexOfObjectPassingTest:^BOOL(YWTribe *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.tribeId isEqualToString:tribeId]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    if (row == NSNotFound) {
        return;
    }
    
    [tribes removeObjectAtIndex:row];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Actions
- (void)tribeCreationBarItemPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"创建群"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"普通群", @"多聊群", nil];
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [actionSheet showFromBarButtonItem:sender animated:YES];
    }
    else {
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        UIStoryboard *board = [UIStoryboard storyboardWithName: @"Tribe" bundle: nil];

        
        SPTribeInfoEditViewController *controller = [board instantiateViewControllerWithIdentifier:@"ContactCell"];
        if (buttonIndex == 0) {
            controller.mode = SPTribeInfoEditModeCreateNormal;
        }
        else if (buttonIndex == 1) {
            controller.mode = SPTribeInfoEditModeCreateMultipleChat;
        }
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedTribes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *groupedTribesKey = @(section).stringValue;
    NSArray *tribes = self.groupedTribes[groupedTribesKey];
    return tribes.count;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *groupedTribesKey = @(section).stringValue;
//    NSArray *tribes = self.groupedTribes[groupedTribesKey];
//    if (section == 0) {
//        return tribes.count ? @"普通群" : nil;
//    }
//    else if (section == 1) {
//        return tribes.count ? @"多聊群" : nil;
//    }
//    return nil;
//}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor colorWithWhite:242./255 alpha:1.0];
    header.textLabel.textColor = [UIColor colorWithWhite:155./255 alpha:1.0];
    header.textLabel.font = [UIFont systemFontOfSize:12.0];
    header.textLabel.shadowColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *groupedTribesKey = @(indexPath.section).stringValue;
    NSArray *tribes = self.groupedTribes[groupedTribesKey];
    
    ChatTribeTableViewCell *cell = nil;
    if( indexPath.row >= [tribes count] ) {
        NSAssert(0, @"数据出错了");
    }
    else {
        YWTribe *tribe = tribes[indexPath.row];
        YWTribeConversation *conversation = [YWTribeConversation fetchConversationByTribe:tribe createIfNotExist:YES baseContext:[self ywIMCore]];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"
                                               forIndexPath:indexPath];
        
        UIImage *avatar = [[SPUtil sharedInstance] avatarForTribe:tribe];
        
//        [cell configureWithAvatar:avatar
//                            title:tribe.tribeName
//                         subtitle:nil];
        NSString *massage;
        if (conversation.conversationUnreadMessagesCount.integerValue == 0) {
            massage = [NSString safeString:conversation.conversationLatestMessageContent];
        } else {
            massage = [NSString stringWithFormat:@"[%@] %@",conversation.conversationUnreadMessagesCount,conversation.conversationLatestMessageContent];;
        }
        cell.avatarImageView.image = avatar;
        cell.goupNameLabel.text  = tribe.tribeName;
        cell.dateLabel.text = [NSString stringFromCompleteDate:conversation.conversationLatestMessageTime];
        cell.massageLabel.text = massage;
    
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *groupedTribesKey = @(indexPath.section).stringValue;
    NSMutableArray *tribes = self.groupedTribes[groupedTribesKey];
    
    YWTribe *tribe = [tribes objectAtIndex:indexPath.row];
    
    
    [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithTribe:tribe fromNavigationController:self.navigationController];
}


#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}

- (id<IYWTribeService>)ywTribeService {
    return [[self ywIMCore] getTribeService];
}



@end
