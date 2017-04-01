//
//  RegistViewController.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/27.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMEBaseViewController.h"

@interface RegistViewController : HOMEBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *txtf_nameInput;
@property (weak, nonatomic) IBOutlet UITextField *txtf_passInput;
@property (weak, nonatomic) IBOutlet UITextField *txtf_emailInput;

@property (weak, nonatomic) IBOutlet UIButton *btn_toLogin;
@property (weak, nonatomic) IBOutlet UIButton *btn_toClose;
@property (weak, nonatomic) IBOutlet UIButton *btn_toRegist;
@property (weak, nonatomic) IBOutlet UIView *v_titleContainer;
@property (weak, nonatomic) IBOutlet UIView *v_nameContainer;
@property (weak, nonatomic) IBOutlet UIView *v_passContainer;
@property (weak, nonatomic) IBOutlet UIView *v_emailContainer;

@property (strong, nonatomic) UIViewController *parentVc;

- (IBAction) toClose:(id)sender;
- (IBAction) toRegist:(id)sender;

@end
