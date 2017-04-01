//
//  DownloadViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/13.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "DownloadViewController.h"
#import "SetNavigationItem.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController

- (void)setNavigationBar {
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:@"下载" subTitle:@""];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    
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
