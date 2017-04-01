//
//  ForgetPasswordViewController.m
//  OldUniversity
//
//  Created by mahaomeng on 15/7/31.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB_COLOR(243, 243, 239);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH /3.f, self.navigationController.navigationBar.frame.size.height)];
    label.text = @"重置密码";
    label.textColor = WHITE_COLOR;
    label.font = [UIFont systemFontOfSize:kTitleFont];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    [self customBackBtn];
    [self customUI];
}

-(void)customBackBtn
{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 20, 20);
    [button1 addTarget:self action:@selector(onBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [button1 setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonR1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    self.navigationItem.leftBarButtonItems = @[barButtonR1];
}

-(void)onBackBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)customUI
{
//    手机一键登录
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30 +64, WIDTH -40, 45)];
    imageView2.backgroundColor = WHITE_COLOR;
    imageView2.userInteractionEnabled = YES;
    [self.view addSubview:imageView2];
    
//    手机号输入框
    UIImageView *phoneQuickImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 25)];
    phoneQuickImageView.image = [UIImage imageNamed:@"手机号码图标"];
    [imageView2 addSubview:phoneQuickImageView];
    
    UITextField *usernameQuickTextField = [[UITextField alloc]initWithFrame:CGRectMake(45, phoneQuickImageView.frame.origin.y, WIDTH -190, 25)];
    usernameQuickTextField.placeholder = @"手机号";
    usernameQuickTextField.keyboardType = UIKeyboardTypeNumberPad;
    usernameQuickTextField.font = [UIFont systemFontOfSize:15];
    usernameQuickTextField.clearButtonMode = UITextFieldViewModeAlways;
    [imageView2 addSubview:usernameQuickTextField];
    
//    获取验证码按钮
    UIButton *sendMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendMessageBtn.frame = CGRectMake(usernameQuickTextField.frame.origin.x +usernameQuickTextField.frame.size.width, 5, 98, 35);
    [sendMessageBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [sendMessageBtn addTarget:self action:@selector(onSendMessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [sendMessageBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    sendMessageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendMessageBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮-正常"] forState:UIControlStateNormal];
    [imageView2 addSubview:sendMessageBtn];
    
//    一键登录按钮
    UIButton *qiuckLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qiuckLoginBtn.frame = CGRectMake(imageView2.frame.origin.x, imageView2.frame.origin.y +imageView2.frame.size.height +40, imageView2.frame.size.width, imageView2.frame.size.height);
    [qiuckLoginBtn setTitle:@"重设密码" forState:UIControlStateNormal];
//    [qiuckLoginBtn addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    [qiuckLoginBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [qiuckLoginBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮-正常"] forState:UIControlStateNormal];
    [self.view addSubview:qiuckLoginBtn];

}

-(void)onSendMessageBtnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
