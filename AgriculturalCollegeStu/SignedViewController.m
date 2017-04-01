//
//  SignedViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/10.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "SignedViewController.h"
#import "SignedStuView.h"

@interface SignedViewController ()

@end

@implementation SignedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"已签到学生";
    SignedStuView *nanu = [SignedStuView initViewLayout];
    nanu.signedStuInfo = self.signedStuInfo;
    [self.view addSubview:nanu];
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
