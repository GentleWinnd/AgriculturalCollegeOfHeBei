//
//  HandoutViewController.m
//  xingxue_pro
//
//  Created by 张磊 on 16/5/12.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HandoutViewController.h"
#import "ListCell.h"
#import "Header_key.h"
#import "VideoPageModel.h"
#import "VideoEpisodesModel.h"


@interface HandoutViewController ()

@end

@implementation HandoutViewController
{
    CATransition *animation;
}

@synthesize v_bottomContainer;
@synthesize v_titleContainer;
@synthesize btn_back;
@synthesize lbl_title;

- (void) viewDidLoad {
    [super viewDidLoad];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    v_titleContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    v_titleContainer.layer.shadowOffset = CGSizeMake(0, 1);
    v_titleContainer.layer.shadowOpacity = 0.5;
    v_titleContainer.layer.shadowRadius = 1;
    
    animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //animation.type = @"pageCurl";
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    
    [_webv_handoutHtml loadHTMLString:_handoutHtml baseURL:nil];
}

- (IBAction) backClick:(id)sender {
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    [_faceCourseVideoVc dismissViewControllerAnimated:NO completion:nil];
}

@end