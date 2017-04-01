//
//  InputleaveChatView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/19.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "InputleaveChatView.h"
#import "InputLeaveBubbleViewModel.h"

@interface InputleaveChatView()
{
    UIImageView *imageView;
}

@end

@implementation InputleaveChatView


- (instancetype)init {
    
    UIImage *image = [UIImage imageNamed:@"greeting_message"];
    CGRect frame = {{0, 0}, image.size};
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeWidth
                                                                          multiplier:1.0
                                                                            constant:0.0];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:1.0
                                                                             constant:0.0];
        
        [self addConstraints:@[widthConstraint, heightConstraint]];
    }
    return self;
}


#pragma mark - YWBaseBubbleChatViewInf
/// 内容区域大小
- (CGSize)getBubbleContentSize
{
    return self.frame.size;
}

- (void)updateBubbleView {
    ;
}

// 返回所持ViewModel类名，用于类型检测
- (NSString *)viewModelClassName
{
    return NSStringFromClass([InputLeaveBubbleViewModel class]);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
