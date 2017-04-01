//
//  ProfileViewController.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/27.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileViewController.h"
#import "Header_key.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
{
    
}

@synthesize txtf_name;
@synthesize txtf_phone;
@synthesize txtf_address;
@synthesize txtf_course;
@synthesize txtf_progress;
@synthesize btn_goBack;
@synthesize btn_save;
@synthesize parentVc;

- (void) viewDidLoad {
    [super viewDidLoad];
    [self checkProfileInfo];
    
    _v_course.hidden = YES;
    _v_progress.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated {

    _v_topcontainer .layer.shadowColor = [UIColor blackColor].CGColor;
    _v_topcontainer.layer.shadowOffset = CGSizeMake(0, 1);
    _v_topcontainer.layer.shadowOpacity = 0.5;
    _v_topcontainer.layer.shadowRadius = 1;
}

- (void) checkProfileInfo {
    
    NSUserDefaults *appCaches = [NSUserDefaults standardUserDefaults];
    NSDictionary *profileInfo = [appCaches objectForKey:PROFILE_INFO_KEY];
    
    if(profileInfo != nil) {
        [txtf_name setText:profileInfo[@"profile_name"]];
        [txtf_phone setText:profileInfo[@"profile_phone"]];
        [txtf_address setText:profileInfo[@"profile_address"]];
        [txtf_course setText:profileInfo[@"profile_course"]];
        [txtf_progress setText:profileInfo[@"profile_progress"]];
    }
}

- (IBAction) goBackAction:(id)sender {

    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //animation.type = @"pageCurl";
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    [parentVc dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction) saveAction:(id)sender {
    
    NSUserDefaults *appCaches = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *profileMutable = [NSMutableDictionary dictionary];
    [profileMutable setObject:txtf_name.text forKey:@"profile_name"];
    [profileMutable setObject:txtf_phone.text forKey:@"profile_phone"];
    [profileMutable setObject:txtf_address.text forKey:@"profile_address"];
    [profileMutable setObject:txtf_course.text forKey:@"profile_course"];
    [profileMutable setObject:txtf_progress.text forKey:@"profile_progress"];
    
    [appCaches setObject:profileMutable forKey:PROFILE_INFO_KEY];
    
    [self goBackAction:nil];
}


@end
