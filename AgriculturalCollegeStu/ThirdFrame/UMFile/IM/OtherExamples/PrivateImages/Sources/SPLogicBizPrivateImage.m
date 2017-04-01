//
//  SPLogicBizPrivateImage.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 16/4/6.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import "SPLogicBizPrivateImage.h"

#import <ALBBMediaService/ALBBWantuService.h>

#import "SPKitExample.h"

#import <WXOUIModule/YWIndicator.h>

#import "SPViewModelPrivateImage.h"
#import "SPBubbleViewPrivateImage.h"

/// 这几个字段需要多端一致
/// 阅图即焚消息type
#define __ContentValueTypePrivateImage @"PrivateImage"
/// 阅图即焚消息中图片url
#define __ContentKeyPrivateImageUrl @"url"

/// 阅图即焚消息回执type
#define __ContentValueTypePrivateImageRecvRead @"PrivateImageRecvRead"
/// 阅图即焚消息回执中原消息messageId，值必须为字符串
#define __ContentKeyPrivateImageRecvReadMessageId   @"PrivateImageRecvReadMessageId"


/// 以下字段仅iOS端本地使用
/// 用于本地消息中保存发送者Id
#define __ContentKeyLocalSaveSenderLongId    @"LocalSaveSenderLongId"
/// 用于本地消息中保存原消息Id
#define __ContentKeyLocalSaveMessageId      @"LocalSaveMessageId"

@interface SPLogicBizPrivateImage ()

@property (nonatomic, copy) BOOL (^onPreviewImageLoadedBlock)(NSNotification *);

@end

@implementation SPLogicBizPrivateImage

#pragma mark - life

- (id)init
{
    self = [super init];
    
    if (self) {
        /// 初始化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationImageLoad:) name:YWImageBrowserHelperNotificationImageLoad object:nil];
    }
    
    return self;
}

#pragma mark - callback

- (void)onNotificationImageLoad:(NSNotification *)aNote
{
    BOOL handled = NO;
    if (self.onPreviewImageLoadedBlock) {
        handled = self.onPreviewImageLoadedBlock(aNote);
    }
    
    if (handled) {
        /// 处理过后就重置
        self.onPreviewImageLoadedBlock = NULL;
    }
}

#pragma mark - private

- (NSString *)_generateFileNameWithImageData:(NSData *)aImageData
{
    return [[[YWAPI sharedInstance] getGlobalUtilService4Security] md5OfData:aImageData];
}

/// 此函数中不做格式校验，调用前确保内容正确
- (void)_saveLocalFromMessage:(id<IYWMessage>)aMessage
{
    void (^theBlock)() = ^ {
        /// make new body
        YWMessageBodyCustomize *body = (YWMessageBodyCustomize *)[aMessage messageBody];
        NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:[body.content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        NSMutableDictionary *newContentDic = [[NSMutableDictionary alloc] initWithCapacity:10];
        [newContentDic addEntriesFromDictionary:contentDic];
        [newContentDic addEntriesFromDictionary:@{__ContentKeyLocalSaveSenderLongId:[aMessage messageFromPerson].personLongId, __ContentKeyLocalSaveMessageId:[aMessage messageId]}];
        NSString *newContentStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:newContentDic options:0 error:NULL] encoding:NSUTF8StringEncoding];
        
        YWMessageBodyCustomize *newBody = [[YWMessageBodyCustomize alloc] initWithMessageCustomizeContent:newContentStr summary:body.summary];
        
        /// fetch conversation
        YWP2PConversation *conversation = [YWP2PConversation fetchConversationByConversationId:[aMessage conversationId] creatIfNotExist:YES baseContext:[SPKitExample sharedInstance].ywIMKit.IMCore];
        
        /// save local
        NSDictionary *controlDic = @{kYWMsgCtrlKeyClientLocal:@{kYWMsgCtrlKeyClientLocalKeyOnlySave:@(YES)}};
        [conversation asyncSendMessageBody:newBody controlParameters:controlDic progress:NULL completion:NULL];
    };
    
    if ([NSThread isMainThread]) {
        theBlock();
    } else {
        dispatch_async(dispatch_get_main_queue(), theBlock);
    }
}

/// 异步发送某条阅图即焚消息的已读回执
- (void)_asyncSendRecvReadWithLocalMessage:(id<IYWMessage>)aLocalMessage
{
    /// 异步发送
    
    __weak typeof(self) weakSelf = self;
    
    YWMessageBodyCustomize *localBody = (YWMessageBodyCustomize *)[aLocalMessage messageBody];
    NSDictionary *localContentDic = [NSJSONSerialization JSONObjectWithData:[localBody.content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];

    
    if ([self isRecvReadForMessageId:localContentDic[__ContentKeyLocalSaveMessageId]]) {
        /// 已经发送过
        return;
    }
    
    NSDictionary *contentDic = @{kSPCustomizeMessageType:__ContentValueTypePrivateImageRecvRead, __ContentKeyPrivateImageRecvReadMessageId: localContentDic[__ContentKeyLocalSaveMessageId]};
    NSString *contentStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:contentDic options:0 error:NULL] encoding:NSUTF8StringEncoding];
    YWMessageBodyCustomize *body = [[YWMessageBodyCustomize alloc] initWithMessageCustomizeContent:contentStr summary:@"阅图即焚已读回执" isTransparent:YES];
    NSDictionary *controlDic = @{kYWMsgCtrlKeyPush: @{kYWMsgCtrlKeyPushKeyNeedPush:@(0)}};
    YWP2PConversation *conv = [YWP2PConversation fetchConversationByConversationId:[aLocalMessage conversationId] creatIfNotExist:YES baseContext:[SPKitExample sharedInstance].ywIMKit.IMCore];
    [conv asyncSendMessageBody:body controlParameters:controlDic progress:NULL completion:^(NSError *error, NSString *messageID) {
        if (error.code == 0) {
            [weakSelf markRecvReadForMessageId:localContentDic[__ContentKeyLocalSaveMessageId]];
        }
    }];
}

#define __DefaultKeyForMessageState [@"__DefaultKeyForMessageState" stringByAppendingString:[[[SPKitExample sharedInstance].ywIMKit.IMCore getLoginService] currentLoginedUser].personLongId]

#warning PLEASE USE DATABASE TO STORE IN COMMERCIAL APPS

/// 下面这两个函数在demo中使用NSUserDefaults简化实现，在商用app上请使用数据库存储。

- (void)_updateObject:(id)aObject forKey:(NSString *)aKey forMessageId:(NSString *)aMessageId {
    if (aObject == nil || aKey == nil || aMessageId == nil) {
        return;
    }
    
    NSDictionary *oldDic = [[NSUserDefaults standardUserDefaults] objectForKey:__DefaultKeyForMessageState];
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] initWithCapacity:oldDic.count + 10];
    if (oldDic) {
        [mdic addEntriesFromDictionary:oldDic];
    }
    
    
    NSDictionary *oldMsgState = [mdic objectForKey:aMessageId];
    NSMutableDictionary *msgState = [[NSMutableDictionary alloc] initWithCapacity:oldMsgState.count + 5];
    if (oldMsgState) {
        [msgState addEntriesFromDictionary:oldMsgState];
    }
    
    [msgState setObject:aObject forKey:aKey];
    [mdic setObject:msgState forKey:aMessageId];
    [[NSUserDefaults standardUserDefaults] setObject:mdic forKey:__DefaultKeyForMessageState];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)_fetchObjectForKey:(NSString *)aKey forMessageId:(NSString *)aMessageId
{
    if (aKey == nil || aMessageId == nil) {
        return nil;
    }
    
    return [[[[NSUserDefaults standardUserDefaults] objectForKey:__DefaultKeyForMessageState] objectForKey:aMessageId] objectForKey:aKey];
}

#pragma mark - public

+ (instancetype)sharedInstance
{
    static SPLogicBizPrivateImage *sInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[SPLogicBizPrivateImage alloc] init];
    });
    
    return sInstance;
}

#define __MessageStateKeySelfRead @"SelfRead"
#define __MessageStateKeyRecvRead @"RecvRead"

/// 调用下面这几个接口时总是使用原始阅图即焚消息的messageId

- (void)markSelfReadForMessageId:(NSString *)aMessageId
{
    [self _updateObject:@(YES) forKey:__MessageStateKeySelfRead forMessageId:aMessageId];
}

- (void)markRecvReadForMessageId:(NSString *)aMessageId
{
    [self _updateObject:@(YES) forKey:__MessageStateKeyRecvRead forMessageId:aMessageId];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSPLogicBizPrivateImageNotificationRecvRead object:nil userInfo:@{kSPLogicBizPrivateImageNotificationRecvReadUserInfoKeyMessageId:aMessageId}];
}

- (BOOL)isSelfReadForMessageId:(NSString *)aMessageId
{
    return [[self _fetchObjectForKey:__MessageStateKeySelfRead forMessageId:aMessageId] boolValue];
}

- (BOOL)isRecvReadForMessageId:(NSString *)aMessageId
{
    return [[self _fetchObjectForKey:__MessageStateKeyRecvRead forMessageId:aMessageId] boolValue];
}

- (BOOL)isRecvReadOfLocalMessage:(id<IYWMessage>)aLocalMessage
{
    YWMessageBodyCustomize *localBody = (YWMessageBodyCustomize *)[aLocalMessage messageBody];
    NSDictionary *localContentDic = [NSJSONSerialization JSONObjectWithData:[localBody.content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];

    return [self isRecvReadForMessageId:localContentDic[__ContentKeyLocalSaveMessageId]];
}

- (NSString *)fetchOriginalMessageIdFromLocalMessage:(id<IYWMessage>)aLocalMessage
{
    YWMessageBodyCustomize *localBody = (YWMessageBodyCustomize *)[aLocalMessage messageBody];
    NSDictionary *localContentDic = [NSJSONSerialization JSONObjectWithData:[localBody.content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    return localContentDic[__ContentKeyLocalSaveMessageId];

}


- (void)asyncSendPrivateImageData:(NSData *)aImageData inConversation:(YWP2PConversation *)aConversation
{
    /// 使用顽兔sdk上传图片，请参考：http://baichuan.taobao.com/docs/doc.htm?spm=a3c0d.7629140.0.0.k30QX2&treeId=38&articleId=104010&docType=1
    
}

- (BOOL)handleListenNewCustomMessage:(id<IYWMessage>)aMessage
{
    BOOL handleResult = NO;
    YWMessageBodyCustomize *body = nil;
    NSDictionary *contentDic = nil;
    
    do {
        /// check class
        if (![[aMessage messageBody] isKindOfClass:[YWMessageBodyCustomize class]]) {
            break;
        }
        body = (YWMessageBodyCustomize *)[aMessage messageBody];
        
        /// check content
        @try {
            contentDic = [NSJSONSerialization JSONObjectWithData:[body.content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        }
        @catch (NSException *exception) {
            contentDic = nil;
        }
        if (contentDic.count <= 0) {
            break;
        }
        
        NSString *type = contentDic[kSPCustomizeMessageType];
        /// check type
        if (![type isKindOfClass:[NSString class]]) {
            break;
        }
        
        if ([type isEqualToString:__ContentValueTypePrivateImage]) {
            /// check url
            NSString *urlString = contentDic[__ContentKeyPrivateImageUrl];
            if (![urlString isKindOfClass:[NSString class]] || urlString.length <= 0) {
                break;
            }
            
            /// save local
            [self _saveLocalFromMessage:aMessage];
            handleResult = YES;
            break;
        }
        
        if ([type isEqualToString:__ContentValueTypePrivateImageRecvRead]) {
            /// 已读回执
            NSString *messageId = contentDic[__ContentKeyPrivateImageRecvReadMessageId];
            if (![messageId isKindOfClass:[NSString class]] || messageId.length <= 0) {
                break;
            }
            
            [self markRecvReadForMessageId:messageId];
            
            handleResult = YES;
            break;
        }
        
    } while (NO);
    
    return handleResult;
}

/// 如果是阅图即焚消息，则返回非空
- (YWBaseBubbleViewModel *)handleShowMessage:(id<IYWMessage>)aMessage
{
    SPViewModelPrivateImage *result = nil;
    do {
        YWMessageBodyCustomize *body = (YWMessageBodyCustomize *)[aMessage messageBody];
        if (![body isKindOfClass:[YWMessageBodyCustomize class]]) {
            break;
        }
        
        NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:[body.content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        if (![contentDic[kSPCustomizeMessageType] isEqualToString:__ContentValueTypePrivateImage]) {
            break;
        }
        
        result = [[SPViewModelPrivateImage alloc] initWithMessage:aMessage isOutgoing:[contentDic[__ContentKeyLocalSaveSenderLongId] isEqualToString:[[[SPKitExample sharedInstance].ywIMKit.IMCore getLoginService] currentLoginedUser].personLongId]];
    } while (NO);
    
    return result;
}

/// 如果是阅图即焚消息，则返回非空
- (YWBaseBubbleChatView *)handleShowModel:(YWBaseBubbleViewModel *)aModel
{
    SPBubbleViewPrivateImage *result = nil;
    
    do {
        if (![aModel isKindOfClass:[SPViewModelPrivateImage class]]) {
            break;
        }
        
        result = [[SPBubbleViewPrivateImage alloc] init];
    } while (NO);
    
    return result;
}

/// 如果是阅图即焚消息，则返回YES
- (BOOL)handlePrepare4UseBubbleView:(YWBaseBubbleChatView *)aView inConversationController:(YWConversationViewController *)aController
{
    __weak typeof(self) weakSelf = self;
    __weak typeof(aController) weakController = aController;
    
    SPBubbleViewPrivateImage *bubbleView = (SPBubbleViewPrivateImage *)aView;
    BOOL result = NO;
    do {
        if (![bubbleView isKindOfClass:[SPBubbleViewPrivateImage class]]) {
            break;
        }
        
        /// 设置用户点击回调block
        [bubbleView setDidClickBlock:^(SPBubbleViewPrivateImage *aBubbleView){
            
            YWMessageBodyCustomize *body = (YWMessageBodyCustomize *)[aBubbleView.message messageBody];
            NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:[body.content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            if (contentDic[__ContentKeyPrivateImageUrl] == nil) {
                return;
            }

            
            /// 判断是否已经读过该消息，如果已经读过则直接提示
            if ([weakSelf isSelfReadForMessageId:contentDic[__ContentKeyLocalSaveMessageId]]) {
                [YWIndicator showTopToastTitle:@"提示" content:@"您已查看过图片,图片已消失" userInfo:nil withTimeToDisplay:1.f andClickBlock:NULL];
                return;
            }
            
            
            /// 如果没有读过则使用大图预览功能，查看图片
            /// 标记为本地已读；如果自己是接收者，还需要发送已读回执；
            [YWImageBrowserHelper previewImagesWithUrlsArray:@[contentDic[__ContentKeyPrivateImageUrl]] currentIndex:0 inNavigationController:weakController.navigationController fromView:nil additionalActions:nil withIMKit:[SPKitExample sharedInstance].ywIMKit extraParams:@{YWImageBrowserHelperParamKeyEnableSave:@(NO)}];

            /// 显示提示语
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [YWIndicator showTopToastTitle:@"此图片5秒后自动关闭" content:nil userInfo:nil withTimeToDisplay:0.5f andClickBlock:NULL];
            });

            
            [weakSelf setOnPreviewImageLoadedBlock:^BOOL(NSNotification *aNote) {
                BOOL handled = NO;
                
                NSString *urlString = aNote.userInfo[YWImageBrowserHelperNotificationImageLoadKeyUrlString];
                NSError *error = aNote.userInfo[YWImageBrowserHelperNotificationImageLoadKeyError];
                
                do {
                    /// validation
                    if (![urlString isKindOfClass:[NSString class]]) {
                        break;
                    }
                    if (![urlString isEqualToString:contentDic[__ContentKeyPrivateImageUrl]]) {
                        break;
                    }
                    /// url 匹配，进行处理
                    if (error.code != 0) {
                        /// 虽然匹配，但加载失败
                        handled = YES;
                        break;
                    }
                    
                    [weakSelf markSelfReadForMessageId:contentDic[__ContentKeyLocalSaveMessageId]];
                    if (![contentDic[__ContentKeyLocalSaveSenderLongId] isEqualToString:[[[SPKitExample sharedInstance].ywIMKit.IMCore getLoginService] currentLoginedUser].personLongId]) {
                        /// 自己是接收者
                        [weakSelf _asyncSendRecvReadWithLocalMessage:aBubbleView.message];
                    }
                    /// 5秒后隐藏
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [YWImageBrowserHelper dismissLastController];
                    });
                    
                } while (NO);
                
                return handled;
            }];
        }];
        
        result = YES;
    } while (NO);
    
    return result;
}



@end
