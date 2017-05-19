//
//  MineViewController.m
//  xingxue_pro
//
//  Created by YH on 16/4/25.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineViewController.h"
#import "SettingViewController.h"
#import "AboutUsViewController.h"
#import "OpinionViewController.h"
#import "FavoriteViewController.h"
#import "DownloadViewController.h"
#import "ResourceManagerViewController.h"
#import "StuApprovalInfoTableViewController.h"
#import <MessageUI/MessageUI.h>
#import "SourseDataCache.h"
#import "UIImageView+AFNetworking.h"
#import "UserData.h"

@interface MineViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *setBtn;
@property (strong, nonatomic) IBOutlet UIImageView *headPortrait;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *classGrade;

@end

@implementation MineViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self observerUserRoleChanged];

    [self changeHeaderPortrait];
    [self registUserInfoNotif];
    [self refreshedUserRole];

}

#pragma mark - observer userrole chaneged

- (void)observerUserRoleChanged {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshedUserRole) name:NOTICE_USERROLE_CHANGED object:nil];
    
}

#pragma mark - user login suceess

- (void)refreshedUserRole {
    [self.headPortrait setImageWithURL:[NSURL URLWithString:[NSString safeString:[UserData getUser].avater]] placeholderImage:nil];
    self.nameLabel.text = [NSString safeString:[UserData getUser].nickName];
    
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UserRole role = [UserData getUser].userRole;

    if (role == UserRoleTeacher) {
        return 7;
    }
    return 9;
}


#pragma mark - add tapgesture in headerpottrait

- (void)changeHeaderPortrait {
    _classGrade.hidden = YES;
    _headPortrait.layer.cornerRadius = 40;
    _headPortrait.layer.masksToBounds = YES;
    _headPortrait.layer.borderColor = [UIColor whiteColor].CGColor;
    _headPortrait.layer.borderWidth = 2;
    _headPortrait.image = [UIImage imageWithData:[UserData getUser].userIcon];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePortrait)];
    
    self.headPortrait.userInteractionEnabled = YES;
    [self.headPortrait addGestureRecognizer:tap];
}

#pragma mark change header portrait

- (void)changePortrait {

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
 
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //添加Button
        [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //处理点击拍照
            [self presentPickerSourseViewControllerWithSourseType:UIImagePickerControllerSourceTypeCamera];
        }]];

    }
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //处理点击从相册选取
        [self presentPickerSourseViewControllerWithSourseType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}

#pragma mark - push camera or photo library

- (void)presentPickerSourseViewControllerWithSourseType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}
#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
   
    NSData * imageData  = UIImageJPEGRepresentation(image, 0.01);
    UIImage *headerImg = [UIImage imageWithData:imageData];
    self.headPortrait.image = headerImg;
    NSString *base64Encoded = [imageData base64EncodedStringWithOptions:0];
    NSDictionary *parameter = @{@"AccessToken":[UserData getAccessToken],
                                @"Avatar":base64Encoded,
                                @"FileExt":@"png"};
    [NetServiceAPI postUserAvaterWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"]  integerValue] == 1) {
            [UserData saveUserHeaderPortrait:UIImageJPEGRepresentation(headerImg,0.01)];
        } else {
        
        }
    } failure:^(NSError *error) {
        
    }];
    
//    [NetServiceAPI postUploadImageImageData:imageData nameOfImage:@"Avarter" fileOfName:@"headerImage" mimeOfType:@"png" progress:^(NSProgress *uploadProgress) {
//        
//    } sucess:^(id responseObject) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self pushViewController:[self getSelectedVCWith:indexPath] animated:YES hiddenTabbar:YES];
}

#pragma mark - getVC

- (UIViewController *)getSelectedVCWith:(NSIndexPath *)indexPath {
    UIViewController *view;
    switch (indexPath.row) {
        case 2:{//收藏
            FavoriteViewController *favorView = [[FavoriteViewController alloc] init];
            view = favorView;
        }
            break;
        case 3:{//离线
//            DownloadViewController *loadView = [[DownloadViewController alloc] init];
//            [self.navigationController pushViewController:loadView animated:YES];
            ResourceManagerViewController *resource = [[ResourceManagerViewController alloc] init];
            view = resource;
        }
            break;
        case 5:{//关于我们
            AboutUsViewController *aboutView = [[AboutUsViewController alloc] init];
            view = aboutView;
        }
            break;
        case 6:{//意见反馈
//            OpinionViewController *view = [[OpinionViewController alloc] init];
//            [self.navigationController pushViewController:view animated:YES];
            MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
            
            if (mailController) {  // 如果没有设置邮件帐户，mailController 为nil
                NSString *email = [SourseDataCache getAPPFeedBackEmail];
                mailController.mailComposeDelegate = self;
                [mailController setSubject:@"发送意见反馈"];
                [mailController setToRecipients:@[email]];
                [TabbarManager setTabBarHidden:YES];

                [self presentViewController:mailController animated:YES completion:nil];
            }
        }
            break;

        case 8:{//请假
            StuApprovalInfoTableViewController *approvalView = [[StuApprovalInfoTableViewController alloc] init];
            view = approvalView;
            
        }
            break;
        
        default:
            break;
    }
    return view;
}

- (IBAction)settingBtnAction:(UIButton *)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SettingViewController *settingView = [board instantiateViewControllerWithIdentifier:@"setting_sb"];
    [self.navigationController pushViewController:settingView animated:YES];
    
}

- (void) checkLoginInfo {
    
    //[contentView checkLogin];
}

- (void) registUserInfoNotif {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInformation:) name:@"sendData" object:nil];
}

- (void)getInformation:(NSNotification *)noti {
    [self checkLoginInfo];
    NSLog(@"------- %@",noti.object);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TabbarManager setTabBarHidden:NO];
}


#pragma mark - push viewcontroller

- (void)pushViewController:(UIViewController *)VC animated:(BOOL)animated hiddenTabbar:(BOOL)hidden {
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
        [TabbarManager setTabBarHidden:hidden];
    }
 }

#pragma mark - system mail delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissViewControllerAnimated:controller completion:nil];
}


@end
