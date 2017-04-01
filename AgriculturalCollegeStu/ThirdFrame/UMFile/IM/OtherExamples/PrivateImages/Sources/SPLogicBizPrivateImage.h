//
//  SPLogicBizPrivateImage.h
//  WXOpenIMSampleDev
//
//  Created by huanglei on 16/4/6.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WXOUIModule/YWUIFMWK.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

@interface SPLogicBizPrivateImage : NSObject

+ (instancetype)sharedInstance;

/// 异步调用多媒体云的图片上传接口，并发送阅图即焚消息
- (void)asyncSendPrivateImageData:(NSData *)aImageData inConversation:(YWP2PConversation *)aConversation;

/// 如果是阅图即焚消息，则处理并返回YES
- (BOOL)handleListenNewCustomMessage:(id<IYWMessage>)aMessage;

/// 如果是阅图即焚消息，则返回非空
- (YWBaseBubbleViewModel *)handleShowMessage:(id<IYWMessage>)aMessage;

/// 如果是阅图即焚消息，则返回非空
- (YWBaseBubbleChatView *)handleShowModel:(YWBaseBubbleViewModel *)aModel;

/// 如果是阅图即焚消息，则返回YES
- (BOOL)handlePrepare4UseBubbleView:(YWBaseBubbleChatView *)aView inConversationController:(YWConversationViewController *)aController;


#pragma mark -

/// 根据阅图即焚的本地消息，判断该消息对应的真实阅图即焚透传消息对方是否已读
- (BOOL)isRecvReadOfLocalMessage:(id<IYWMessage>)aLocalMessage;

- (NSString *)fetchOriginalMessageIdFromLocalMessage:(id<IYWMessage>)aLocalMessage;

/// 收到已读回执
#define kSPLogicBizPrivateImageNotificationRecvRead @"kSPLogicBizPrivateImageNotificationRecvRead"
/// 包含messageId
#define kSPLogicBizPrivateImageNotificationRecvReadUserInfoKeyMessageId @"kSPLogicBizPrivateImageNotificationRecvReadUserInfoKeyMessageId"

@end
