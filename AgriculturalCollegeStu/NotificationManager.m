//
//  NotificationManager.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/5.
//  Copyright © 2017年 YH. All rights reserved.
//
#define TEMPORARY_TEST @"TemporaryTest"
#define STU_ASK_LEAVE @"AskLeave"


#import "NotificationManager.h"
#import "StuClassTestViewController.h"
#import "ApprovalStateViewController.h"
#import "RDVTabBarController.h"
#import "AlertViewFrame.h"
#import "TabbarManager.h"
#import "SourseDataCache.h"
#import "NSString+Date.h"
#import "UserData.h"

static NotificationManager *pushNotice;

@interface NotificationManager()<AlertViewFrameDelegate>
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) UIViewController *selectedVC;


@end
@implementation NotificationManager

+ (instancetype)sharePushNotification {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (pushNotice == nil) {
            pushNotice = [[NotificationManager alloc] init];
        }
    });
    return pushNotice;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (pushNotice == nil) {
            pushNotice = [super allocWithZone:zone];
        }
    });
    return pushNotice;
}

- (instancetype)copy {
    return pushNotice;
}

- (instancetype)mutableCopy {
    return pushNotice;
}

#pragma mark - post notice

- (void)postPushNotification:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_NOTICE object:nil userInfo:userInfo];
    
}

#pragma mark -  add observer

- (void)addPushNoticeObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealPushNoticeInfo:) name:PUSH_NOTICE object:nil];

}

#pragma mark - dealwith motice info

- (void)dealPushNoticeInfo:(NSNotification *)notice {
    /* ActivityId = "0765e4e0-03d5-4f19-83be-751990065728";
     Id = "2ca57f73-b7f7-49fd-8085-70d9e478b8a1";
     Key = TemporaryTest;
     QuestionOptions = "A,B,C,D,E";
     QuestionType = "\U5355\U9009\U9898";
*/
    /*
     Id = "e403965c-ff02-4cd5-90d9-23f7aa9dca68";
     Key = AskLeave;

     */
    
    UIViewController *currentVC = [self getCurrentVC];
     _userInfo = notice.userInfo;
    NSString *key = _userInfo[@"extra"][@"Key"];
    if ([key isEqualToString:TEMPORARY_TEST] ) {//class temporrary test
        if ([currentVC isKindOfClass:[StuClassTestViewController class]]) {
            [self createAlertViewWithMessage:@"您有临时测验"];
        
        } else if([currentVC isKindOfClass:[RDVTabBarController class]]){
            [self createAlertViewWithMessage:@"您有临时测验"];
            [self pushTemporaryTestView];
        }
        
    } else if([key isEqualToString:STU_ASK_LEAVE]){//leave
        [self createAlertViewWithMessage:@"您有请假通知"];
        [self pushApprovalStateView];
    }

}

- (void)saveGetNotice:(BOOL)readed {
    NSMutableDictionary *MNotice = [NSMutableDictionary dictionaryWithDictionary:_userInfo];
    [MNotice setValue:[NSString stringFromCompleteDate:[NSDate date]] forKey:@"Date"];
    [SourseDataCache saveAppNoticeInfo:MNotice readed:readed];

}

#pragma mark - creat alertView

- (void)createAlertViewWithMessage:(NSString *)message {
    UIViewController *currentVC = [self getCurrentVC];
    
    AlertViewFrame *alertView = [[AlertViewFrame alloc] init];
    [alertView alertViewWithTitle:@"通知" message:message confirm:@"打开" cancle:@"忽略" showInView:currentVC];
    alertView.delegate = self;

}

- (void)alertViewActionConfirm:(BOOL)confrim {

    if (confrim) {
        if (_selectedVC) {
            RDVTabBarController *RDView = (RDVTabBarController*)[self getCurrentVC];
            UINavigationController *NView = (UINavigationController*)RDView.selectedViewController;
            [NView.visibleViewController.navigationController pushViewController:_selectedVC animated:YES];
            [TabbarManager setTabBarHidden:YES];
            [self saveGetNotice:YES];
            return;
        } else {
           // [self updateTemporaryView];
        
        }
    } else {
    
    
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_NEW_MESSAGE object:nil];
    [self saveGetNotice:NO];
}

#pragma mark - stuTestView

- (void)pushTemporaryTestView {
    StuClassTestViewController *stuTest = [[StuClassTestViewController alloc] init];
    stuTest.testInfo = _userInfo;
    _selectedVC = stuTest;
}

#pragma mark - update

- (void)updateTemporaryView {
    StuClassTestViewController *stuTest = (StuClassTestViewController *)[self getCurrentVC];
    stuTest.testInfo = _userInfo;
    [stuTest updateTestCourse];
}

#pragma mark - push approval view

- (void)pushApprovalStateView {
    ApprovalStateViewController *leaveView = [[ApprovalStateViewController alloc] init];
    leaveView.approvalId = _userInfo[@"extra"][@"Id"];
    leaveView.approvalState = [UserData getUser].userRole == UserRoleStudent?YES:NO;
    _selectedVC = leaveView;
}

- (UIViewController *)getCurrentVC {//获取当前屏幕显示的viewcontroller
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}




@end
