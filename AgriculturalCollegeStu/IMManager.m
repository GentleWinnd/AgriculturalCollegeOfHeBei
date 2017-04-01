//
//  IMManager.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/28.
//  Copyright © 2016年 YH. All rights reserved.
//


#import "IMManager.h"
#import "SPKitExample.h"
#import "UserData.h"
#import "SPUtil.h"


@implementation IMManager

#pragma mark - 登录即时通信

+ (void)tryLoginIMInViewController:(UIViewController *)viewController {
    [[SPKitExample sharedInstance] exampleGetFeedbackUnreadCount:YES inViewController:viewController];
    __weak typeof(self) weakSelf = self;
    
    //[[SPUtil sharedInstance] setWaitingIndicatorShown:YES withKey:self.description];
    
    //这里先进行应用的登录
    NSString *userID = [UserData getUser].IMUserID;
//    NSString *userPS = [NSString stringWithFormat:@"%@%@",userID,@"BaiChuanOpenIM"];
    NSString *userPS = @"111111";
    //应用登陆成功后，登录IMSDK
    [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:userID
                                                                           passWord:userPS
                                                                    preloginedBlock:^{
                                                                        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
                                                                        // [weakSelf _pushMainControllerAnimated:YES];
                                                                    } successBlock:^{
                                                                        
                                                                        //  到这里已经完成SDK接入并登录成功，你可以通过exampleMakeConversationListControllerWithSelectItemBlock获得会话列表
                                                                        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
                                                                        
                                                                        // [weakSelf _pushMainControllerAnimated:YES];
#if DEBUG
                                                                        // 自定义轨迹参数均为透传
                                                                        //                                                                        [YWExtensionServiceFromProtocol(IYWExtensionForCustomerService) updateExtraInfoWithExtraUI:@"透传内容" andExtraParam:@"透传内容"];
#endif
                                                                    } failedBlock:^(NSError *aError) {
                                                                        [[SPUtil sharedInstance] setWaitingIndicatorShown:NO withKey:weakSelf.description];
                                                                        
                                                                        if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
                                                                            
                                                                        }
                                                                        
                                                                    }];
}




@end
