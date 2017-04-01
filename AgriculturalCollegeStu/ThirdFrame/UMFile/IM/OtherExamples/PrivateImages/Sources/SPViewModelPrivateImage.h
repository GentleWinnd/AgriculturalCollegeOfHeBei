//
//  SPViewModelPrivateImage.h
//  WXOpenIMSampleDev
//
//  Created by huanglei on 16/4/7.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import <WXOUIModule/YWUIFMWK.h>

@interface SPViewModelPrivateImage : YWBaseBubbleViewModel

- (instancetype)initWithMessage:(id<IYWMessage>)aMessage isOutgoing:(BOOL)aIsOutgoing;

@property (nonatomic, readonly) id<IYWMessage> message;

@end
