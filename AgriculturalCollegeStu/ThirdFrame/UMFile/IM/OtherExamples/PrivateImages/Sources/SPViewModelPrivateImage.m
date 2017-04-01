//
//  SPViewModelPrivateImage.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 16/4/7.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import "SPViewModelPrivateImage.h"

@interface SPViewModelPrivateImage ()

@property (nonatomic, strong, readwrite) id<IYWMessage> message;

@end

@implementation SPViewModelPrivateImage

- (instancetype)initWithMessage:(id<IYWMessage>)aMessage isOutgoing:(BOOL)aIsOutgoing
{
    self = [super init];
    
    if (self) {
        /// 初始化
        [self setMessage:aMessage];
        
        [self setBubbleStyle:BubbleStyleCustomize];
        [self setLayout:aIsOutgoing ? WXOBubbleLayoutRight : WXOBubbleLayoutLeft];
    }
    
    return self;
}



@end
