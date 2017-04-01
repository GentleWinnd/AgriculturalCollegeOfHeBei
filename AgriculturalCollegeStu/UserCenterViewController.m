//
//  UserCenterViewController.m
//  OldUniversity
//
//  Created by mahaomeng on 15/7/23.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "UserCenterViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "UserPersonalCenterViewController.h"
#import "BaseScrollView.h"
#import "AppDelegate.h"

@interface UserCenterViewController ()<UIScrollViewDelegate>

@end

@implementation UserCenterViewController
{
    HOMEButon *_buttonL;
    HOMEButon *_buttonR;
    BaseScrollView *_scrollView;
    UIImageView *_btnBottomImageView;
    BOOL _flag;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    if ([[_userDefaults objectForKey:USERINFO]allKeys].count >0) {
        UserPersonalCenterViewController *uvc = [[UserPersonalCenterViewController alloc]init];
        [self.navigationController pushViewController:uvc animated:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(instancetype)initWithFlag:(BOOL)flag
{
    if (self = [super init]) {
        _flag = flag;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB_COLOR(243, 243, 239);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH /3.f, self.navigationController.navigationBar.frame.size.height)];
    label.text = @"登录";
    label.textColor = WHITE_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:kTitleFont];
    self.navigationItem.titleView = label;
    
    [self customBarButtons];
    [self customButton];
    [self customScrollView];
}

-(void)customBarButtons
{
    UIBarButtonItem *barButtonR1 = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(onRBarButtonClick:)];
    barButtonR1.tintColor = WHITE_COLOR;
    
    self.navigationItem.rightBarButtonItems = @[barButtonR1];
}

-(void)customButton
{
    _buttonL = [[HOMEButon alloc]initWithFrame:CGRectMake(0, 64, WIDTH /2.f, 48) withTitle:@"用户名登录" andButtonClickEvent:^(HOMEButon *sender) {
        [sender setTitleColor:RED_COLOR forState:UIControlStateNormal];
        [_buttonR setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
        [UIView animateWithDuration:0.6f animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
            _btnBottomImageView.frame = CGRectMake(0, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
            [_scrollView endEditing:YES];
        }];
    }];
    _buttonL.backgroundColor = WHITE_COLOR;
    [_buttonL setTitleColor:RED_COLOR forState:UIControlStateNormal];
//    [self.view addSubview:_buttonL];
    
    _buttonR = [[HOMEButon alloc]initWithFrame:CGRectMake(_buttonL.frame.origin.x +_buttonL.frame.size.width, _buttonL.frame.origin.y, _buttonL.frame.size.width, _buttonL.frame.size.height) withTitle:@"手机一键登录" andButtonClickEvent:^(HOMEButon *sender) {
        [sender setTitleColor:RED_COLOR forState:UIControlStateNormal];
        [_buttonL setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
        [UIView animateWithDuration:0.6f animations:^{
            _scrollView.contentOffset = CGPointMake(WIDTH, 0);
            _btnBottomImageView.frame = CGRectMake(WIDTH /2.f, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
            [_scrollView endEditing:YES];
        }];
    }];
    _buttonR.backgroundColor = WHITE_COLOR;
    [_buttonR setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
//    [self.view addSubview:_buttonR];
    
    _btnBottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2)];
    _btnBottomImageView.backgroundColor = RED_COLOR;
//    [self.view addSubview:_btnBottomImageView];
}

#pragma mark - 跳转注册页面
-(void)onRBarButtonClick:(UIBarButtonItem *)sender
{
    [_scrollView endEditing:YES];
    RegisterViewController *rvc = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}

-(void)customScrollView {
    _scrollView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, _btnBottomImageView.frame.origin.y +_btnBottomImageView.frame.size.height, WIDTH, HEIGHT -64 -49 -_buttonL.frame.size.height -2)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(WIDTH *2.f, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    _scrollView.scrollEnabled = NO;
    
//    用户名登录
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 30, WIDTH -40, 90)];
    imageView1.image = [UIImage imageNamed:@"文本框"];
    imageView1.userInteractionEnabled = YES;
    [_scrollView addSubview:imageView1];
    
//    账号输入框
    UIImageView *phoneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 25)];
    phoneImageView.image = [UIImage imageNamed:@"手机号码图标"];
    [imageView1 addSubview:phoneImageView];
    
    NSDictionary *userIn = [_userDefaults objectForKey:LOGIN_LOG];
    UITextField *usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(45, phoneImageView.frame.origin.y, imageView1.frame.size.width -45, phoneImageView.frame.size.height)];
    usernameTextField.placeholder = @"用户名";
    if ([userIn[@"UserName"] length] >0) {
        usernameTextField.text = userIn[@"UserName"];
    }

//    usernameTextField.text = @"15210117653";
    usernameTextField.font = [UIFont systemFontOfSize:15];
    usernameTextField.clearButtonMode = UITextFieldViewModeAlways;
    [imageView1 addSubview:usernameTextField];
    
//    密码输入框
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 55, 25, 25)];
    passwordImageView.image = [UIImage imageNamed:@"密码图标"];
    [imageView1 addSubview:passwordImageView];
    
    UITextField *passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(45, passwordImageView.frame.origin.y, imageView1.frame.size.width -45, phoneImageView.frame.size.height)];
    passwordTextField.placeholder = @"密码";
    if ([userIn[@"Password"] length] >0) {
        passwordTextField.text = userIn[@"Password"];
    }
//    passwordTextField.text = @"123456";
    passwordTextField.secureTextEntry = YES;
    passwordTextField.font = [UIFont systemFontOfSize:15];
    passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    [imageView1 addSubview:passwordTextField];

//    记住密码按钮
    HOMEButon *rememberPasswordBtn = [[HOMEButon alloc]initWithFrame:CGRectMake(imageView1.frame.origin.x +5, imageView1.frame.origin.y +imageView1.frame.size.height +10, 20, 20) withTitle:@"" andButtonClickEvent:^(HOMEButon *sender) {
        sender.selected = !sender.selected;
    }];
    [rememberPasswordBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [rememberPasswordBtn setBackgroundImage:[UIImage imageNamed:@"选择"] forState:UIControlStateSelected];
    ([userIn[@"Password"] length] >0) ? (rememberPasswordBtn.selected = YES) : (rememberPasswordBtn.selected = NO);
    [_scrollView addSubview:rememberPasswordBtn];
    
    HOMEButon *rememberPasswordText = [[HOMEButon alloc]initWithFrame:CGRectMake(rememberPasswordBtn.frame.origin.x +rememberPasswordBtn.frame.size.width, rememberPasswordBtn.frame.origin.y, 70, rememberPasswordBtn.frame.size.height) withTitle:@"记住密码" andButtonClickEvent:^(HOMEButon *sender) {
        rememberPasswordBtn.selected = !rememberPasswordBtn.selected;
    }];
    rememberPasswordText.titleLabel.font = [UIFont systemFontOfSize:15];
    [rememberPasswordText setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
    [_scrollView addSubview:rememberPasswordText];
    
//    忘记密码按钮
    __weak typeof(self) myself = self;
    HOMEButon *forgetPasswordBtn = [[HOMEButon alloc]initWithFrame:CGRectMake(imageView1.frame.size.width -50, rememberPasswordText.frame.origin.y, rememberPasswordText.frame.size.width, rememberPasswordText.frame.size.height) withTitle:@"忘记密码" andButtonClickEvent:^(HOMEButon *sender) {
        ForgetPasswordViewController *fvc = [[ForgetPasswordViewController alloc]init];
        [myself.navigationController pushViewController:fvc animated:YES];
    }];
    forgetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetPasswordBtn setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
    forgetPasswordBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    [_scrollView addSubview:forgetPasswordBtn];
  
#pragma -mark 登录按钮
    HOMEButon *loginBtn = [[HOMEButon alloc]initWithFrame:CGRectMake(imageView1.frame.origin.x, forgetPasswordBtn.frame.origin.y +forgetPasswordBtn.frame.size.height +20, imageView1.frame.size.width, imageView1.frame.size.height /2.f) withTitle:@"登录"andButtonClickEvent:^(HOMEButon *sender) {
//        _HUD.labelText = @"正在登录";
//        [_HUD show:YES];
//        _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        NSDictionary *para = @{@"UserName" :usernameTextField.text, @"Password" :passwordTextField.text};
//
//
//       [_AFNManager POST:URL_USER_LOGIN parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//           [_HUD hide:YES];
//           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//           if ([dic[@"State"] integerValue] ==1) {
//               NSMutableDictionary *userInfo = [dic mutableCopy];
//               [userInfo setObject:usernameTextField.text forKey:@"UserName"];
//               [userInfo setObject:passwordTextField.text forKey:@"Password"];
//               NSMutableDictionary *loginlog = [NSMutableDictionary dictionary];
//               [loginlog setObject:usernameTextField.text forKey:@"UserName"];
//               if (rememberPasswordBtn.selected) {
//                   [loginlog setObject:passwordTextField.text forKey:@"Password"];
//               } else {
//                   [loginlog setObject:@"" forKey:@"Password"];
//               }
//               [_userDefaults setObject:loginlog forKey:LOGIN_LOG];
//               NSLog(@"%@", [_userDefaults objectForKey:USERINFO]);
//               for (NSInteger i =0; i <userInfo.allValues.count; i++) {
//                   if (userInfo.allValues[i] ==[NSNull null]) {
//                       [userInfo removeObjectForKey:userInfo.allKeys[i]];
//                   }
//               }
//               [_userDefaults setObject:userInfo forKey:USERINFO];
//               [_userDefaults synchronize];
//               NSLog(@"%@", [_userDefaults objectForKey:USERINFO]);
//               if (_flag) {
//                   if (myself.favoriteBlock) {
//                       myself.favoriteBlock();
//                   }
//                   [myself.navigationController popViewControllerAnimated:YES];
//               } else {
//                   [self onceLogIn];
//                   UserPersonalCenterViewController *uvc = [[UserPersonalCenterViewController alloc]init];
//                   [myself.navigationController pushViewController:uvc animated:NO];
                   
//                   self.tabBarController.selectedIndex = 0;
//               }
//               
//           } else {
//               ALERT_HOME(nil, @"登录失败");
//           }
//       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//           [_HUD hide:YES];
//           NSLog(@"%@", error.description);
//           ALERT_HOME(@"登录失败", error.description);
//       }];
//
    }];
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
    
//    一键登录按钮
    HOMEButon *qiuckLoginBtn = [[HOMEButon alloc]initWithFrame:CGRectMake(imageView2.frame.origin.x, imageView2.frame.origin.y +imageView2.frame.size.height +40, imageView2.frame.size.width, imageView2.frame.size.height) withTitle:@"一键登录"andButtonClickEvent:^(HOMEButon *sender) {
        
    }];
    [qiuckLoginBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [qiuckLoginBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮-正常"] forState:UIControlStateNormal];
    [_scrollView addSubview:qiuckLoginBtn];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_scrollView endEditing:YES];
    if (scrollView.contentOffset.x == 0) {
        [UIView animateWithDuration:0.f animations:^{
            [_buttonL setTitleColor:RED_COLOR forState:UIControlStateNormal];
            [_buttonR setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
            _btnBottomImageView.frame = CGRectMake(0, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
        }];
    } else {
        [UIView animateWithDuration:0.f animations:^{
            [_buttonR setTitleColor:RED_COLOR forState:UIControlStateNormal];
            [_buttonL setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
            _btnBottomImageView.frame = CGRectMake(WIDTH /2.f, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
        }];
    }
}

/**
 *  用户登录操作
 */
-(void)onceLogIn
{
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    NSArray *controllerNames = @[@"首页", @"慕课", @"个人中心"];
    NSArray *images = @[@"首页-正常", @"慕课-正常", @"个人中心-正常"];
    NSArray *selectesImages = @[@"首页-点击", @"慕课-点击", @"个人中心-选中"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *controllers;
    if ([[userDefaults objectForKey:USERINFO]allKeys].count >0) {
        controllers = @[@"MainViewController", @"CourseViewController", @"UserPersonalCenterViewController"];
        
    } else {
        controllers = @[@"MainViewController", @"CourseViewController", @"UserCenterViewController"];
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i=0; i<controllers.count; i++) {
        Class myclass = NSClassFromString(controllers[i]);
        UIViewController *controll = [[myclass alloc]init];
        UINavigationController *nac = [[UINavigationController alloc]initWithRootViewController:controll];
        UITabBarItem *barItem = [[UITabBarItem alloc]initWithTitle:controllerNames[i] image:[UIImage imageNamed:images[i]] selectedImage:[UIImage imageNamed:selectesImages[i]]];
        nac.tabBarItem = barItem;
        [nac.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
        [arr addObject:nac];
    }
    [tabBar.tabBar setSelectedImageTintColor:[UIColor redColor]];
    tabBar.viewControllers = arr;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = tabBar;
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
