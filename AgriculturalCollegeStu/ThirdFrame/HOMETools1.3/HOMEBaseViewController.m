//
//  HOMEBaseViewController.m
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/6.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import "HOMEBaseViewController.h"

@interface HOMEBaseViewController ()

@end

@implementation HOMEBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    _AFNManager = [AFHTTPSessionManager manager];
//    关闭自动解析
//    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _AFNManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];

//    _HUD = [[HOMEMBProgressHUD alloc]initWithView:self.view];
//    [self.view addSubview:_HUD];
    
    _userDefaults = [NSUserDefaults standardUserDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}






-(NSString*)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
    return uuid;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)dealloc
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


@end
