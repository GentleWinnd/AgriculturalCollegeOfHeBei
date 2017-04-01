//
//  HandoutViewController.h
//  xingxue_pro
//
//  Created by 张磊 on 16/5/12.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMEBaseViewController.h"

@interface HandoutViewController : HOMEBaseViewController

@property (weak, nonatomic) IBOutlet UIView *v_titleContainer;
@property (weak, nonatomic) IBOutlet UIView *v_bottomContainer;
@property (weak, nonatomic) IBOutlet UIButton *btn_back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UIWebView *webv_handoutHtml;

@property (strong, nonatomic) UIViewController *faceCourseVideoVc;
@property (strong, nonatomic) NSString *handoutHtml;


- (IBAction) backClick:(id)sender;


@end