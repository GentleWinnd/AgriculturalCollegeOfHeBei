//
//  SPBubbleViewPrivateImage.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 16/4/7.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import "SPBubbleViewPrivateImage.h"
#import "SPViewModelPrivateImage.h"

#import "SPLogicBizPrivateImage.h"

@interface SPBubbleViewPrivateImage ()

@property (nonatomic, strong) SPViewModelPrivateImage *viewModel;

@property (nonatomic, strong) UIControl *controlBackground;

@property (nonatomic, strong) UIImageView *imageViewIcon;
@property (nonatomic, strong) UILabel *labelRecvRead;

@end

@implementation SPBubbleViewPrivateImage

@dynamic viewModel;

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.controlBackground = [[UIControl alloc] initWithFrame:self.bounds];
        [self.controlBackground setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.controlBackground setBackgroundColor:[UIColor clearColor]];
        [self.controlBackground addTarget:self action:@selector(actionBackground:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.controlBackground];
        
        self.imageViewIcon = [[UIImageView alloc] init];
        [self.imageViewIcon setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.imageViewIcon];
        
        self.labelRecvRead = [[UILabel alloc] init];
        [self.labelRecvRead setFont:[UIFont systemFontOfSize:11.f]];
        [self addSubview:self.labelRecvRead];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationRevcRead:) name:kSPLogicBizPrivateImageNotificationRecvRead object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /// TODO: 是否需要布局
}

#pragma mark - private

- (void)_updateRecvRead
{
    BOOL recvRead = [[SPLogicBizPrivateImage sharedInstance] isRecvReadOfLocalMessage:self.message];
    
    if (self.viewModel.layout == WXOBubbleLayoutLeft) {
        /// 显示为原点
        if (recvRead) {
            [self.labelRecvRead setHidden:YES];
        } else {
            [self.labelRecvRead setHidden:NO];
        }
    } else {
        if (recvRead) {
            [self.labelRecvRead setText:@"已读"];
            [self.labelRecvRead setTextColor:[UIColor lightGrayColor]];
        } else {
            [self.labelRecvRead setText:@"未读"];
            [self.labelRecvRead setTextColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]];
        }
    }
    
    
    if ([[SPLogicBizPrivateImage sharedInstance] isRecvReadOfLocalMessage:self.message]) {
        [self.labelRecvRead setText:@"已读 "];
    } else {
        [self.labelRecvRead setText:@"未读 "];
    }
}

#pragma mark - properties

- (id<IYWMessage>)message
{
    return self.viewModel.message;
}

#pragma mark - handlers

- (IBAction)actionBackground:(id)sender
{
    if (self.didClickBlock) {
        self.didClickBlock(self);
    }
}

- (void)onNotificationRevcRead:(NSNotification *)aNote
{
    NSString *messageIdFromNotification = aNote.userInfo[kSPLogicBizPrivateImageNotificationRecvReadUserInfoKeyMessageId];
    NSString *messageIdSelf = [[SPLogicBizPrivateImage sharedInstance] fetchOriginalMessageIdFromLocalMessage:self.message];
    if (messageIdSelf && [messageIdFromNotification isEqualToString:messageIdSelf]) {
        /// 需要更新
        [self _updateRecvRead];
    }
}

#pragma mark - YWBaseBubbleChatViewInf

- (CGSize)getBubbleContentSize
{
    return CGSizeMake(203, 165);
}

- (void)updateBubbleView
{
    if (self.viewModel.layout == WXOBubbleLayoutLeft) {
        [self.imageViewIcon setFrame:CGRectMake(0, 0, 165, [self getBubbleContentSize].height)];
        [self.imageViewIcon setImage:[UIImage imageNamed:@"bubble_privateimage_left"]];
        
        [self.labelRecvRead setFrame:CGRectMake(CGRectGetMaxX(self.imageViewIcon.frame), [self getBubbleContentSize].height - 5 - 12, 5, 5)];
        [self.labelRecvRead setTextColor:[UIColor clearColor]];
        [self.labelRecvRead setBackgroundColor:[UIColor colorWithRed:30/255.f green:144/255.f blue:1.f alpha:1.f]];
        [self.labelRecvRead.layer setCornerRadius:2.5f];
        [self.labelRecvRead.layer setMasksToBounds:YES];
    } else {
        [self.imageViewIcon setFrame:CGRectMake([self getBubbleContentSize].width - 165, 0, 165, [self getBubbleContentSize].height)];
        [self.imageViewIcon setImage:[UIImage imageNamed:@"bubble_privateimage_right"]];
        
        [self.labelRecvRead setFrame:CGRectMake(0, [self getBubbleContentSize].height - 13 - 12, [self getBubbleContentSize].width - self.imageViewIcon.frame.size.width, 13)];
        [self.labelRecvRead setTextAlignment:NSTextAlignmentRight];
        [self.labelRecvRead setBackgroundColor:[UIColor clearColor]];
    }
    
    [self _updateRecvRead];
}

- (NSNumber *)forceHideUnreadLabel
{
    return @(YES);
}

- (NSString *)viewModelClassName
{
    return NSStringFromClass([SPViewModelPrivateImage class]);
}


@end
