//
//  SettingViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/26.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "SettingViewController.h"
#import "LogInViewController.h"
#import "SetNavigationItem.h"


@interface SettingViewController ()

@end

@implementation SettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:@"设置" subTitle:@""];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0://清理缓存
            [self creatClearupMemoryAlert];

            break;
        case 1://检查更新
//            [Progress progressShowcontent:@"当前已是最新版本"];
            break;
        case 2:{//退出登录
            LogInViewController *logView = [[LogInViewController alloc] init];
            
            [self presentViewController:logView animated:YES completion:nil];
            self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject];
        }

            
            break;
        case 3:
            break;
        case 5://更多
            
            break;
        case 7:{//
           
        }
            break;
   
        default:
            break;
    }

}

#pragma mark - create clear up memory

- (void)creatClearupMemoryAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定清除所有缓存？视频、文件、缓存的作业数据" preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 添加按钮
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮--%@-%@", [weakAlert.textFields.firstObject text], [weakAlert.textFields.lastObject text]);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }]];
    
    
    [self presentViewController:alert animated:YES completion:nil];

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
