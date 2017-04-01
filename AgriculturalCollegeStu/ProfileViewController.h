//
//  profile.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/27.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMEBaseViewController.h"

@interface ProfileViewController : HOMEBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *txtf_name;
@property (weak, nonatomic) IBOutlet UITextField *txtf_phone;
@property (weak, nonatomic) IBOutlet UITextField *txtf_address;
@property (weak, nonatomic) IBOutlet UITextField *txtf_course;
@property (weak, nonatomic) IBOutlet UITextField *txtf_progress;

@property (weak, nonatomic) IBOutlet UIView *v_course;
@property (weak, nonatomic) IBOutlet UIView *v_progress;

@property (weak, nonatomic) IBOutlet UIButton *btn_save;
@property (weak, nonatomic) IBOutlet UIButton *btn_goBack;
@property (weak, nonatomic) IBOutlet UIView *v_topcontainer;

@property (strong, nonatomic) UIViewController *parentVc;


- (IBAction) goBackAction:(id)sender;
- (IBAction) saveAction:(id)sender;



@end
