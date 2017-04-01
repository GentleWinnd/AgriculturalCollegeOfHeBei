//
//  InputViewLeaveModel.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/19.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "InputViewLeaveModel.h"
#import "StuLeavedViewController.h"

#if __has_include("SPContactListController.h")
#import "SPContactListController.h"
#define HAS_CONTACTLIST 1
#endif
#import "SPUtil.h"
#import "SPKitExample.h"

#if HAS_CONTACTLIST
@interface InputViewLeaveModel ()<SPContactListControllerDelegate>
#else
@interface InputViewLeaveModel ()
#endif

@end

@implementation InputViewLeaveModel

#pragma mark - properties

- (YWConversationViewController *)conversationViewController
{
    if ([self.inputViewRef.controllerRef isKindOfClass:[YWConversationViewController class]]) {
        return (YWConversationViewController *)self.inputViewRef.controllerRef;
    } else {
        return nil;
    }
}


- (void)sendContactCardWithPersonId:(NSString *)aPersonId
{
    if (!aPersonId) {
        return ;
    }
    
    NSDictionary *contentDictionary = @{
                                        kSPCustomizeMessageType:LEAVE_LABEL,
                                        @"personId": aPersonId
                                        };
    NSData *data = [NSJSONSerialization dataWithJSONObject:contentDictionary
                                                   options:0
                                                     error:NULL];
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    YWConversationViewController *conversationController = [self conversationViewController];
    __weak __typeof(conversationController) weakController = conversationController;
    
    /// 构建一个自定义消息
    YWMessageBodyCustomize *body = [[YWMessageBodyCustomize alloc] initWithMessageCustomizeContent:content summary:@"[请假]"];
    
    /// 发送该自定义消息
    [conversationController.conversation asyncSendMessageBody:body
                                                     progress:nil
                                                   completion:^(NSError *error, NSString *messageID) {
                                                       if (error.code != 0) {
                                                           [[SPUtil sharedInstance] showNotificationInViewController:weakController title:@"名片发送失败!" subtitle:nil type:SPMessageNotificationTypeError];
                                                       }
                                                   }];
}
#if HAS_CONTACTLIST
#pragma mark - SPContactListControllerDelegate
- (void)contactListController:(SPContactListController *)controller didSelectPersonIDs:(NSArray *)personIDs {
    if ([personIDs.firstObject isKindOfClass:[NSString class]]) {
        [self sendContactCardWithPersonId:personIDs.firstObject];
    }
}
#endif

#pragma mark - YWInputViewPluginProtocol

/**
 * 您需要实现以下方法
 */

// 插件图标
- (UIImage *)pluginIconImage
{
    return [UIImage imageNamed:@"leave_chat"];
}

// 插件名称
- (NSString *)pluginName
{
    return @"请假";
}

// 插件对应的view，会被加载到inputView上
- (UIView *)pluginContentView
{
    return nil;
}

// 插件被选中运行
- (void)pluginDidClicked
{
#if HAS_CONTACTLIST
    YWConversationViewController *conversationController = [self conversationViewController];
    StuLeavedViewController *LeaveView = [[StuLeavedViewController alloc] init];
    
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:LeaveView];
    
    [conversationController presentViewController:naviController
                                         animated:YES
                                       completion:NULL];
#else
    [self sendContactCardWithPersonId:@"jiakuipro003"];
#endif
}

- (YWInputViewPluginType)pluginType {
    return YWInputViewPluginTypeDefault;
}



@end
