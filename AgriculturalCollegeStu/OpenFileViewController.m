//
//  OpenFileViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/28.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "OpenFileViewController.h"

@interface OpenFileViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation OpenFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看文件";
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    //加载文件
    [self loadDocument: _filePath inView:_webView];
    
}


#pragma mark - 加载文件

- (void)loadDocument:(NSString *)documentPath inView:(UIWebView *)webView{
    NSURL *url = [NSURL fileURLWithPath:documentPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
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
