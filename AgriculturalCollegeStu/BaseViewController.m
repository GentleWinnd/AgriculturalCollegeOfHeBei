//
//  BaseViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/10.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone; //view不需要拓展到整个屏幕{}
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _userDefaults = [NSUserDefaults standardUserDefaults];

}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];

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
