//
//  AboutUsViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/13.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "AboutUsViewController.h"
#import "SourseDataCache.h"

@interface AboutUsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *versionLable;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于我们";
//    [self getAboutUsInfo];
    self.rightLabel.adjustsFontSizeToFitWidth = YES;
    
}


/*"Description":null,"VersionNumber":"1.0.0.0","Hash":"c4ca4238a0b923820dcc509a6f75849b","FilePath":"http://nduserservice.urart.cc/upload/21532a34-294b-4d3a-966f-e30088430a0d.ipa","FileSize":1}*/
- (void)getAboutUsInfo {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    
    [NetServiceAPI getAboutUsInfoWithParameters:nil success:^(id responseObject) {
        [progress hiddenProgress];
        NSMutableDictionary *versionInfo = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary safeDictionary:responseObject]];
        for (NSString *key in [responseObject allKeys]) {
            if ([versionInfo[key] isKindOfClass:[NSNull class]]) {
                [versionInfo removeObjectForKey:key];
            }
        }
        NSDictionary *version = [SourseDataCache getAPPVersionInfo];
        
        if (![versionInfo[@"VersionNumber"] isEqualToString:version[@"VersionNumber"]]) {
            [self refreshedCurrentVersion:responseObject[@"VersionNumber"]];
            [SourseDataCache saveAPPVersionInfo:versionInfo];
        }
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
        
    }];

}

- (void)refreshedCurrentVersion:(NSString *)version {
    if (version == nil) {
        return;
    }
    self.versionLable.text = version;

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
