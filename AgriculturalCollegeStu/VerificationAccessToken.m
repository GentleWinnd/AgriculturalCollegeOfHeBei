//
//  VerificationAccessToken.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/6.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "VerificationAccessToken.h"
#import "LogInViewController.h"
#import "UserData.h"
#import "User.h"

@implementation VerificationAccessToken


+ (BOOL)accessTokenIsValid {
    User *user = [UserData getUser];
    NSTimeInterval interval = [user.accessTokenDate timeIntervalSinceNow];
    if (interval > user.expiresIn) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)refreshToken:(void(^)(bool getToken))refresh
             failure:(void(^)(NSError *error))failure {
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:[UserData getRefreshToken], REFRESH_TOKEN, nil];
    
    @WeakObj(self);
    [NetServiceAPI postRefreshTokenWithParameters:parameters success:^(id responseObject) {
        int status = [[responseObject valueForKey:@"State"] intValue];
        
        if (status == 1) { // 获取token成功
            [selfWeak saveResponseObject:responseObject];
            if (refresh) {
                refresh(YES);
            }
            
        } else { // refresh token 过期
            if (refresh) {
                refresh(NO);
            }
            LogInViewController *logView = [[LogInViewController alloc] init];
            [[selfWeak getCurrentShowViewController] presentViewController:logView animated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
//        [KTMErrorHint showNetError:error inView:[weakSelf getCurrentVC].view];
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)saveResponseObject:(NSDictionary *)responseObject {
    User *user = [UserData getUser];
    user.accessToken = responseObject[@"AccessToken"];
    user.accessTokenDate = responseObject[@"Expires"];
    user.expiresIn = 7*60*60*24;
    [UserData storeUserData:user];
}

+ (UIViewController *)getCurrentShowViewController {//获取当前屏幕显示的viewcontroller
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
