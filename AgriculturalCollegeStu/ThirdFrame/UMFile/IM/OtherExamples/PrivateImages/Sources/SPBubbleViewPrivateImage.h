//
//  SPBubbleViewPrivateImage.h
//  WXOpenIMSampleDev
//
//  Created by huanglei on 16/4/7.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import <WXOUIModule/YWUIFMWK.h>

@class SPBubbleViewPrivateImage;
typedef void(^SPBubbleViewPrivateImageDidClickBlock)(SPBubbleViewPrivateImage *aBubbleView);

@interface SPBubbleViewPrivateImage : YWBaseBubbleChatView

@property (nonatomic, readonly) id<IYWMessage> message;

@property (nonatomic, copy) SPBubbleViewPrivateImageDidClickBlock didClickBlock;
- (void)setDidClickBlock:(SPBubbleViewPrivateImageDidClickBlock)didClickBlock;

@end
