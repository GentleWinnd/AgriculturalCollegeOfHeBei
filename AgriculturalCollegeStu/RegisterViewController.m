//
//  RegisterViewController.m
//  OldUniversity
//
//  Created by mahaomeng on 15/7/31.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "RegisterViewController.h"
#import "BaseScrollView.h"

@interface RegisterViewController ()<UIScrollViewDelegate, UIAlertViewDelegate>

@end

@implementation RegisterViewController
{
    UIButton *_buttonL;
    HOMEButon *_buttonR;
    BaseScrollView *_scrollView;
    UIImageView *_btnBottomImageView;
    
    UITextField *_usernameTextField;
    UITextField *_passwordTextField;
    UITextField *_mailTextField;
}

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
    label.text = @"注册";
    label.textColor = WHITE_COLOR;
    label.font = [UIFont systemFontOfSize:kTitleFont];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    [self customBackBtn];
    [self customButton];
    [self customScrollView];
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

-(void)customButton
{
//    _buttonL = [[HOMEButon alloc]initWithFrame:CGRectMake(0, 64, WIDTH /2.f, 48) withTitle:@"andButtonClickEvent:^(HOMEButon *sender) {
//        [sender setTitleColor:RED_COLOR forState:UIControlStateNormal];
//        [myself.buttonR setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
//        [UIView animateWithDuration:0.6f animations:^{
//            myself.scrollView.contentOffset = CGPointMake(0, 0);
//            myself.btnBottomImageView.frame = CGRectMake(0, myself.buttonL.frame.origin.y +myself.buttonL.frame.size.height, myself.buttonL.frame.size.width, 2);
//            [myself.scrollView endEditing:YES];
//        }];
//    }];
    _buttonL = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonL.frame = CGRectMake(0, 64, WIDTH /2.f, 48);
    [_buttonL setTitle:@"用户名注册" forState:UIControlStateNormal];
    [_buttonL addTarget:self action:@selector(onBtnLClick:) forControlEvents:UIControlEventTouchUpInside];
    _buttonL.backgroundColor = WHITE_COLOR;
    [_buttonL setTitleColor:RED_COLOR forState:UIControlStateNormal];
//    [self.view addSubview:_buttonL];
    
    _buttonR = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonR.frame = CGRectMake(_buttonL.frame.origin.x +_buttonL.frame.size.width, _buttonL.frame.origin.y, _buttonL.frame.size.width, _buttonL.frame.size.height);
    [_buttonR setTitle:@"手机一键注册" forState:UIControlStateNormal];
    [_buttonR addTarget:self action:@selector(onBtnRClick:) forControlEvents:UIControlEventTouchUpInside];
    _buttonR.backgroundColor = WHITE_COLOR;
    [_buttonR setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
//    [self.view addSubview:_buttonR];
    
    _btnBottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2)];
    _btnBottomImageView.backgroundColor = RED_COLOR;
//    [self.view addSubview:_btnBottomImageView];
}

-(void)onBtnLClick:(UIButton *)sender
{
    [sender setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [_buttonR setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
    [UIView animateWithDuration:0.6f animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
        _btnBottomImageView.frame = CGRectMake(0, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
        [_scrollView endEditing:YES];
    }];
}

-(void)onBtnRClick:(UIButton *)sender
{
    [sender setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [_buttonL setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
    [UIView animateWithDuration:0.6f animations:^{
        _scrollView.contentOffset = CGPointMake(WIDTH, 0);
        _btnBottomImageView.frame = CGRectMake(WIDTH /2.f, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
        [_scrollView endEditing:YES];
    }];
}

-(void)customScrollView
{
    _scrollView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, _btnBottomImageView.frame.origin.y +_btnBottomImageView.frame.size.height, WIDTH, HEIGHT -64 -49 -_buttonL.frame.size.height -2)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(WIDTH *2.f, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    //    用户名登录
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, WIDTH -40, 45 *3)];
    imageView1.userInteractionEnabled = YES;
    [_scrollView addSubview:imageView1];
    
    for (NSInteger i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45*i, imageView1.frame.size.width, 44)];
        imageView.backgroundColor = WHITE_COLOR;
        [imageView1 addSubview:imageView];
    }
    
    //    账号输入框
    UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 25)];
    phoneImageView.image = [UIImage imageNamed:@"手机号码图标"];
    [imageView1 addSubview:phoneImageView];
    
    _usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(45, phoneImageView.frame.origin.y, imageView1.frame.size.width -45, phoneImageView.frame.size.height)];
    _usernameTextField.placeholder = @"用户名";
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.clearButtonMode = UITextFieldViewModeAlways;
    [imageView1 addSubview:_usernameTextField];
    
    //    密码输入框
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 55, 25, 25)];
    passwordImageView.image = [UIImage imageNamed:@"密码图标"];
    [imageView1 addSubview:passwordImageView];
    
    _passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(45, passwordImageView.frame.origin.y, imageView1.frame.size.width -45, phoneImageView.frame.size.height)];
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    [imageView1 addSubview:_passwordTextField];
    
    //    邮箱输入框
    UIImageView *mailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 25, 25)];
    mailImageView.image = [UIImage imageNamed:@"密码图标"];
    [imageView1 addSubview:mailImageView];
    
     _mailTextField = [[UITextField alloc]initWithFrame:CGRectMake(45, mailImageView.frame.origin.y, imageView1.frame.size.width -45, phoneImageView.frame.size.height)];
    _mailTextField.placeholder = @"邮箱";
    _mailTextField.font = [UIFont systemFontOfSize:15];
    _mailTextField.clearButtonMode = UITextFieldViewModeAlways;
    [imageView1 addSubview:_mailTextField];
    
    //    注册按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(imageView1.frame.origin.x, imageView1.frame.origin.y +imageView1.frame.size.height +30, imageView1.frame.size.width, 45);
    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(onLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮-正常"] forState:UIControlStateNormal];
    [_scrollView addSubview:loginBtn];
    
    //    手机一键登录
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(20 +WIDTH, 30, WIDTH -40, 45)];
    imageView2.backgroundColor = WHITE_COLOR;
    imageView2.userInteractionEnabled = YES;
    [_scrollView addSubview:imageView2];
    
    //    手机号输入框
    UIImageView *phoneQuickImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 25)];
    phoneQuickImageView.image = [UIImage imageNamed:@"手机号码图标"];
    [imageView2 addSubview:phoneQuickImageView];
    
    UITextField *usernameQuickTextField = [[UITextField alloc]initWithFrame:CGRectMake(45, phoneImageView.frame.origin.y, imageView1.frame.size.width -45, phoneImageView.frame.size.height)];
    usernameQuickTextField.placeholder = @"手机号";
    usernameQuickTextField.keyboardType = UIKeyboardTypeNumberPad;
    usernameQuickTextField.font = [UIFont systemFontOfSize:15];
    usernameQuickTextField.clearButtonMode = UITextFieldViewModeAlways;
    [imageView2 addSubview:usernameQuickTextField];
    
    //    一键注册按钮
    HOMEButon *qiuckLoginBtn = [[HOMEButon alloc]initWithFrame:CGRectMake(imageView2.frame.origin.x, imageView2.frame.origin.y +imageView2.frame.size.height +40, imageView2.frame.size.width, imageView2.frame.size.height) withTitle:@"一键注册"andButtonClickEvent:^(HOMEButon *sender) {
        
    }];
    [qiuckLoginBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [qiuckLoginBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮-正常"] forState:UIControlStateNormal];
    [_scrollView addSubview:qiuckLoginBtn];
}

-(void)onLoginBtnClick:(UIButton *)sender
{
    NSDictionary *para = @{@"UserName" :_usernameTextField.text, @"Password" :_passwordTextField.text, @"Email" :_mailTextField.text};
//    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [_AFNManager POST:URL_USER_REGISTER parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if ([dic[@"State"] integerValue] ==1) {
//            //                _valueBlock(dic);
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
    [_scrollView endEditing:YES];
    if (buttonIndex ==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_scrollView endEditing:YES];
    if (scrollView.contentOffset.x == 0) {
//        [UIView animateWithDuration:0.f animations:^{
//            [_buttonL setTitleColor:RED_COLOR forState:UIControlStateNormal];
//            [_buttonR setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
//            _btnBottomImageView.frame = CGRectMake(0, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
//        }];
    } else {
//        [UIView animateWithDuration:0.f animations:^{
//            [_buttonR setTitleColor:RED_COLOR forState:UIControlStateNormal];
//            [_buttonL setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
//            _btnBottomImageView.frame = CGRectMake(WIDTH /2.f, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
//        }];
    }
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
