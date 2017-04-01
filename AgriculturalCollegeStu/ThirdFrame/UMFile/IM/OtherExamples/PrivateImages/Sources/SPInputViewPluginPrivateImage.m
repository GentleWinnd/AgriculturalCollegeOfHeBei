//
//  SPInputViewPluginPrivateImage.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 16/4/6.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import "SPInputViewPluginPrivateImage.h"

#import "SPLogicBizPrivateImage.h"

@interface SPInputViewPluginPrivateImage ()
<UIActionSheetDelegate>

@property (nonatomic, readonly) YWConversationViewController *conversationViewController;

@end

@implementation SPInputViewPluginPrivateImage


#pragma mark - properties

- (YWConversationViewController *)conversationViewController
{
    YWConversationViewController *result = nil;
    
    if ([self.inputViewRef.messageInputViewDelegate isKindOfClass:[YWConversationViewController class]]) {
        result = (YWConversationViewController *)self.inputViewRef.messageInputViewDelegate;
    }
    
    return result;
}

#pragma mark - YWInputViewPluginProtocol

// 插件位置，默认为YWInputViewPluginPositionMorePanel
- (YWInputViewPluginPosition)pluginPosition
{
    return YWInputViewPluginPositionMorePanel;
}

// 加载该插件的inputView
@synthesize inputViewRef;

// 插件类型，用来向对方发送当前用户正在做的操作，例如正在拍照或者正在选择地理位置，详见 YWInputViewPluginType 的定义
- (YWInputViewPluginType)pluginType
{
    return YWInputViewPluginTypeDefault;
}

// 插件图标
- (UIImage *)pluginIconImage
{
    return [UIImage imageNamed:@"plugin_icon_privateImage"];
}

// 插件名称
- (NSString *)pluginName
{
    return @"阅图即焚";
}

// 插件对应的view，会被加载到inputView上
- (UIView *)pluginContentView
{
    return nil;
}

@synthesize delegate;

// 插件被选中运行
- (void)pluginDidClicked
{
    if (![self.conversationViewController.conversation isKindOfClass:[YWP2PConversation class]]) {
        /// 仅允许p2p
        return;
    }
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [as showInView:self.conversationViewController.view];
}

#pragma mark - UIActionSheet delegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL shouldPresent = NO;
    YWPhotoPickerHelper *helper = [[YWPhotoPickerHelper alloc] initWithYWIMKit:self.conversationViewController.kitRef];
    
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        /// 拍照
        [helper setPhotoPickerType:YWPhotoPickerTypeTakePhoto];
        shouldPresent = YES;
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
        /// 相册
        [helper setPhotoPickerType:YWPhotoPickerTypeSingle];
        shouldPresent = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [helper setPhotoPickerResultBlock:^(NSDictionary *aUserInfo) {
        NSData *imageData = [aUserInfo[YWPhotoPickerResultKeySelectedImageDatasArray] firstObject];
        if (imageData) {
            [[SPLogicBizPrivateImage sharedInstance] asyncSendPrivateImageData:imageData inConversation:(YWP2PConversation *)weakSelf.conversationViewController.conversation];
        }
    }];
    
    if (shouldPresent) {
        [helper presentFromController:self.conversationViewController];
    }
}

@end
