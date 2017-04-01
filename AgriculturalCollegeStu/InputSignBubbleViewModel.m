//
//  InputBubbleViewModel.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/19.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "InputSignBubbleViewModel.h"

@implementation InputSignBubbleViewModel
- (instancetype)initWithMessage:(id<IYWMessage>)aMessage
{
    self = [super init];
    
    if (self) {
        /// 设置气泡类型
        self.bubbleStyle = BubbleStyleCustomize;
        self.layout = [aMessage outgoing] ? WXOBubbleLayoutRight : WXOBubbleLayoutLeft;
    }
    
    return self;
}

@end
