//
//  AlertViewFrame.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/29.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "AlertViewFrame.h"

@implementation AlertViewFrame

- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirm cancle:(NSString *)cancle showInView:(UIViewController *)VC {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        if ([self.delegate respondsToSelector:@selector(alertViewActionConfirm:)]) {
            [self.delegate alertViewActionConfirm:YES];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:cancle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if ([self.delegate respondsToSelector:@selector(alertViewActionConfirm:)]) {
            [self.delegate alertViewActionConfirm:NO];
        }
    }]];
    
    [VC presentViewController:alert animated:YES completion:nil];

}

- (void)alertController {
    // 危险操作:弹框提醒
    // 1.UIAlertView
    // 2.UIActionSheet
    // iOS8开始:UIAlertController == UIAlertView + UIActionSheet
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"你的操作时非法的，您要继续吗" preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮--%@-%@", [weakAlert.textFields.firstObject text], [weakAlert.textFields.lastObject text]);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"其它" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"点击了其它按钮");
    }]];
    
    // 添加文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.textColor = [UIColor redColor];
        textField.text = @"123";
        [textField addTarget:self action:@selector(usernameDidChange:) forControlEvents:UIControlEventEditingChanged];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.secureTextEntry = YES;
        textField.text = @"123";
    }];
    
}



@end
