//
//  LogInViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/23.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "LogInViewController.h"
#import "NSString+Extension.h"
#import "AccessTokenManager.h"
#import "MBProgressManager.h"
#import "NSString+Date.h"
#import "TabbarManager.h"
#import "IMManager.h"
#import "Progress.h"
#import "UserData.h"
#import "User.h"

@interface LogInViewController ()
{
    MBProgressManager *progressManager;

}
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *userPWTextField;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    progressManager = [[MBProgressManager alloc] init];
    [self showPreviousUserInfo];
}

- (void)showPreviousUserInfo {
    self.userNameTextField.text = [UserData getUser].userName;
    self.userPWTextField.text = [UserData getUser].userPass;
    [UserData removeUserData];
}

- (IBAction)loginBtnAction:(UIButton *)sender {
    
    
    if ([NSString isBlankString:self.userNameTextField.text]) {
        [self alertMessage:@"请填写用户名"];
        
    } else if ([NSString isBlankString:self.userPWTextField.text]) {
        [self alertMessage:@"请填写密码"];
        
    } else {
        //[self loginAPI];
        [self.view resignFirstResponder];
        [self login];
    }
}

- (void)login {
    
    NSDictionary *parameter = @{@"UserName":self.userNameTextField.text,
                                @"Password":self.userPWTextField.text};
    
    progressManager.progressType = MBProgressTypeLittleChrysanthemum;
    progressManager.showView = self.view;
    [progressManager loadingWithTitleProgress:@"正在登录..."];
    
    [NetServiceAPI postLoginInfoWithParameters:parameter success:^(id responseObject) {

        if ([responseObject[@"State"] integerValue] !=1) {
            [Progress progressShowcontent:@"密码或账号错误，请重新输入"];
        } else {
            User *user = [[User alloc] init];
            user.accessToken = responseObject[@"AccessToken"];
            user.accessTokenDate = [NSString dateFromSSSDateString:responseObject[@"Expires"]];
            user.userName = self.userNameTextField.text;
            user.userPass = self.userPWTextField.text;
            
            NSDictionary *userInfo = [NSDictionary safeDictionary:responseObject[@"DataObject"][@"UserInfo"]];
            user.nickName = [NSString safeString:userInfo[@"FullName"]];
            user.avater = [NSString safeString:userInfo[@"Avatar"]];
            user.IMUserID = [NSString safeString:userInfo[@"Id"]];
            user.userID = [NSString safeString:userInfo[@"Id"]];

            if ([((NSArray *)responseObject[@"DataObject"][@"UserRoleKeys"]).lastObject isEqualToString:@"Teacher"]) {//teacher
                user.userRole = UserRoleTeacher;
            } else {
                user.userRole = UserRoleStudent;
                
            }

            [UserData storeUserData:user];
            
            [TabbarManager setSelectedIndex:0];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_USERROLE_CHANGED object:nil];

            [self loginIM];

        }
        [progressManager hiddenProgress];
    } failure:^(NSError *error) {
        
        [KTMErrorHint showNetError:error inView:self.view];
        NSLog(@"%@", error.description);
        [progressManager hiddenProgress];
    }];
}



#pragma mark - alert

- (void)alertMessage:(NSString *)message {
    
    [Progress progressShowcontent:message currView:self.view];
}

#pragma mark - loginIM

- (void)loginIM {
    if ([AccessTokenManager accessTokenIsValid]) {
        [IMManager tryLoginIMInViewController:self];
        
    } else {
        [AccessTokenManager refreshToken:^(bool getToken) {
            [IMManager tryLoginIMInViewController:self];
        } failure:^(NSError *error) {
            
        }];
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
