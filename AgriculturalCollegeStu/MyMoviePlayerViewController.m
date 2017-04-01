//
//  MyMoviePlayerViewController.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/11.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "MyMoviePlayerViewController.h"

@interface MyMoviePlayerViewController ()

@end

@implementation MyMoviePlayerViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIDeviceOrientationIsLandscape(interfaceOrientation);//IOS5
}

- (BOOL)shouldAutorotate
{
    
    return YES;
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskLandscape;//|UIInterfaceOrientationMaskLandscapeLeft;//只支持横屏
    
    //竖屏
    // return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
