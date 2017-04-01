//
//  RegistViewController.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/27.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController
{
    
}

@synthesize txtf_nameInput;
@synthesize txtf_passInput;
@synthesize txtf_emailInput;
@synthesize btn_toLogin;
@synthesize btn_toRegist;
@synthesize parentVc;
@synthesize v_titleContainer;
@synthesize v_nameContainer;
@synthesize v_passContainer;
@synthesize v_emailContainer;

- (void) viewDidLoad {
    [super viewDidLoad];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    v_titleContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    v_titleContainer.layer.shadowOffset = CGSizeMake(0, 1);
    v_titleContainer.layer.shadowOpacity = 0.5;
    v_titleContainer.layer.shadowRadius = 1;
    
    v_nameContainer.layer.cornerRadius = 5;
    v_passContainer.layer.cornerRadius = 5;
    v_emailContainer.layer.cornerRadius = 5;
    btn_toRegist.layer.cornerRadius = 5;
}

- (void) toClose:(id)sender {
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //animation.type = @"pageCurl";
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    [parentVc dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction) toRegist:(id)sender {
    
    NSDictionary *para = @{@"UserName" :txtf_nameInput.text, @"Password" :txtf_passInput.text, @"Email" :txtf_emailInput.text};
    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [_AFNManager POST:URL_USER_REGISTER parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if ([dic[@"State"] integerValue] ==1) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//        } else {
//            ALERT_HOME(@"注册失败", dic[@"Message"]);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        ALERT_HOME(@"注册失败", error.description);
//    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0) {
        [self toClose:nil];
    }
}

- (IBAction) toLogin:(id)sender {
    
    
}


@end
