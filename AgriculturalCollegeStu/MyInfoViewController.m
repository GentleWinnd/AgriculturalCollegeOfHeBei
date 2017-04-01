//
//  MyInfoViewController.m
//  OldUniversity
//
//  Created by mahaomeng on 15/7/31.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "MyInfoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
//#import "GTMBase64.h"

@interface MyInfoViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation MyInfoViewController
{
//    头像
    UIImageView *_iconImageView;
    UIActionSheet *_imagePickTypeSheet;
    UITextField *_usernameTextFeild;
    UITextField *_phonenumberTextFeild;
    UITextField *_addressTextFeild;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB_COLOR(243, 243, 239);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH /3.f, self.navigationController.navigationBar.frame.size.height)];
    label.text = @"我的资料";
    label.font = [UIFont systemFontOfSize:kTitleFont];
    label.textColor = WHITE_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    [self customCommitBarBtn];
    [self customBackBtn];
    [self customUI];
    [self requsetData];
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

-(void)customCommitBarBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 20);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onCommitBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtn;
}

-(void)onCommitBarBtnClick:(id)sender {
//    _HUD.labelText = @"正在修改";
//    [_HUD show:YES];
//    NSDictionary *para = @{@"AccessToken": [_userDefaults objectForKey:USERINFO][@"AccessToken"], @"FullName": _usernameTextFeild.text};
//    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [_AFNManager POST:URL_SET_USERINFO parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@", dic);
//        if ([dic[@"Message"] isEqualToString:@"ok"]) {
//            if (_backBlock) {
//                _backBlock();
//            }
//            _HUD.labelText = @"修改成功!";
//            _HUD.mode = MBProgressHUDModeText;
//            [_HUD hide:YES afterDelay:1];
//        } else {
//            _HUD.labelText = @"修改失败!";
//            _HUD.mode = MBProgressHUDModeText;
//            [_HUD hide:YES afterDelay:1];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        _HUD.labelText = @"修改失败!";
//        _HUD.mode = MBProgressHUDModeText;
//        [_HUD hide:YES afterDelay:1];
//        NSLog(@"%@", error.localizedDescription);
//    }];
}

-(void)onBackBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requsetData
{
//    _HUD.labelText = @"正在加载数据";
//    [_HUD show:YES];
//    NSLog(@"%@", [_userDefaults objectForKey:USERINFO][@"AccessToken"]);
//    [_AFNManager GET:[NSString stringWithFormat:URL_USER_INFO, [_userDefaults objectForKey:USERINFO][@"AccessToken"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [_HUD hide:YES];
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            if (responseObject[@"Avatar"] != [NSNull null]) {
//                [_iconImageView setImageWithURL:[NSURL URLWithString:responseObject[@"Avatar"]] placeholderImage:[UIImage imageNamed:@"默认图"]];
//            }
//            _usernameTextFeild.text = responseObject[@"FullName"];
//        }
//        NSLog(@"%@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [_HUD hide:YES];
//        NSLog(@"%@", error.localizedDescription);
//    }];
}

-(void)customUI
{
//    __weak typeof(self) myself = self;
//    头像
    _imagePickTypeSheet = [[UIActionSheet alloc]initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照" ,@"从相册中选择", nil];
    [self.view addSubview:_imagePickTypeSheet];
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = CGRectMake(20, 64 +20, WIDTH -40, 100);
    [iconBtn addTarget:self action:@selector(onIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    iconBtn.backgroundColor = WHITE_COLOR;
    UILabel *iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, iconBtn.frame.size.height)];
    iconLabel.text = @"头像";
    iconLabel.textColor = LIGHTGRAY_COLOR;
    [iconBtn addSubview:iconLabel];
    
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH -150, 10, 80, 80)];
    _iconImageView.image = [UIImage imageNamed:@"default_head"];
    _iconImageView.layer.cornerRadius = _iconImageView.frame.size.height /2.f;
    _iconImageView.layer.masksToBounds = YES;
    [iconBtn addSubview:_iconImageView];
    
    UIImageView *rightArrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_iconImageView.frame.origin.x +_iconImageView.frame.size.width +5, 40, 25, 25)];
    rightArrowImageView.image = [UIImage imageNamed:@"u23a"];
    [iconBtn addSubview:rightArrowImageView];
    
    [self.view addSubview:iconBtn];
    
//    姓名/用户名
    UIImageView *usernameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(iconBtn.frame.origin.x, iconBtn.frame.origin.y +iconBtn.frame.size.height +1, iconBtn.frame.size.width, 45)];
    usernameImageView.backgroundColor = WHITE_COLOR;
    usernameImageView.userInteractionEnabled = YES;
    
    UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, usernameImageView.frame.size.height)];
    usernameLabel.text = @"用户名";
    usernameLabel.textColor = LIGHTGRAY_COLOR;
    [usernameImageView addSubview:usernameLabel];
    
     _usernameTextFeild = [[UITextField alloc]initWithFrame:CGRectMake(usernameLabel.frame.origin.x +usernameLabel.frame.size.width, usernameLabel.frame.origin.y, usernameImageView.frame.size.width -usernameLabel.frame.origin.x -usernameLabel.frame.size.width -10, usernameLabel.frame.size.height)];
    _usernameTextFeild.textAlignment = NSTextAlignmentRight;
    _usernameTextFeild.placeholder = @"未设置";
    [usernameImageView addSubview:_usernameTextFeild];
    
    [self.view addSubview:usernameImageView];
    
//   手机号码
    UIImageView *phonenumberImageView = [[UIImageView alloc]initWithFrame:CGRectMake(usernameImageView.frame.origin.x, usernameImageView.frame.origin.y +usernameImageView.frame.size.height +1, usernameImageView.frame.size.width, usernameImageView.frame.size.height)];
    phonenumberImageView.backgroundColor = WHITE_COLOR;
    phonenumberImageView.userInteractionEnabled = YES;
    
    UILabel *phonenumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, usernameImageView.frame.size.height)];
    phonenumberLabel.text = @"手机号码";
    phonenumberLabel.textColor = LIGHTGRAY_COLOR;
    [phonenumberImageView addSubview:phonenumberLabel];
    
     _phonenumberTextFeild= [[UITextField alloc]initWithFrame:CGRectMake(phonenumberLabel.frame.origin.x +phonenumberLabel.frame.size.width, usernameLabel.frame.origin.y, usernameImageView.frame.size.width -usernameLabel.frame.origin.x -phonenumberLabel.frame.size.width -10, phonenumberLabel.frame.size.height)];
    _phonenumberTextFeild.textAlignment = NSTextAlignmentRight;
    _phonenumberTextFeild.placeholder = _usernameTextFeild.placeholder;
    _phonenumberTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    [phonenumberImageView addSubview:_phonenumberTextFeild];
    [self.view addSubview:phonenumberImageView];
    
    _phonenumberTextFeild.userInteractionEnabled = NO;

//   常用地址
    UIImageView *addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(phonenumberImageView.frame.origin.x, phonenumberImageView.frame.origin.y +phonenumberImageView.frame.size.height +1, phonenumberImageView.frame.size.width, phonenumberImageView.frame.size.height)];
    addressImageView.backgroundColor = WHITE_COLOR;
    addressImageView.userInteractionEnabled = YES;
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, phonenumberImageView.frame.size.height)];
    addressLabel.text = @"常用地址";
    addressLabel.textColor = LIGHTGRAY_COLOR;
    [addressImageView addSubview:addressLabel];
    
    _addressTextFeild = [[UITextField alloc]initWithFrame:CGRectMake(addressLabel.frame.origin.x +addressLabel.frame.size.width, usernameLabel.frame.origin.y, usernameImageView.frame.size.width -usernameLabel.frame.origin.x -addressLabel.frame.size.width -10, addressLabel.frame.size.height)];
    _addressTextFeild.textAlignment = NSTextAlignmentRight;
    _addressTextFeild.placeholder = _usernameTextFeild.placeholder;
    _addressTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    [addressImageView addSubview:_addressTextFeild];
    
    _addressTextFeild.userInteractionEnabled = NO;
    
    [self.view addSubview:addressImageView];

}

-(void)onIconBtnClick:(UIButton *)sender
{
    [_imagePickTypeSheet showInView:self.view];
}

-(void)onLogoutBtnClick:(UIButton *)sender
{
    [_userDefaults removeObjectForKey:USERINFO];
    [_userDefaults synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) { //相册
        UIImagePickerController *imagePikerController = [[UIImagePickerController alloc]init];
        imagePikerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePikerController.allowsEditing = YES;
        imagePikerController.delegate = self;
        [self presentViewController:imagePikerController animated:YES completion:nil];
    } else if (buttonIndex ==0) { //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {//判断系统是否支持相机
            UIImagePickerController *cameraPicker = [[UIImagePickerController alloc]init];
            cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;//指定打开相机
            cameraPicker.allowsEditing = YES;
            cameraPicker.delegate = self;
            [self presentViewController:cameraPicker animated:YES completion:nil];
        } else {
            ALERT_HOME(nil, @"此设备不支持相机");
        }
    }
}

//UIImagePickerControllerDelegate协议中定义的方法，当用户选中图片的时候会被调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //先判断一下选中的是不是图片
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//注意类型转化。
        _iconImageView.image = info[UIImagePickerControllerEditedImage]; //获取选中的图片
    }
    [picker dismissViewControllerAnimated:YES completion:nil];//关闭ImagePickerController
//    _HUD.labelText = @"正在上传";
//    [_HUD show:YES];
//    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary *userInfo = [_userDefaults objectForKey:USERINFO];
//    NSString *base64String = [GTMBase64 stringByEncodingData:UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.01f)];
//    NSDictionary *para = @{@"AccessToken" :userInfo[@"AccessToken"] ,@"Avatar" :base64String, @"FileExt": @"JPG"};
//    NSLog(@"%@", para);
//    [_AFNManager POST:URL_UPLOAD_ICON parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        [_HUD hide:YES];
//        if (_backBlock) {
//            _backBlock();
//        }
//        NSLog(@"%@", dic);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [_HUD hide:YES];
//        NSLog(@"%@", error.description);
//    }];
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
